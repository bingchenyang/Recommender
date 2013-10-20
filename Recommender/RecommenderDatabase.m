//
//  RecommenderDatabase.m
//  Recommender
//
//  Created by Benson Yang on 9/21/13.
//  Copyright (c) 2013 Benson. All rights reserved.
//

#import "RecommenderDatabase.h"
static UIManagedDocument *document;

@implementation RecommenderDatabase

+ (void)openDatabaseOnCompletion:(DBOpenCompletionBlock)completionBlock {
    NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    url = [url URLByAppendingPathComponent:@"RecommenderDatabase"];
    
    if (document == nil) {
        document = [[UIManagedDocument alloc] initWithFileURL: url];
    }
    if ([[NSFileManager defaultManager] fileExistsAtPath:[url path]]) {
        [document openWithCompletionHandler:^(BOOL success) {
            if (success) {
                completionBlock(document);
            } else {
                // error handle
                NSLog(@"打开数据库并未成功\n:%@", [url path]);
            }
        }];
    }
    else {
        [document saveToURL: url forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
            if (success) {
                completionBlock(document);
            }
            else {
                // error handle
            }
        }];
        
    }
}

@end
