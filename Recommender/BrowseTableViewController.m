//
//  BrowseTableViewController.m
//  Recommender
//
//  Created by Benson Yang on 8/31/13.
//  Copyright (c) 2013 Benson. All rights reserved.
//

#import "BrowseTableViewController.h"
#import "BrowsePoiCell.h"
#import "ImageCacheCenter.h"
#import "BrowseWebViewController.h"
#import "BrowseRootViewController.h"

@interface BrowseTableViewController ()

@end

@implementation BrowseTableViewController

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
    self.poiStream = [[PoiStream alloc] init];
    self.poiStream.delegate = self;
    [self.refreshControl beginRefreshing];
    [self.poiStream fetchPois];
    
}

- (void)refresh {
    [self.refreshControl beginRefreshing];
    [self.poiStream fetchPois];
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
    return [self.poiStream.pois count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"BrowsePoiCell";
    BrowsePoiCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    Poi *poiAtThisRow = [self.poiStream.pois objectAtIndex:indexPath.row];
    cell.name = poiAtThisRow.name;
    cell.description = poiAtThisRow.address;
    
    UIImage *photo = [[ImageCacheCenter defaultCacheCenter] fetchImageWithUrl:poiAtThisRow.smallPhotoUrl onCompletion:^{
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
    if (photo != nil) {
        cell.photo = photo;
    }
    else {
        cell.photo = [UIImage imageNamed:@"PoiDefaultIcon.png"];
    }
    
    UIImage *rating = [[ImageCacheCenter defaultCacheCenter] fetchImageWithUrl:poiAtThisRow.ratingSmallImageUrl onCompletion:^{
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
    if (rating != nil) {
        cell.rating = rating;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    BrowseWebViewController *webViewController = [[BrowseWebViewController alloc] init];
//    webViewController.poi = [self.poiStream.pois objectAtIndex:indexPath.row];
//    [self.navigationController pushViewController:webViewController animated:YES];
    BrowseRootViewController *parentVC = (BrowseRootViewController *)self.parentViewController;
    [parentVC performSegueWithIdentifier:@"toPoiDetailWeb" sender:indexPath];
}

#pragma mark - PoiStreamDelegate
- (void)PoiStreamDelegateFetchPoisDidFinish:(PoiStream *)poiStream {
    self.poiStream = poiStream;
    [self.refreshControl endRefreshing];
    [self.tableView reloadData];
}

@end
