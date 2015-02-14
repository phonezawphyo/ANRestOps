//
//  ANRestOpsClient.h
//  ANRestOps
//
//  Created by Ayush Newatia on 31/12/2014.
//  Copyright (c) 2014 Spectrum. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ANRestOpsResponse.h"

@interface ANRestOpsClient : NSObject

typedef void(^ANRestOpsCompletionHandler)(ANRestOpsResponse *);

+ (instancetype)sharedClient;

/**
    The maximum number of concurrents requests that ca be executed by the `NSOperationQueue`. Default is 1 and it is recommended to leave it unchanged.
*/
- (void)setMaxConcurrentRequests:(NSUInteger)numberOfRequests;

- (ANRestOpsResponse *)sendSynchronousRequest:(NSURLRequest *)request;

- (void)sendAsynchronousRequest:(NSURLRequest *)request
         withCompletionHandler:(ANRestOpsCompletionHandler)completionBlock;

@end
