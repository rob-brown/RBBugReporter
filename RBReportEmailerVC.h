//
//  RBReportEmailerVC.h
//
//  Created by Robert Brown on 8/6/11.
//  Copyright 2011 Robert Brown. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>

@protocol RBEmailBuilder;

@interface RBReportEmailerVC : MFMailComposeViewController <MFMailComposeViewControllerDelegate, UINavigationControllerDelegate>

- (id)initWithEmailBuilder:(id<RBEmailBuilder>)builder;

@end
