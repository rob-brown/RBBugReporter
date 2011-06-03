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
#import "NSString+RBExtras.h"
#import "RBLogFileFactory.h"

/**
 * The standard max age limit, in days, that log files should be kept around.
 */
static const NSUInteger kDefaultLogFileAgeLimit = 7;

/** 
 * Whether or not the logger should purge old log files when the logger is 
 * started. Log files are deemed old when their age in days is greater than 
 * kDefaultLogFileAgeLimit.
 */
static const BOOL kAutoPurgeLogFiles = NO;


@interface RBLogger ()

/// A dispatch queue used for serializing log messages. 
@property (nonatomic, assign) dispatch_queue_t loggerQueue;

/**
 * Private initializer.
 *
 * @return self;
 */
- (id) initialize;

+ (NSString *)logFilePathForDate:(NSDate *)date;

@end


/// The singleton instance.
static RBLogger * sharedLogger = nil;

@implementation RBLogger

@synthesize loggerQueue;

- (void)logError:(NSError *)error {
    [self logMessage:[NSString stringWithError:error]];
}

- (void)logException:(NSException *)exception {
    [self logMessage:[NSString stringWithException:exception]];
}

- (void)logMessage:(NSString *)msg {
    
    // Uses some GCD magic to serialize the requests and to avoid holding up the calling thread.
    dispatch_async([self loggerQueue], ^{
        
        // Writes to the log file.
        [[self currentLogFile] write:msg];
    });
}

+ (id<RBLogFile>)logFileForDate:(NSDate *)date {
    
    // Gets the file path with the given date.
    NSString * filePath = [[self class] logFilePathForDate:date];
    
    return [[[RBLogFileFactory sharedFactory] newLogFileWithPath:filePath] autorelease];
}

- (id<RBLogFile>)currentLogFile {
    
    return [[self class] logFileForDate:[NSDate date]];
}

+ (NSString *)logFilePathForDate:(NSDate *)date {
    
    // Generates the file name.
    NSString * dateTemplate = @"yyyy-MM-dd";
	NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:dateTemplate];
    NSString * formattedDate = [formatter stringFromDate:date];
    [formatter release];
    NSString * fileName = [NSString stringWithFormat:@"LogFile%@.log", formattedDate];
    
    // Generates an array of relative components.
    NSArray * relativeComps = [NSArray arrayWithObjects:@"LogFiles", fileName, nil];
    
    return [NSString pathWithComponentsRelativeToDocumentsDirectory:relativeComps];
}

+ (void)purgeOldLogFiles:(NSUInteger)dayAgeLimit {
    
    // TODO: Implement this.
}


#pragma mark - Singleton methods

+ (RBLogger *) sharedLogger {
    
    @synchronized(self) {
    
        if (!sharedLogger) {
            sharedLogger = [[super allocWithZone:nil] initialize];
        }
    }
    
    return sharedLogger;
}

- (id) initialize {
    
    if ((self = [super init])) {
        [self setLoggerQueue:dispatch_queue_create("com.robertbrown.RBLoggerQueue", NULL)];
        
        // Auto-purges old log files if activated.
        if (kAutoPurgeLogFiles) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [[self class] purgeOldLogFiles:kDefaultLogFileAgeLimit];
            });
        }
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
