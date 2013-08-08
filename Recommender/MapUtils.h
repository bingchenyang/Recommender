//
//  MapUtils.h
//  Recommender
//
//  Created by Benson Yang on 8/8/13.
//  Copyright (c) 2013 Benson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MAMapKit.h"

@interface MapUtils : NSObject
+ (void)zoomMapView:(MAMapView *)mapView ToFitAnnotations:(NSArray *)annotations;

@end
