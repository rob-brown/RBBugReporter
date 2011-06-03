//
//  RBBaseLogFile.h
//  StatCollector
//
//  Created by Robert Brown on 6/2/11.
//  Copyright 2011 Robert Brown. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RBLogFile.h"

@interface RBBaseLogFile : NSObject <RBLogFile>

/**
 * Standard initializer. 
 *
 * @param path The file path of the underlying file. The file doesn't need to 
 * exist. It can be created lazily.
 *
 * @return self
 */
- (id)initWithFilePath:(NSString *)path;

/**
 * Returns the path of the log file.
 *
 * @return The path of the log file.
 */
- (NSString *)filePath;

@end
