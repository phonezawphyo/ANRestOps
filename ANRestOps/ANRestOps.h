//
//  ANRestOps.h
//  ANRestOps
//
//  Created by Ayush Newatia on 31/12/2014.
//  Copyright (c) 2014 Spectrum. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ANRestOpsClient.h"
#import "ANRestOpsResponse.h"

@interface ANRestOps : NSObject

typedef NS_ENUM(NSUInteger, ANRestOpsDataFormat)
{
    ANRestOpsJSONFormat,
    ANRestOpsFormFormat
} ;

+ (void)setUserAgent:(NSString *)urlString;

/**
    Send a synchronous GET request.
 
    @param urlString The complete URL. For eg: `http://www.apple.com`.
*/
+ (ANRestOpsResponse *)get:(NSString *)urlString;

/**
    Send a synchronous GET request with parameters.
 
    @param urlString The complete URL. For eg: `http://www.apple.com`.
    @param parameters An NSDictionary with NSString keys AND NSString values which will be automatically formatted in `x-www-form-urlencoded` format and appended to the URL.
*/
+ (ANRestOpsResponse *)get:(NSString *)urlString withParameters:(NSDictionary *)parameters;

/**
    Send an asynchronous GET request.
 
    @param urlString The complete URL. For eg: `http://www.apple.com`.
    @param startingBlock A block of code to be executed just before the request is made. This will be run on the main thread.
    @param completionBlock The completion handler after the request is completed. The block is passed an instance of `ANRestOpsResponse`. This will be run on the main thread.
*/
+ (void)getInBackground:(NSString *)urlString
          beforeRequest:(void (^)(void))startingBlock
           onCompletion:(ANRestOpsCompletionHandler)completionBlock;

/**
    Send an asynchronous GET request with parameters.
 
    @param urlString The complete URL. For eg: `http://www.apple.com`
    @param parameters An NSDictionary with NSString keys AND NSString values which will be automatically formatted in `x-www-form-urlencoded` format and appended to the URL.
    @param startingBlock A block of code to be executed just before the request is made. This will be run on the main thread.
    @param completionBlock The completion handler after the request is completed. The block is passed an instance of `ANRestOpsResponse`. This will be run on the main thread.
*/
+ (void)getInBackground:(NSString *)urlString
             parameters:(NSDictionary *)parameters
          beforeRequest:(void (^)(void))startingBlock
           onCompletion:(ANRestOpsCompletionHandler)completionBlock;

/**
    Send a synchronous POST request with a plain text payload.
 
    @param urlString The complete URL. For eg: `http://www.apple.com`.
    @param payload A string that will be send in the body of the HTTP request as plain text.
 
    @warning `payload` can be set to `nil` but it is not recommended to do so.
*/
+ (ANRestOpsResponse *)post:(NSString *)urlString payload:(NSString *)payload;

/**
    Send a synchronous POST request with formatted payload.
 
    @param urlString The complete URL. For eg: `http://www.apple.com`.
    @param payload An NSDictionary with NSString keys AND NSString values which can be formatted in `x-www-form-urlencoded` format or JSON format.
    @param format The format in which the parameters dictionary will be serialized and sent in the request. The options are `ANRestOpsFormFormat` or `ANRestOpsJSONFormat`.
 
    @warning `payload` can be set to `nil` but it is not recommended to do so.
*/
+ (ANRestOpsResponse *)post:(NSString *)urlString payload:(NSDictionary *)payload payloadFormat:(ANRestOpsDataFormat)format;

/**
    Send an asynchronous POST request with a plain text payload.
 
    @param urlString The complete URL. For eg: `http://www.apple.com`.
    @param payload A string that will be send in the body of the HTTP request as plain text.
    @param startingBlock A block of code to be executed just before the request is made. This will be run on the main thread.
    @param completionBlock The completion handler after the request is completed. The block is passed an instance of `ANRestOpsResponse`. This will be run on the main thread.
 
    @warning `payload` can be set to `nil` but it is not recommended to do so.
*/
+ (void)postInBackground:(NSString *)urlString
                 payload:(NSString *)payload
           beforeRequest:(void (^)(void))startingBlock
            onCompletion:(ANRestOpsCompletionHandler)completionBlock;

/**
    Send an asynchronous POST request with formatted payload.
 
    @param urlString The complete URL. For eg: `http://www.apple.com`.
    @param payload An NSDictionary with NSString keys AND NSString values which can be formatted in `x-www-form-urlencoded` format or JSON format.
    @param format The format in which the parameters dictionary will be serialized and sent in the request. The options are `ANRestOpsFormFormat` or `ANRestOpsJSONFormat`.
    @param startingBlock A block of code to be executed just before the request is made. This will be run on the main thread.
    @param completionBlock The completion handler after the request is completed. The block is passed an instance of `ANRestOpsResponse`. This will be run on the main thread.
 
    @warning `payload` can be set to `nil` but it is not recommended to do so.
*/
+ (void)postInBackground:(NSString *)urlString
                 payload:(NSDictionary *)payload
           payloadFormat:(ANRestOpsDataFormat)format
           beforeRequest:(void (^)(void))startingBlock
            onCompletion:(ANRestOpsCompletionHandler)completionBlock;

