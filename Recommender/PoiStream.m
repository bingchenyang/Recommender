//
//  PoiStream.m
//  Recommender
//
//  Created by Benson Yang on 8/31/13.
//  Copyright (c) 2013 Benson. All rights reserved.
//

#import "PoiStream.h"
#import "DianPingEngine.h"
#import "DianPingAPI.h"

#define FIND_BUSINESS_API @"v1/business/find_businesses"

@implementation PoiStream

- (void)fetchPois {
    NSDictionary *params = @{@"keyword": @"景点", @"city": @"上海", @"platform": @2, @"sort": @(DianPingSortTypeDefault)};
    NSString *operationPath = [DianPingAPI serializeURL:FIND_BUSINESS_API params:params];
    
    DianPingEngine *engine = [DianPingEngine sharedEngine];
    MKNetworkOperation *fetchPoiOp = [engine operationWithPath:operationPath];
    [fetchPoiOp addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        NSString *status = completedOperation.responseJSON[@"status"];
        if ([status isEqualToString:@"OK"]) {
            [self handlePoiResponse:completedOperation.responseJSON[@"businesses"]];
            [self.delegate PoiStreamDelegateFetchPoisDidFinish:self];
        } else {
            // handle error;
        }
        
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        // Normally this error is more like a connection eror.
    }];
    
    [engine enqueueOperation:fetchPoiOp];
}

- (void)fetchMore {
    
}

- (void)handlePoiResponse:(NSArray *)poisInfoArray {
    NSMutableArray *pois = [NSMutableArray arrayWithCapacity:[poisInfoArray count]];
    for (NSDictionary *poiInfo in poisInfoArray) {
        Poi *poi = [[Poi alloc] initWithResponse:poiInfo];
        [pois addObject:poi];
    }
    
    self.pois = pois;
}

@end
