//
//  User.h
//  Recommender
//
//  Created by Benson Yang on 10/19/13.
//  Copyright (c) 2013 Benson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TravelProject;

@interface User : NSManagedObject

@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) NSString * userName;
@property (nonatomic, retain) NSSet *travelProjects;
@end

@interface User (CoreDataGeneratedAccessors)

- (void)addTravelProjectsObject:(TravelProject *)value;
- (void)removeTravelProjectsObject:(TravelProject *)value;
- (void)addTravelProjects:(NSSet *)values;
- (void)removeTravelProjects:(NSSet *)values;

@end
