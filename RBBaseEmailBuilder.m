//
//  RBBaseEmailBuilder.m
//  StatCollector
//
//  Created by Robert Brown on 5/24/11.
//  Copyright 2011 Robert Brown. All rights reserved.
//

#import "RBBaseEmailBuilder.h"

/**
 * The default email to use. Placed as a static global for convenience. This 
 * value should be changed to the desired default email.
 */
static NSString * const kDefaultEmail = @"MyEmail@example.com";

@implementation RBBaseEmailBuilder

@synthesize recipients, subjectLine;

- (id)init {
    
    if ((self = [super init])) {
        
        [self setRecipients:[NSArray arrayWithObject:kDefaultEmail]];
        [self setSubjectLine:@""];
    }
    
    return self;
}

- (NSString *)emailMessage {
    
    // This should be overriden by subclasses.
    return @"";
}

- (void)dealloc {
    [recipients release];
    [subjectLine release];
    [super dealloc];
}

@end
