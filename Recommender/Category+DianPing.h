//
//  Category+DianPing.h
//  Recommender
//
//  Created by Benson Yang on 9/21/13.
//  Copyright (c) 2013 Benson. All rights reserved.
//

#import "Category.h"

@interface Category (DianPing)

+ (Category *)categoryWithCategoryName:(NSString *)categoryName inObjectContext:(NSManagedObjectContext *)context;
+ (NSSet *)categoryWithCategoryArray:(NSArray *)categoryArray inObjectContext:(NSManagedObjectContext *)context;


@end
