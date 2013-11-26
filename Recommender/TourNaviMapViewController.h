//
//  TourNaviMapViewController.h
//  Recommender
//
//  Created by Benson Yang on 11/11/13.
//  Copyright (c) 2013 Benson. All rights reserved.
//
// 当前位置-->origin-->destination

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>
#import <CoreMotion/CoreMotion.h>
#import "Poi+DianPing.m"

@interface TourNaviMapViewController : UIViewController <MAMapViewDelegate, AMapSearchDelegate>
@property (nonatomic, strong) Poi *origin;
@property (nonatomic, strong) Poi *destination;

@end
