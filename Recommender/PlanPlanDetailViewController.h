//
//  PlanPlanDetialViewController.h
//  Recommender
//
//  Created by Benson Yang on 11/8/13.
//  Copyright (c) 2013 Benson. All rights reserved.
//

#import "BasePlanDetailViewController.h"

@interface PlanPlanDetailViewController : BasePlanDetailViewController <AMapSearchDelegate, UIAlertViewDelegate>
@property (strong, nonatomic) IBOutlet UISegmentedControl *naviTypeSegment;

@end
