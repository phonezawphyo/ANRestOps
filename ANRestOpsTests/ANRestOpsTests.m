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

# pragma mark - Set Up

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

# pragma mark - Get Tests

- (void)testGetRequest
{
    ANRestOpsResponse *response = [ANRestOps get:@"http://httpbin.org/get"];
    
    XCTAssertEqual([response statusCode], 200, @"Status is 200 OK");
    XCTAssertNotNil([response data], @"Data returned is not nil");
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

- (void)testGetRequestWithParams
{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"Value1",@"Key1",@"Value2",@"Key2", nil];
    ANRestOpsResponse *response = [ANRestOps get:@"http://httpbin.org/get" withParameters:params];
    
    XCTAssertEqual([response statusCode], 200, @"Status is 200 OK");
    XCTAssertNotNil([response data], @"Data returned is not nil");
    
    NSLog(@"Response: %@", [response dataAsString]);
    
    XCTAssertTrue([[response dataAsDictionary][@"args"] count] == 2, @"The response contains the passed arguments");
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

- (void)testGetRequestWithParamsDictionaryThatContainsObjectsThatAreNotStringsThrowsAnException
{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[NSURLRequest new],@"Key1",[NSURLRequest new],@"Key2", nil];
    
    XCTAssertThrows([ANRestOps get:@"http://httpbin.org/get" withParameters:params], @"Exception is thrown for invalid dictionary");
}

# pragma mark - Post Tests

- (void)testPostRequestWithPlainTextPayload
{
    ANRestOpsResponse *response = [ANRestOps post:@"http://httpbin.org/post" payload:@"test payload"];
    
    XCTAssertEqual([response statusCode], 200, @"Status is 200 OK");
    XCTAssertNotNil([response data], @"Data returned is not nil");
    
    NSDictionary *responseDictionary = [response dataAsDictionary];
    
    XCTAssertTrue([responseDictionary[@"data"] isEqualToString:@"test payload"], @"The payload is correctly returned");
    XCTAssertTrue([responseDictionary[@"headers"][@"Content-Type"] isEqualToString:@"text/plain"], @"There is no payload form data");
    
    XCTAssertTrue([responseDictionary[@"args"] count] == 0, @"There are no payload args");
    XCTAssertTrue([responseDictionary[@"form"] count] == 0, @"There is no payload form data");
}

- (void)testAsyncPostRequestWithPlainTextPayload
{
    
    __block NSString *beforeBlock = nil;
    XCTestExpectation *urlResponseExpectation = [self expectationWithDescription:@"URL Response expectation"];
    
    [ANRestOps postInBackground:@"http://httpbin.org/post"
                        payload:@"test payload"
                  beforeRequest:^
     {
         beforeBlock = @"Before block executed";
     }
                   onCompletion:^(ANRestOpsResponse *response)
     {
         XCTAssertEqual(beforeBlock, @"Before block executed", "Before block has been executed");
         XCTAssertEqual([response statusCode], 200, @"Status is 200 OK");
         XCTAssertNotNil([response data], @"Data returned is not nil");
         
         NSDictionary *responseDictionary = [response dataAsDictionary];
         
         XCTAssertTrue([responseDictionary[@"data"] isEqualToString:@"test payload"], @"The payload is correctly returned");
         XCTAssertTrue([responseDictionary[@"headers"][@"Content-Type"] isEqualToString:@"text/plain"], @"There is no payload form data");
         
         XCTAssertTrue([responseDictionary[@"args"] count] == 0, @"There are no payload args");
         XCTAssertTrue([responseDictionary[@"form"] count] == 0, @"There is no payload form data");
         
         [urlResponseExpectation fulfill];
     }];
    
    [self waitForExpectationsWithTimeout:3.0 handler:^(NSError *error) {
        NSLog(@"%@ :Error in request", error);
    }];
}

