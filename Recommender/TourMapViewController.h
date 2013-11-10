//
//  TourMapViewController.h
//  Recommender
//
//  Created by Benson Yang on 11/7/13.
//  Copyright (c) 2013 Benson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>

@interface TourMapViewController : UIViewController <MAMapViewDelegate, AMapSearchDelegate>
@property (nonatomic, strong) NSOrderedSet *pois;

@end
