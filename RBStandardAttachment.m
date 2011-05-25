//
// RBStandardAttachment.m
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

#import "RBStandardAttachment.h"
#import "NSURL+RBExtras.h"


@interface RBStandardAttachment ()

/**
 * A string representing the file path of the attachment.
 */
@property (nonatomic, copy) NSString * fileName;

@end


@implementation RBStandardAttachment

@synthesize fileName, fileMIMEType;

- (id) initWithFilePath:(NSString *)path {
    
    if ((self = [super init])) {
        
        [self setFileName:path];
    }
    
    return self;
}

- (NSData *)data {
    
    return [NSData dataWithContentsOfFile:[self fileName]];
}

- (NSString *)MIMEType {
    
    // If a MIME type isn't specified then it is inferred.
    if ([self fileMIMEType])
        return [self fileMIMEType];
    else
        return [[NSURL URLWithString:[self fileName]] MIMEType];
}

- (void)dealloc {
    [fileName release];
    [fileMIMEType release];
    [super dealloc];
}

@end
