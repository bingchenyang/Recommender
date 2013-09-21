//
//  Category+DianPing.m
//  Recommender
//
//  Created by Benson Yang on 9/21/13.
//  Copyright (c) 2013 Benson. All rights reserved.
//

#import "Category+DianPing.h"

@implementation Category (DianPing)

+ (Category *)categoryWithCategoryName:(NSString *)categoryName
                       inObjectContext:(NSManagedObjectContext *)context {
    Category *category = nil;
    
    // 1.fetch
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Category"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    request.predicate = [NSPredicate predicateWithFormat:@"name = %@", categoryName];
    
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    // 2.
    if (!matches || [matches count] > 1) {
        // nil means fetch failed; more than one impossible
    }
    else if ([matches count] == 1) {
        category = [matches lastObject];
    }
    else {
        category = [NSEntityDescription insertNewObjectForEntityForName:@"Category" inManagedObjectContext:context];
        category.name = categoryName;
    }
    
    return category;
}

+ (NSSet *)categoriesWithCategoryArray:(NSArray *)categoryArray
                       inObjectContext:(NSManagedObjectContext *)context {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:[categoryArray count]];
    for (NSString *categoryName in categoryArray) {
        Category *category = [self categoryWithCategoryName:categoryName
                                            inObjectContext:context];
        [array addObject:category];
    }
    return [NSSet setWithArray:array];
}

@end
