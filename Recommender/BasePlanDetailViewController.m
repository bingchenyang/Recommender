//
//  PlanDetailViewController.m
//  Recommender
//
//  Created by Benson Yang on 10/20/13.
//  Copyright (c) 2013 Benson. All rights reserved.
//

#import "BasePlanDetailViewController.h"
#import "Poi+DianPing.h"
#import "SimulateAnnealTSP.h"
#import "ImageCacheCenter.h"
#import "Utils.h"
#import "TourMapViewController.h"

#define MAX_INTEGER 0x7fffffff
struct MGraph {
    int vertexNumber;
    int edgesNumber;
    int edges[20][20];
};

@interface PoiPair : NSObject
@property (nonatomic, strong) Poi *origin;
@property (nonatomic, strong) Poi *destination;
@end
@implementation PoiPair
@end

@interface BasePlanDetailViewController ()
@property (nonatomic, strong) AMapSearchAPI *searchAPI;
@property (nonatomic, strong) NSMutableOrderedSet *poiPairs;

@end

@implementation BasePlanDetailViewController {
    struct MGraph poisGraph;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.searchAPI = [[AMapSearchAPI alloc] initWithSearchKey:@"a7d8df80ccf7c8d83afdf083fdef34be" Delegate:self];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    NSMutableArray *rightBarButtonItems = [self.navigationItem.rightBarButtonItems mutableCopy];
    UIBarButtonItem *showInMapBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(showInMap:)];
    [rightBarButtonItems addObject:showInMapBarButtonItem];
    self.navigationItem.rightBarButtonItems = rightBarButtonItems;
    
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.travelPlan.pois count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    Poi *poi = [self.travelPlan.pois objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%d. %@", indexPath.row + 1, poi.name];
    cell.detailTextLabel.text = poi.address;
//    cell.imageView.image = [[ImageCacheCenter defaultCacheCenter] fetchImageWithUrl:poi.smallPhotoUrl onCompletion:^{
//        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//    }];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    
}

// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

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

- (void)showInMap:(id)sender {
    TourMapViewController *tMVC = [[TourMapViewController alloc] init];
    tMVC.pois = self.travelPlan.pois;
    [self.navigationController pushViewController:tMVC animated:YES];
}

@end
