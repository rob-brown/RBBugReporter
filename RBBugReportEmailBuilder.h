//
// RBBugReportEmailBuilder.h
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

#import "RBBaseEmailBuilder.h"

@interface RBBugReportEmailBuilder : RBBaseEmailBuilder

/**
 * Part of the bug report email message. This string is shown just before the 
 * commentMsg.
 */
@property (nonatomic, copy) NSString * commentHeader;

/**
 * Part of the bug report email message. This string is shown just before the 
 * errorMsg.
 */
@property (nonatomic, copy) NSString * errorHeader;

/**
 * Part of the bug report email message. This string is shown just before the 
 * deviceMsg.
 */
@property (nonatomic, copy) NSString * deviceHeader;

/**
 * Part of the bug report email message. This string is to give instructions how 
 * the user is to provide feedback.
 */
@property (nonatomic, copy) NSString * commentMsg;

/**
 * Part of the bug report email message. This string is to provide error 
 * details.
 */
@property (nonatomic, copy) NSString * errMsg;

/**
 * Part of the bug report email message. This string provides details on the 
 * device the user is using.
 */
@property (nonatomic, copy) NSString * deviceMsg;


/**
 * Creates a bug report email from the given error.
 *
 * @param error The error to generate the bug report from.
 */
- (id) initWithError:(NSError *)error;

/**
 * Creates a bug report email from the given string.
 *
 * @param msg The error message to use with the bug report.
 */
- (id) initWithErrorMessage:(NSString *)msg;

@end
