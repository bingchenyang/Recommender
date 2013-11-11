//
//  TourMapViewController.m
//  Recommender
//
//  Created by Benson Yang on 11/7/13.
//  Copyright (c) 2013 Benson. All rights reserved.
//

#import "TourMapViewController.h"
#import "PoiPair.h"
#import "Poi+DianPing.m"
#import "Utils.h"
#import "UIImage+DPAnnotation.h"

@interface TourMapViewController ()
@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) AMapSearchAPI *searchAPI;

@property (nonatomic, strong) NSMutableOrderedSet *poiPairs;

@end

@implementation TourMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [MAMapServices sharedServices].apiKey = @"a7d8df80ccf7c8d83afdf083fdef34be";
    self.searchAPI = [[AMapSearchAPI alloc] initWithSearchKey:@"a7d8df80ccf7c8d83afdf083fdef34be" Delegate:self];
    
    self.mapView = [[MAMapView alloc] init];
    self.mapView.rotateCameraEnabled = NO;
    self.mapView.rotateEnabled = NO;
    [self.view addSubview:self.mapView];
    [self.view bringSubviewToFront:self.naviTypeSegment];
    
    self.poiPairs = [self poiPairsFromPois:self.pois];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.naviTypeSegment.selectedSegmentIndex = [[[NSUserDefaults standardUserDefaults] valueForKey:kNaviTypeSegmentSelectedIndex] integerValue];
    self.mapView.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    CGRect frame = self.view.bounds;
    frame.origin.y += self.naviTypeSegment.frame.size.height;
    frame.size.height -= self.naviTypeSegment.frame.size.height;
    self.mapView.frame = frame;
    
    [self requestForNextPolylines];
    
    for (Poi *poi in self.pois) {
        DPPoiAnnotation *annotation = [Utils annotationForPoi:poi];
        [self.mapView addAnnotation:annotation];
    }
    [Utils zoomMapView:self.mapView ToFitAnnotations:self.mapView.annotations];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    NSLog(@"receive memory warning in: %@", [self class]);
}

#pragma mark
- (NSMutableOrderedSet *)poiPairsFromPois:(NSOrderedSet *)pois {
    NSMutableOrderedSet *poiPairs = [[NSMutableOrderedSet alloc] init];
    
    for (int i = 0; i < pois.count - 1; i++) {
        Poi *origin = [pois objectAtIndex:i];
        Poi *destination = [pois objectAtIndex:i+1];
        PoiPair *poiPair = [[PoiPair alloc] initWithOrigin:origin andDestination:destination];
        
        [poiPairs addObject:poiPair];
    }
    if (pois.count > 1) {
        Poi *origin = [pois lastObject];
        Poi *destination = [pois objectAtIndex:0];
        PoiPair *poiPair = [[PoiPair alloc] initWithOrigin:origin andDestination:destination];
        
        [poiPairs addObject:poiPair];
    }
    
    return  poiPairs;
}

- (void)requestForNextPolylines {
    if (self.poiPairs.count > 0) {
        AMapNavigationSearchRequest *naviRequest= [[AMapNavigationSearchRequest alloc] init];
        if (self.naviTypeSegment.selectedSegmentIndex == NaviTypeDrive) {
            naviRequest.searchType = AMapSearchType_NaviDrive;
        }
        else if (self.naviTypeSegment.selectedSegmentIndex == NaviTypeBus) {
            naviRequest.searchType = AMapSearchType_NaviBus;
        }
        else if (self.naviTypeSegment.selectedSegmentIndex == NaviTypeWalk) {
            naviRequest.searchType = AMapSearchType_NaviWalking;
        }
        //每次处理完self.poiPairs第一个object会被移除
        PoiPair *poiPair = [self.poiPairs objectAtIndex:0];
        Poi *origin = poiPair.origin;
        Poi *destination = poiPair.destination;
        naviRequest.origin = [AMapGeoPoint locationWithLatitude:[origin.latitude floatValue] longitude:[origin.longitude floatValue]];
        naviRequest.destination = [AMapGeoPoint locationWithLatitude:[destination.latitude floatValue] longitude:[destination.longitude floatValue]];
        naviRequest.city = @"shanghai";
        [self.searchAPI AMapNavigationSearch:naviRequest];
    }
}

