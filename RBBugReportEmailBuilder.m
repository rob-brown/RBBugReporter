//
//  RBBugReportEmailBuilder.m
//  StatCollector
//
//  Created by Robert Brown on 5/24/11.
//  Copyright 2011 Robert Brown. All rights reserved.
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
