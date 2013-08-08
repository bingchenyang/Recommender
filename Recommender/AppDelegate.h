//
//  AppDelegate.h
//  Recommender
//
//  Created by Benson Yang on 8/6/13.
//  Copyright (c) 2013 Benson. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ViewController *viewController;

@property (strong, nonatomic) UINavigationController *navController;

@end
