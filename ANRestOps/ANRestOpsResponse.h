//
//  ANRestOpsResponse.h
//  ANRestOps
//
//  Created by Ayush Newatia on 31/12/2014.
//  Copyright (c) 2014 Spectrum. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ANRestOpsResponse : NSObject

/**
    The raw data returned in the body of the response.
*/
@property (nonatomic, strong) NSData *data;

/**
    A connection error is stored in this property.
*/
@property (nonatomic, strong) NSError *error;

- (instancetype)initWithResponse:(NSURLResponse *)response
                            data:(NSData *)data
                           error:(NSError *)error;
/**
    @return The URL the request was sent to.
*/
- (NSString *)url;

/**
    @return The HTTP Status Code of the response.
*/
- (NSUInteger)statusCode;

/**
    @return The MIME type of the response.
*/
- (NSString *)contentType;

/**
    @return The data in NSString format.
*/
- (NSString *)dataAsString;

/**
    @return The data parsed into an NSDictionary.
 
    @warning Be aware that the response has to be in JSON format for this to work otherwise it will just log an error.
*/
- (NSDictionary *)dataAsDictionary;

/**
    @return All the HTTP response headers in an NSDictionary.
*/
- (NSDictionary *)allHttpHeaders;

@end
