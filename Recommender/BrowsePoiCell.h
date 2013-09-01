//
//  BrowsePoiCell.h
//  Recommender
//
//  Created by Benson Yang on 9/1/13.
//  Copyright (c) 2013 Benson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BrowsePoiCell : UITableViewCell


@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) UIImage *photo;
@property (nonatomic, strong) UIImage *rating;

@end
