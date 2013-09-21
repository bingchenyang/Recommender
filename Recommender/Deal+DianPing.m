//
//  Deal+DianPing.m
//  Recommender
//
//  Created by Benson Yang on 9/21/13.
//  Copyright (c) 2013 Benson. All rights reserved.
//

#import "Deal+DianPing.h"

@implementation Deal (DianPing)

+ (Deal *)dealWithDPResponse:(NSDictionary *)dpResponse
             inObjectContext:(NSManagedObjectContext *)context {
    Deal *deal = nil;
    
    // 1.fetch
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Deal"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"id" ascending:YES]];
    request.predicate = [NSPredicate predicateWithFormat:@"id = %@", dpResponse[@"id"]];
    
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    // 2.
    if (!matches || [matches count] > 1) {
        // nil means fetch failed; more than one impossible
    }
    else if ([matches count] == 1) {
        deal = [matches lastObject];
    }
    else {
        deal = [NSEntityDescription insertNewObjectForEntityForName:@"Deal" inManagedObjectContext:context];
        deal.id = dpResponse[@"id"];
        deal.dealDescription = dpResponse[@"description"];
        deal.url = dpResponse[@"url"];
    }
    
    return deal;
}

+ (NSSet *)dealsWithDPResponse:(NSArray *)dpResponse
               inObjectContext:(NSManagedObjectContext *)context {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:[dpResponse count]];
    for (NSDictionary *dealInfo in dpResponse) {
        Deal *deal = [self dealWithDPResponse:dealInfo inObjectContext:context];
        [array addObject:deal];
    }
    return [NSSet setWithArray:array];
}

@end
