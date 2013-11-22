//
//  TourNaviDescriptionViewController.h
//  Recommender
//
//  Created by Benson Yang on 11/11/13.
//  Copyright (c) 2013 Benson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>

@interface TourNaviDescriptionViewController : UITableViewController
@property (nonatomic, strong) NSArray *routes;
@property (nonatomic, strong) NSOrderedSet *pois;

@end
