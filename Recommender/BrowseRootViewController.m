//
//  BrowseRootViewController.m
//  Recommender
//
//  Created by Benson Yang on 8/31/13.
//  Copyright (c) 2013 Benson. All rights reserved.
//

#import "BrowseRootViewController.h"
#import "HelperMethods.h"
#import "BrowseWebViewController.h"

@interface BrowseRootViewController ()

@end

@implementation BrowseRootViewController

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
    
    self.browseMapViewController = [[BrowseMapViewController alloc] init];
    self.browseTableViewController = [[BrowseTableViewController alloc] init];
    [self addChildViewController:self.browseMapViewController];
    [self addChildViewController:self.browseTableViewController];
    
    self.mapOrTable.selectedSegmentIndex = [[NSUserDefaults standardUserDefaults] integerForKey:kBrowseViewMode];
    self.currentViewController = [self.childViewControllers objectAtIndex:self.mapOrTable.selectedSegmentIndex];
    [self.view addSubview:self.currentViewController.view];
}

- (void)viewDidAppear:(BOOL)animated {
    [HelperMethods printFrameOfView:self.view withViewName:@"self.view"];
    [HelperMethods printFrameOfView:self.currentViewController.view withViewName:@"self.currentVC.view"];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toPoiDetailWeb"]) {
        BrowseWebViewController *poiDetailWeb = segue.destinationViewController;
        
        NSIndexPath *index = sender;
        poiDetailWeb.poi = [self.browseTableViewController.poiStream.pois objectAtIndex:index.row];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onChangeMapOrTableView:(id)sender {
    [[NSUserDefaults standardUserDefaults] setInteger:self.mapOrTable.selectedSegmentIndex forKey:kBrowseViewMode];
    
    UIViewController *toViewController = [[self childViewControllers] objectAtIndex:self.mapOrTable.selectedSegmentIndex];
    [self transitionFromViewController:self.currentViewController toViewController:toViewController duration:1 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
    } completion:^(BOOL finished) {
        if (finished) {
            self.currentViewController = toViewController;
        }
    }];
}

#pragma mark - Helper Methods


@end
