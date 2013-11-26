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

+ (UIImage *)userLocationImage:(CGFloat)radians {
    UIImage *image = [UIImage imageNamed:@"userDirectionIndicator.png"];
    UIGraphicsBeginImageContext(CGSizeMake(40, 40));
    [image drawInRect:CGRectMake(0, 0, 40, 40)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    scaledImage = [scaledImage imageRotatedByRadians: (-radians)];
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

- (UIImage *)imageRotatedByRadians:(CGFloat)radians
{
    // calculate the size of the rotated view's containing box for our drawing space
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.size.width, self.size.height)];
    CGAffineTransform t = CGAffineTransformMakeRotation(radians);
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
    
    // Create the bitmap context
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    
    // Move the origin to the middle of the image so we will rotate and scale around the center.
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    
    //   // Rotate the image context
    CGContextRotateCTM(bitmap, radians);
    
    // Now, draw the rotated/scaled image into the context
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-self.size.width / 2, -self.size.height / 2, self.size.width, self.size.height), [self CGImage]);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
