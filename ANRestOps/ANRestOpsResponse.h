//
//  ANRestOpsResponse.h
//  ANRestOps
//
//  Created by Ayush Newatia on 31/12/2014.
//  Copyright (c) 2014 Spectrum. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ANRestOpsResponse : NSObject

@property (nonatomic, strong) NSData *data;
@property (nonatomic, strong) NSError *error;

- (instancetype)initWithResponse:(NSURLResponse *)response
                            data:(NSData *)data
                           error:(NSError *)error;
- (NSString *)url;
- (NSUInteger)statusCode;
- (NSString *)contentType;
- (NSString *)dataAsString;
- (NSDictionary *)dataAsDictionary;
- (NSDictionary *)allHttpHeaders;

@end
