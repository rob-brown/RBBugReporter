//
// RBLogger.h
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

#import "RBLogFile.h"

@interface RBLogger : NSObject

/**
 * Logs an error. Simply calls logMessage: with a string generated from the 
 * error.
 *
 * @param error The error to log.
 */
- (void)logError:(NSError *)error;

/**
 * Logs an exception. Simply calls logMessage: with a string generated from the 
 * exception.
 *
 * @param exception The exception to log.
 */
- (void)logException:(NSException *)exception;

/**
 * Writes the given message to the log file.
 *
 * @param msg The unformatted message to write to the log file.
 *
 * @todo Change this later to use NSOperationQueue instead of GCD.
 */
- (void)logMessage:(NSString *)msg;

/**
 * Returns the log file for the given date. There may or may not be an actual 
 * file underneath the RBLogFile.
 *
 * @param date The date of the log file.
 *
 * @return The log file for the given date.
 */
+ (id<RBLogFile>)logFileForDate:(NSDate *)date;

/** 
 * Returns the log file that the logger is currently using.
 *
 * @return The log file that the logger is currently using.
 */
- (id<RBLogFile>)currentLogFile;

/**
 * Returns the singleton instance.
 *
 * @return The singleton instance.
 */
+ (RBLogger *) sharedLogger;

@end
