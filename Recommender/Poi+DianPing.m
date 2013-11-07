//
//  Poi+DianPing.m
//  Recommender
//
//  Created by Benson Yang on 9/17/13.
//  Copyright (c) 2013 Benson. All rights reserved.
//

#import "Poi+DianPing.h"
#import "Category+DianPing.h"
#import "Region+DianPing.h"
#import "Deal+DianPing.h"

@implementation Poi (DianPing)

- (id) initWithResponse:(NSDictionary *)response {
    self = [self init];
    if (self) {
        [self loadFromDictionary:response];
    }
    return self;
}

- (void)loadFromDictionary:(NSDictionary *)data {
    
    self.poiId = data[@"business_id"];
    self.name = data[@"name"];
    self.branchName = data[@"branch_name"];
    self.address = data[@"address"];
    self.telephone = data[@"telephone"];
    self.city = data[@"city"];
    self.regions = data[@"regions"];
    self.categories = data[@"categories"];
    // CGFloat can be double
    self.latitude = data[@"latitude"];
    self.longitude = data[@"longitude"];
    self.avgRating = data[@"avg_rating"];

    self.ratingSmallImageUrl = data[@"rating_s_img_url"];
    self.productGrade = data[@"product_grade"];
    self.decorationGrade = data[@"decoration_grade"];
    self.serviceGrade = data[@"service_grade"];
    self.avgPrice = data[@"avg_price"];
    self.reviewCount = data[@"review_count"];
    self.poiUrl = data[@"business_url"];
    self.smallPhotoUrl = data[@"s_photo_url"];
    
    self.hasCoupon = data[@"has_coupon"];
    self.couponId = data[@"coupon_id"];
    self.couponDescription = data[@"coupon_description"];
    self.couponUrl = data[@"coupon_url"];
    
    self.hasDeal = data[@"has_deal"];
    self.dealCount = data[@"deal_count"];
    self.deals = data[@"deals"];
}

+ (Poi *)poiWithDPResponse:(NSDictionary *)dpResponse
         inObjectContext:(NSManagedObjectContext *)context {
    Poi *poi = nil;
    
    // 1.fetch
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Poi"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"poiId" ascending:YES]];
    request.predicate = [NSPredicate predicateWithFormat:@"poiId = %@", [[dpResponse valueForKey:@"business_id"] description]];
    
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    // 2.
    if (!matches || [matches count] > 1) {
        // nil means fetch failed; more than one impossible
    }
    else if ([matches count] == 1) {
        poi = [matches lastObject];
    }
    else {
        poi = [NSEntityDescription insertNewObjectForEntityForName:@"Poi" inManagedObjectContext:context];
        poi.poiId = dpResponse[@"business_id"];
        poi.name = dpResponse[@"name"];
        poi.branchName = dpResponse[@"branch_name"];
        poi.address = dpResponse[@"address"];
        poi.telephone = dpResponse[@"telephone"];
        poi.city = dpResponse[@"city"];
        
        if (dpResponse[@"regions"] != nil) {
            poi.regions = [Region regionsWithCategoryArray:dpResponse[@"regions"] inObjectContext:context];
        }
        if (dpResponse[@"categories"] != nil) {
            poi.categories = [Category categoriesWithCategoryArray: dpResponse[@"categories"] inObjectContext:context];
        }
        
        poi.latitude = dpResponse[@"latitude"];
        poi.longitude = dpResponse[@"longitude"];
        poi.avgRating = dpResponse[@"avg_rating"];
        
        poi.ratingSmallImageUrl = dpResponse[@"rating_s_img_url"];
        poi.productGrade = dpResponse[@"product_grade"];
        poi.decorationGrade = dpResponse[@"decoration_grade"];
        poi.serviceGrade = dpResponse[@"service_grade"];
        poi.avgPrice = dpResponse[@"avg_price"];
        poi.reviewCount = dpResponse[@"review_count"];
        poi.poiUrl = dpResponse[@"business_url"];
        poi.smallPhotoUrl = dpResponse[@"s_photo_url"];
        
        poi.hasCoupon = dpResponse[@"has_coupon"];
        poi.couponId = dpResponse[@"coupon_id"];
        poi.couponDescription = dpResponse[@"coupon_description"];
        poi.couponUrl = dpResponse[@"coupon_url"];
        
        poi.hasDeal = dpResponse[@"has_deal"];
        poi.dealCount = dpResponse[@"deal_count"];
        if ([poi.hasCoupon boolValue]) {
            poi.deals = [Deal dealsWithDPResponse:dpResponse[@"deals"] inObjectContext:context];
        }
    }
    
    return poi;
}
@end
