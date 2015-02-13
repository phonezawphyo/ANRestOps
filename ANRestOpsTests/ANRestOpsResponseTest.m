//
//  ANRestOpsResponseTest.m
//  ANRestOps
//
//  Created by Ayush Newatia on 13/02/2015.
//  Copyright (c) 2015 Spectrum. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "ANRestOpsResponse.h"
#import "ANRestOps.h"

@interface ANRestOpsResponseTest : XCTestCase

@property (strong, nonatomic) ANRestOpsResponse *response;

@end

@implementation ANRestOpsResponseTest

- (void)setUp
{
    if (!self.response)
    {
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"Value1",@"Key1",@"Value2",@"Key2", nil];
        self.response = [ANRestOps post:@"http://httpbin.org/post" payload:params payloadFormat:ANRestOpsFormFormat];
    }
}

- (void)testStatusCodeIsReturned
{
    XCTAssertTrue([self.response statusCode] == 200);
}

- (void)testDataIsReturned
{
    XCTAssertTrue([self.response.data isKindOfClass:[NSData class]]);
}

- (void)testURLIsReturned
{
    XCTAssertTrue([[self.response url] containsString:@"http://httpbin.org/post"]);
}

- (void)testContentTypeIsReturned
{
    XCTAssertTrue([[self.response contentType] isEqualToString:@"application/json"]);
}

- (void)testDataAsStringIsReturned
{
    XCTAssertTrue([[self.response dataAsString] isKindOfClass:[NSString class]]);
}

- (void)testDataAsDictionaryIsReturned
{
    XCTAssertTrue([[self.response dataAsDictionary] isKindOfClass:[NSDictionary class]]);
}

- (void)testHttpHeaderAreReturned
{
    XCTAssertTrue([[self.response allHttpHeaders] isKindOfClass:[NSDictionary class]]);
}

@end
