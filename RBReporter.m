//
// RBReporter.m
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

#import "RBReporter.h"
#import "RBLogger.h"
#import "RBAttachment.h"
#import "UIWindow+RBExtras.h"
#import "NSString+RBExtras.h"

#if defined(FLURRY)
#import "FlurryAPI.h"
#endif

static NSString * const kReportActionCancel = @"Cancel";
static NSString * const kReportActionReport = @"Report";

// ???: Should I set the UINavigationControllerDelegate so I can watch the view controller pops?
// This could prevent memory leaks when the mail composser is force popped externally.
// I should also keep the previous delegate around, if any, so that it can still receive messages.


@implementation RBReporter

@synthesize alertMsg, navController, emailBuilder;

- (id) init {
    
    if ((self = [super init])) {
        
        // Automatically discovers the nav controller.
        NSAutoreleasePool * pool = [NSAutoreleasePool new];
        UIWindow * keyWindow = [[UIApplication sharedApplication] keyWindow];
        UINavigationController * aNavController = [keyWindow topNavController];
        [self setNavController:aNavController];
        
        // Sets up the defaults for all the strings.
        [self setAlertMsg:@"A critical error has occurred. Please submit a bug report so that we may better serve you."];
        
        [pool release];
    }
    
    return self;
}

- (void) presentBugAlertWithBuilder:(id<RBEmailBuilder>)builder {
    
    // The bug reporter must explicitly retain itself to guarantee it will be around.
    [self retain];
    
    // Grabs the builder so it can be used in the email composer.
    [self setEmailBuilder:builder];
    
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"Report Bug" 
                                                         message:[self alertMsg]
                                                        delegate:self 
                                               cancelButtonTitle:kReportActionCancel 
                                               otherButtonTitles:kReportActionReport, nil];
    [alertView setDelegate:self];
    [alertView show];
    [alertView release];
}

- (void) presentBugReportComposerWithBuilder:(id<RBEmailBuilder>)builder {
    
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
    [mailComposer setSubject:[builder subjectLine]];
    [mailComposer setToRecipients:[builder recipients]];
    [mailComposer setMessageBody:[builder emailMessage]
                          isHTML:[builder isHTML]];
    
    // Adds all of the attachments, if any. 
    NSArray * attachments = [builder attachments];
    
    for (id<RBAttachment> attachment in attachments) {
        [mailComposer addAttachmentData:[attachment data]
                               mimeType:[attachment MIMEType]
                               fileName:[attachment fileName]];
    }
    
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


#pragma mark - Logging methods

+ (void)logError:(NSError *)error {
	
    NSLog(@"%@", [NSString stringWithError:error]);
    [[RBLogger sharedLogger] logError:error];
}

+ (void)logException:(NSException *)exception {
    
    NSLog(@"%@", [NSString stringWithException:exception]);
    [[RBLogger sharedLogger] logException:exception];
}

+ (void)logMessage:(NSString *)msg {

    NSLog(@"%@", msg);
    [[RBLogger sharedLogger] logMessage:msg];
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
                            message:[NSString stringWithError:error]
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
    
    NSString * buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
    
    if ([buttonTitle isEqualToString:kReportActionCancel]) {
        // Do Nothing.
    }
    else if ([buttonTitle isEqualToString:kReportActionReport]) {
        [self presentBugReportComposerWithBuilder:[self emailBuilder]];
    }
    
    // This is the release associated with the retain in presentBugAlert.
    [self release];
}


#pragma mark - MFMailComposeViewControllerDelegate methods

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
	
	[[self navController] dismissModalViewControllerAnimated:YES];
    
    // This is the release associated with the retain in presentBugReportComposer.
    [self release];
}


#pragma mark - Memory Management

- (void)dealloc {
    [alertMsg release];
    [navController release];
    [emailBuilder release];
    [super dealloc];
}


@end