- (void)testPostRequestWithDictionaryEncodedAsFormData
{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"Value1",@"Key1",@"Value2",@"Key2", nil];

    ANRestOpsResponse *response = [ANRestOps post:@"http://httpbin.org/post" payload:params payloadFormat:ANRestOpsFormFormat];
    
    XCTAssertEqual([response statusCode], 200, @"Status is 200 OK");
    XCTAssertNotNil([response data], @"Data returned is not nil");
    
    NSDictionary *responseDictionary = [response dataAsDictionary];
    
    XCTAssertEqual([responseDictionary[@"data"] length], 0,@"There is no raw data returned");
    XCTAssertTrue([responseDictionary[@"headers"][@"Content-Type"] isEqualToString:@"application/x-www-form-urlencoded"], @"The content type is correctly set to form data");
    
    XCTAssertTrue([responseDictionary[@"args"] count] == 0, @"There are no payload args");
    XCTAssertTrue([responseDictionary[@"form"] count] == 2, @"The payload form data is correctly returned");
}

- (void)testAsyncPostRequestWithDictionaryEncodedAsFormData
{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"Value1",@"Key1",@"Value2",@"Key2", nil];
    __block NSString *beforeBlock = nil;
    XCTestExpectation *urlResponseExpectation = [self expectationWithDescription:@"URL Response expectation"];
    
    [ANRestOps postInBackground:@"http://httpbin.org/post"
                        payload:params
                  payloadFormat:ANRestOpsFormFormat
                  beforeRequest:^
     {
         beforeBlock = @"Before block executed";
     }
                   onCompletion:^(ANRestOpsResponse *response)
     {
         XCTAssertEqual(beforeBlock, @"Before block executed", "Before block has been executed");
         XCTAssertEqual([response statusCode], 200, @"Status is 200 OK");
         XCTAssertNotNil([response data], @"Data returned is not nil");
         
         NSDictionary *responseDictionary = [response dataAsDictionary];
         
         XCTAssertEqual([responseDictionary[@"data"] length], 0,@"There is no raw data returned");
         XCTAssertTrue([responseDictionary[@"headers"][@"Content-Type"] isEqualToString:@"application/x-www-form-urlencoded"], @"The content type is correctly set to form data");
         
         XCTAssertTrue([responseDictionary[@"args"] count] == 0, @"There are no payload args");
         XCTAssertTrue([responseDictionary[@"form"] count] == 2, @"The payload form data is correctly returned");
         
         [urlResponseExpectation fulfill];
     }];
    
    [self waitForExpectationsWithTimeout:3.0 handler:^(NSError *error) {
        NSLog(@"%@ :Error in request", error);
    }];
}

- (void)testPostRequestWithDictionaryEncodedAsJSONData
{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"Value1",@"Key1",@"Value2",@"Key2", nil];
    
    ANRestOpsResponse *response = [ANRestOps post:@"http://httpbin.org/post" payload:params payloadFormat:ANRestOpsJSONFormat];
    
    XCTAssertEqual([response statusCode], 200, @"Status is 200 OK");
    XCTAssertNotNil([response data], @"Data returned is not nil");
    
    NSDictionary *responseDictionary = [response dataAsDictionary];
    
    XCTAssertTrue([responseDictionary[@"headers"][@"Content-Type"] isEqualToString:@"application/json"], @"The content type is correctly set to JSON data");
    
    XCTAssertTrue([responseDictionary[@"args"] count] == 0, @"There are no payload args");
    XCTAssertTrue([responseDictionary[@"form"] count] == 0, @"There is no form data returned");
    XCTAssertTrue([responseDictionary[@"json"] count] == 2, @"The JSON data is correctly returned");
}

