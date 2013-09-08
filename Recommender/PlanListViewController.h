//
//  PlanListViewController.h
//  Recommender
//
//  Created by Benson Yang on 9/5/13.
//  Copyright (c) 2013 Benson. All rights reserved.
//
// 主要职责：
// 1. 展示已有计划
// 2. 将选中的poi添加至某计划

#import <UIKit/UIKit.h>
#import "Poi.h"

@interface PlanListViewController : UITableViewController
@property (nonatomic, strong) Poi *poi;
@property (strong, nonatomic) IBOutlet UIToolbar *toolBar;

@end
