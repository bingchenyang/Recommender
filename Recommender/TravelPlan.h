//
//  TravelPlan.h
//  Recommender
//
//  Created by Benson Yang on 9/21/13.
//  Copyright (c) 2013 Benson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AfterNoonPlan, MorningPlan, NightPlan, TravelProject;

@interface TravelPlan : NSManagedObject

@property (nonatomic, retain) NSNumber * sequenceNumber;
@property (nonatomic, retain) AfterNoonPlan *afterNoonPlan;
@property (nonatomic, retain) MorningPlan *morningPlan;
@property (nonatomic, retain) NightPlan *nightPlan;
@property (nonatomic, retain) TravelProject *travelProject;

@end
