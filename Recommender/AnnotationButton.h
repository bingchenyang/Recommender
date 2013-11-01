//
//  AnnotationButton.h
//  Recommender
//
//  Created by Benson Yang on 8/8/13.
//  Copyright (c) 2013 Benson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>
#import "DPPoiAnnotation.h"
#import "Poi+DianPing.h"

@interface AnnotationButton : UIButton
@property (nonatomic, strong) DPPoiAnnotation *annotation;
@property (nonatomic, strong) Poi *poi;

- (id)init;

@end