- (void)testAsyncPostRequestWithDictionaryEncodedAsJSONData
{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"Value1",@"Key1",@"Value2",@"Key2", nil];
    __block NSString *beforeBlock = nil;
    XCTestExpectation *urlResponseExpectation = [self expectationWithDescription:@"URL Response expectation"];
    
    [ANRestOps postInBackground:@"http://httpbin.org/post"
                        payload:params
                  payloadFormat:ANRestOpsJSONFormat
                  beforeRequest:^
     {
         beforeBlock = @"Before block executed";
     }
                   onCompletion:^(ANRestOpsResponse *response)
     {
         XCTAssertEqual(beforeBlock, @"Before block executed", "Before block has been executed");
         XCTAssertEqual([response statusCode], 200, @"Status is 200 OK");
         XCTAssertNotNil([response data], @"Data returned is not nil");
         
         NSDictionary *responseDictionary = [response dataAsDictionary];
         
         XCTAssertTrue([responseDictionary[@"headers"][@"Content-Type"] isEqualToString:@"application/json"], @"The content type is correctly set to JSON data");
         
         XCTAssertTrue([responseDictionary[@"args"] count] == 0, @"There are no payload args");
         XCTAssertTrue([responseDictionary[@"form"] count] == 0, @"There is no form data returned");
         XCTAssertTrue([responseDictionary[@"json"] count] == 2, @"The JSON data is correctly returned");
         
         [urlResponseExpectation fulfill];
     }];
    
    [self waitForExpectationsWithTimeout:3.0 handler:^(NSError *error) {
        NSLog(@"%@ :Error in request", error);
    }];
}

# pragma mark - Put Tests

- (void)testPutRequestWithPlainTextPayload
{
    ANRestOpsResponse *response = [ANRestOps put:@"http://httpbin.org/put" payload:@"test payload"];
    
    XCTAssertEqual([response statusCode], 200, @"Status is 200 OK");
    XCTAssertNotNil([response data], @"Data returned is not nil");
    
    NSDictionary *responseDictionary = [response dataAsDictionary];
    
    XCTAssertTrue([responseDictionary[@"data"] isEqualToString:@"test payload"], @"The POST payload is correctly returned");
    XCTAssertTrue([responseDictionary[@"headers"][@"Content-Type"] isEqualToString:@"text/plain"], @"There is no payload form data");
    
    XCTAssertTrue([responseDictionary[@"args"] count] == 0, @"There are no payload args");
    XCTAssertTrue([responseDictionary[@"form"] count] == 0, @"There is no payload form data");
}

- (void)testAsyncPutRequestWithPlainTextPayload
{
    
    __block NSString *beforeBlock = nil;
    XCTestExpectation *urlResponseExpectation = [self expectationWithDescription:@"URL Response expectation"];
    
    [ANRestOps putInBackground:@"http://httpbin.org/put"
                        payload:@"test payload"
                  beforeRequest:^
     {
         beforeBlock = @"Before block executed";
     }
                   onCompletion:^(ANRestOpsResponse *response)
     {
         XCTAssertEqual(beforeBlock, @"Before block executed", "Before block has been executed");
         XCTAssertEqual([response statusCode], 200, @"Status is 200 OK");
         XCTAssertNotNil([response data], @"Data returned is not nil");
         
         NSDictionary *responseDictionary = [response dataAsDictionary];
         
         XCTAssertTrue([responseDictionary[@"data"] isEqualToString:@"test payload"], @"The POST payload is correctly returned");
         XCTAssertTrue([responseDictionary[@"headers"][@"Content-Type"] isEqualToString:@"text/plain"], @"There are no payload form data");
         
         XCTAssertTrue([responseDictionary[@"args"] count] == 0, @"There are no payload args");
         XCTAssertTrue([responseDictionary[@"form"] count] == 0, @"There is no payload form data");
         
         [urlResponseExpectation fulfill];
     }];
    
    [self waitForExpectationsWithTimeout:3.0 handler:^(NSError *error) {
        NSLog(@"%@ :Error in request", error);
    }];
}

- (void)testPutRequestWithDictionaryEncodedAsFormData
{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"Value1",@"Key1",@"Value2",@"Key2", nil];
    
    ANRestOpsResponse *response = [ANRestOps put:@"http://httpbin.org/put" payload:params payloadFormat:ANRestOpsFormFormat];
    
    XCTAssertEqual([response statusCode], 200, @"Status is 200 OK");
    XCTAssertNotNil([response data], @"Data returned is not nil");
    
    NSDictionary *responseDictionary = [response dataAsDictionary];
    
    XCTAssertEqual([responseDictionary[@"data"] length], 0,@"There is no raw data returned");
    XCTAssertTrue([responseDictionary[@"headers"][@"Content-Type"] isEqualToString:@"application/x-www-form-urlencoded"], @"The content type is correctly set to form data");
    
    XCTAssertTrue([responseDictionary[@"args"] count] == 0, @"There are no payload args");
    XCTAssertTrue([responseDictionary[@"form"] count] == 2, @"The payload form data is correctly returned");
}

