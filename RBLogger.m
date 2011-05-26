//
// RBLogger.m
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

#import "RBLogger.h"
#import "RBExtendedLogFile.h"
#import "NSString+RBExtras.h"


@interface RBLogger ()

@property (nonatomic, assign) dispatch_queue_t loggerQueue;

@property (nonatomic, retain) RBExtendedLogFile * currentLogFile;

/**
 * Private initializer.
 *
 * @return self;
 */
- (id) initialize;

@end


/// The singleton instance.
static RBLogger * sharedLogger = nil;

@implementation RBLogger

@synthesize loggerQueue, currentLogFile;

- (void)logError:(NSError *)error {
    
    [self logMessage:[NSString stringWithError:error]];
}

- (void)logException:(NSException *)exeption {
    
    // TODO: Create exception string and pass to -logMessage:.
    
}

- (void)logMessage:(NSString *)msg {
    
    // Uses some GCD magic to serialize the requests and to avoid holding up the calling thread.
    dispatch_async([self loggerQueue], ^{
        
        // Writes to the log file.
        [[self currentLogFile] write:msg];
    });
}

- (RBExtendedLogFile *)logFileForDate:(NSDate *)date {
    
    // Try to find the log file for a given date. If exists, then return it.
    
    
    return nil;
}

- (RBExtendedLogFile *)currentLogFile {
    
    // If no log file, create one.
    
    
    // If log file is out of date, release it and create a new one.
    
    
    // NOTE: Use the factory to create log files.
    
    return nil;
}


#pragma mark - Singleton methods

+ (RBLogger *) sharedLogger {
    
    if (!sharedLogger) {
        
        sharedLogger = [[super allocWithZone:nil] initialize];
    }
    
    return sharedLogger;
}

- (id) initialize {
    
    if ((self = [super init])) {
        
        [self setLoggerQueue:dispatch_queue_create("com.robertbrown.RBLoggerQueue", NULL)];
    }
    
    return self;
}

+ (id) allocWithZone:(NSZone *)zone {
    
    // The retain is needed to satisfy the static analyzer.
    return [[self sharedLogger] retain];
}

- (id) copyWithZone:(NSZone *)zone {
    return self;
}

- (id) init {
    return self;
}

- (id) retain {
    return self;
}

- (void) release {
    // Do nothing.
}

- (id) autorelease {
    return self;
}

- (NSUInteger) retainCount {
    return NSUIntegerMax;
}

@end
