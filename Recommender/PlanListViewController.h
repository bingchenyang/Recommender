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
// 数据应来源于服务器，目前暂时存放至本地数据库

#import <UIKit/UIKit.h>
#import "Poi.h"

@interface PlanListViewController : UITableViewController
@property (nonatomic, strong) Poi *poi;

@end
