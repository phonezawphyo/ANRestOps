//
//  ANRestOps.m
//  ANRestOps
//
//  Created by Ayush Newatia on 31/12/2014.
//  Copyright (c) 2014 Spectrum. All rights reserved.
//

#import "ANRestOps.h"

@implementation ANRestOps

#pragma mark - Synchronous Get and Batch Get

+ (ANRestOpsResponse *)get:(NSString *)urlString
{
    NSURLRequest *request = [ANRestOps getRequestWithURL:urlString];
    ANRestOpsResponse *response = [[ANRestOpsClient sharedClient] sendSynchronousRequest:request];
    
    return response;
}

+ (ANRestOpsResponse *)get:(NSString *)urlString withParameters:(NSDictionary *)parameters
{
    NSString *parametersString = [ANRestOps getFormFormattedParametersFromDictionary:parameters];
    
    urlString = [urlString stringByAppendingString:@"?"];
    urlString = [urlString stringByAppendingString:parametersString];
    
    NSURLRequest *request = [ANRestOps getRequestWithURL:urlString];
    ANRestOpsResponse *response = [[ANRestOpsClient sharedClient] sendSynchronousRequest:request];
    
    return response;
}


#pragma mark - Asynchronous Get

+ (void)getInBackground:(NSString *)urlString
          beforeRequest:(void (^)(void))startingBlock
           onCompletion:(ANRestOpsCompletionHandler)completionBlock
{
    if (startingBlock)
    {
        startingBlock();
    }
    NSURLRequest *request = [ANRestOps getRequestWithURL:urlString];
    [[ANRestOpsClient sharedClient] sendAsynchronousRequest:request withCompletionHandler:completionBlock];
}

+ (void)getInBackground:(NSString *)urlString
             parameters:(NSDictionary *)parameters
          beforeRequest:(void (^)(void))startingBlock
           onCompletion:(ANRestOpsCompletionHandler)completionBlock
{
    NSString *parametersString = [ANRestOps getFormFormattedParametersFromDictionary:parameters];
    urlString = [urlString stringByAppendingString:@"?"];
    urlString = [urlString stringByAppendingString:parametersString];
    
    [ANRestOps getInBackground:urlString beforeRequest:startingBlock onCompletion:completionBlock];
}

#pragma mark - Synchronous Post and Batch Post

+ (ANRestOpsResponse *)post:(NSString *)urlString payload:(NSString *)payload
{

    NSURLRequest *request = [ANRestOps postRequestWithURL:urlString payload:payload isPayloadString:YES];
    ANRestOpsResponse *response = [[ANRestOpsClient sharedClient] sendSynchronousRequest:request];
    
    return response;
}

+ (ANRestOpsResponse *)post:(NSString *)urlString payload:(NSDictionary *)payload payloadFormat:(ANRestOpsDataFormat)format
{
    NSData *httpBody = [ANRestOps getPayloadDataFromDictionary:payload formattedAs:format];
    
    NSURLRequest *request = [ANRestOps postRequestWithURL:urlString payload:httpBody isPayloadString:NO withContentType:format];
    
    ANRestOpsResponse *response = [[ANRestOpsClient sharedClient] sendSynchronousRequest:request];
    
    return response;
}

#pragma mark - Asynchronous Post

+ (void)postInBackground:(NSString *)urlString
                 payload:(NSString *)payload
           beforeRequest:(void (^)(void))startingBlock
            onCompletion:(ANRestOpsCompletionHandler)completionBlock
{
    if (startingBlock)
    {
        startingBlock();
    }
    
    NSURLRequest *request = [ANRestOps postRequestWithURL:urlString payload:payload isPayloadString:YES];
    [[ANRestOpsClient sharedClient] sendAsynchronousRequest:request withCompletionHandler:completionBlock];
}

+ (void)postInBackground:(NSString *)urlString
                 payload:(NSDictionary *)payload
           payloadFormat:(ANRestOpsDataFormat)format
           beforeRequest:(void (^)(void))startingBlock
            onCompletion:(ANRestOpsCompletionHandler)completionBlock
{
    if (startingBlock)
    {
        startingBlock();
    }
    
    NSData *httpBody = [ANRestOps getPayloadDataFromDictionary:payload formattedAs:format];
    
    NSURLRequest *request = [ANRestOps postRequestWithURL:urlString payload:httpBody isPayloadString:NO withContentType:format];
    
    [[ANRestOpsClient sharedClient] sendAsynchronousRequest:request withCompletionHandler:completionBlock];
}

#pragma mark - Private Utility Methods

+ (NSString *)getFormFormattedParametersFromDictionary:(NSDictionary *)parameters
{
    NSMutableString *parametersString = [NSMutableString new];
    
    for (NSString *key in [parameters allKeys])
    {
        if ([parameters[key] isKindOfClass:[NSString class]] && [key isKindOfClass:[NSString class]])
        {
            [parametersString appendFormat:@"%@=%@&",key,[parameters valueForKey:key]];
        }
        else
        {
            [NSException raise:@"Invalid dictionary" format:@"Params dictionary can only contain key-value pairs of NSStrings"];
        }
    }
    
    [parametersString deleteCharactersInRange:NSMakeRange([parametersString length]-1, 1)];
    
    return parametersString;
}

+ (NSData *)getJSONFormattedParametersFromDictionary:(NSDictionary *)parameters
{
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:parameters
                                                   options:0
                                                     error:&error];
    
    if (data)
    {
        return data;
    }
    else
    {
        [NSException raise:@"Invalid dictionary" format:@"%@ error raised during JSON serialization", error];
        return nil;
    }
}

+ (NSData *)getPayloadDataFromDictionary:(NSDictionary *)parameters formattedAs:(ANRestOpsDataFormat)format
{
    NSData *data = nil;
    
    if (format == ANRestOpsFormFormat)
    {
        data = [[ANRestOps getFormFormattedParametersFromDictionary:parameters] dataUsingEncoding:NSUTF8StringEncoding];
    }
    else if (format == ANRestOpsJSONFormat)
    {
        data = [ANRestOps getJSONFormattedParametersFromDictionary:parameters];
    }
    
    return data;
}

+ (NSURLRequest *)setUpDefaultRequestValuesWithURL:(NSString *)urlString
{
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [[NSURLRequest requestWithURL:url] mutableCopy];
    [request addValue:@"ANRestOps/1.0" forHTTPHeaderField:@"User-Agent"];
    
    return request;
}

+ (NSURLRequest *)getRequestWithURL:(NSString *)urlString
{
    return [ANRestOps setUpDefaultRequestValuesWithURL:urlString];
}

+ (NSURLRequest *)postRequestWithURL:(NSString *)urlString payload:(id)payload isPayloadString:(BOOL)isString
{
    NSMutableURLRequest *request = [[ANRestOps setUpDefaultRequestValuesWithURL:urlString] mutableCopy];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"text/plain" forHTTPHeaderField:@"Content-Type"];
    if (isString)
    {
        [request setHTTPBody:[payload dataUsingEncoding:NSUTF8StringEncoding]];
    }
    else
    {
        [request setHTTPBody:payload];
    }
    
    return request;
}

+ (NSURLRequest *)postRequestWithURL:(NSString *)urlString payload:(id)payload isPayloadString:(BOOL)isString withContentType:(ANRestOpsDataFormat)format
{
    NSMutableURLRequest *request = [[ANRestOps postRequestWithURL:urlString payload:payload isPayloadString:isString] mutableCopy];
    
    if (format == ANRestOpsJSONFormat)
    {
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    }
    else
    {
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    }
    
    return request;
}

@end
