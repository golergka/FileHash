//
//  SHHashComputer.h
//  hash
//
//  Created by Елена Чугреева on 09.06.12.
//  Copyright (c) 2012 e.chugreeva@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const gotFilePathNotification;
extern NSString * const gotResultNotification;
extern NSString * const progressNotification;

// used to measure progress of computation

@interface SHHashComputer : NSObject

@property (copy) NSURL *path;
@property (copy) NSString *result;
@property (weak) NSOperation *operation;
@property double progress;

+ (NSOperationQueue*)operationQueue;

- (NSString*)hashType;
- (void)gotPath:(NSURL*)newPath;
- (void)cancel;

// for protected use only

- (NSString*)computeHash; // override it in children
- (void)computeAndSendHash;

@end
