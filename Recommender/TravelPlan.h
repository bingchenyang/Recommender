//
//  TravelPlan.h
//  Recommender
//
//  Created by Benson Yang on 10/19/13.
//  Copyright (c) 2013 Benson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Poi, TravelProject;

@interface TravelPlan : NSManagedObject

@property (nonatomic, retain) NSNumber * sequenceNumber;
@property (nonatomic, retain) NSSet *pois;
@property (nonatomic, retain) TravelProject *travelProject;
@end

@interface TravelPlan (CoreDataGeneratedAccessors)

- (void)addPoisObject:(Poi *)value;
- (void)removePoisObject:(Poi *)value;
- (void)addPois:(NSSet *)values;
- (void)removePois:(NSSet *)values;

@end
