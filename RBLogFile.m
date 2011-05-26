//
// RBLogFile.m
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

#import "RBLogFile.h"


@interface RBLogFile ()

@property (nonatomic, copy) NSString * filePath;

@end


@implementation RBLogFile

@synthesize filePath;

- (id)initWithFilePath:(NSString *)theFilePath {
    
    if ((self = [super init])) {
        
        [self setFilePath:theFilePath];
        
        filePath = [NSString stringWithString:theFilePath];
        
    }
    
    return self;
}



- (void)write:(NSString *)text {
    
    NSFileManager* fileManager = [NSFileManager defaultManager];
    
    if ( ![fileManager fileExistsAtPath:filePath] )
    {
        if(![fileManager createFileAtPath:filePath contents:nil attributes:nil])
        {
            //  File Creation Failed
            return;
        }
    }
    
    NSOutputStream* outFile = [NSOutputStream outputStreamToFileAtPath:filePath append:YES];
    [outFile open];
    
    [outFile write:[[text dataUsingEncoding:NSUTF8StringEncoding] bytes] maxLength:[[text dataUsingEncoding:NSUTF8StringEncoding] length]];
    
    [outFile close];
    
}

- (void)dealloc {
    
    filePath = nil;
    [filePath release];
    [super dealloc];
    
}

@end
