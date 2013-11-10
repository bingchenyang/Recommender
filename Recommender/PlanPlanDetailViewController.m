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
#import "SimulateAnnealTSP.h"
#import "PoiPair.h"

#define MAX_INTEGER 0x7fffffff
struct MGraph {
    int vertexNumber;
    int edgesNumber;
    int edges[20][20];
};

@interface PlanPlanDetailViewController ()
@property (nonatomic, strong) AMapSearchAPI *searchAPI;
@property (nonatomic, strong) NSMutableOrderedSet *poiPairs;

@end

@implementation PlanPlanDetailViewController {
    struct MGraph poisGraph;
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
    poisGraph.vertexNumber = self.travelPlan.pois.count;
    poisGraph.edgesNumber = self.poiPairs.count;
    for (int i = 0; i < 20; i++) {
        for (int j = 0; j < 20; j++) {
            if (i != j) {
                poisGraph.edges[i][j] = MAX_INTEGER;
            }
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
- (IBAction)calculateRoutes:(id)sender {
    if ([self.poiPairs count] > 0) {
        [Utils showProgressHUD:self withText:@"请求中..."];
        AMapNavigationSearchRequest *naviRequest= [[AMapNavigationSearchRequest alloc] init];
        naviRequest.searchType = AMapSearchType_NaviWalking;
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

#pragma mark - AMapSearchDelegate Methods

- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response {
    NSString *result = [NSString stringWithFormat:@"%@", response.regeocode];
    NSLog(@"ReGeo: %@", result);
}

- (void)onNavigationSearchDone:(AMapNavigationSearchRequest *)request response:(AMapNavigationSearchResponse *)response {
    PoiPair *poiPair = [self.poiPairs objectAtIndex:0];
    int originIndex = [self.travelPlan.pois indexOfObject:poiPair.origin];
    int destinationIndex = [self.travelPlan.pois indexOfObject:poiPair.destination];
    poisGraph.edges[originIndex][destinationIndex] = 0;
    if (response.route.transits.count != 0) {
        for (AMapTransit *transit in response.route.transits) {
            poisGraph.edges[originIndex][destinationIndex] += transit.duration;
        }
    }
    else if (response.route.paths.count != 0) {
        for (AMapPath *path in response.route.paths) {
            poisGraph.edges[originIndex][destinationIndex] += path.duration;
        }
    }
    [self.poiPairs removeObjectAtIndex:0];
    
    // handle response
    NSLog(@"%d", [self.poiPairs count]);
    
    
    // 如果仍有pairs，继续
    if ([self.poiPairs count] > 0) {
        [self calculateRoutes:nil];
    }
    else {
        //[SimulateAnnealTSP simulateAnneal:poisGraph.edges withSize:poisGraph.vertexNumber];
        [Utils hideProgressHUD:self];
        [SimulateAnnealTSP enumTSP:poisGraph.edges withSize:poisGraph.vertexNumber onComplete:^(NSArray *solution) {
            //根据solution的内容，重新排列table中cell的顺序
            NSOrderedSet *oldSet = self.travelPlan.pois;
            NSMutableOrderedSet *newSet = [[NSMutableOrderedSet alloc] init];
            for (int i = 0; i < poisGraph.vertexNumber; i++) {
                [newSet addObject:[oldSet objectAtIndex:[[solution objectAtIndex:i] integerValue]]];
            }
            
            self.travelPlan.pois = newSet;
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationMiddle];
        }];
    }
}

@end