- (void)testAsyncPutRequestWithDictionaryEncodedAsFormData
{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"Value1",@"Key1",@"Value2",@"Key2", nil];
    __block NSString *beforeBlock = nil;
    XCTestExpectation *urlResponseExpectation = [self expectationWithDescription:@"URL Response expectation"];
    
    [ANRestOps putInBackground:@"http://httpbin.org/put"
                        payload:params
                  payloadFormat:ANRestOpsFormFormat
                  beforeRequest:^
     {
         beforeBlock = @"Before block executed";
     }
                   onCompletion:^(ANRestOpsResponse *response)
     {
         XCTAssertEqual(beforeBlock, @"Before block executed", "Before block has been executed");
         XCTAssertEqual([response statusCode], 200, @"Status is 200 OK");
         XCTAssertNotNil([response data], @"Data returned is not nil");
         
         NSDictionary *responseDictionary = [response dataAsDictionary];
         
         XCTAssertEqual([responseDictionary[@"data"] length], 0,@"There is no raw data returned");
         XCTAssertTrue([responseDictionary[@"headers"][@"Content-Type"] isEqualToString:@"application/x-www-form-urlencoded"], @"The content type is correctly set to form data");
         
         XCTAssertTrue([responseDictionary[@"args"] count] == 0, @"There are no payload args");
         XCTAssertTrue([responseDictionary[@"form"] count] == 2, @"The payload form data is correctly returned");
         
         [urlResponseExpectation fulfill];
     }];
    
    [self waitForExpectationsWithTimeout:3.0 handler:^(NSError *error) {
        NSLog(@"%@ :Error in request", error);
    }];
}

- (void)testPutRequestWithDictionaryEncodedAsJSONData
{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"Value1",@"Key1",@"Value2",@"Key2", nil];
    
    ANRestOpsResponse *response = [ANRestOps put:@"http://httpbin.org/put" payload:params payloadFormat:ANRestOpsJSONFormat];
    
    XCTAssertEqual([response statusCode], 200, @"Status is 200 OK");
    XCTAssertNotNil([response data], @"Data returned is not nil");
    
    NSDictionary *responseDictionary = [response dataAsDictionary];
    
    XCTAssertTrue([responseDictionary[@"headers"][@"Content-Type"] isEqualToString:@"application/json"], @"The content type is correctly set to JSON data");
    
    XCTAssertTrue([responseDictionary[@"args"] count] == 0, @"There are no payload args");
    XCTAssertTrue([responseDictionary[@"form"] count] == 0, @"There is no form data returned");
    XCTAssertTrue([responseDictionary[@"json"] count] == 2, @"The JSON data is correctly returned");
}

- (void)testAsyncPutRequestWithDictionaryEncodedAsJSONData
{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"Value1",@"Key1",@"Value2",@"Key2", nil];
    __block NSString *beforeBlock = nil;
    XCTestExpectation *urlResponseExpectation = [self expectationWithDescription:@"URL Response expectation"];
    
    [ANRestOps putInBackground:@"http://httpbin.org/put"
                        payload:params
                  payloadFormat:ANRestOpsJSONFormat
                  beforeRequest:^
     {
         beforeBlock = @"Before block executed";
     }
                   onCompletion:^(ANRestOpsResponse *response)
     {
         XCTAssertEqual(beforeBlock, @"Before block executed", "Before block has been executed");
         XCTAssertEqual([response statusCode], 200, @"Status is 200 OK");
         XCTAssertNotNil([response data], @"Data returned is not nil");
         
         NSDictionary *responseDictionary = [response dataAsDictionary];
         
         XCTAssertTrue([responseDictionary[@"headers"][@"Content-Type"] isEqualToString:@"application/json"], @"The content type is correctly set to JSON data");
         
         XCTAssertTrue([responseDictionary[@"args"] count] == 0, @"There are no payload args");
         XCTAssertTrue([responseDictionary[@"form"] count] == 0, @"There is no form data returned");
         XCTAssertTrue([responseDictionary[@"json"] count] == 2, @"The JSON data is correctly returned");
         
         [urlResponseExpectation fulfill];
     }];
    
    [self waitForExpectationsWithTimeout:3.0 handler:^(NSError *error) {
        NSLog(@"%@ :Error in request", error);
    }];
}

