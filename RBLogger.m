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
#import "NSDate+RBExtras.h"
#import "RBLogFileFactory.h"
#import "RBReporter.h"

/**
 * The standard max age limit, in days, that log files should be kept around.
 */
static const NSUInteger kDefaultLogFileAgeLimit = 30;

/** 
 * Whether or not the logger should purge old log files when the logger is 
 * started. Log files are deemed old when their age in days is greater than 
 * kDefaultLogFileAgeLimit.
 */
static const BOOL kAutoPurgeLogFiles = YES;

/**
 * The template to use for naming log files.
 */
static NSString * const kLogFileDateTemplate = @"yyyy-MM-dd";

/**
 * The extension to use for log files.
 */
static NSString * const kLogFileExtension = @"log";

/**
 * The name of the directory for the log files.
 */
static NSString * const kLogFileDirectoryName = @"LogFiles";


@interface RBLogger ()

/// A dispatch queue used for serializing log messages. 
@property (nonatomic, assign) dispatch_queue_t loggerQueue;

/**
 * Private initializer.
 *
 * @return self;
 */
- (id) initialize;

/**
 * Returns the path of the log file for the given date.
 *
 * @return The path of the log file for the given date.
 */
+ (NSString *)logFilePathForDate:(NSDate *)date;

/**
 * Returns the path to the log file directory.
 *
 * @return The path to the log file directory.
 */
+ (NSString *)logFileDirectory;

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
	NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:kLogFileDateTemplate];
    NSString * formattedDate = [formatter stringFromDate:date];
    [formatter release];
    NSString * fileName = [NSString stringWithFormat:@"LogFile%@.%@", formattedDate, kLogFileExtension];
    
    // Generates an array of path components.
    NSArray * pathComps = [NSArray arrayWithObjects:[self logFileDirectory], fileName, nil];
    
    return [NSString pathWithComponents:pathComps];
}

+ (NSString *)logFileDirectory {
    
    NSArray * relativeComps = [NSArray arrayWithObject:kLogFileDirectoryName];
    
    return [NSString pathWithComponentsRelativeToDocumentsDirectory:relativeComps];
}

+ (void)purgeOldLogFiles:(NSUInteger)dayAgeLimit {
    
    // Gets the log file directory.
    NSString * logDir = [self logFileDirectory];
    NSFileManager * fileManager = [NSFileManager defaultManager];
    
    // Gets all the files in the directory.
    NSError * error = nil;
    NSArray * files = [fileManager contentsOfDirectoryAtPath:logDir error:&error];
    
    if (error) {
        [RBReporter logError:error];
        return;
    }
    
    // Iterates through all of the files and deletes any that are too old.
    for (NSString * file in files) {
        
        NSDictionary * attributes = [fileManager attributesOfItemAtPath:file error:&error];
        
        if (error) {
            [RBReporter logError:error];
            error = nil;
            continue;
        }
        
        NSDate * creationDate = [attributes valueForKey:NSFileCreationDate];
        
        // If the log file is too old, then it is deleted.
        if ([creationDate timeIntervalSinceDate:[NSDate date]] > dayAgeLimit * ONE_DAY && 
            [[file pathExtension] isEqualToString:kLogFileExtension]) {
            
            [fileManager removeItemAtPath:file error:&error];
            
            if (error) {
                [RBReporter logError:error];
                error = nil;
                continue;
            }
        }
    }
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
