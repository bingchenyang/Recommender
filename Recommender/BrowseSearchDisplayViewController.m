//
//  BrowseSearchDisplayViewController.m
//  Recommender
//
//  Created by Benson Yang on 11/25/13.
//  Copyright (c) 2013 Benson. All rights reserved.
//

#import "BrowseSearchDisplayViewController.h"
#import "ActionSheetPicker.h"
#import "Utils.h"
#import "BrowsePoiCell.h"
#import "ImageCacheCenter.h"
#import "BrowseWebViewController.h"

@interface BrowseSearchDisplayViewController ()
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

@property (strong, nonatomic) NSArray *searchTypes;
@property NSInteger selectedSearchType;
@end

@implementation BrowseSearchDisplayViewController

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
    
    self.poiStream = [[PoiStream alloc] init];
    self.poiStream.delegate = self;
    self.searchTypes = @[@"景点", @"餐馆", @"酒店"];
    self.searchBar.prompt = @"景点";
    self.searchBar.delegate = self;
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
    return self.poiStream.pois.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SearchResultCell";
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
    return 107;
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

#pragma mark

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toPoiDetailWeb"]) {
        BrowseWebViewController *poiDetailWeb = segue.destinationViewController;
        
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        poiDetailWeb.poi = [self.poiStream.pois objectAtIndex:indexPath.row];
    }
}

- (IBAction)cancelButtonClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (IBAction)typeButtonClicked:(id)sender {
    
    [ActionSheetStringPicker showPickerWithTitle:@"选择搜索类型"
                                            rows:self.searchTypes
                                initialSelection:self.selectedSearchType
                                       doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                           
                                           switch (selectedIndex) {
                                               case kSelectedIndexPoi:
                                                   self.searchBar.prompt = @"景点";
                                                   break;
                                               case kSelectedIndexHotel:
                                                   self.searchBar.prompt = @"酒店";
                                                   break;
                                               case kSelectedIndexResturant:
                                                   self.searchBar.prompt = @"餐馆";
                                                   break;
                                               default:
                                                   break;
                                           }
                                           self.selectedSearchType = selectedIndex;
    }
                                     cancelBlock:^(ActionSheetStringPicker *picker) {
        
    }
                                          origin:sender];
}

#pragma mark - UISearchBarDelegate Methods
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSString *keywords = [searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (![keywords isEqualToString:@""]) {
        [Utils showProgressHUD:self withText:@"搜索中..."];
        [self.poiStream searchPoiWithKeywords:keywords type:self.selectedSearchType];
        [searchBar resignFirstResponder];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}
#pragma mark - PoiStreamDelegate Methods
- (void)PoiStreamDelegateFetchPoisDidFinish:(PoiStream *)poiStream {
    self.poiStream = poiStream;
    [self.tableView reloadData];
    [Utils hideProgressHUD:self];
}
- (void)PoiStreamDelegateFetchPoisDidFail:(PoiStream *)poiSrream {
    [Utils hideProgressHUD:self];
}
@end
