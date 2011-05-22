//
//  RBBugReporter.m
//  StatCollector
//
//  Created by Robert Brown on 4/29/11.
//  Copyright 2011 Robert Brown. All rights reserved.
//

#import "RBBugReporter.h"
#import "UIWindow+RBExtras.h"

#if defined(FLURRY)
#import "FlurryAPI.h"
#endif

enum BugReporterAlertButton {
    
    kBugReportActionCancel = 0,
    kBugReportActionReport,
};

// ???: Should I set the UINavigationControllerDelegate so I can watch the view controller pops?
// This could prevent memory leaks when the mail composser is force popped externally.
// I should also keep the previous delegate around, if any, so that it can still receive messages.


@interface RBBugReporter ()

/**
 * Sets up default values for all initializers.
 */
- (void) initDefaults;

/**
 * Convenience method for generating a string from an error.
 *
 * @param error The error to generate a string from.
 */
+ (NSString *)stringWithError:(NSError *)error;

/**
 * Convenience method that generates a string of device stats.
 */
+ (NSString *)deviceInfoString;

@end


@implementation RBBugReporter

@synthesize recipients, subjectLine, commentHeader, errorHeader, deviceHeader; 
@synthesize commentMsg, errMsg, deviceMsg, alertMsg, navController;

- (id) initWithError:(NSError *)error {
    
    if ((self = [super init])) {

        [self setErrMsg:[[self class] stringWithError:error]];
        [self initDefaults];
    }
    
    return self;
}

- (id) initWithErrorMessage:(NSString *)msg {
    
    if ((self = [super init])) {
        
        [self setErrMsg:msg];
        [self initDefaults];
    }
    
    return self;
}

- (void) initDefaults {
    
    // Automatically discovers the nav controller.
    NSAutoreleasePool * pool = [NSAutoreleasePool new];
    UIWindow * keyWindow = [[UIApplication sharedApplication] keyWindow];
    UINavigationController * aNavController = [keyWindow topNavController];
    [self setNavController:aNavController];
    
    // Sets up the defaults for all the strings.
    [self setRecipients:[NSArray arrayWithObject:@"MyEmail@example.com"]];
    [self setSubjectLine:@"Bug Report"];
    [self setCommentHeader:@"[[Comments]]"];
    [self setErrorHeader:@"[[Error]]"];
    [self setDeviceHeader:@"[[Device Info]]"];
    [self setCommentMsg:@"\n\n\n\n\n--------------------\nAdd any additional comments above, such as how to reproduce the bug.\n"];
    [self setDeviceMsg:[[self class] deviceInfoString]];
    [self setAlertMsg:@"A critical error has occurred. Please submit a bug report so that we may better serve you."];
    
    [pool release];
}

+ (NSString *)stringWithError:(NSError *)error {
    
    return [NSString stringWithFormat:
            @"ERROR:\n Description: %@\n Recovery Options:%@\n Recovery Suggestion:%@\n Failure Reason:%@\n Recovery Attempter:%@\n Error Info:%@\n",
            [error localizedDescription], 
            [error localizedRecoveryOptions], 
            [error localizedRecoverySuggestion], 
            [error localizedFailureReason], 
            [error recoveryAttempter], 
            [error userInfo]];
}

+ (NSString *)deviceInfoString {
    
    UIDevice * device = [UIDevice currentDevice];
    NSString * osName = [device systemName];
    NSString * osVersion = [device systemVersion];
    NSString * deviceModel = [device model];
    
    return [NSString stringWithFormat:
            @"OS Name: %@\nOS Version: %@\nModel: %@\n", 
            osName, 
            osVersion, 
            deviceModel];
}

- (void) presentBugAlert {
    
    // The bug reporter must explicitly retain itself to guarantee it will be around.
    [self retain];
    
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"Report Bug" 
                                                         message:[self alertMsg]
                                                        delegate:self 
                                               cancelButtonTitle:@"Cancel" 
                                               otherButtonTitles:@"Report", nil];
    [alertView setDelegate:self];
    [alertView show];
    [alertView release];
}

