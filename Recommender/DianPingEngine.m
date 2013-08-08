//
//  DianPingEngine.m
//  Recommender
//
//  Created by Benson Yang on 8/6/13.
//  Copyright (c) 2013 Benson. All rights reserved.
//

#import "DianPingEngine.h"
#import "DianPingAPI.h"

#define FIND_BUSINESS_API @"v1/business/find_businesses"


@implementation DianPingEngine
- (id) init {
    NSMutableDictionary *headerFields = [NSMutableDictionary dictionary];
    [headerFields setValue:@"iOS" forKey:@"x-client-identifier"];
    if (self = [self initWithHostName:@"api.dianping.com" customHeaderFields:headerFields]) {
        return self;
    }
    return nil;
}

- (MKNetworkOperation *)findPoi:(NSString *)keyword
                         inCity:(NSString *)city
                           page:(NSInteger)page
                           sort:(DianPingSortType)sort
                   onCompletion:(DPResponseBlock)completion
                        onError:(MKNKErrorBlock)onError {
    
    NSDictionary *params = @{@"keyword": keyword, @"city": city, @"page": [NSNumber numberWithInt:page], @"sort": [NSNumber numberWithInt:sort]};
    NSString *dianPingURL = [DianPingAPI serializeURL:FIND_BUSINESS_API params:params];
    
    MKNetworkOperation *op = [self operationWithPath:dianPingURL];
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        NSArray *businesses = [completedOperation.responseJSON objectForKey:@"businesses"];
        
        completion(businesses);
        
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        NSLog(@"%@", error);
    }];
    
    [self enqueueOperation:op];
    
    return op;
}
@end
