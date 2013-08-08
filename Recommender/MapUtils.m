//
//  MapUtils.m
//  Recommender
//
//  Created by Benson Yang on 8/8/13.
//  Copyright (c) 2013 Benson. All rights reserved.
//

#import "MapUtils.h"

#define MINIMUM_ZOOM_ARC 0.014 //approximately 1 miles (1 degree of arc ~= 69 miles)
#define ANNOTATION_REGION_PAD_FACTOR 1.15
#define MAX_DEGREES_ARC 360

@implementation MapUtils
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
