//
//  Poi.h
//  Recommender
//
//  Created by Benson Yang on 8/31/13.
//  Copyright (c) 2013 Benson. All rights reserved.
//
// 一个Poi(Point of interest)就是一个景点，是对get_single_business返回值的封装

#import <Foundation/Foundation.h>

@interface Poi : NSObject
- (id)initWithResponse:(NSDictionary *)response;
- (void)loadFromDictionary:(NSDictionary *)data;

@property (nonatomic, strong) NSDictionary *responseData;

@property (nonatomic) NSInteger poiId; // business_id
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *branchName;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *telephone;
@property (nonatomic, copy) NSString *city;
@property (nonatomic) NSArray *regions;
@property (nonatomic) NSArray *categories;
@property (nonatomic) CGFloat latitude;
@property (nonatomic) CGFloat longitude;
@property (nonatomic) CGFloat avgRating;
@property (nonatomic, copy) NSString *ratingSmallImageUrl;
@property (nonatomic) NSInteger productGrade;
@property (nonatomic) NSInteger decorationGrade;
@property (nonatomic) NSInteger serviceGrade;
@property (nonatomic) NSInteger avgPrice;
@property (nonatomic) NSInteger reviewCount;
@property (nonatomic, copy) NSString *poiUrl; // business_url
@property (nonatomic, copy) NSString *smallPhotoUrl;

//优惠券
@property (nonatomic) BOOL hasCoupon;
@property (nonatomic) NSInteger couponId;
@property (nonatomic, copy) NSString *couponDescription;
@property (nonatomic, copy) NSString *couponUrl;

//团购
@property (nonatomic) BOOL hasDeal;
@property (nonatomic) NSInteger dealCount;
@property (nonatomic) NSArray *deals;

@end
