//
//  Category.h
//  Recommender
//
//  Created by Benson Yang on 10/19/13.
//  Copyright (c) 2013 Benson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Poi;

@interface Category : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *pois;
@end

@interface Category (CoreDataGeneratedAccessors)

- (void)addPoisObject:(Poi *)value;
- (void)removePoisObject:(Poi *)value;
- (void)addPois:(NSSet *)values;
- (void)removePois:(NSSet *)values;

@end
