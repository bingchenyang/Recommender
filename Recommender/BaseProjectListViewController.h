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
//
// 基类负责最基本的显示已有计划即可
// 提供添加、删除计划的能力
// 不提供segue

#import <UIKit/UIKit.h>
#import "Poi.h"

@interface BaseProjectListViewController : UITableViewController <NSFetchedResultsControllerDelegate, UITextFieldDelegate>
@property (nonatomic, strong) Poi *poi;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end
