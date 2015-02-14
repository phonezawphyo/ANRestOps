//
//  ANRestOpsClient.m
//  ANRestOps
//
//  Created by Ayush Newatia on 31/12/2014.
//  Copyright (c) 2014 Spectrum. All rights reserved.
//

#import "ANRestOpsClient.h"
#import <UIKit/UIKit.h>

@interface ANRestOpsClient()

@property (nonatomic,strong) NSOperationQueue *queue;


@end

@implementation ANRestOpsClient

- (instancetype)init
{
    @throw [NSException exceptionWithName:@"Incorrect initialisation" reason:@"Singleton object - Use [ANRestOpsClient sharedClient]" userInfo:nil];
}

- (instancetype)initLocal
{
    self = [super init];
    return  self;
}

+ (instancetype)sharedClient
{
    static ANRestOpsClient *client = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        client = [[self alloc] initLocal];
    });
    return client;
}

- (NSOperationQueue *)queue
{
    if (!_queue)
    {
        _queue = [NSOperationQueue new];
        _queue.maxConcurrentOperationCount = 1;
    }
    return _queue;
}

- (void)setMaxConcurrentRequests:(NSUInteger)numberOfRequests
{
    self.queue.maxConcurrentOperationCount = numberOfRequests;
}

- (ANRestOpsResponse *)sendSynchronousRequest:(NSURLRequest *)request
{
    NSURLResponse *URLresponse = nil;
    NSError *error = nil;
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&URLresponse error:&error];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    ANRestOpsResponse *response = [[ANRestOpsResponse alloc] initWithResponse:URLresponse data:data error:error];
    
    return response;
}

- (void)sendAsynchronousRequest:(NSURLRequest *)request withCompletionHandler:(ANRestOpsCompletionHandler)completionBlock
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:self.queue
                           completionHandler:^(NSURLResponse *URLresponse, NSData *data, NSError *connectionError) {
                               ANRestOpsResponse *response = [[ANRestOpsResponse alloc] initWithResponse:URLresponse
                                                                                                    data:data
                                                                                                   error:connectionError];
                               dispatch_async(dispatch_get_main_queue(), ^{
                                   [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
                                   completionBlock(response);
                               });
    }];
}

@end
