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
NSString * const progressNotification = @"progressOfType";

static NSOperationQueue *_operationQueue;

@implementation SHHashComputer

@synthesize path,operation,result,progress;

+ (NSOperationQueue*)operationQueue {
    
    if(_operationQueue == nil)
        _operationQueue = [NSOperationQueue new];
    return _operationQueue;
    
}

- (void)gotPath:(NSURL*)newPath {
    
    self.path = newPath;
    
    if (self.operation)
        [self.operation cancel];
    
    NSInvocationOperation *newOperation = [NSInvocationOperation alloc];
    newOperation = [newOperation initWithTarget:self
                                       selector:@selector(computeAndSendHash)
                                         object:newOperation];
    
    [[SHHashComputer operationQueue] addOperation:newOperation];
    self.operation = newOperation;
    
        
}

- (void)cancel {
    
    if (self.operation != nil)
        [self.operation cancel];
    
}

// that's where actual computation will take place in children
- (NSString*)computeHash {
    
    [NSThread sleepForTimeInterval:3];
    return [NSString stringWithFormat:@"unimplemented hash for file %@", self.path];
}

- (void)computeAndSendHash {
    
    self.result = [self computeHash];
    
    if (![self.operation isCancelled]) {
        
        NSString *notificationName = [NSString stringWithFormat:@"%@%@",
                                      gotResultNotification,
                                      self.hashType];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:notificationName
                                                            object:self];
        self.operation = nil;
        
    }
    
}

// override in children with correct type like @"MD5" or @"SHA-1"
- (NSString*)hashType {
    return @"unimplemented";
}

@end
