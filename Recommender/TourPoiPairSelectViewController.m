//
//  TourPoiPairSelectViewController.m
//  Recommender
//
//  Created by Benson Yang on 11/23/13.
//  Copyright (c) 2013 Benson. All rights reserved.
//

#import "TourPoiPairSelectViewController.h"
#import "TourNaviMapViewController.h"
#import "PoiPair.h"

@interface TourPoiPairSelectViewController ()
@property (nonatomic, strong) NSMutableOrderedSet *poiPairs;

@end

@implementation TourPoiPairSelectViewController

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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.poiPairs = [self poiPairsFromPois:self.pois];
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
    return self.poiPairs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PoiPairCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    PoiPair *poiPair = [self.poiPairs objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"从【%@】到【%@】", poiPair.origin.name, poiPair.destination.name];
    
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

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */


#pragma mark
- (NSMutableOrderedSet *)poiPairsFromPois:(NSOrderedSet *)pois {
    NSMutableOrderedSet *poiPairs = [[NSMutableOrderedSet alloc] init];
    
    for (int i = 0; i < pois.count - 1; i++) {
        Poi *origin = [pois objectAtIndex:i];
        Poi *destination = [pois objectAtIndex:i+1];
        PoiPair *poiPair = [[PoiPair alloc] initWithOrigin:origin andDestination:destination];
        
        [poiPairs addObject:poiPair];
    }
    if (pois.count > 1) {
        Poi *origin = [pois lastObject];
        Poi *destination = [pois objectAtIndex:0];
        PoiPair *poiPair = [[PoiPair alloc] initWithOrigin:origin andDestination:destination];
        
        [poiPairs addObject:poiPair];
    }
    
    return  poiPairs;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toTourNaviMapView"]) {
        TourNaviMapViewController *tnmVC = segue.destinationViewController;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        tnmVC.origin = [[self.poiPairs objectAtIndex:indexPath.row] origin];
        tnmVC.destination = [[self.poiPairs objectAtIndex:indexPath.row] destination];
    }
}

@end
