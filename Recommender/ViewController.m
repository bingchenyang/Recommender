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

#define kDianPingShowPoiDetail @"DianPingShowPoiDetail"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) MAMapView *mapView;
@property (weak, nonatomic) IBOutlet UIView *mapDisplayView;

@property (nonatomic, strong) NSArray *poiList;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
     self.mapView = [[MAMapView alloc] init];
    
    DianPingEngine *engine = [[DianPingEngine alloc] init];
    [engine findPoi:@"景点" inCity:@"上海" page:1 sort:DianPingSortTypeDefault onCompletion:^(NSArray *businesses) {
        for (NSDictionary *business in businesses) {
            MAPointAnnotation *annotation = [self annotationForBusiness:business];
            [self.mapView addAnnotation:annotation];
        }
        [MapUtils zoomMapView:self.mapView ToFitAnnotations:self.mapView.annotations];
    } onError:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.searchBar.delegate = self;
    self.searchBar.showsCancelButton = YES;
    
    self.mapView.frame = self.mapDisplayView.bounds;
    self.mapView.delegate = self;
    [self.mapDisplayView addSubview:self.mapView];
}

- (void)viewWillDisappear:(BOOL)animated {
    self.searchBar.delegate = nil;
    self.mapView.delegate = nil;
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
    
    DianPingEngine *engine = [[DianPingEngine alloc] init];
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
- (MAPointAnnotation *)annotationForBusiness:(NSDictionary *)business {
    MAPointAnnotation *annotation = [[MAPointAnnotation alloc] init];
    double latitude = [[business valueForKey:@"latitude"] doubleValue];
    double longitude = [[business valueForKey:@"longitude"] doubleValue];
    annotation.coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    annotation.title = [business valueForKey:@"name"];
    return annotation;
}

- (void) showPoiDetail:(id) sender {
    AnnotationButton *button = (AnnotationButton *)sender;
    PoiDetailViewController *pDVC = [[PoiDetailViewController alloc]initWithNibName:@"PoiDetailViewController" bundle:nil];
    pDVC.annotation = button.annotation;
    [self.navigationController pushViewController:pDVC animated:YES];
}

#pragma mark - MAMapViewDelegate
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation {
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
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
        return annotationView;
    }
    
    return nil;
}

@end
