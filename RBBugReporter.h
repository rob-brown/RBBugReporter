//
// RBBugReporter.h
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
#import <MessageUI/MFMailComposeViewController.h>

/**
 * A class for generating bug reports, logging errors, etc. Includes support for 
 * Flurry. The bug reporter comes with many defaults which can be overriden as
 * necessary through various accessor methods.
 */
@interface RBBugReporter : NSObject <UIAlertViewDelegate, MFMailComposeViewControllerDelegate, UINavigationControllerDelegate>

// -----------------------------------------------------------------------------
// Customizable Properties
// -----------------------------------------------------------------------------

/**
 * An array of NSStrings that hold the email addresses of all recipients for the
 * bug report email.
 */
@property (nonatomic, retain) NSArray * recipients;

/**
 * The subject line of the bug report email.
 */
@property (nonatomic, copy) NSString * subjectLine;

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
 * The message body of the alert view presented when calling presentBugAlert.
 */
@property (nonatomic, copy) NSString * alertMsg;

/**
 * A navigation controller is necessary to push an email view. setNavController: 
 * may be used to specify the navigation controller if it isn't automatically
 * discovered properly.
 */
@property (nonatomic, retain) UINavigationController * navController;

// -----------------------------------------------------------------------------
// Initializers
// -----------------------------------------------------------------------------

/**
 * Creates a bug report from the given error.
 *
 * @param error The error to generate the bug report from.
 */
- (id) initWithError:(NSError *)error;

/**
 * Creates a bug report from the given string.
 *
 * @param msg The error message to use with the bug report.
 */
- (id) initWithErrorMessage:(NSString *)msg;

// -----------------------------------------------------------------------------
// Reporting/Logging Methods
// -----------------------------------------------------------------------------

/**
 * Presents an alert view which asks the user if they want to report a bug. If 
 * the user wants to report a bug, then an email composer is presented.
 */
- (void) presentBugAlert;

/**
 * Generates and presents the email composer modally. This is 3.0 compatible.
 * To support earlier versions, a different technique will need to be used.
 * This may be accessed directly if you don't want to use -presentBugAlert 
 * before presenting the mail composer.
 */
- (void) presentBugReportComposer;

/**
 * Presents a simple alert view with only a cancel button with no actions. Used
 * for presenting information or error messages to the user where no action is
 * required.
 *
 * @param name The title of the alert view.
 * @param message The message body of the alert view.
 */
+ (void) presentAlertWithTitle:(NSString *)title message:(NSString *)message;

/**
 * Convenient error logger given an NSError.
 *
 * @param error The error to log.
 */
+ (void) logError:(NSError *)error;

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
