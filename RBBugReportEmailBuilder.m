//
// RBBugReportEmailBuilder.m
//
// Copyright (c) 2011 Robert Brown
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import "RBBugReportEmailBuilder.h"
#import "NSString+RBExtras.h"


@interface RBBugReportEmailBuilder ()

/**
 * Sets up default values for all initializers.
 */
- (void) initDefaults;

/**
 * Convenience method that generates a string of device stats.
 */
+ (NSString *)deviceInfoString;

@end


@implementation RBBugReportEmailBuilder

@synthesize commentHeader, errorHeader, deviceHeader, commentMsg, errMsg, deviceMsg;

- (id)init {
    return [self initWithErrorMessage:@""];
}

- (id) initWithError:(NSError *)error {
    
    if ((self = [super init])) {
        
        [self setErrMsg:[NSString stringWithError:error]];
        [self initDefaults];
    }
    
    return self;
}

- (id) initWithErrorMessage:(NSString *)msg {
    
    if ((self = [super init])) {
        
        [self setErrMsg:msg];
        [self initDefaults];
    }
    
    return self;
}

- (void)initDefaults {
    
    // Sets up the defaults for all the strings.
    NSAutoreleasePool * pool = [NSAutoreleasePool new];
    [self setSubjectLine:@"Bug Report"];
    [self setCommentHeader:@"[[Comments]]"];
    [self setErrorHeader:@"[[Error]]"];
    [self setDeviceHeader:@"[[Device Info]]"];
    [self setCommentMsg:@"\n\n\n\n\n--------------------\nAdd any additional comments above, such as how to reproduce the bug.\n"];
    [self setDeviceMsg:[[self class] deviceInfoString]];
    
    [pool release];
}

- (NSString *)emailMessage {
    
    // Generates the body of the email.
    NSString * commentSection = [NSString stringWithFormat:@"%@\n%@\n", [self commentHeader], [self commentMsg]];
    NSString * errorSection = [NSString stringWithFormat:@"%@\n%@\n", [self errorHeader], [self errMsg]];
    NSString * deviceInfoSection = [NSString stringWithFormat:@"%@\n%@\n", [self deviceHeader], [self deviceMsg]];
    
    return [NSString stringWithFormat:@"%@\n%@\n%@\n", commentSection, errorSection, deviceInfoSection];
}

+ (NSString *)deviceInfoString {
    
    UIDevice * device = [UIDevice currentDevice];
    NSString * osName = [device systemName];
    NSString * osVersion = [device systemVersion];
    NSString * deviceModel = [device model];
    
    return [NSString stringWithFormat:
            @"OS Name: %@\nOS Version: %@\nModel: %@\n", 
            osName, 
            osVersion, 
            deviceModel];
}

@end
