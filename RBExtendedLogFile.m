//
// RBExtendedLogFile.m
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

#import "RBExtendedLogFile.h"
#import "NSError+RBExtras.h"


@interface RBExtendedLogFile ()

/**
 * Attempts to create the file if it isn't already. 
 *
 * @param error An error is returned by reference to indicate any errors.
 *
 * @return YES if the file was created successfully, NO otherwise. If NO is 
 * returned, then error will contain any error information.
 */
- (BOOL)createFile:(NSError **)error;

/**
 * Writes the header data if it hasn't already.
 */
- (void)writeHeaderData;

@end


const NSInteger RBFileCreationError = 3000;


@implementation RBExtendedLogFile

- (id)initWithFilePath:(NSString *)theFilePath {
    
    if ((self = [super initWithFilePath:theFilePath])) {
        
    }
    
    return self;
}

- (BOOL)write:(NSString *)text error:(NSError **)error {
    
    // Creates the file, if necessary.
    if (![self createFile:error])
        return NO;
    
    // Formats the log message.
    NSString * now = [NSDateFormatter localizedStringFromDate:[NSDate date]
                                                    dateStyle:NSDateFormatterNoStyle
                                                    timeStyle:NSDateFormatterShortStyle];
    NSString * logMsg = [NSString stringWithFormat:@"[%@] [%@]", now, text];
    
    // Writes the formatted log message to the file.
    NSData * logData = [logMsg dataUsingEncoding:NSUTF8StringEncoding];
    
    NSOutputStream * outFile = [NSOutputStream outputStreamToFileAtPath:[self filePath] 
                                                                 append:YES];
    [outFile open];
    [outFile write:[logData bytes] maxLength:[logData length]];
    [outFile close];
    
    return YES;
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
                                           NSLocalizedDescriptionKey, @"File could not be created.", // FIXME: This really should be localized as the key implies.
                                           nil];
                *error = [[[NSError alloc] initWithDomain:RBErrorDomain
                                                     code:RBFileCreationError
                                                 userInfo:userInfo] autorelease];
            }
            
            return NO;
        }
        else {
            [self writeHeaderData];
        }
    }
    
    return YES;
}

- (void)writeHeaderData {
    
    // Uses a format similar to the extended log file format.
    NSDictionary * bundleInfo = [[NSBundle mainBundle] infoDictionary];
    NSString * nameStr = [bundleInfo objectForKey:@"CFBundleName"];
    NSString * versionStr = [bundleInfo objectForKey:@"CFBundleVersion"];
    NSString * dateStr = [NSDateFormatter localizedStringFromDate:[NSDate date]
                                                        dateStyle:NSDateFormatterMediumStyle
                                                        timeStyle:NSDateFormatterNoStyle];
    NSString * fieldStr = @"time message";
    
    NSString * headerStr = [NSString stringWithFormat:
                            @"#Name: %@\n#Version: %@\n#Date: %@\n#Fields: %@\n", 
                            nameStr,
                            versionStr, 
                            dateStr, 
                            fieldStr];
    NSData * headerData = [headerStr dataUsingEncoding:NSUTF8StringEncoding];
    
    NSOutputStream * outFile = [NSOutputStream outputStreamToFileAtPath:[self filePath] 
                                                                 append:YES];
    [outFile open];
    [outFile write:[headerData bytes] maxLength:[headerData length]];
    [outFile close];
}


#pragma mark - Memory Management

- (void)dealloc {
    [super dealloc];
}

@end
