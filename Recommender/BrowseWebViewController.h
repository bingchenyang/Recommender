//
//  BrowseWebViewController.h
//  Recommender
//
//  Created by Benson Yang on 9/5/13.
//  Copyright (c) 2013 Benson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Poi.h"

@interface BrowseWebViewController : UIViewController <UIWebViewDelegate>
@property (strong, nonatomic) IBOutlet UIWebView *contentView;

@property (nonatomic, strong) Poi *poi;

@end
