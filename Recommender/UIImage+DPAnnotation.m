//
//  UIImage+DPAnnotation.m
//  Recommender
//
//  Created by Benson Yang on 11/10/13.
//  Copyright (c) 2013 Benson. All rights reserved.
//

#import "UIImage+DPAnnotation.h"

@implementation UIImage (DPAnnotation)
+ (id)imageWithNumber:(NSInteger)num {
    UIImage *image = [UIImage imageNamed:@"dot.png"];
    
    UIGraphicsBeginImageContext(image.size);
    [image drawAtPoint:CGPointZero];
    CGSize textSize = CGSizeMake(image.size.width / 2, image.size.height / 2);
    CGPoint textPoint = CGPointMake(image.size.width / 2 - textSize.width / 3, image.size.height / 3 - textSize.height / 3);
    [[NSString stringWithFormat:@"%d", num] drawAtPoint:textPoint withFont:[UIFont systemFontOfSize:textSize.height]];
    UIImage *resultImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImg;
}

@end
