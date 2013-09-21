//
//  Poi+DianPing.h
//  Recommender
//
//  Created by Benson Yang on 9/17/13.
//  Copyright (c) 2013 Benson. All rights reserved.
//

#import "Poi.h"
#import "Category+DianPing.h"

@interface Poi (DianPing)

- (id)initWithResponse:(NSDictionary *)response;
- (void)loadFromDictionary:(NSDictionary *)data;
+ (Poi *)poiWithDPResponse:(NSDictionary *)dpResponse inObjectContext:(NSManagedObjectContext *)context;

@end
