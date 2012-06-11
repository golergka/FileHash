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

@interface SHHashComputer : NSObject

@property (copy) NSURL *path;
@property (copy) NSString *result;
@property (weak) NSOperation *operation;

+ (NSOperationQueue*)operationQueue;

- (NSString*)hashType;
- (void)gotPath:(NSURL*)newPath;

// for protected use only

- (NSString*)computeHash; // override it in children
- (void)computeAndSendHash;

@end
