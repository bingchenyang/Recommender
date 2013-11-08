//
//  TourMapViewController.h
//  Recommender
//
//  Created by Benson Yang on 11/7/13.
//  Copyright (c) 2013 Benson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>

@interface TourMapViewController : UIViewController <MAMapViewDelegate>
@property (nonatomic, strong) NSOrderedSet *pois;

@end
