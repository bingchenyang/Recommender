//
//  Deal.h
//  Recommender
//
//  Created by Benson Yang on 9/21/13.
//  Copyright (c) 2013 Benson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Deal : NSManagedObject

@property (nonatomic, retain) NSString * dealDescription;
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * url;

@end
