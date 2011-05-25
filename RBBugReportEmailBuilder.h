//
//  RBBugReportEmailBuilder.h
//  StatCollector
//
//  Created by Robert Brown on 5/24/11.
//  Copyright 2011 Robert Brown. All rights reserved.
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
