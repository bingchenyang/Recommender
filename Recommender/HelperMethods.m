//
//  HelperMethods.m
//  Recommender
//
//  Created by Benson Yang on 8/31/13.
//  Copyright (c) 2013 Benson. All rights reserved.
//

#import "HelperMethods.h"

@implementation HelperMethods

+(void)printFrameOfView:(UIView *)theView withViewName:(NSString *)name{
    NSLog(@"Frame %@: [(%f, %f) %f, %f]", name, theView.frame.origin.x, theView.frame.origin.y, theView.frame.size.width, theView.frame.size.height);
}

@end
