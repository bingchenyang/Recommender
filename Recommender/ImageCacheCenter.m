//
//  ImageCacheCenter.m
//  Recommender
//
//  Created by Benson Yang on 9/1/13.
//  Copyright (c) 2013 Benson. All rights reserved.
//

#import "ImageCacheCenter.h"

@interface ImageCacheCenter ()
@property (nonatomic, strong) NSMutableDictionary *imageHouse;
@property NSLock *accessLock;
@end

@implementation ImageCacheCenter

+ (ImageCacheCenter *)defaultCacheCenter {
    static ImageCacheCenter *sCenter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sCenter = [[self alloc] init];
        sCenter.accessLock = [[NSLock alloc] init];
        sCenter.imageHouse = [NSMutableDictionary dictionary];
    });
    
    return sCenter;
}

- (void)setImage:(UIImage *)image ForKey:(NSString *)key {
    if (image != nil && key != nil) {
        [self.accessLock lock];
        [self.imageHouse setObject:image forKey:key];
        [self.accessLock unlock];
    }
}

- (UIImage *)imageForKey:(NSString *)key {
    UIImage *image = nil;
    
    [self.accessLock lock];
    image = [self.imageHouse objectForKey:key];
    [self.accessLock unlock];
    
    return image;
}

- (UIImage *)fetchImageWithUrl:(NSString *)url {
    
}

@end
