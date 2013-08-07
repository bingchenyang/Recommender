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
- (MKNetworkOperation *)findPoi:(NSString *)keyword inCity:(NSString *)city page:(NSInteger)page sort:(DianPingSortType)sort {
    NSDictionary *params = @{@"keyword": keyword, @"city": city, @"page": [NSNumber numberWithInt:page], @"sort": [NSNumber numberWithInt:sort]};
    NSString *dianPingURL = [DianPingAPI serializeURL:FIND_BUSINESS_API params:params];
    
    MKNetworkOperation *op = [self operationWithPath:dianPingURL];
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        NSLog(@"%@", completedOperation.responseString);
        
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        ;
    }];
    
    [self enqueueOperation:op];
    
    return op;
}
@end
