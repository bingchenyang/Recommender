//
//  Utils.m
//  Recommender
//
//  Created by Benson Yang on 11/7/13.
//  Copyright (c) 2013 Benson. All rights reserved.
//

#import "Utils.h"
#import <algorithm>

#define kProgressHUDTag 9999

#define MINIMUM_ZOOM_ARC 0.014 //approximately 1 miles (1 degree of arc ~= 69 miles)
#define ANNOTATION_REGION_PAD_FACTOR 1.15
#define MAX_DEGREES_ARC 360

static struct MGraph poisGraph;

@implementation Utils

#pragma mark - Progress HUD Utils
+ (void)showProgressHUD:(UIViewController *)controller withText:(NSString *)text {
    MBProgressHUD *existingHud = (MBProgressHUD *)[controller.view viewWithTag: kProgressHUDTag];
    if (nil == existingHud) {
        MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:controller.view];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.labelText = text;
        hud.tag = kProgressHUDTag;
        [hud show:YES];
        [controller.view addSubview:hud];
    }
}

+ (void)hideProgressHUD:(UIViewController *)controller {
    MBProgressHUD *hud = (MBProgressHUD *)[controller.view viewWithTag: kProgressHUDTag];
    if (hud != nil) {
        [hud removeFromSuperview];
    }
}

#pragma mark - DPPoiAnnotation Utils
+ (DPPoiAnnotation *)annotationForBusiness:(NSDictionary *)business {
    DPPoiAnnotation *annotation = [[DPPoiAnnotation alloc] init];
    double latitude = [[business valueForKey:@"latitude"] doubleValue];
    double longitude = [[business valueForKey:@"longitude"] doubleValue];
    annotation.coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    annotation.title = [business valueForKey:@"name"];
    annotation.subtitle = [business valueForKey:@"address"];
    annotation.pid = [business valueForKey:@"business_id"];
    annotation.photoURL = [business valueForKey:@"s_photo_url"];
    annotation.ratingImgURL = [business valueForKey:@"rating_s_img_url"];
    
    return annotation;
}

+ (DPPoiAnnotation *)annotationForPoi:(Poi *)poi {
    DPPoiAnnotation *annotation = [[DPPoiAnnotation alloc] init];
    annotation.poi = poi;
    annotation.coordinate = CLLocationCoordinate2DMake([poi.latitude floatValue], [poi.longitude floatValue]);
    annotation.title = poi.name;
    annotation.subtitle = poi.address;
    annotation.photoURL = poi.smallPhotoUrl;
    annotation.ratingImgURL = poi.ratingSmallImageUrl;
    
    return annotation;
}

#pragma mark - Map Utils
+ (void)zoomMapView:(MAMapView *)mapView ToFitAnnotations:(NSArray *)annotations {
    int count = [annotations count];
    if (count == 0) return;
    
    MAMapPoint points[count];
    for (int i = 0; i < count; i++) {
        CLLocationCoordinate2D coordinate = [(id<MAAnnotation>)[annotations objectAtIndex:i] coordinate];
        points[i] = MAMapPointForCoordinate(coordinate);
    }
    
    MAMapRect mapRect = [[MAPolygon polygonWithPoints:points count:count] boundingMapRect];
    MACoordinateRegion region = MACoordinateRegionForMapRect(mapRect);
    
    region.span.latitudeDelta *= ANNOTATION_REGION_PAD_FACTOR;
    region.span.longitudeDelta *= ANNOTATION_REGION_PAD_FACTOR;
    
    if (region.span.latitudeDelta < MINIMUM_ZOOM_ARC) {
        region.span.latitudeDelta = MINIMUM_ZOOM_ARC;
    }
    if (region.span.longitudeDelta < MINIMUM_ZOOM_ARC) {
        region.span.longitudeDelta = MINIMUM_ZOOM_ARC;
    }
    
    if (region.span.latitudeDelta > MAX_DEGREES_ARC) {
        region.span.latitudeDelta = MAX_DEGREES_ARC;
    }
    if (region.span.longitudeDelta > MAX_DEGREES_ARC) {
        region.span.longitudeDelta = MAX_DEGREES_ARC;
    }
    
    if (count == 1) {
        region.span.latitudeDelta = MINIMUM_ZOOM_ARC;
        region.span.longitudeDelta = MINIMUM_ZOOM_ARC;
    }
    
    [mapView setRegion:region animated:YES];
}

#pragma mark - TSP问题求解
+ (void)initPoisGraph {
    for (int i = 0; i < 20; i++) {
        for (int j = 0; j < 20; j++) {
            poisGraph.edges[i][j] = 0;
        }
    }
    
    poisGraph.edgesNumber = 0;
    poisGraph.vertexNumber = 0;
}

+ (struct MGraph *)GetPoisGraph {
    return &poisGraph;
}

