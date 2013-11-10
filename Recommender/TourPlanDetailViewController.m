//
//  TourPlanDetailViewController.m
//  Recommender
//
//  Created by Benson Yang on 11/8/13.
//  Copyright (c) 2013 Benson. All rights reserved.
//

#import "TourPlanDetailViewController.h"
#import "TourMapViewController.h"

@interface TourPlanDetailViewController ()

@end

@implementation TourPlanDetailViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource Methods
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

#pragma mark - 
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ToTourMapView"]) {
        TourMapViewController *tMVC = segue.destinationViewController;
        tMVC.pois = self.travelPlan.pois;
    }
}
@end
