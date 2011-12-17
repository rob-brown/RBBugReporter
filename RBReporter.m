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

#import <dispatch/dispatch.h>

#import "RBReporter.h"
#import "RBLogger.h"
#import "RBAttachment.h"
#import "UIApplication+RBExtras.h"
#import "NSString+RBExtras.h"
#import "RBReportEmailerVC.h"

#if defined(FLURRY)
#import "FlurryAPI.h"
#endif

@implementation RBReporter

+ (void) presentBugReportComposerWithBuilder:(id<RBEmailBuilder>)builder inNavController:(UINavigationController *)navController {
    
    // First checks if emails can be sent.
    if (![RBReportEmailerVC canSendMail]) {
        [self presentAlertWithTitle:@"Can't Send Email"
                            message:@"Your device is not set up for sending email. Please set up an email account in the Setttings app."];
        return;
    }
    
    RBReportEmailerVC * emailer = [[RBReportEmailerVC alloc] initWithEmailBuilder:builder];
    
    // Infers the nav controller if it's not specified.
    if (!navController)
        navController = [UIApplication topNavController];
    
    [navController presentModalViewController:emailer animated:YES];
}

+ (void) presentBugReportComposerWithBuilder:(id<RBEmailBuilder>)builder {
    [self presentBugReportComposerWithBuilder:builder inNavController:nil];
}

+ (void) presentAlertWithTitle:(NSString *)title message:(NSString *)message {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:title 
                                                         message:message 
                                                        delegate:nil 
                                               cancelButtonTitle:@"OK" 
                                               otherButtonTitles:nil];
        [alert show];
    });
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

+ (void)logDebugMessage:(NSString *)msg {
#if DEBUG
    [self logMessage:msg];
#endif
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

@end
