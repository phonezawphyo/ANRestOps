//
//  ANRestOpsTests.m
//  ANRestOps
//
//  Created by Ayush Newatia on 18/01/2015.
//  Copyright (c) 2015 Spectrum. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ANRestOps.h"

@interface ANRestOpsTests : XCTestCase

@end

@implementation ANRestOpsTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testGetRequest
{
    ANRestOpsResponse *response = [ANRestOps get:@"http://httpbin.org/get"];
    
    XCTAssertEqual([response statusCode], 200, @"Status is 200 OK");
    XCTAssertNotNil([response data], @"Data returned is not nil");
}

- (void)testGetRequestWithParams
{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"Value1",@"Key1",@"Value2",@"Key2", nil];
    ANRestOpsResponse *response = [ANRestOps get:@"http://httpbin.org/get" withParameters:params];
    
    XCTAssertEqual([response statusCode], 200, @"Status is 200 OK");
    XCTAssertNotNil([response data], @"Data returned is not nil");
    
    XCTAssertTrue([[response dataAsString] containsString:@"Key1"], @"The response contains the parameter key");
    XCTAssertTrue([[response dataAsString] containsString:@"Value1"], @"The response contains the parameter value");
    XCTAssertTrue([[response dataAsString] containsString:@"Key2"], @"The response contains the parameter key");
    XCTAssertTrue([[response dataAsString] containsString:@"Value2"], @"The response contains the parameter value");
}

- (void)testGetRequestWithParamsDictionaryThatContainsObjectsThatAreNotStringsThrowsAnException
{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[NSURLRequest new],@"Key1",[NSURLRequest new],@"Key2", nil];
    
    XCTAssertThrows([ANRestOps get:@"http://httpbin.org/get" withParameters:params], @"Exception is thrown for invalid dictionary");
}

- (void)testAsyncGetRequest
{
    __block NSString *beforeBlock = nil;
    XCTestExpectation *urlResponseExpectation = [self expectationWithDescription:@"URL Response expectation"];
    
    [ANRestOps getInBackground:@"http://httpbin.org/get"
                beforeRequest:^
    {
        beforeBlock = @"Before block executed";
    }
                onCompletion:^(ANRestOpsResponse *response)
    {
        XCTAssertEqual(beforeBlock, @"Before block executed", "Before block has been executed");
        XCTAssertEqual([response statusCode], 200, @"Status is 200 OK");
        XCTAssertNotNil([response data], @"Data returned is not nil");
        
        [urlResponseExpectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:3.0 handler:^(NSError *error) {
        NSLog(@"%@ :Error in request", error);
    }];
}

- (void)testAsyncGetRequestWithParams
{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"Value1",@"Key1",@"Value2",@"Key2", nil];
    __block NSString *beforeBlock = nil;
    XCTestExpectation *urlResponseExpectation = [self expectationWithDescription:@"URL Response expectation"];

    [ANRestOps getInBackground:@"http://httpbin.org/get"
                    parameters:params
                 beforeRequest:^
    {
        beforeBlock = @"Before block executed";
    }
                  onCompletion:^(ANRestOpsResponse *response)
    {
        XCTAssertEqual(beforeBlock, @"Before block executed", "Before block has been executed");
        XCTAssertEqual([response statusCode], 200, @"Status is 200 OK");
        XCTAssertNotNil([response data], @"Data returned is not nil");
        
        XCTAssertTrue([[response dataAsString] containsString:@"Key1"], @"The response contains the parameter key");
        XCTAssertTrue([[response dataAsString] containsString:@"Value1"], @"The response contains the parameter value");
        XCTAssertTrue([[response dataAsString] containsString:@"Key2"], @"The response contains the parameter key");
        XCTAssertTrue([[response dataAsString] containsString:@"Value2"], @"The response contains the parameter value");
        
        [urlResponseExpectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:3.0 handler:^(NSError *error) {
        NSLog(@"%@ :Error in request", error);
    }];
}

- (void)testPostRequestWithPlainTextPayload
{
    ANRestOpsResponse *response = [ANRestOps post:@"http://httpbin.org/post" payload:@"test payload"];
    
    XCTAssertEqual([response statusCode], 200, @"Status is 200 OK");
    XCTAssertNotNil([response data], @"Data returned is not nil");
    
    NSError *error = nil;
    NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:response.data options:0 error:&error];
    
    XCTAssertTrue([responseDictionary[@"data"] isEqualToString:@"test payload"], @"The POST payload is correctly returned");
    XCTAssertTrue([responseDictionary[@"headers"][@"Content-Type"] isEqualToString:@"text/plain"], @"There are no POST payload form data");
    
    XCTAssertTrue([responseDictionary[@"args"] count] == 0, @"There are no POST payload args");
    XCTAssertTrue([responseDictionary[@"form"] count] == 0, @"There are no POST payload form data");
}

@end
