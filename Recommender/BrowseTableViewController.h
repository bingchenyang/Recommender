//
//  BrowseTableViewController.h
//  Recommender
//
//  Created by Benson Yang on 8/31/13.
//  Copyright (c) 2013 Benson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PoiStream.h"

@interface BrowseTableViewController : UITableViewController <PoiStreamDelegate>

@property (nonatomic, strong) PoiStream *poiStream;

@end
