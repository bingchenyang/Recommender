//
//  MorningPlan.h
//  Recommender
//
//  Created by Benson Yang on 9/21/13.
//  Copyright (c) 2013 Benson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Event, Poi, Transportation, TravelPlan;

@interface MorningPlan : NSManagedObject

@property (nonatomic, retain) TravelPlan *belongTo;
@property (nonatomic, retain) NSSet *events;
@property (nonatomic, retain) NSSet *pois;
@property (nonatomic, retain) NSSet *transportations;
@end

@interface MorningPlan (CoreDataGeneratedAccessors)

- (void)addEventsObject:(Event *)value;
- (void)removeEventsObject:(Event *)value;
- (void)addEvents:(NSSet *)values;
- (void)removeEvents:(NSSet *)values;

- (void)addPoisObject:(Poi *)value;
- (void)removePoisObject:(Poi *)value;
- (void)addPois:(NSSet *)values;
- (void)removePois:(NSSet *)values;

- (void)addTransportationsObject:(Transportation *)value;
- (void)removeTransportationsObject:(Transportation *)value;
- (void)addTransportations:(NSSet *)values;
- (void)removeTransportations:(NSSet *)values;

@end
