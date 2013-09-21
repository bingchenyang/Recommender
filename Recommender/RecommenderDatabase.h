//
//  RecommenderDatabase.h
//  Recommender
//
//  Created by Benson Yang on 9/21/13.
//  Copyright (c) 2013 Benson. All rights reserved.
//
// 向外提供UIManagedDocument

#import <Foundation/Foundation.h>

typedef void (^DBOpenCompletionBlock)(UIManagedDocument* document);

@interface RecommenderDatabase : NSObject

+ (void)openDatabaseOnCompletion:(DBOpenCompletionBlock)completionBlock;

@end
