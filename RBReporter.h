//
// RBReporter.h
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
#import <TargetConditionals.h>

#import "RBEmailBuilder.h"


// iOS-specific imports. 
#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#endif


/**
 * A class for generating reports, logging errors, etc. Includes support for 
 * Flurry. The bug reporter comes with many defaults which can be overriden as
 * necessary through various accessor methods.
 *
 * @todo Turn off NSLog when not debugging.
 */
@interface RBReporter : NSObject

// -----------------------------------------------------------------------------
// Reporting/Logging Methods
// -----------------------------------------------------------------------------

#if TARGET_OS_IPHONE

/**
 * Generates and presents the email composer modally. This is 3.0 compatible.
 * To support earlier versions, a different technique will need to be used.
 *
 * @param builder The email builder to use to generate the email report.
 * @param navController The navigation controller to present the email reporter 
 * in. Pass nil and RBReporter will attempt to discover which navigation 
 * controller the emailer should be presented in. 
 */
+ (void)presentBugReportComposerWithBuilder:(id<RBEmailBuilder>)builder inNavController:(UINavigationController *)navController;

/**
 * A convenience method to +presentBugReportComposerWithBuilder:inNavController: 
 * if you don't want to specify a navigation controller.
 *
 * @param builder The email builder to use to generate the email report.
 */
+ (void)presentBugReportComposerWithBuilder:(id<RBEmailBuilder>)builder;

#endif

/**
 * Presents a simple alert view with only a cancel button with no actions. Used
 * for presenting information or error messages to the user where no action is
 * required.
 *
 * @param name The title of the alert view.
 * @param message The message body of the alert view.
 */
+ (void)presentAlertWithTitle:(NSString *)title message:(NSString *)message;

/**
 * Convenient error logger given an NSError.
 *
 * @param error The error to log.
 */
+ (void)logError:(NSError *)error;

/**
 * Convenient exception logger given an NSException.
 *
 * @param exception The exception to log.
 */
+ (void)logException:(NSException *)exception;

/**
 * Convenient message logger.
 *
 * @param msg The message to log.
 */
+ (void)logMessage:(NSString *)msg;

/**
 * Like +logMessage: except it only logs the message if DEBUG is defined.
 *
 * @param msg The message to log.
 */
+ (void)logDebugMessage:(NSString *)msg;

// -----------------------------------------------------------------------------
// Flurry Methods
// -----------------------------------------------------------------------------
//
// These should only be used if Flurry is included. Users of this class should 
// define FLURRY in the project settings, otherwise these methods are no-ops. 
// These messages also become no-ops if DEBUG is defined. This wrapper 
// around Flurry makes it convenient to use Flurry without mixing debug sessions
// with regular user sessions.
//
// -----------------------------------------------------------------------------

/**
 * Convenience method. Simply calls sendFlurryReportWithTitle:message:error: 
 * with some default values.
 *
 * @param error The error to use to generate the Flurry error log.
 */
+ (void)sendFlurryReportWithError:(NSError *)error;

/**
 * Logs an error with Flurry. 
 *
 * @param title The title of the error log.
 * @param msg A message to go with the log.
 * @param error The error being logged.
 */
+ (void)sendFlurryReportWithTitle:(NSString *)title message:(NSString *)msg error:(NSError *)error;

/**
 * Logs an exception with Flurry. 
 *
 * @param title The title of the exception log.
 * @param msg A message to go with the log.
 * @param exception The exception being logged.
 */
+ (void)sendFlurryReportWithTitle:(NSString *)title message:(NSString *)msg exception:(NSException *)exception;

/**
 * Logs an event with Flurry.
 *
 * @param event The event to log.
 */
+ (void)logFlurryEvent:(NSString *)event;

@end
