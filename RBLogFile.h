//
// RBLogFile.h
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

/**
 * Protocol for log files. These log file objects are wrappers around files on 
 * the local system or a server.
 */
@protocol RBLogFile <NSObject>

/**
 * Appends the given text to the underlying log file. Ignores any errors. This 
 * should not be called directly. Use RBLogger so that all writes are 
 * synchronized and thread safe. Furthermore, the underlying file should never
 * be directly written to.
 *
 * @param text The text to append to the log file.
 */
- (void)write:(NSString *)text;

/**
 * Appends the given text to the underlying log file. This should not be called 
 * directly. Use RBLogger so that all writes are synchronized and thread safe.
 * Furthermore, the underlying file should never be directly written to.
 *
 * @param text The text to append to the log file.
 * @param error An error is returned by reference if the text can't be written.
 */
- (void)write:(NSString *)text error:(NSError **)error;

/**
 * Returns whether or not an actual file exists underneath. 
 *
 * @return YES if a file exists, NO otherwise.
 */
- (BOOL)underlyingFileExists;

@end
