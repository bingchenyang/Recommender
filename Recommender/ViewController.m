//
//  ViewController.m
//  Recommender
//
//  Created by Benson Yang on 8/6/13.
//  Copyright (c) 2013 Benson. All rights reserved.
//

#import "ViewController.h"
#import "DianPingEngine.h"
#import "MapUtils.h"
#import "AnnotationButton.h"
#import "DPPoiAnnotation.h"

#define kDianPingShowPoiDetail @"DianPingShowPoiDetail"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) MAMapView *mapView;
@property (weak, nonatomic) IBOutlet UIView *mapDisplayView;

@property (nonatomic, strong) MKNetworkEngine *engineForImg;
@end

@implementation ViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
     self.mapView = [[MAMapView alloc] init];
    
    DianPingEngine *engine = [DianPingEngine sharedEngine];
    [engine findPoi:@"景点" inCity:@"上海" page:1 sort:DianPingSortTypeDefault onCompletion:^(NSArray *businesses) {
        for (NSDictionary *business in businesses) {
            DPPoiAnnotation *annotation = [self annotationForBusiness:business];
            [self.mapView addAnnotation:annotation];
        }
        [MapUtils zoomMapView:self.mapView ToFitAnnotations:self.mapView.annotations];
    } onError:^(NSError *error) {
        NSLog(@"%@", error);
    }];
    
    self.engineForImg = [[MKNetworkEngine alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.searchBar.delegate = self;
    self.searchBar.showsCancelButton = YES;
    
    self.mapView.frame = self.mapDisplayView.bounds;
    self.mapView.delegate = self;
    [self.mapDisplayView addSubview:self.mapView];
    
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    self.searchBar.delegate = nil;
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

#pragma mark - UISearchBarDelegate Methods
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    DianPingEngine *engine = [DianPingEngine sharedEngine];
    [engine findPoi:[NSString stringWithFormat:@"景点 %@", searchBar.text] inCity:@"上海" page:1 sort:DianPingSortTypeDefault onCompletion:^(NSArray *businesses) {
        for (NSDictionary *business in businesses) {
            MAPointAnnotation *annotation = [self annotationForBusiness:business];
            [self.mapView addAnnotation:annotation];
        }
        [MapUtils zoomMapView:self.mapView ToFitAnnotations:self.mapView.annotations];
    } onError:^(NSError *error) {
        NSLog(@"%@", error);
    }];
    
    [searchBar resignFirstResponder];
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

- (void) showPoiDetail:(id) sender {
    AnnotationButton *button = (AnnotationButton *)sender;
    PoiDetailViewController *pDVC = [[PoiDetailViewController alloc]initWithNibName:@"PoiDetailViewController" bundle:nil];
    pDVC.annotation = button.annotation;
    [self.navigationController pushViewController:pDVC animated:YES];
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

@end
