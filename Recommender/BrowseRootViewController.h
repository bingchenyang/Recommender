//
//  BrowseRootViewController.h
//  Recommender
//
//  Created by Benson Yang on 8/31/13.
//  Copyright (c) 2013 Benson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BrowseMapViewController.h"
#import "BrowseTableViewController.h"

typedef enum {
    BrowseViewModeMap = 0,
    BrowseViewModeTable = 1
} BrowseViewMode;

#define kBrowseViewMode @"BrowseViewMode"

@interface BrowseRootViewController : UIViewController
@property (weak, nonatomic) IBOutlet UISegmentedControl *mapOrTable;
@property (strong, nonatomic) UIViewController *currentViewController;
@property (strong, nonatomic) BrowseTableViewController *browseTableViewController;
@property (strong, nonatomic) BrowseMapViewController *browseMapViewController;

- (IBAction)onChangeMapOrTableView:(id)sender;

@end
