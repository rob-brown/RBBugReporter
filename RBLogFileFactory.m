//
//  RBLogFileFactory.m
//  StatCollector
//
//  Created by Robert Brown on 5/26/11.
//  Copyright 2011 Robert Brown. All rights reserved.
//

#import "RBLogFileFactory.h"

#import "RBExtendedLogFile.h"

/// The singleton instance.
static RBLogFileFactory * sharedFactory = nil;


@implementation RBLogFileFactory

- (id<RBLogFile>)newLogFileWithPath:(NSString *)path {
    
    return [[RBExtendedLogFile alloc] initWithFilePath:path];
}

#pragma mark - Singleton methods

+ (RBLogFileFactory *)sharedFactory {
    
    if (!sharedFactory) {
        
        sharedFactory = [[super allocWithZone:nil] init];
    }
    
    return sharedFactory;
}

+ (id) allocWithZone:(NSZone *)zone {
    
    // The retain is needed to satisfy the static analyzer.
    return [[self sharedFactory] retain];
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
