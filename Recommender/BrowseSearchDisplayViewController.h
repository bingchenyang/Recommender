//
//  BrowseSearchDisplayViewController.h
//  Recommender
//
//  Created by Benson Yang on 11/25/13.
//  Copyright (c) 2013 Benson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PoiStream.h"

@interface BrowseSearchDisplayViewController : UITableViewController <UISearchBarDelegate, UISearchDisplayDelegate, PoiStreamDelegate>

@property (nonatomic, strong) PoiStream *poiStream;

@end
