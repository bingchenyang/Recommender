//
//  ImageCacheCenter.h
//  Recommender
//
//  Created by Benson Yang on 9/1/13.
//  Copyright (c) 2013 Benson. All rights reserved.
//
// I created this object to manage the entire application's images.
// 

#import <Foundation/Foundation.h>

@interface ImageCacheCenter : NSObject

+ (ImageCacheCenter *)defaultCacheCenter;

- (void)setImage:(UIImage *)image ForKey:(NSString *)key;
- (UIImage *)imageForKey:(NSString *)key;

- (UIImage *)fetchImageWithUrl:(NSString *)url;

@end
