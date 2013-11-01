//
//  ViewController.m
//  Recommender
//
//  Created by Benson Yang on 8/6/13.
//  Copyright (c) 2013 Benson. All rights reserved.
//

#import "BrowseMapViewController.h"
#import "DianPingEngine.h"
#import "MapUtils.h"
#import "DPPoiAnnotation.h"
#import "HelperMethods.h"
#import "BrowseWebViewController.h"
#import "BrowseRootViewController.h"

#define kDianPingShowPoiDetail @"DianPingShowPoiDetail"

@interface BrowseMapViewController ()
@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) MKNetworkEngine *engineForImg;
@end

@implementation BrowseMapViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [MAMapServices sharedServices].apiKey = @"a7d8df80ccf7c8d83afdf083fdef34be";
    
    self.mapView = [[MAMapView alloc] init];
    self.mapView.frame = self.view.bounds;

    self.poiStream = [[PoiStream alloc] init];
    self.poiStream.delegate = self;
    [self.poiStream fetchPois];

    self.engineForImg = [[MKNetworkEngine alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];

    //self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    self.view.frame = self.parentViewController.view.bounds;
    self.mapView.frame = self.parentViewController.view.bounds;
}

- (void)viewWillDisappear:(BOOL)animated {
    self.mapView.delegate = nil;
    self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Helper Methods
- (DPPoiAnnotation *)annotationForBusiness:(NSDictionary *)business {
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

- (DPPoiAnnotation *)annotationForPoi:(Poi *)poi {
    DPPoiAnnotation *annotation = [[DPPoiAnnotation alloc] init];
    annotation.poi = poi;
    annotation.coordinate = CLLocationCoordinate2DMake([poi.latitude floatValue], [poi.longitude floatValue]);
    annotation.title = poi.name;
    annotation.subtitle = poi.address;
    annotation.photoURL = poi.smallPhotoUrl;
    annotation.ratingImgURL = poi.ratingSmallImageUrl;
    
    return annotation;
}

#pragma mark - MAMapViewDelegate
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id)annotation {
    if ([annotation isKindOfClass:[DPPoiAnnotation class]])
    {
        DPPoiAnnotation *poiAnnotation = annotation;
        static NSString *poiReuseIndetifier = @"poiReuseIndetifier";
        MAPinAnnotationView *annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:poiReuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:poiAnnotation reuseIdentifier:poiReuseIndetifier];
            annotationView.canShowCallout = YES;
        }
        else
        {
            annotationView.annotation = poiAnnotation;
        }
        
        annotationView.pinColor = MAPinAnnotationColorPurple;
        annotationView.animatesDrop = YES;
        AnnotationButton *rightButton = [[AnnotationButton alloc] init];
        [rightButton addTarget:self action:@selector(showPoiDetail:) forControlEvents:UIControlEventTouchUpInside];
        rightButton.annotation = poiAnnotation;
        rightButton.poi = poiAnnotation.poi;
        
        annotationView.rightCalloutAccessoryView = rightButton;
        
        UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [spinner startAnimating];
        annotationView.leftCalloutAccessoryView = spinner;
        
//        MKNetworkOperation *op = [self.engineForImg operationWithURLString:[annotation photoURL]];
//        [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
//            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
//            imgView.image = [UIImage imageWithData:completedOperation.responseData];
//            annotationView.leftCalloutAccessoryView = imgView;
//        } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
//            ;
//        }];
//        [self.engineForImg enqueueOperation:op];
        
        return annotationView;
    }
    
    return nil;
}

#pragma mark - PoiStreamDelegate
- (void)PoiStreamDelegateFetchPoisDidFinish:(PoiStream *)poiStream {
    self.poiStream = poiStream;
    for (Poi *poi in poiStream.pois) {
        DPPoiAnnotation *annotation = [self annotationForPoi:poi];
        [self.mapView addAnnotation:annotation];
    }
    [MapUtils zoomMapView:self.mapView ToFitAnnotations:self.mapView.annotations];
}

#pragma mark - 
- (void) showPoiDetail:(id)sender {
    AnnotationButton *aButton = sender;
    BrowseRootViewController *parentVC = (BrowseRootViewController *)self.parentViewController;
    [parentVC performSegueWithIdentifier:@"toPoiDetailWeb" sender:aButton];
}
@end
