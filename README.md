## Description

ANRestOps is a simple library based on the NSURLConnection and NSOperationQueue APIs. 
It abstracts away most of the complexity to set up these objects and allows you to make simple REST calls in a single line of code.

## Usage

ANRestOps currently has GET and POST methods. PUT, PATCH and DELETE are coming as soon as I can be bothered to write them. The method call will return an instance of `ANRestOpsResponse`. This class has a number of helper methods to extract data from the response. Refer to `ANRestOpsResponse.h`.

A `GET` request can be executed like the below line:

	ANRestOpsResponse *response = [ANRestOps get:@"http://httpbin.org/get"];

Or you can optionally include parameters in the form of an `NSDictionary`. The keys and values will be formatted into web form (`application/x-www-form-urlencoded`) before the request.

	NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"Value1",@"Key1",@"Value2",@"Key2", nil];
    ANRestOpsResponse *response = [ANRestOps get:@"http://httpbin.org/get" withParameters:params];

To perform a `GET` request in the background, the following method can be used:

	[ANRestOps getInBackground:@"http://httpbin.org/get"
                beforeRequest:^
    {
        // Put any work that needs to be done before the request here
    }
                onCompletion:^(ANRestOpsResponse *response)
    {   
        // The completion handler will be passed the response and is run on the main thread
    }];

Or optionally with parameters:

	NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"Value1",@"Key1",@"Value2",@"Key2", nil];
	[ANRestOps getInBackground:@"http://httpbin.org/get"
                    parameters:params
                 beforeRequest:^
    {
        // Put any work that needs to be done before the request here
    }
                  onCompletion:^(ANRestOpsResponse *response)
    {
        // The completion handler will be passed the response and is run on the main thread
    }];


`POST` requests can also be done similarly. There is an extra option that allows you to choose how your payload is formatted. You could pass in a plain `NSString` instance or an `NSDictionary` and choose to have it formatted as form parameters or JSON. An example is shown below. `POST` requests can be done synchronously or asynchronously similar to `GET`.

	NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"Value1",@"Key1",@"Value2",@"Key2", nil];
	[ANRestOps postInBackground:@"http://httpbin.org/get"
                            payload:params
                      payloadFormat:ANRestOpsJSONFormat
                      beforeRequest:^
        {
        	// Put any work that needs to be done before the request here
        }
                       onCompletion:^(ANRestOpsResponse *response)
        {
            // The completion handler will be passed the response and is run on the main thread
        }]; 


## Requirements

ANRestOps requires at least iOS 7 and ARC.

## Installation

ANRestOps is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

    pod "ANRestOps"

## Author

Ayush Newatia, ayushnewatia@gmail.com

## License

ANRestOps is available under the MIT license. See the LICENSE file for more info.

