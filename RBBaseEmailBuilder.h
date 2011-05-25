//
//  RBBaseEmailBuilder.h
//  StatCollector
//
//  Created by Robert Brown on 5/24/11.
//  Copyright 2011 Robert Brown. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RBEmailBuilder.h"

@interface RBBaseEmailBuilder : NSObject <RBEmailBuilder>

/**
 * An array of NSStrings that hold the email addresses of all recipients for the
 * bug report email.
 */
@property (nonatomic, retain) NSArray * recipients;

/**
 * The subject line of the bug report email.
 */
@property (nonatomic, copy) NSString * subjectLine;

@end
