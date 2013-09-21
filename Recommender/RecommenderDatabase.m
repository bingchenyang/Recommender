//
//  RecommenderDatabase.m
//  Recommender
//
//  Created by Benson Yang on 9/21/13.
//  Copyright (c) 2013 Benson. All rights reserved.
//

#import "RecommenderDatabase.h"

@implementation RecommenderDatabase

+ (void)openDatabaseOnCompletion:(DBOpenCompletionBlock)completionBlock {
    NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    url = [url URLByAppendingPathComponent:@"RecommenderDatabase"];
    
    UIManagedDocument *document = [[UIManagedDocument alloc] initWithFileURL: url];
    if ([[NSFileManager defaultManager] fileExistsAtPath:[url path]]) {
        [document openWithCompletionHandler:^(BOOL success) {
            if (success) {
                completionBlock(document);
            } else {
                // error handle
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
