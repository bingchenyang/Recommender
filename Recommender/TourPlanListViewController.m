//
//  TourPlanListViewController.m
//  Recommender
//
//  Created by Benson Yang on 11/8/13.
//  Copyright (c) 2013 Benson. All rights reserved.
//

#import "TourPlanListViewController.h"
#import "TourPlanDetailViewController.h"

@interface TourPlanListViewController ()

@end

@implementation TourPlanListViewController

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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ToTourPlanDetailView"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        TravelPlan *travelPlan = [self.fetchedResultsController objectAtIndexPath:indexPath];
        TourPlanDetailViewController *tPDVC = segue.destinationViewController;
        tPDVC.managedObjectContext = self.managedObjectContext;
        tPDVC.travelPlan = travelPlan;
    }
}

#pragma mark - Table view data source
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

@end
