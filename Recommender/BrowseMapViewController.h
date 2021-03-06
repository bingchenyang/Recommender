//
//  ViewController.h
//  Recommender
//
//  Created by Benson Yang on 8/6/13.
//  Copyright (c) 2013 Benson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>
#import "PoiStream.h"
#import "AnnotationButton.h"

@interface BrowseMapViewController : UIViewController <MAMapViewDelegate, PoiStreamDelegate>

@property (nonatomic, strong) PoiStream *poiStream;

@end
