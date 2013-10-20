//
//  TravelProject.h
//  Recommender
//
//  Created by Benson Yang on 10/19/13.
//  Copyright (c) 2013 Benson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TravelPlan, User;

@interface TravelProject : NSManagedObject

@property (nonatomic, retain) NSDate * createDate;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *plans;
@property (nonatomic, retain) User *traveller;
@end

@interface TravelProject (CoreDataGeneratedAccessors)

- (void)addPlansObject:(TravelPlan *)value;
- (void)removePlansObject:(TravelPlan *)value;
- (void)addPlans:(NSSet *)values;
- (void)removePlans:(NSSet *)values;

@end
