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
#import "AnnotationButton.h"
#import "DPPoiAnnotation.h"
#import "HelperMethods.h"
#import "BrowseWebViewController.h"

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
    self.mapView = [[MAMapView alloc] init];
    
    self.poiStream = [[PoiStream alloc] init];
    self.poiStream.delegate = self;
    [self.poiStream fetchPois];
    
    self.engineForImg = [[MKNetworkEngine alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.mapView.frame = self.view.bounds;
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];
    
    [HelperMethods printFrameOfView:self.view withViewName:@"self.view in M"];
    [HelperMethods printFrameOfView:self.mapView withViewName:@"self.mapView in M"];
    //self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [HelperMethods printFrameOfView:self.view withViewName:@"self.view in M --> viewDidAppear"];
    [HelperMethods printFrameOfView:self.mapView withViewName:@"self.mapView in M --> viewDidAppear"];
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

#pragma mark - 验证
- (NSString *)keyForMap {
    return @"a7d8df80ccf7c8d83afdf083fdef34be";
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
    annotation.coordinate = CLLocationCoordinate2DMake(poi.latitude, poi.longitude);
    annotation.title = poi.name;
    annotation.subtitle = poi.address;
    annotation.photoURL = poi.smallPhotoUrl;
    annotation.ratingImgURL = poi.ratingSmallImageUrl;
    
    return annotation;
}

- (void) showPoiDetail:(id) sender {
//    AnnotationButton *button = (AnnotationButton *)sender;
//    PoiDetailViewController *pDVC = [[PoiDetailViewController alloc]initWithNibName:@"PoiDetailViewController" bundle:nil];
//    pDVC.annotation = button.annotation;
//    [self.navigationController pushViewController:pDVC animated:YES];
    
    BrowseWebViewController *webViewController = [[BrowseWebViewController alloc] init];
}

#pragma mark - MAMapViewDelegate
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id)annotation {
    if ([annotation isKindOfClass:[DPPoiAnnotation class]])
    {
        static NSString *poiReuseIndetifier = @"poiReuseIndetifier";
        MAPinAnnotationView *annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:poiReuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:poiReuseIndetifier];
            annotationView.canShowCallout = YES;
        }
        else
        {
            annotationView.annotation = annotation;
        }
        
        annotationView.pinColor = MAPinAnnotationColorPurple;
        annotationView.animatesDrop = YES;
        AnnotationButton *rightButton = [[AnnotationButton alloc] init];
        [rightButton addTarget:self action:@selector(showPoiDetail:) forControlEvents:UIControlEventTouchUpInside];
        rightButton.annotation = annotation;
        annotationView.rightCalloutAccessoryView = rightButton;
        
        UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [spinner startAnimating];
        annotationView.leftCalloutAccessoryView = spinner;
        
        MKNetworkOperation *op = [self.engineForImg operationWithURLString:[annotation photoURL]];
        [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
            imgView.image = [UIImage imageWithData:completedOperation.responseData];
            annotationView.leftCalloutAccessoryView = imgView;
        } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
            ;
        }];
        [self.engineForImg enqueueOperation:op];
        
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

@end
