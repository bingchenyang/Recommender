//
//  DPPoiAnnotation.h
//  Recommender
//
//  Created by Benson Yang on 8/8/13.
//  Copyright (c) 2013 Benson. All rights reserved.
//

#import "MAPointAnnotation.h"

@interface DPPoiAnnotation : MAPointAnnotation
@property (strong, nonatomic) NSString *pid;
@property (strong, nonatomic) NSString *ratingImgURL;
@property (strong, nonatomic) NSString *photoURL;

@end
