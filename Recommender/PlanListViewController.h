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

@interface PlanListViewController : UITableViewController <NSFetchedResultsControllerDelegate, UIAlertViewDelegate>
// 由于travelProject是由上一级传入，故managedObjectContext需要从ProjectListViewController传过来
@property (nonatomic, strong) Poi *poi;
@property (nonatomic, strong) TravelProject *travelProject;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end
