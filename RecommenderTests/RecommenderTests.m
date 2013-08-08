//
//  RecommenderTests.m
//  RecommenderTests
//
//  Created by Benson Yang on 8/6/13.
//  Copyright (c) 2013 Benson. All rights reserved.
//

#import "RecommenderTests.h"
#import "DianPingAPI.h"
#import "DianPingEngine.h"

@implementation RecommenderTests {
    DianPingEngine *engine;
}

- (void)setUp
{
    [super setUp];
    
    NSMutableDictionary *headerFields = [NSMutableDictionary dictionary];

}

- (void)tearDown
{
    engine = nil;
    
    [super tearDown];
}

- (void)testUrl {
    NSString *baseURL = @"v1/business/find_business";
    NSDictionary *params = @{@"keyword": @"景点", @"city": @"上海"};
    NSString *sURL = [DianPingAPI serializeURL:baseURL params:params];
    STAssertNotNil(sURL, @"nil");
}

- (void)testEngine {
    MKNetworkOperation *op = [engine operationWithPath:@"v1/business/find_business?appkey=0405376228&city=%E4%B8%8A%E6%B5%B7&keyword=%E6%99%AF%E7%82%B9&page=1&sort=1&sign=6733F83FA4C9E37C3AEDD58E38E47EA6BD0DD863"];
    STAssertNotNil(op, @"it's nil");
}

@end
