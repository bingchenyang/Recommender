//
//  Poi.h
//  Recommender
//
//  Created by Benson Yang on 10/20/13.
//  Copyright (c) 2013 Benson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Category, Deal, Region, TravelPlan;

@interface Poi : NSManagedObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSNumber * avgPrice;
@property (nonatomic, retain) NSNumber * avgRating;
@property (nonatomic, retain) NSString * branchName;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * couponDescription;
@property (nonatomic, retain) NSNumber * couponId;
@property (nonatomic, retain) NSString * couponUrl;
@property (nonatomic, retain) NSNumber * dealCount;
@property (nonatomic, retain) NSNumber * decorationGrade;
@property (nonatomic, retain) NSNumber * hasCoupon;
@property (nonatomic, retain) NSNumber * hasDeal;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * poiId;
@property (nonatomic, retain) NSString * poiUrl;
@property (nonatomic, retain) NSNumber * productGrade;
@property (nonatomic, retain) NSString * ratingSmallImageUrl;
@property (nonatomic, retain) NSNumber * reviewCount;
@property (nonatomic, retain) NSNumber * serviceGrade;
@property (nonatomic, retain) NSString * smallPhotoUrl;
@property (nonatomic, retain) NSString * telephone;
@property (nonatomic, retain) NSSet *categories;
@property (nonatomic, retain) NSSet *deals;
@property (nonatomic, retain) NSSet *regions;
@property (nonatomic, retain) NSSet *travelPlans;
@end

@interface Poi (CoreDataGeneratedAccessors)

- (void)addCategoriesObject:(Category *)value;
- (void)removeCategoriesObject:(Category *)value;
- (void)addCategories:(NSSet *)values;
- (void)removeCategories:(NSSet *)values;

- (void)addDealsObject:(Deal *)value;
- (void)removeDealsObject:(Deal *)value;
- (void)addDeals:(NSSet *)values;
- (void)removeDeals:(NSSet *)values;

- (void)addRegionsObject:(Region *)value;
- (void)removeRegionsObject:(Region *)value;
- (void)addRegions:(NSSet *)values;
- (void)removeRegions:(NSSet *)values;

- (void)addTravelPlansObject:(TravelPlan *)value;
- (void)removeTravelPlansObject:(TravelPlan *)value;
- (void)addTravelPlans:(NSSet *)values;
- (void)removeTravelPlans:(NSSet *)values;

@end
