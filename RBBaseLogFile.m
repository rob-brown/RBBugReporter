//
//  RBBaseLogFile.m
//  StatCollector
//
//  Created by Robert Brown on 6/2/11.
//  Copyright 2011 Robert Brown. All rights reserved.
//

#import "RBBaseLogFile.h"


@interface RBBaseLogFile ()

/**
 * A string representing the path to the underlying file.
 */
@property (nonatomic, copy) NSString * filePath;

@end


@implementation RBBaseLogFile

@synthesize filePath;

- (id)initWithFilePath:(NSString *)path {
    
    if ((self = [super init])) {
        [self setFilePath:path];
    }
    
    return self;
}

- (BOOL)write:(NSString *)text {
    return [self write:text error:NULL];
}

- (BOOL)write:(NSString *)text error:(NSError **)error {
    
    NSData * data = [text dataUsingEncoding:NSUTF8StringEncoding];
    NSOutputStream * outFile = [NSOutputStream outputStreamToFileAtPath:[self filePath] 
                                                                 append:YES];
    [outFile open];
    [outFile write:[data bytes] maxLength:[data length]];
    [outFile close];
    
    return YES;
}

- (BOOL)underlyingFileExists {
    
    return [[NSFileManager defaultManager] fileExistsAtPath:[self filePath]];
}

- (void)dealloc {
    [filePath release];
    [super dealloc];
}

@end
