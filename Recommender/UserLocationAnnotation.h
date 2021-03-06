//
//  UserLocationAnnotation.h
//  Recommender
//
//  Created by Benson Yang on 11/23/13.
//  Copyright (c) 2013 Benson. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>

@interface UserLocationAnnotation : MAPointAnnotation
@property (nonatomic, strong) MAUserLocation *userLocation;

@end
