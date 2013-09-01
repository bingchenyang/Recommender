//
//  Poi.m
//  Recommender
//
//  Created by Benson Yang on 8/31/13.
//  Copyright (c) 2013 Benson. All rights reserved.
//


#import "Poi.h"

@implementation Poi

- (id) initWithResponse:(NSDictionary *)response {
    self = [self init];
    if (self) {
        [self loadFromDictionary:response];
    }
    return self;
}

- (void)loadFromDictionary:(NSDictionary *)data {
    self.responseData = data;
    
    self.poiId = [data[@"business_id"] integerValue];
    self.name = data[@"name"];
    self.branchName = data[@"branch_name"];
    self.address = data[@"address"];
    self.telephone = data[@"telephone"];
    self.city = data[@"city"];
    self.regions = data[@"regions"];
    self.categories = data[@"categories"];
    // CGFloat can be double
    if (!CGFLOAT_IS_DOUBLE) {
        self.latitude = [data[@"latitude"] floatValue];
        self.longitude = [data[@"longitude"] floatValue];
        self.avgRating = [data[@"avg_rating"] floatValue];
    }
    else {
        self.latitude = [data[@"latitude"] doubleValue];
        self.longitude = [data[@"longitude"] doubleValue];
        self.avgRating = [data[@"avg_rating"] doubleValue];
    }
    self.ratingSmallImageUrl = data[@"rating_s_img_url"];
    self.productGrade = [data[@"product_grade"] integerValue];
    self.decorationGrade = [data[@"decoration_grade"] integerValue];
    self.serviceGrade = [data[@"service_grade"] integerValue];
    self.avgPrice = [data[@"avg_price"] integerValue];
    self.reviewCount = [data[@"review_count"] integerValue];
    self.poiUrl = data[@"business_url"];
    self.smallPhotoUrl = data[@"s_photo_url"];
    
    self.hasCoupon = [data[@"has_coupon"] boolValue];
    self.couponId = [data[@"coupon_id"] integerValue];
    self.couponDescription = data[@"coupon_description"];
    self.couponUrl = data[@"coupon_url"];
    
    self.hasDeal = [data[@"has_deal"] boolValue];
    self.dealCount = [data[@"deal_count"] integerValue];
    self.deals = data[@"deals"];
}

@end
