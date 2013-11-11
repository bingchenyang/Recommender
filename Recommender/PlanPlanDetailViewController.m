//
//  PlanPlanDetialViewController.m
//  Recommender
//
//  Created by Benson Yang on 11/8/13.
//  Copyright (c) 2013 Benson. All rights reserved.
//

#import "PlanPlanDetailViewController.h"
#import "Utils.h"
#import "Poi+DianPing.h"
#import "PoiPair.h"


@interface PlanPlanDetailViewController ()
@property (nonatomic, strong) AMapSearchAPI *searchAPI;
@property (nonatomic, strong) NSMutableOrderedSet *poiPairs;

@end

@implementation PlanPlanDetailViewController {
    struct MGraph *p_poisGraph;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.searchAPI = [[AMapSearchAPI alloc] initWithSearchKey:@"a7d8df80ccf7c8d83afdf083fdef34be" Delegate:self];
    
    self.poiPairs = [self poiPairsFromPois:self.travelPlan.pois];
    [self.naviTypeSegment addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    
    [Utils initPoisGraph];
    p_poisGraph = [Utils GetPoisGraph];
    p_poisGraph->edgesNumber = self.poiPairs.count;
    p_poisGraph->vertexNumber = self.travelPlan.pois.count;
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.naviTypeSegment.selectedSegmentIndex = [[[NSUserDefaults standardUserDefaults] valueForKey:kNaviTypeSegmentSelectedIndex] integerValue];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate Methods

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSMutableOrderedSet *tmpSet = [self.travelPlan.pois mutableCopy];
        [tmpSet removeObjectAtIndex:indexPath.row];
        self.travelPlan.pois = tmpSet;
        
        NSError *error;
        [self.managedObjectContext save:&error];
        if (error) {
            NSLog(@"%@", error);
        }
        [tableView reloadData];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        
    }
}

#pragma mark -
- (IBAction)calculateRoutes:(id)sender {
    if ([self.poiPairs count] > 0) {
        [Utils showProgressHUD:self withText:@"请求中..."];
        AMapNavigationSearchRequest *naviRequest= [[AMapNavigationSearchRequest alloc] init];
        
        if (self.naviTypeSegment.selectedSegmentIndex == NaviTypeDrive) {
            naviRequest.searchType = AMapSearchType_NaviDrive;
        }
        else if (self.naviTypeSegment.selectedSegmentIndex == NaviTypeBus) {
            naviRequest.searchType = AMapSearchType_NaviBus;
        }
        else if (self.naviTypeSegment.selectedSegmentIndex == NaviTypeWalk) {
            naviRequest.searchType = AMapSearchType_NaviWalking;
        }
        
        PoiPair *poiPair = [self.poiPairs objectAtIndex:0];
        Poi *origin = poiPair.origin;
        Poi *destination = poiPair.destination;
        naviRequest.origin = [AMapGeoPoint locationWithLatitude:[origin.latitude floatValue] longitude:[origin.longitude floatValue]];
        naviRequest.destination = [AMapGeoPoint locationWithLatitude:[destination.latitude floatValue] longitude:[destination.longitude floatValue]];
        naviRequest.city = @"shanghai";
        [self.searchAPI AMapNavigationSearch:naviRequest];
    }
}

- (NSMutableOrderedSet *)poiPairsFromPois:(NSOrderedSet *)pois {
    NSMutableOrderedSet *poiPairs = [[NSMutableOrderedSet alloc] init];
    
    for (int i = 0; i < [pois count]; i++) {
        Poi *origin = [pois objectAtIndex:i];
        for (int j = i + 1; j < [pois count]; j++) {
            Poi *destination = [pois objectAtIndex:j];
            PoiPair *poiPair = [[PoiPair alloc] init];
            poiPair.origin = origin;
            poiPair.destination = destination;
            [poiPairs addObject:poiPair];
            
            PoiPair *poiPairReverse = [[PoiPair alloc] init];
            poiPairReverse.origin = destination;
            poiPairReverse.destination = origin;
            [poiPairs addObject:poiPairReverse];
        }
    }
    
    return  poiPairs;
}

-(void)segmentAction:(UISegmentedControl *)segmentedControl {
    NSInteger oldIndex = [[[NSUserDefaults standardUserDefaults] valueForKey:kNaviTypeSegmentSelectedIndex] integerValue];
    NSInteger newIndex = segmentedControl.selectedSegmentIndex;
    
    if (oldIndex == NaviTypeOther) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"改变该值会使得自定义数据丢失" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        [alert show];
    }
    else {
        if (self.poiPairs.count == 0) {
            self.poiPairs = [self poiPairsFromPois:self.travelPlan.pois];
        }
        [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithInteger:newIndex] forKey:kNaviTypeSegmentSelectedIndex];
    }
}

#pragma mark - AMapSearchDelegate Methods

- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response {
    NSString *result = [NSString stringWithFormat:@"%@", response.regeocode];
    NSLog(@"ReGeo: %@", result);
}

- (void)onNavigationSearchDone:(AMapNavigationSearchRequest *)request response:(AMapNavigationSearchResponse *)response {
    PoiPair *poiPair = [self.poiPairs objectAtIndex:0];
    int originIndex = [self.travelPlan.pois indexOfObject:poiPair.origin];
    int destinationIndex = [self.travelPlan.pois indexOfObject:poiPair.destination];
    p_poisGraph->edges[originIndex][destinationIndex] = 0;
    if (response.route.transits.count != 0) {// 公交换乘方案
        NSInteger minDuration = NSIntegerMax;
        for (AMapTransit *transit in response.route.transits) {
            if (transit.duration < minDuration) {
                minDuration = transit.duration;
            }
        }
        p_poisGraph->edges[originIndex][destinationIndex] = minDuration;
    }
    else if (response.route.paths.count != 0) {// 驾车、步行方案
        NSInteger minDuration = NSIntegerMax;
        for (AMapPath *path in response.route.paths) {
            if (path.duration < minDuration) {
                minDuration = path.duration;
            }
        }
        p_poisGraph->edges[originIndex][destinationIndex] = minDuration;
    }
    [self.poiPairs removeObjectAtIndex:0];
    
    NSLog(@"%d", [self.poiPairs count]);
    
    
    // 如果仍有pairs，继续
    if ([self.poiPairs count] > 0) {
        [self calculateRoutes:nil];
    }
    else {
        [Utils hideProgressHUD:self];
        [Utils enumTSPWithCompletionHandler:^(NSArray *solution) {
            //根据solution的内容，重新排列table中cell的顺序
            NSOrderedSet *oldSet = self.travelPlan.pois;
            NSMutableOrderedSet *newSet = [[NSMutableOrderedSet alloc] init];
            for (int i = 0; i < p_poisGraph->vertexNumber; i++) {
                [newSet addObject:[oldSet objectAtIndex:[[solution objectAtIndex:i] integerValue]]];
            }
            
            self.travelPlan.pois = newSet;
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationMiddle];
        }];
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
}

- (void)alertViewCancel:(UIAlertView *)alertView {
    
}

@end
