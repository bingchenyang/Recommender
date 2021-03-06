//
//  Deal+DianPing.h
//  Recommender
//
//  Created by Benson Yang on 9/21/13.
//  Copyright (c) 2013 Benson. All rights reserved.
//

#import "Deal.h"

@interface Deal (DianPing)

+ (Deal *)dealWithDPResponse:(NSDictionary *)dpResponse inObjectContext:(NSManagedObjectContext *)context;
+ (NSSet *)dealsWithDPResponse:(NSArray *)dpResponse inObjectContext:(NSManagedObjectContext *)context;

@end
