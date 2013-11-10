//
//  PoiPair.h
//  Recommender
//
//  Created by Benson Yang on 11/9/13.
//  Copyright (c) 2013 Benson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Poi.h"

@interface PoiPair : NSObject
@property (nonatomic, strong) Poi *origin;
@property (nonatomic, strong) Poi *destination;

- (id)initWithOrigin:(Poi *)origin andDestination:(Poi *)destination;

@end
