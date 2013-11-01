//
//  DPPoiAnnotation.h
//  Recommender
//
//  Created by Benson Yang on 8/8/13.
//  Copyright (c) 2013 Benson. All rights reserved.
//

#import <MAMapKit/MAPointAnnotation.h>
#import "Poi+DianPing.h"

@interface DPPoiAnnotation : MAPointAnnotation
@property (strong ,nonatomic) Poi *poi;
@property (strong, nonatomic) NSString *pid;
@property (strong, nonatomic) NSString *ratingImgURL;
@property (strong, nonatomic) NSString *photoURL;

@end
