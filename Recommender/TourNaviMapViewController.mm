//
//  TourNaviMapViewController.m
//  Recommender
//
//  Created by Benson Yang on 11/11/13.
//  Copyright (c) 2013 Benson. All rights reserved.
//

#import "TourNaviMapViewController.h"
#import "UserLocationAnnotation.h"
#import "UIImage+DPAnnotation.h"
#import "Utils.h"

static MAUserLocation *sCurrentLocation;

@interface TourNaviMapViewController ()
@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) AMapSearchAPI *searchAPI;

@property (nonatomic, strong) UserLocationAnnotation *userLocationAnnotation;
@property (nonatomic, strong) MAAnnotationView *userLocationAnnotationView;
@property (nonatomic, strong) CMMotionManager *motionManager;
@end

@implementation TourNaviMapViewController

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
    [self.view addSubview:self.mapView];
    
    self.userLocationAnnotation = [[UserLocationAnnotation alloc] init];
    self.userLocationAnnotationView = [[MAAnnotationView alloc] initWithAnnotation:self.userLocationAnnotation reuseIdentifier:@"userLocationAnnotationView"];
    
    DPPoiAnnotation *originAnnotation = [Utils annotationForPoi:self.origin];
    DPPoiAnnotation *destinationAnnotation = [Utils annotationForPoi:self.destination];
    [self.mapView addAnnotations:@[originAnnotation, destinationAnnotation]];
    
    [Utils zoomMapView:self.mapView ToFitAnnotations:self.mapView.annotations];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.mapView.delegate = self;
    self.motionManager = [[CMMotionManager alloc] init];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.mapView.frame = self.view.bounds;
    self.mapView.showsUserLocation = YES;
    //[Utils zoomMapView:self.mapView ToFitAnnotations:self.mapView.annotations];
    
    [self.mapView addAnnotation:self.userLocationAnnotation];
    if ([self.motionManager isMagnetometerAvailable]) {
        self.motionManager.deviceMotionUpdateInterval = 0.5;
        [self.motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMDeviceMotion *motion, NSError *error) {
            CMAttitude *attitude = motion.attitude;
            self.userLocationAnnotationView.image = [UIImage userLocationImage:attitude.yaw];
        }];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"该设备磁力计不可用" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    self.mapView.delegate = nil;
    [self.motionManager stopDeviceMotionUpdates];
    self.motionManager = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

#pragma mark - MAMapViewDelegate
- (MAOverlayView *)mapView:(MAMapView *)mapView viewForOverlay:(id<MAOverlay>)overlay {
    if ([overlay isKindOfClass: [MAPolyline class]]) {
        MAPolylineView *polylineView = [[MAPolylineView alloc] initWithOverlay:overlay];
        polylineView.lineWidth = 5.0;
        polylineView.strokeColor = [UIColor blueColor];
        polylineView.fillColor = [UIColor redColor];
        return polylineView;
    }
    
    return nil;
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation {
    if ([annotation isKindOfClass:[UserLocationAnnotation class]]) {
        
        return self.userLocationAnnotationView;
    }
    else if ([annotation isKindOfClass:[DPPoiAnnotation class]]) {
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
        
        annotationView.image = [UIImage imageNamed:@"dot.png"];
        
        return annotationView;
    }
    
    return nil;
}


- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation {
    if (nil == sCurrentLocation) {
        sCurrentLocation = userLocation;
        
        //当前位置 --> origin
        AMapNavigationSearchRequest *firstRequest= [[AMapNavigationSearchRequest alloc] init];
        //Origin --> destination
        AMapNavigationSearchRequest *secondRequest = [[AMapNavigationSearchRequest alloc] init];
        NSInteger naviType = [[[NSUserDefaults standardUserDefaults] valueForKey:kNaviTypeSegmentSelectedIndex] integerValue];
        if (naviType == NaviTypeDrive) {
            firstRequest.searchType = AMapSearchType_NaviDrive;
            secondRequest.searchType = AMapSearchType_NaviDrive;
        }
        else if (naviType == NaviTypeBus) {
            firstRequest.searchType = AMapSearchType_NaviBus;
            secondRequest.searchType = AMapSearchType_NaviBus;
        }
        else if (naviType == NaviTypeWalk) {
            firstRequest.searchType = AMapSearchType_NaviWalking;
            secondRequest.searchType = AMapSearchType_NaviWalking;
        }
        
        CLLocationCoordinate2D coordinate = userLocation.location.coordinate;
        
        firstRequest.origin = [AMapGeoPoint locationWithLatitude:coordinate.latitude longitude:coordinate.longitude];
        firstRequest.destination = [AMapGeoPoint locationWithLatitude:[self.origin.latitude floatValue] longitude:[self.origin.longitude floatValue]];
        
        secondRequest.origin = firstRequest.destination;
        secondRequest.destination = [AMapGeoPoint locationWithLatitude:[self.destination.latitude floatValue] longitude:[self.destination.longitude floatValue]];
        
        firstRequest.city = @"shanghai";
        secondRequest.city = @"shanghai";
        [self.searchAPI AMapNavigationSearch:firstRequest];
        [self.searchAPI AMapNavigationSearch:secondRequest];
    }
    
    self.userLocationAnnotation.userLocation = userLocation;
    self.userLocationAnnotation.coordinate = userLocation.coordinate;
}


- (void)mapView:(MAMapView *)mapView didFailToLocateUserWithError:(NSError *)error {
    
}

#pragma mark - AMapSearchDelegate
- (void)onNavigationSearchDone:(AMapNavigationSearchRequest *)request response:(AMapNavigationSearchResponse *)response {
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
}

@end
