//
//  PoiPair.m
//  Recommender
//
//  Created by Benson Yang on 11/9/13.
//  Copyright (c) 2013 Benson. All rights reserved.
//

#import "PoiPair.h"

@implementation PoiPair

- (id)initWithOrigin:(Poi *)origin andDestination:(Poi *)destination {
    if (self = [super init]) {
        self.origin = origin;
        self.destination = destination;
    }
    return self;
}

@end
