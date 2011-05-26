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
#import "NSError+RBExtras.h"


@interface RBLogFile ()

/**
 * A string representing the path to the underlying file.
 */
@property (nonatomic, copy) NSString * filePath;

/**
 * Attempts to create the file if it isn't already. 
 *
 * @param error An error is returned by reference to indicate any errors.
 *
 * @return YES if the file was created successfully, NO otherwise. If NO is 
 * returned, then error will contain any error information.
 */
- (BOOL)createFile:(NSError **)error;

@end


const NSInteger RBFileCreationError = 3000;


@implementation RBLogFile

@synthesize filePath;

- (id)initWithFilePath:(NSString *)theFilePath {
    
    if ((self = [super init])) {
        
        [self setFilePath:theFilePath];
    }
    
    return self;
}

- (void)write:(NSString *)text {
    [self write:text error:NULL];
}

- (void)write:(NSString *)text error:(NSError **)error {
    
    NSString * path = [self filePath];
    
    if (![self createFile:error])
        return;
    
    NSOutputStream * outFile = [NSOutputStream outputStreamToFileAtPath:path 
                                                                 append:YES];
    
    NSData * data = [text dataUsingEncoding:NSUTF8StringEncoding];
    
    [outFile open];
    [outFile write:[data bytes] maxLength:[data length]];
    [outFile close];    
}

- (BOOL)createFile:(NSError **)error {
    
    NSFileManager * fileManager = [NSFileManager defaultManager];
    NSString * path = [self filePath];
    
    // Creates the file if it doesn't exists. 
    if (![fileManager fileExistsAtPath:path]) {
        
        if (![fileManager createFileAtPath:path contents:nil attributes:nil]) {
            
            //  File Creation Failed
            if (error != NULL) {
                
                NSDictionary * userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                           NSLocalizedDescriptionKey, @"File could not be created.", 
                                           nil];
                
                *error = [[[NSError alloc] initWithDomain:RBErrorDomain
                                                     code:RBFileCreationError
                                                 userInfo:userInfo] autorelease];
            }
            
            return NO;
        }
    }
    
    return YES;
}

- (void)dealloc {
    [filePath release], filePath = nil;
    [super dealloc];
}

@end
