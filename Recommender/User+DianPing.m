//
//  User+DianPing.m
//  Recommender
//
//  Created by Benson Yang on 10/19/13.
//  Copyright (c) 2013 Benson. All rights reserved.
//

#import "User+DianPing.h"

@implementation User (DianPing)

+ (User *)userWithUserName:(NSString *)userName
               andPassword:(NSString *)password
           inObjectContext:(NSManagedObjectContext *)context {
    // TODO: cancel the hard coding here
    userName = kHardCodingUserName;
    password = kHardCodingPassword;
    
    User *user = nil;
    
    // 1.fetch
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    request.predicate = [NSPredicate predicateWithFormat:@"userName = %@ and password = %@", userName, password];
    
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    // 2.
    if (!matches || [matches count] > 1) {
        // nil means fetch failed; more than one impossible
    }
    else if ([matches count] == 1) {
        user = [matches lastObject];
    }
    else {
        user = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:context];
        user.userName = userName;
        user.password = password;
    }
    
    return user;
}

@end
