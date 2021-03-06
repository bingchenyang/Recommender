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
#import "RecommenderDatabase.h"

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
            //[self.delegate PoiStreamDelegateFetchPoisDidFinish:self];
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
    // 1.取得UIManagedDocument --> NSManagedObjectContext
    // 2.将结果写入数据库，或是从数据库读取数据至self.pois
    // 3.回调函数

    [RecommenderDatabase openDatabaseOnCompletion:^(UIManagedDocument *document) {
        NSMutableArray *pois = [NSMutableArray arrayWithCapacity:[poisInfoArray count]];
        NSManagedObjectContext *context = document.managedObjectContext;
        for (NSDictionary *poiInfo in poisInfoArray) {
            Poi *poi = [Poi poiWithDPResponse:poiInfo inObjectContext:context];
            [pois addObject:poi];
        }
        self.pois = pois;
        
        [self.delegate PoiStreamDelegateFetchPoisDidFinish:self];
    }];
}

- (void)searchPoiWithKeywords:(NSString *)keywords type:(NSInteger)type {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"keyword": keywords, @"city": @"上海", @"platform": @2, @"sort": @(DianPingSortTypeDefault)}];
    
    switch (type) {
        case kSelectedIndexPoi:
            [params setValue:@"景点" forKey:@"category"];
            break;
        case kSelectedIndexHotel:
            [params setValue:@"酒店" forKey:@"category"];
            break;
        case kSelectedIndexResturant:
            [params setValue:@"美食" forKey:@"category"];
        default:
            break;
    }
    NSString *operationPath = [DianPingAPI serializeURL:FIND_BUSINESS_API params:params];
    DianPingEngine *engine = [DianPingEngine sharedEngine];
    MKNetworkOperation *searchOp = [engine operationWithPath:operationPath];
    [searchOp addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        NSString *status = completedOperation.responseJSON[@"status"];
        if ([status isEqualToString:@"OK"]) {
            [self handlePoiResponse:completedOperation.responseJSON[@"businesses"]];
            //[self.delegate PoiStreamDelegateFetchPoisDidFinish:self];
        } else {
            // handle error;
        }
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        
    }];
    
    [engine enqueueOperation:searchOp];
}
@end
