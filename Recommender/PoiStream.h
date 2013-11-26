//
//  PoiStream.h
//  Recommender
//
//  Created by Benson Yang on 8/31/13.
//  Copyright (c) 2013 Benson. All rights reserved.
//
// A PoiStream is a collection of Pois.


#import <Foundation/Foundation.h>
#import "Poi+DianPing.h"

#define kSelectedIndexPoi 0
#define kSelectedIndexResturant 1
#define kSelectedIndexHotel 2

@class PoiStream;
@protocol PoiStreamDelegate <NSObject>
@optional
- (void)PoiStreamDelegateFetchPoisDidFinish:(PoiStream *)poiStream;
- (void)PoiStreamDelegateFetchPoisDidFail:(PoiStream *)poiSrream;

@end


@interface PoiStream : NSObject

@property (nonatomic, strong) NSMutableArray *pois;

@property (nonatomic, weak) id<PoiStreamDelegate> delegate;

//Defaul will fetch with keyword:景点 page:1 platform:mobile city:上海
-(void)fetchPois;
-(void)fetchMore;


//type -- 景点，餐馆，酒店
-(void)searchPoiWithKeywords:(NSString *)keywords type:(NSInteger)type;

@end
