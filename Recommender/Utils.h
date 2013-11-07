//
//  Utils.h
//  Recommender
//
//  Created by Benson Yang on 11/7/13.
//  Copyright (c) 2013 Benson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

@interface Utils : NSObject

+ (void)showProgressHUD:(UIViewController *)controller withText:(NSString *)text;

+ (void)hideProgressHUD:(UIViewController *)controller;

@end
