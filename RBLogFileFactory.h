//
//  RBLogFileFactory.h
//  StatCollector
//
//  Created by Robert Brown on 5/26/11.
//  Copyright 2011 Robert Brown. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RBLogFile.h"


/**
 * Creates all of the log files for RBLogger. -newLogFileWithPath: should be 
 * changed to use the log file of choice for the application. 
 */
@interface RBLogFileFactory : NSObject

/**
 * Returns an RBLogFile that has been implicitly retained by the caller.
 *
 * @param path The path of the log file.
 */
- (id<RBLogFile>)newLogFileWithPath:(NSString *)path;

/**
 * Returns the shared instance.
 */
+ (RBLogFileFactory *)sharedFactory;

@end
