//
// RBBaseEmailBuilder.m
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

#import "RBBaseEmailBuilder.h"

/**
 * The default email to use. Placed as a static global for convenience. This 
 * value should be changed to the desired default email.
 */
static NSString * const kDefaultEmail = @"MyEmail@example.com";

@implementation RBBaseEmailBuilder

@synthesize recipients, subjectLine, html;

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

- (NSArray *)attachments {
    
    // Returns no attachments. Override this if you want to provide attachments.
    return [NSArray array];
}


@end