- (void) presentBugReportComposer {
    
    // The bug reporter must explicitly retain itself to guarantee it will be around.
    [self retain];
    
    // Checks if the device is set up to send email.
    NSAutoreleasePool * pool = [NSAutoreleasePool new];
    if (![MFMailComposeViewController canSendMail]) {
        [[self class] presentAlertWithTitle:@"Can't Send Email"
                                    message:@"Your device is not set up for sending email. Please set up an email account in the Setttings app."];
        [pool release];
        return;
    }
    
    // Sets up the mail composer.
    MFMailComposeViewController * mailComposer = [MFMailComposeViewController new];
    [mailComposer setMailComposeDelegate:self];
    [mailComposer setSubject:[self subjectLine]];
    [mailComposer setToRecipients:[self recipients]];
    
    // Generates the body of the email.
    NSString * commentSection = [NSString stringWithFormat:@"%@\n%@\n", [self commentHeader], [self commentMsg]];
    NSString * errorSection = [NSString stringWithFormat:@"%@\n%@\n", [self errorHeader], [self errMsg]];
    NSString * deviceInfoSection = [NSString stringWithFormat:@"%@\n%@\n", [self deviceHeader], [self deviceMsg]];
    
    [mailComposer setMessageBody:[NSString stringWithFormat:@"%@\n%@\n%@\n", commentSection, errorSection, deviceInfoSection] 
                          isHTML:NO];
    
    // Shows the bug report email.
    [[self navController] presentModalViewController:mailComposer animated:YES];
    [mailComposer release];
    [pool release];
}

+ (void) presentAlertWithTitle:(NSString *)title message:(NSString *)message {
	UIAlertView * alert = [[UIAlertView alloc] initWithTitle:title 
													 message:message 
													delegate:nil 
										   cancelButtonTitle:@"OK" 
										   otherButtonTitles:nil];
	[alert show];
	[alert release];
}

+ (void) logError:(NSError *)error {
	
    NSLog(@"%@", [self stringWithError:error]);
}


#pragma mark - Flurry methods

+ (void)sendFlurryReportWithTitle:(NSString *)title message:(NSString *)msg error:(NSError *)error {
    
#if defined(FLURRY) && !defined(DEBUG)
    [FlurryAPI logError:title
                message:msg
                  error:error];
#endif
}

+ (void)sendFlurryReportWithTitle:(NSString *)title message:(NSString *)msg exception:(NSException *)exception {
    
#if defined(FLURRY) && !defined(DEBUG)
    [FlurryAPI logError:title
                message:msg 
              exception:exception];
#endif
}

+ (void)sendFlurryReportWithError:(NSError *)error {
    
#if defined(FLURRY) && !defined(DEBUG)
    [self sendFlurryReportWithTitle:@"Error"
                            message:[self stringWithError:error]
                              error:error];
#endif
}

+ (void)logFlurryEvent:(NSString *)event {
    
#if defined(FLURRY) && !defined(DEBUG)
    [FlurryAPI logEvent:event];
#endif
}


#pragma mark - UIAlertViewDelegate methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (buttonIndex) {
            
        case kBugReportActionCancel:
            // Do nothing.
            break;
            
        case kBugReportActionReport:
            [self presentBugReportComposer];
            break;
            
        default:
            break;
    }
    
    // This is the release associated with the retain in presentBugAlert.
    [self release];
}


#pragma mark -
#pragma mark MFMailComposeViewControllerDelegate methods

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
	
	[[self navController] dismissModalViewControllerAnimated:YES];
    
    // This is the release associated with the retain in presentBugReportComposer.
    [self release];
}


#pragma mark - Memory Management

- (void)dealloc {
    [recipients release];
    [subjectLine release];
    [commentHeader release];
    [errorHeader release];
    [deviceHeader release];
    [commentMsg release];
    [errMsg release];
    [deviceMsg release];
    [alertMsg release];
    [navController release];
    [super dealloc];
}


@end
