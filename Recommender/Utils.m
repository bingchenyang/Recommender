//
//  Utils.m
//  Recommender
//
//  Created by Benson Yang on 11/7/13.
//  Copyright (c) 2013 Benson. All rights reserved.
//

#import "Utils.h"

#define kProgressHUDTag 9999

#define MINIMUM_ZOOM_ARC 0.014 //approximately 1 miles (1 degree of arc ~= 69 miles)
#define ANNOTATION_REGION_PAD_FACTOR 1.15
#define MAX_DEGREES_ARC 360

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

@end
