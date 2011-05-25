//
//  RBEmailBuilder.h
//  StatCollector
//
//  Created by Robert Brown on 5/24/11.
//  Copyright 2011 Robert Brown. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol RBEmailBuilder <NSObject>

- (NSArray *)recipients;

- (NSString *)subjectLine;

- (NSString *)emailMessage;

@end