/**
    Send a synchronous PUT request with a plain text payload.
 
    @param urlString The complete URL. For eg: `http://www.apple.com`.
    @param payload A string that will be send in the body of the HTTP request as plain text. This can also be set to `nil`.
*/
+ (ANRestOpsResponse *)put:(NSString *)urlString payload:(NSString *)payload;

/**
    Send a synchronous PUT request with formatted payload.
 
    @param urlString The complete URL. For eg: `http://www.apple.com`
    @param payload An NSDictionary with NSString keys AND NSString values which can be formatted in `x-www-form-urlencoded` format or JSON format. This can also be set to `nil`.
    @param format The format in which the parameters dictionary will be serialized and sent in the request. The options are `ANRestOpsFormFormat` or `ANRestOpsJSONFormat`.
*/
+ (ANRestOpsResponse *)put:(NSString *)urlString payload:(NSDictionary *)payload payloadFormat:(ANRestOpsDataFormat)format;

/**
    Send an asynchronous PUT request with a plain text payload.
 
    @param urlString The complete URL. For eg: `http://www.apple.com`.
    @param payload A string that will be send in the body of the HTTP request as plain text. This can also be set to `nil`.
    @param startingBlock A block of code to be executed just before the request is made. This will be run on the main thread.
    @param completionBlock The completion handler after the request is completed. The block is passed an instance of `ANRestOpsResponse`. This will be run on the main thread.
*/
+ (void)putInBackground:(NSString *)urlString
                payload:(NSString *)payload
          beforeRequest:(void (^)(void))startingBlock
           onCompletion:(ANRestOpsCompletionHandler)completionBlock;

/**
    Send an asynchronous PUT request with formatted payload.
 
    @param urlString The complete URL. For eg: `http://www.apple.com`.
    @param payload An NSDictionary with NSString keys AND NSString values which can be formatted in `x-www-form-urlencoded` format or JSON format. This can also be set to `nil`
    @param format The format in which the parameters dictionary will be serialized and sent in the request. The options are `ANRestOpsFormFormat` or `ANRestOpsJSONFormat`.
    @param startingBlock A block of code to be executed just before the request is made. This will be run on the main thread.
    @param completionBlock The completion handler after the request is completed. The block is passed an instance of `ANRestOpsResponse`. This will be run on the main thread.
 */
+ (void)putInBackground:(NSString *)urlString
                payload:(NSDictionary *)payload
          payloadFormat:(ANRestOpsDataFormat)format
          beforeRequest:(void (^)(void))startingBlock
           onCompletion:(ANRestOpsCompletionHandler)completionBlock;

/**
    Send a synchronous DELETE request with a plain text payload.
 
    @param urlString The complete URL. For eg: `http://www.apple.com`.
    @param payload A string that will be send in the body of the HTTP request as plain text. This can also be set to `nil`.
 */
+ (ANRestOpsResponse *)delete:(NSString *)urlString payload:(NSString *)payload;

/**
    Send a synchronous DELETE request with formatted payload.
 
    @param urlString The complete URL. For eg: `http://www.apple.com`
    @param payload An NSDictionary with NSString keys AND NSString values which can be formatted in `x-www-form-urlencoded` format or JSON format. This can also be set to `nil`.
    @param format The format in which the parameters dictionary will be serialized and sent in the request. The options are `ANRestOpsFormFormat` or `ANRestOpsJSONFormat`.
*/
+ (ANRestOpsResponse *)delete:(NSString *)urlString payload:(NSDictionary *)payload payloadFormat:(ANRestOpsDataFormat)format;

/**
    Send an asynchronous DELETE request with a plain text payload.
 
    @param urlString The complete URL. For eg: `http://www.apple.com`.
    @param payload A string that will be send in the body of the HTTP request as plain text. This can also be set to `nil`.
    @param startingBlock A block of code to be executed just before the request is made. This will be run on the main thread.
    @param completionBlock The completion handler after the request is completed. The block is passed an instance of `ANRestOpsResponse`. This will be run on the main thread.
 */
+ (void)deleteInBackground:(NSString *)urlString
                   payload:(NSString *)payload
             beforeRequest:(void (^)(void))startingBlock
              onCompletion:(ANRestOpsCompletionHandler)completionBlock;

/**
    Send an asynchronous DELETE request with formatted payload.
 
    @param urlString The complete URL. For eg: `http://www.apple.com`.
    @param payload An NSDictionary with NSString keys AND NSString values which can be formatted in `x-www-form-urlencoded` format or JSON format. This can also be set to `nil`
    @param format The format in which the parameters dictionary will be serialized and sent in the request. The options are `ANRestOpsFormFormat` or `ANRestOpsJSONFormat`.
    @param startingBlock A block of code to be executed just before the request is made. This will be run on the main thread.
    @param completionBlock The completion handler after the request is completed. The block is passed an instance of `ANRestOpsResponse`. This will be run on the main thread.
*/
+ (void)deleteInBackground:(NSString *)urlString
                   payload:(NSDictionary *)payload
             payloadFormat:(ANRestOpsDataFormat)format
             beforeRequest:(void (^)(void))startingBlock
              onCompletion:(ANRestOpsCompletionHandler)completionBlock;

@end
