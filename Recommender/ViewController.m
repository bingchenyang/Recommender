//
//  ViewController.m
//  Recommender
//
//  Created by Benson Yang on 8/6/13.
//  Copyright (c) 2013 Benson. All rights reserved.
//

#import "ViewController.h"
#import "DianPingEngine.h"

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
    
    NSMutableDictionary *headerFields = [NSMutableDictionary dictionary];
    [headerFields setValue:@"iOS" forKey:@"x-client-identifier"];
    DianPingEngine *engine = [[DianPingEngine alloc] initWithHostName:@"api.dianping.com"];
    [engine findPoi:@"景点" inCity:@"上海" page:1 sort:1];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.searchBar.delegate = self;
    self.searchBar.showsCancelButton = YES;
    
    self.mapView.frame = self.mapDisplayView.bounds;
    self.mapView.delegate = self;
    [self.mapDisplayView addSubview:self.mapView];
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
    
}

@end
