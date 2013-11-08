//
//  BrowsePlanListViewController.m
//  Recommender
//
//  Created by Benson Yang on 11/8/13.
//  Copyright (c) 2013 Benson. All rights reserved.
//

#import "BrowsePlanListViewController.h"
#import "BrowsePlanDetialViewController.h"

#define kButtonIndexCancel  0
#define kButtonIndexConfirm 1

@interface BrowsePlanListViewController ()
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;

@end

@implementation BrowsePlanListViewController

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
    if ([segue.identifier isEqualToString:@"toPlanDetailView"]) {
        BrowsePlanDetialViewController *pDVC = segue.destinationViewController;
        pDVC.travelPlan = [self.fetchedResultsController objectAtIndexPath:sender];
        pDVC.managedObjectContext = self.managedObjectContext;
    }
}

#pragma mark - UITalbleViewDelegate Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedIndexPath = indexPath;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"添加景点"
                                                    message:@"确认添加景点"
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确定", nil];
    [alert show];
}


#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == kButtonIndexConfirm) {
        TravelPlan *plan = [self.fetchedResultsController objectAtIndexPath:self.selectedIndexPath];
        
        // TODO:这里有apple的bug
        NSMutableOrderedSet *tempSet = [NSMutableOrderedSet orderedSetWithOrderedSet:plan.pois];
        [tempSet addObject:self.poi];
        plan.pois = tempSet;
        
        NSError *error;
        [self.managedObjectContext save:&error];
        if (error) {
            NSLog(@"%@", error);
        }
    }
}

#pragma mark - UITalbleViewDelegate Methods
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

@end
