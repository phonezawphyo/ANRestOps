//
//  ANRestOpsResponse.m
//  ANRestOps
//
//  Created by Ayush Newatia on 31/12/2014.
//  Copyright (c) 2014 Spectrum. All rights reserved.
//

#import "ANRestOpsResponse.h"


@interface ANRestOpsResponse()

@property (nonatomic, strong) NSHTTPURLResponse *urlResponse;

@end

@implementation ANRestOpsResponse

- (instancetype)initWithResponse:(NSURLResponse *)headers
                            data:(NSData *)data
                           error:(NSError *)error
{
    self = [super init];
    self.urlResponse = (NSHTTPURLResponse *)headers;
    self.data = data;
    self.error = error;
    
    return self;
}

- (NSString *)url
{
    return [self.urlResponse.URL absoluteString];
}

- (NSDictionary *)allHttpHeaders;
{
    return self.urlResponse.allHeaderFields;
}

- (NSUInteger)statusCode
{
    return self.urlResponse.statusCode;
}

- (NSString *)contentType
{
    return [self allHttpHeaders][@"Content-Type"];
}

- (NSString *)contentLength
{
    return [self allHttpHeaders][@"Content-Length"];
}

- (NSString *)dataAsString
{
    return [NSString stringWithUTF8String:[self.data bytes]];
}

- (NSDictionary *)dataAsDictionary
{
    NSError *error = nil;
    NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:self.data options:0 error:&error];
    
    if (!error)
    {
        return dataDictionary;
    }
    else
    {
        NSLog(@"The following error occured during JSON serialisation: %@", error);
        return nil;
    }
}

@end
