//
//  UserManager.h
//  Recommender
//
//  Created by Benson Yang on 10/19/13.
//  Copyright (c) 2013 Benson. All rights reserved.
//
//  UserManager主要负责处理和用户有关的事情，比如登录，验证用户身份等。

#import <Foundation/Foundation.h>
#import "User.h"


@interface UserManager : NSObject

-(User *)currentUser;

@end
