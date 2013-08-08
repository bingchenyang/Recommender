//
//  AnnotationButton.h
//  Recommender
//
//  Created by Benson Yang on 8/8/13.
//  Copyright (c) 2013 Benson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MAMapKit.h"

@interface AnnotationButton : UIButton
@property (nonatomic, strong) id<MAAnnotation> annotation;

- (id)init;

@end
