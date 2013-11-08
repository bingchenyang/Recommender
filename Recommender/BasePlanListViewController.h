//
//  PlanListViewController.h
//  Recommender
//
//  Created by Benson Yang on 10/19/13.
//  Copyright (c) 2013 Benson. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "Poi+DianPing.h"
#import "TravelProject.h"
#import "RecommenderDatabase.h"

@interface BasePlanListViewController : UITableViewController <NSFetchedResultsControllerDelegate, UIAlertViewDelegate>
@property (nonatomic, strong) Poi *poi;
@property (nonatomic, strong) TravelProject *travelProject;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end
