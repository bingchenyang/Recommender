//
//  TourNaviDescriptionViewController.m
//  Recommender
//
//  Created by Benson Yang on 11/11/13.
//  Copyright (c) 2013 Benson. All rights reserved.
//

#import "TourNaviDescriptionViewController.h"
#import "Utils.h"
#import "TourTransitCell.h"

@interface TourNaviDescriptionViewController ()
@property (nonatomic) NSInteger naviType;
@property (nonatomic, strong) NSArray *heightForRows;

@end

@implementation TourNaviDescriptionViewController

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
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.naviType = [[[NSUserDefaults standardUserDefaults] valueForKey:kNaviTypeSegmentSelectedIndex] integerValue];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 
- (void)refresh {
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return self.routes.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([[self.routes objectAtIndex:0] isKindOfClass:[AMapTransit class]]) {
        AMapTransit *transit = [self.routes objectAtIndex:section];
        return transit.segments.count;
    }
    else if ([[self.routes objectAtIndex:0] isKindOfClass:[AMapPath class]]) {
        AMapPath *path = [self.routes objectAtIndex:section];
        return path.steps.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.naviType == NaviTypeDrive || self.naviType == NaviTypeWalk) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PathCell" forIndexPath:indexPath];
        AMapPath *path = [self.routes objectAtIndex:indexPath.section];
        AMapStep *step = [path.steps objectAtIndex:indexPath.row];
        cell.textLabel.text = step.instruction;
        cell.detailTextLabel.text = step.action;
        return cell;
    }
    else if (self.naviType == NaviTypeBus) {
        TourTransitCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TransitCell" forIndexPath:indexPath];
        AMapSegment *segment = [[[self.routes objectAtIndex:indexPath.section] segments] objectAtIndex:indexPath.row];
        
        NSMutableString *walkingDescription = [[NSMutableString alloc] init];
        for (AMapStep *step in segment.walking.steps) {
            [walkingDescription appendFormat:@"\n%@", step.instruction];
        }
        cell.walkingDescriptionLabel.numberOfLines = segment.walking.steps.count;
        cell.walkingDescriptionLabel.text = walkingDescription;
        [cell.walkingDescriptionLabel sizeToFit];
        cell.buslineDescriptionLabel.text = [[[[self.routes objectAtIndex:indexPath.section] segments] objectAtIndex:indexPath.row] busline].name;
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.naviType == NaviTypeDrive || self.naviType == NaviTypeWalk) {
        return 44;
    }
    else if (self.naviType == NaviTypeBus) {
        AMapSegment *segment = [[[self.routes objectAtIndex:indexPath.section] segments] objectAtIndex:indexPath.row];
        CGFloat height = segment.walking.steps.count * 20 + 30 + [segment.busline.name sizeWithFont:[UIFont systemFontOfSize:15.0]].height;
        
        return height;
    }
    
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section + 1 < self.routes.count) {
        return [NSString stringWithFormat:@"%d.【%@】去往【%@】", section + 1, [[self.pois objectAtIndex:section] name], [[self.pois objectAtIndex:section + 1] name]];
    }
    else {
        return [NSString stringWithFormat:@"%d.【%@】回到【%@】", section + 1, [[self.pois objectAtIndex:section] name], [[self.pois objectAtIndex:0] name]];
    }
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

@end
