//
//  SHHashComputer.m
//  hash
//
//  Created by Елена Чугреева on 09.06.12.
//  Copyright (c) 2012 e.chugreeva@gmail.com. All rights reserved.
//

#import "SHHashComputer.h"

NSString * const gotFilePathNotification = @"gotFilePath";
NSString * const gotResultNotification = @"gotResultOfType";

@implementation SHHashComputer {
    NSString *_hashType;
}

@synthesize path,operation;

- (id)init
{
    self = [super init];
    if (self) {
        _hashType = @"Unimplemented";
    }
    return self;
}

- (void)gotPath:(NSURL*)newPath {
    
    self.path = newPath;
    
    if (self.operation)
        [self.operation cancel];
    
    NSInvocationOperation *newOperation =
    [[NSInvocationOperation alloc] initWithTarget:self
                                         selector:@selector(computeAndSendHash)
                                           object:nil];
    
    [[NSOperationQueue mainQueue] addOperation:newOperation];
    self.operation = newOperation;
    
        
}

- (NSString*)computeHash {
    
    return [NSString stringWithFormat:@"unimplemented hash for file %@", self.path];
}

- (void)computeAndSendHash {
    
    NSString *result = [self computeHash];
    NSString *notificationName = [NSString stringWithFormat:@"%@%@",
                                  gotResultNotification,
                                  _hashType];
    [[NSNotificationCenter defaultCenter] postNotificationName:notificationName
                                                        object:result];
    self.operation = nil;
    
}

- (NSString*)hashType {
    return _hashType;
}

@end
