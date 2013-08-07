//
//  DianPingAPI.h
//  Recommender
//
//  Created by Benson Yang on 8/6/13.
//  Copyright (c) 2013 Benson. All rights reserved.
//

#import <Foundation/Foundation.h>
static NSString * const kAppKey = @"0405376228";
static NSString * const kAppSecret = @"f7bf401814b545c8bddb93b353cb9548";



@interface DianPingAPI : NSObject

+ (NSString *)serializeURL:(NSString *)baseURL params:(NSDictionary *)params;

@end