- (MAPolyline *)polylineFromString:(NSString *)polylineString {
    NSArray *coordinateStrs = [polylineString componentsSeparatedByString:@";"];
    CLLocationCoordinate2D *coordinates = new CLLocationCoordinate2D[coordinateStrs.count];
    for (int i = 0; i < coordinateStrs.count; i++) {
        NSString *coorinateStr = [coordinateStrs objectAtIndex:i];
        NSArray *coordinatePair = [coorinateStr componentsSeparatedByString:@","];
        
        coordinates[i].longitude = [[coordinatePair objectAtIndex:0] doubleValue];
        coordinates[i].latitude = [[coordinatePair lastObject] doubleValue];
    }
    MAPolyline *polyline = [MAPolyline polylineWithCoordinates:coordinates count: coordinateStrs.count];
    delete [] coordinates;
    return polyline;
}

#pragma mark - AMapSearchDelegate Methods
- (void)onNavigationSearchDone:(AMapNavigationSearchRequest *)request response:(AMapNavigationSearchResponse *)response {
    //处理返回结果
    if (response.route.paths.count != 0) {
        int index = 0;
        NSInteger minDuration = NSIntegerMax;
        for (int i = 0; i < response.route.paths.count; i++) {
            AMapPath *path = [response.route.paths objectAtIndex:i];
            if (path.duration < minDuration) {
                minDuration = path.duration;
                index = i;
            }
        }
        // 花费时间最少的path
        AMapPath *leastDurationPath = [response.route.paths objectAtIndex:index];
        for (AMapStep *step in leastDurationPath.steps) {
            MAPolyline *polyline = [self polylineFromString:step.polyline];
            [self.mapView addOverlay:polyline];
        }
    }
    else if (response.route.transits.count != 0) {
        int index = 0;
        NSInteger minDuration = NSIntegerMax;
        for (int i = 0; i < response.route.transits.count; i++) {
            AMapTransit *transit = [response.route.transits objectAtIndex:i];
            if (transit.duration < minDuration) {
                minDuration = transit.duration;
                index = i;
            }
        }
        
        AMapTransit *leastDurationTransit = [response.route.transits objectAtIndex:index];
        for (AMapSegment *segment in leastDurationTransit.segments) {
            AMapWalking *walking = segment.walking;
            for (AMapStep *step in walking.steps) {
                MAPolyline *polyline = [self polylineFromString:step.polyline];
                [self.mapView addOverlay:polyline];
            }
            AMapBusLine *busline = segment.busline;
            MAPolyline *polyline = [self polylineFromString:busline.polyline];
            [self.mapView addOverlay:polyline];
        }
    }
     
    [self.poiPairs removeObjectAtIndex:0];
    
    //TODO:change count > 0 back
    if (self.poiPairs.count > 0) {
        [self requestForNextPolylines];
    }
}

#pragma mark - MAMapDelegate Methods
- (MAOverlayView *)mapView:(MAMapView *)mapView viewForOverlay:(id<MAOverlay>)overlay {
    if ([overlay isKindOfClass:[MAPolyline class]]) {
        MAPolylineView *polylineView = [[MAPolylineView alloc] initWithOverlay:overlay];
        polylineView.lineWidth = 5.0;
        polylineView.strokeColor = [UIColor blueColor];
        polylineView.fillColor = [UIColor redColor];
        return polylineView;
    }
    else if ([overlay isKindOfClass:[MAPolygon class]]) {
        MAPolygonView *polygonView = [[MAPolygonView alloc] initWithOverlay:overlay];
        polygonView.lineWidth = 15.0;
        polygonView.strokeColor = [UIColor colorWithRed:0 green:1 blue:0 alpha:1];
        return polygonView;
    }
    
    return nil;
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation {
    if ([annotation isKindOfClass:[DPPoiAnnotation class]]) {
        static NSString *poiReuseIdentifier = @"dotAnnotationView";
        DPPoiAnnotation *poiAnnotation = annotation;
        MAAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:poiReuseIdentifier];
        if (annotationView == nil) {
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:poiAnnotation reuseIdentifier:poiReuseIdentifier];
            annotationView.canShowCallout = YES;
        }
        else {
            annotationView.annotation = poiAnnotation;
        }
        annotationView.image = [UIImage imageWithNumber:[self.pois indexOfObject:poiAnnotation.poi] + 1];
        return annotationView;
    }
    
    return nil;
}
@end
