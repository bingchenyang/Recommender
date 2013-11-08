//
//  BrowseProjectListViewController.m
//  Recommender
//
//  Created by Benson Yang on 11/8/13.
//  Copyright (c) 2013 Benson. All rights reserved.
//

#import "BrowseProjectListViewController.h"

@interface BrowseProjectListViewController ()

@end

@implementation BrowseProjectListViewController

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
    if ([segue.identifier isEqualToString:@"ToBrowsePlanListView"]) {
        BrowsePlanListViewController *pVC = segue.destinationViewController;
        pVC.poi = self.poi;
        pVC.travelProject = [self.fetchedResultsController objectAtIndexPath:[self.tableView indexPathForCell:sender]];
        pVC.managedObjectContext = self.managedObjectContext; //set managedObjectContext will call viewDidLoad
    }
}

@end
