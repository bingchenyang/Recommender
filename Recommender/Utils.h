//
//  Utils.h
//  Recommender
//
//  Created by Benson Yang on 11/7/13.
//  Copyright (c) 2013 Benson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MAMapKit/MAMapKit.h>
#import "DPPoiAnnotation.h"
#import "MBProgressHUD.h"

@interface Utils : NSObject

+ (void)showProgressHUD:(UIViewController *)controller withText:(NSString *)text;

+ (void)hideProgressHUD:(UIViewController *)controller;

+ (DPPoiAnnotation *)annotationForBusiness:(NSDictionary *)business;

+ (DPPoiAnnotation *)annotationForPoi:(Poi *)poi;

+ (void)zoomMapView:(MAMapView *)mapView ToFitAnnotations:(NSArray *)annotations;

@end
