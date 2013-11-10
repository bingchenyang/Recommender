//
//  PlanDetailViewController.h
//  Recommender
//
//  Created by Benson Yang on 10/20/13.
//  Copyright (c) 2013 Benson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TravelPlan.h"
#import <AMapSearchKit/AMapSearchAPI.h>

@interface BasePlanDetailViewController : UITableViewController <NSFetchedResultsControllerDelegate>
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) TravelPlan *travelPlan;

@end
