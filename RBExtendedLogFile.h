//
// RBExtendedLogFile.h
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

#import <Foundation/Foundation.h>

extern const NSInteger RBFileCreationError;


/**
 * A log file that uses a format similar to the extended log file format. 
 */
@interface RBExtendedLogFile : NSObject

/**
 * Initializes the log file with the given file path. The log file is lazy 
 * created.
 *
 * @param theFilePath The path to the underlying log file.
 *
 * @return self
 */
- (id)initWithFilePath:(NSString *)theFilePath;

/**
 * Appends the given text to the underlying log file. Ignores any errors.
 *
 * @param text The text to append to the log file.
 *
 * @return YES if no errors occurred, NO otherwise.
 */
- (BOOL)write:(NSString *)text;

/**
 * Appends the given text to the underlying log file. 
 *
 * @param text The text to append to the log file.
 * @param error An error is returned by reference if the text can't be written.
 *
 * @return YES if no errors occurred, NO otherwise.
 */
- (BOOL)write:(NSString *)text error:(NSError **)error;

/**
 * Returns the number of times the log file has been written to.
 */
- (NSInteger)writeCount;

@end