# pragma mark - Delete Tests

- (void)testDeleteRequestWithPlainTextPayload
{
    ANRestOpsResponse *response = [ANRestOps delete:@"http://httpbin.org/delete" payload:@"test payload"];
    
    XCTAssertEqual([response statusCode], 200, @"Status is 200 OK");
    XCTAssertNotNil([response data], @"Data returned is not nil");
    
    NSDictionary *responseDictionary = [response dataAsDictionary];
    
    XCTAssertTrue([responseDictionary[@"data"] isEqualToString:@"test payload"], @"The POST payload is correctly returned");
    XCTAssertTrue([responseDictionary[@"headers"][@"Content-Type"] isEqualToString:@"text/plain"], @"There is no payload form data");
    
    XCTAssertTrue([responseDictionary[@"args"] count] == 0, @"There are no payload args");
    XCTAssertTrue([responseDictionary[@"form"] count] == 0, @"There is no payload form data");
}

- (void)testAsyncDeleteRequestWithPlainTextPayload
{
    
    __block NSString *beforeBlock = nil;
    XCTestExpectation *urlResponseExpectation = [self expectationWithDescription:@"URL Response expectation"];
    
    [ANRestOps deleteInBackground:@"http://httpbin.org/delete"
                       payload:@"test payload"
                 beforeRequest:^
     {
         beforeBlock = @"Before block executed";
     }
                  onCompletion:^(ANRestOpsResponse *response)
     {
         XCTAssertEqual(beforeBlock, @"Before block executed", "Before block has been executed");
         XCTAssertEqual([response statusCode], 200, @"Status is 200 OK");
         XCTAssertNotNil([response data], @"Data returned is not nil");
         
         NSDictionary *responseDictionary = [response dataAsDictionary];
         
         XCTAssertTrue([responseDictionary[@"data"] isEqualToString:@"test payload"], @"The POST payload is correctly returned");
         XCTAssertTrue([responseDictionary[@"headers"][@"Content-Type"] isEqualToString:@"text/plain"], @"There are no payload form data");
         
         XCTAssertTrue([responseDictionary[@"args"] count] == 0, @"There are no payload args");
         XCTAssertTrue([responseDictionary[@"form"] count] == 0, @"There is no payload form data");
         
         [urlResponseExpectation fulfill];
     }];
    
    [self waitForExpectationsWithTimeout:3.0 handler:^(NSError *error) {
        NSLog(@"%@ :Error in request", error);
    }];
}

- (void)testDeleteRequestWithDictionaryEncodedAsFormData
{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"Value1",@"Key1",@"Value2",@"Key2", nil];
    
    ANRestOpsResponse *response = [ANRestOps delete:@"http://httpbin.org/delete" payload:params payloadFormat:ANRestOpsFormFormat];
    
    XCTAssertEqual([response statusCode], 200, @"Status is 200 OK");
    XCTAssertNotNil([response data], @"Data returned is not nil");
    
    NSDictionary *responseDictionary = [response dataAsDictionary];
    
    XCTAssertEqual([responseDictionary[@"data"] length], 0,@"There is no raw data returned");
    XCTAssertTrue([responseDictionary[@"headers"][@"Content-Type"] isEqualToString:@"application/x-www-form-urlencoded"], @"The content type is correctly set to form data");
    
    XCTAssertTrue([responseDictionary[@"args"] count] == 0, @"There are no payload args");
    XCTAssertTrue([responseDictionary[@"form"] count] == 2, @"The payload form data is correctly returned");
}

