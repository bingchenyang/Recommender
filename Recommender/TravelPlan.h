//
//  TravelPlan.h
//  Recommender
//
//  Created by Benson Yang on 10/20/13.
//  Copyright (c) 2013 Benson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Poi, TravelProject;

@interface TravelPlan : NSManagedObject

@property (nonatomic, retain) NSNumber * sequenceNumber;
@property (nonatomic, retain) NSOrderedSet *pois;
@property (nonatomic, retain) TravelProject *travelProject;
@end

@interface TravelPlan (CoreDataGeneratedAccessors)

- (void)insertObject:(Poi *)value inPoisAtIndex:(NSUInteger)idx;
- (void)removeObjectFromPoisAtIndex:(NSUInteger)idx;
- (void)insertPois:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removePoisAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInPoisAtIndex:(NSUInteger)idx withObject:(Poi *)value;
- (void)replacePoisAtIndexes:(NSIndexSet *)indexes withPois:(NSArray *)values;
- (void)addPoisObject:(Poi *)value;
- (void)removePoisObject:(Poi *)value;
- (void)addPois:(NSOrderedSet *)values;
- (void)removePois:(NSOrderedSet *)values;
@end
