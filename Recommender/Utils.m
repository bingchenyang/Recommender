//
//  Utils.m
//  Recommender
//
//  Created by Benson Yang on 11/7/13.
//  Copyright (c) 2013 Benson. All rights reserved.
//

#import "Utils.h"

#define kProgressHUDTag 9999

@implementation Utils

+ (void)showProgressHUD:(UIViewController *)controller withText:(NSString *)text {
    MBProgressHUD *existingHud = (MBProgressHUD *)[controller.view viewWithTag: kProgressHUDTag];
    if (nil == existingHud) {
        MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:controller.view];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.labelText = text;
        hud.tag = kProgressHUDTag;
        [hud show:YES];
        [controller.view addSubview:hud];
    }
}

+ (void)hideProgressHUD:(UIViewController *)controller {
    MBProgressHUD *hud = (MBProgressHUD *)[controller.view viewWithTag: kProgressHUDTag];
    if (hud != nil) {
        [hud removeFromSuperview];
    }
}

@end
