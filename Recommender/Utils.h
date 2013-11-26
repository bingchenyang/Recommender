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

#define kNaviTypeSegmentSelectedIndex @"naviTypeSegmentSelectedIndex"
#define MAX_INTEGER 0x7fffffff

struct MGraph {
    int vertexNumber;
    int edgesNumber;
    int edges[20][20];
};

enum NaviType {
    NaviTypeDrive = 0,
    NaviTypeBus = 1,
    NaviTypeWalk = 2,
    NaviTypeOther = 3
};

@interface Utils : NSObject

+ (void)showProgressHUD:(UIViewController *)controller withText:(NSString *)text;

+ (void)hideProgressHUD:(UIViewController *)controller;

+ (DPPoiAnnotation *)annotationForBusiness:(NSDictionary *)business;

+ (DPPoiAnnotation *)annotationForPoi:(Poi *)poi;

+ (void)zoomMapView:(MAMapView *)mapView ToFitAnnotations:(NSArray *)annotations;

/***************TSP******************/
+ (struct MGraph *)GetPoisGraph;

+ (void)initPoisGraph;

//+ (void) enumTSP:(const int [][20])distance withSize:(int)size onComplete:(void(^)(NSArray *solution))complete;
//
//+ (void) simulateAnneal:(const int [][20])distance withSize:(int)size;

+ (void) enumTSPWithCompletionHandler:(void(^)(NSArray *solution))complete;
+ (void) SimulateAnnealTSPWithCompletionHandler:(void(^)(NSArray *solution))complete;
/************************************/

@end
