//
//  Event.h
//  Recommender
//
//  Created by Benson Yang on 9/21/13.
//  Copyright (c) 2013 Benson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Poi;

@interface Event : NSManagedObject

@property (nonatomic, retain) NSString * eventName;
@property (nonatomic, retain) NSNumber * lastingHour;
@property (nonatomic, retain) NSString * memo;
@property (nonatomic, retain) Poi *poi;

@end
