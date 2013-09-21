//
//  Region+DianPing.m
//  Recommender
//
//  Created by Benson Yang on 9/21/13.
//  Copyright (c) 2013 Benson. All rights reserved.
//

#import "Region+DianPing.h"

@implementation Region (DianPing)

+ (Region *)regionWithCategoryName:(NSString *)regionName
                   inObjectContext:(NSManagedObjectContext *)context {
    Region *region = nil;
    
    // 1.fetch
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Region"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    request.predicate = [NSPredicate predicateWithFormat:@"name = %@", regionName];
    
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    // 2.
    if (!matches || [matches count] > 1) {
        // nil means fetch failed; more than one impossible
    }
    else if ([matches count] == 1) {
        region = [matches lastObject];
    }
    else {
        region = [NSEntityDescription insertNewObjectForEntityForName:@"Region" inManagedObjectContext:context];
        region.name = regionName;
    }
    
    return region;
}

+ (NSSet *)regionsWithCategoryArray:(NSArray *)regionArray
                   inObjectContext:(NSManagedObjectContext *)context {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:[regionArray count]];
    for (NSString *regionName in regionArray) {
        Region *region = [self regionWithCategoryName:regionName inObjectContext:context];
        [array addObject:region];
    }
    
    return [NSSet setWithArray:array];
}
@end
