//
//  User+DianPing.h
//  Recommender
//
//  Created by Benson Yang on 10/19/13.
//  Copyright (c) 2013 Benson. All rights reserved.
//

#import "User.h"

#define kHardCodingUserName @"Admin"
#define kHardCodingPassword @"adminadmin"

@interface User (DianPing)
+ (User *)userWithUserName:(NSString *)name andPassword:(NSString *)password inObjectContext:(NSManagedObjectContext *)context;
@end
