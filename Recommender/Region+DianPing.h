//
//  Region+DianPing.h
//  Recommender
//
//  Created by Benson Yang on 9/21/13.
//  Copyright (c) 2013 Benson. All rights reserved.
//

#import "Region.h"

@interface Region (DianPing)

+ (Region *)regionWithCategoryName:(NSString *)regionName inObjectContext:(NSManagedObjectContext *)context;
+ (NSSet *)regionsWithCategoryArray:(NSArray *)regionArray inObjectContext:(NSManagedObjectContext *)context;

@end