#pragma mark - 模拟退火求TSP
+ (void)simulateAnneal:(const int [][20])distance withSize:(int)size {
    double T = 500; //系统温度
    double value = 0;
    int *sequence = new int[size];
    for (int i = 0; i < size; i++) {
        if (i != size - 1) {
            value += distance[i][i+1];
        }
        else {
            value += distance[i][0];
        }
        sequence[i] = i;
    }
    
    int s = 0;
    while (s != 40) {
        int bChange = 0;
        for (int i = 0; i < 15000; i++) {
            int p1 = 0, p2 = 0;
            while (p1 >= p2) {
                p1 = [self randomNumBetween:0 andNum:size];
                p2 = [self randomNumBetween:0 andNum:size];
            }
            double newValue = [self generateNewRouteWithMatrix:distance oldValue:value sequence:sequence size:size p1:p1 p2:p2];
            
            if ([self isAcceptedOldValue:value withNewValue:newValue inTemperature:T]) {
                [self changeSequence:sequence p1:p1 p2:p2];
                value = newValue;
                bChange = 1;
            }
        }
        T *= 0.95;
        if (bChange == 0) {
            s++;
        }
        else {
            s = 0;
        }
    }
    
    for (int i = 0; i < size; i++) {
        printf("%i\n", sequence[i]);
    }
    
    delete [] sequence;
}

+ (void)changeSequence:(int *)sequence p1:(int)p1 p2:(int)p2 {
    for (int i = p1, j = p2; i < j; i++, j--) {
        int tmp = sequence[i];
        sequence[i] = sequence[j];
        sequence[j] = tmp;
    }
}

+ (int)randomNumBetween:(int)low andNum:(int)high {
    return arc4random()%(high - low) + low;
}

+ (double)randomBetweenZeroToOne {
    double result = (double)arc4random()/(double)UINT32_MAX;
    return result;
}

+ (double)generateNewRouteWithMatrix:(const int [][20])distance oldValue:(double)oldValue sequence:(int *)sequence size:(int)size p1:(int)p1 p2:(int)p2 {
    double newValue = SIZE_T_MAX;
    if (p1 != 0 && p2 != size - 1) {
        newValue = oldValue - distance[sequence[p1 - 1]][sequence[p1]] - distance[sequence[p2]][sequence[p2 + 1]] + distance[sequence[p1 - 1]][sequence[p2]] + distance[sequence[p1]][sequence[p2 + 1]];
    }
    else if (p1 != 0 && p2 == size - 1) {
        newValue = oldValue - distance[sequence[p1 - 1]][sequence[p1]] - distance[sequence[p2]][sequence[0]] + distance[sequence[p1 - 1]][sequence[p2]] + distance[sequence[p1]][sequence[0]];
    }
    else if (p1 == 0 && p2 != size - 1) {
        newValue = oldValue - distance[sequence[size - 1]][sequence[p1]] - distance[sequence[p2]][sequence[p2 + 1]] + distance[sequence[size - 1]][sequence[p2]] + distance[sequence[p1]][sequence[p2 + 1]];
    }
    return newValue;
}

+ (BOOL)isAcceptedOldValue:(double)oldValue withNewValue:(double)newValue inTemperature:(double)T {
    BOOL accept = NO;
    if (newValue < oldValue) {
        accept = YES;
    }
    else if (newValue > oldValue) {
        if ([self randomBetweenZeroToOne] < pow(2.71727, (oldValue - newValue) / T)) {
            accept = YES;
        }
    }
    return accept;
}

#pragma mark - 枚举的方式求TSP最优解
+ (void)enumTSP:(const int [][20])distance withSize:(int)size onComplete:(void (^)(NSArray *))complete {
    int *sequence = new int [size];
    int *bestSolution = new int [size];
    for (int i = 0; i < size; i++) {
        sequence[i] = i;
        bestSolution[i] = sequence[i];
    }
    int count = 0;
    while (std::next_permutation(sequence, sequence+size)) {
        count++;
        if ([self getValue:distance ofSequence:sequence withSize:size] < [self getValue:distance ofSequence:bestSolution withSize:size]) {
            printf("%f < %f\n",[self getValue:distance ofSequence:sequence withSize:size], [self getValue:distance ofSequence:bestSolution withSize:size]);
            
            for (int i = 0; i < size; i++) {
                bestSolution[i] = sequence[i];
            }
        }
    }
    printf("after %d, the best solution: %f\n", count, [self getValue:distance ofSequence:bestSolution withSize:size]);
    for (int i = 0; i < size; i++) {
        printf("%i\n", bestSolution[i]);
    }
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:size];
    for (int i = 0; i < size; i++) {
        [array addObject:[NSNumber numberWithInt:bestSolution[i]]];
    }
    
    complete(array);
    
    delete [] sequence;
    delete [] bestSolution;
}

+ (double)getValue:(const int [][20])distance ofSequence:(int *)sequence withSize:(int)size {
    double value = 0;
    for (int i = 0; i < size; i++) {
        if (i != size - 1) {
            value += distance[sequence[i]][sequence[i+1]];
        }
        else {
            value += distance[sequence[i]][sequence[0]];
        }
    }
    return value;
}

+ (void)enumTSPWithCompletionHandler:(void (^)(NSArray *))complete {
    [self enumTSP:poisGraph.edges withSize:poisGraph.vertexNumber onComplete:^(NSArray *solution) {
        complete(solution);
    }];
}
@end
