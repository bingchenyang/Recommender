//
//  PlanPlanListViewController.m
//  Recommender
//
//  Created by Benson Yang on 11/8/13.
//  Copyright (c) 2013 Benson. All rights reserved.
//

#import "PlanPlanListViewController.h"
#import "PlanPlanDetailViewController.h"

@interface PlanPlanListViewController ()

@end

@implementation PlanPlanListViewController

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
    NSArray *barButtonItems = [NSArray arrayWithObjects:self.editButtonItem, self.navigationItem.rightBarButtonItem, nil];
    self.navigationItem.rightBarButtonItems = barButtonItems;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ToPlanPlanDetailView"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        TravelPlan *travelPlan = [self.fetchedResultsController objectAtIndexPath:indexPath];
        PlanPlanDetailViewController *pPDVC = segue.destinationViewController;
        pPDVC.managedObjectContext = self.managedObjectContext;
        pPDVC.travelPlan = travelPlan;
    }
}

#pragma mark - UITalbleViewDelegate Methods
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
@end
