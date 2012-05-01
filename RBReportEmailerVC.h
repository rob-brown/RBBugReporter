//
//  RBReportEmailerVC.h
//
//  Created by Robert Brown on 8/6/11.
//  Copyright 2011 Robert Brown. All rights reserved.
//

#import <TargetConditionals.h>


// iOS-specific class
#if TARGET_OS_IPHONE

#import <MessageUI/MFMailComposeViewController.h>
#import <UIKit/UIKit.h>


@protocol RBEmailBuilder;

@interface RBReportEmailerVC : MFMailComposeViewController <MFMailComposeViewControllerDelegate, UINavigationControllerDelegate>

- (id)initWithEmailBuilder:(id<RBEmailBuilder>)builder;

@end

#endif