- (void)testAsyncDeleteRequestWithDictionaryEncodedAsFormData
{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"Value1",@"Key1",@"Value2",@"Key2", nil];
    __block NSString *beforeBlock = nil;
    XCTestExpectation *urlResponseExpectation = [self expectationWithDescription:@"URL Response expectation"];
    
    [ANRestOps deleteInBackground:@"http://httpbin.org/delete"
                       payload:params
                 payloadFormat:ANRestOpsFormFormat
                 beforeRequest:^
     {
         beforeBlock = @"Before block executed";
     }
                  onCompletion:^(ANRestOpsResponse *response)
     {
         XCTAssertEqual(beforeBlock, @"Before block executed", "Before block has been executed");
         XCTAssertEqual([response statusCode], 200, @"Status is 200 OK");
         XCTAssertNotNil([response data], @"Data returned is not nil");
         
         NSDictionary *responseDictionary = [response dataAsDictionary];
         
         XCTAssertEqual([responseDictionary[@"data"] length], 0,@"There is no raw data returned");
         XCTAssertTrue([responseDictionary[@"headers"][@"Content-Type"] isEqualToString:@"application/x-www-form-urlencoded"], @"The content type is correctly set to form data");
         
         XCTAssertTrue([responseDictionary[@"args"] count] == 0, @"There are no payload args");
         XCTAssertTrue([responseDictionary[@"form"] count] == 2, @"The payload form data is correctly returned");
         
         [urlResponseExpectation fulfill];
     }];
    
    [self waitForExpectationsWithTimeout:3.0 handler:^(NSError *error) {
        NSLog(@"%@ :Error in request", error);
    }];
}

- (void)testDeleteRequestWithDictionaryEncodedAsJSONData
{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"Value1",@"Key1",@"Value2",@"Key2", nil];
    
    ANRestOpsResponse *response = [ANRestOps delete:@"http://httpbin.org/delete" payload:params payloadFormat:ANRestOpsJSONFormat];
    
    XCTAssertEqual([response statusCode], 200, @"Status is 200 OK");
    XCTAssertNotNil([response data], @"Data returned is not nil");
    
    NSDictionary *responseDictionary = [response dataAsDictionary];
    
    XCTAssertTrue([responseDictionary[@"headers"][@"Content-Type"] isEqualToString:@"application/json"], @"The content type is correctly set to JSON data");
    
    XCTAssertTrue([responseDictionary[@"args"] count] == 0, @"There are no payload args");
    XCTAssertTrue([responseDictionary[@"form"] count] == 0, @"There is no form data returned");
    XCTAssertTrue([responseDictionary[@"json"] count] == 2, @"The JSON data is correctly returned");
}

- (void)testAsyncDeleteRequestWithDictionaryEncodedAsJSONData
{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"Value1",@"Key1",@"Value2",@"Key2", nil];
    __block NSString *beforeBlock = nil;
    XCTestExpectation *urlResponseExpectation = [self expectationWithDescription:@"URL Response expectation"];
    
    [ANRestOps deleteInBackground:@"http://httpbin.org/delete"
                       payload:params
                 payloadFormat:ANRestOpsJSONFormat
                 beforeRequest:^
     {
         beforeBlock = @"Before block executed";
     }
                  onCompletion:^(ANRestOpsResponse *response)
     {
         XCTAssertEqual(beforeBlock, @"Before block executed", "Before block has been executed");
         XCTAssertEqual([response statusCode], 200, @"Status is 200 OK");
         XCTAssertNotNil([response data], @"Data returned is not nil");
         
         NSDictionary *responseDictionary = [response dataAsDictionary];
         
         XCTAssertTrue([responseDictionary[@"headers"][@"Content-Type"] isEqualToString:@"application/json"], @"The content type is correctly set to JSON data");
         
         XCTAssertTrue([responseDictionary[@"args"] count] == 0, @"There are no payload args");
         XCTAssertTrue([responseDictionary[@"form"] count] == 0, @"There is no form data returned");
         XCTAssertTrue([responseDictionary[@"json"] count] == 2, @"The JSON data is correctly returned");
         
         [urlResponseExpectation fulfill];
     }];
    
    [self waitForExpectationsWithTimeout:3.0 handler:^(NSError *error) {
        NSLog(@"%@ :Error in request", error);
    }];
}

@end
