//
//  PoiDetailViewController.m
//  Recommender
//
//  Created by Benson Yang on 8/8/13.
//  Copyright (c) 2013 Benson. All rights reserved.
//

#import "PoiDetailViewController.h"
#import "DianPingEngine.h"
#import "PoiDetailViewCell.h"

@interface PoiDetailViewController ()
@property (strong, nonatomic) MKNetworkEngine *engineForImg;
@property (strong, nonatomic) NSDictionary *poi;
@property (strong, nonatomic) UIImage *photo;
@end

@implementation PoiDetailViewController

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
    self.engineForImg = [[MKNetworkEngine alloc] initWithHostName:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    UIView *originalTitleView = self.navigationItem.titleView;
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [spinner startAnimating];
    self.navigationItem.titleView = spinner;
    if (self.annotation != nil) {
        [[DianPingEngine sharedEngine] findPoiWithPid:self.annotation.pid onCompletion:^(NSDictionary *poi) {
            self.navigationItem.titleView = originalTitleView;
            self.navigationItem.title = self.annotation.title;
            self.poi = poi;
            
            MKNetworkOperation *op = [self.engineForImg operationWithURLString:[self.poi objectForKey:@"s_photo_url"]];
            
            [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
                self.photo = [UIImage imageWithData:completedOperation.responseData];
                [self.tableView reloadData];

            } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
                ;
            }];
            [self.engineForImg enqueueOperation:op];
            
            [self.tableView reloadData];
        } onError:^(NSError *error) {
            ;
        }];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    
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
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PoiDetailViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PhotoCell"];
    if (cell == nil) {
        
        cell = [[PoiDetailViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PhotoCell"];
    }
    if (self.photo) {
        cell.imageView.image = self.photo;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 240;
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
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end