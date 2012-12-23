//
//  SHSHA1Computer.m
//  hash
//
//  Created by Макс Янков on 23.12.12.
//  Copyright (c) 2012 e.chugreeva@gmail.com. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>
#import "SHSHA1Computer.h"

static const int CHUNK_SIZE = 512;
static const double PROGRESS_INCREMENT = 0.01;

@implementation SHSHA1Computer

- (NSString*)hashType {
    return @"SHA1";
}

- (NSString*)computeHash {
    
    NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:[self.path path] error:nil];
    
    NSNumber *fileSize = [fileAttributes objectForKey:NSFileSize];
    NSNumber *progressPartSize = [NSNumber numberWithLongLong:(fileSize.longLongValue * PROGRESS_INCREMENT)];
    self.progress = 0;
    
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingFromURL:self.path error:nil];
    
    if (fileHandle == nil) return @"Error reading file";
    
    CC_SHA1_CTX sha1;
    CC_SHA1_Init(&sha1);
    NSNumber *sizeDigested = [NSNumber numberWithInt:0];
    
    BOOL done = NO;
    while(!done) {
        
        if([self.operation isCancelled]) return nil;
        
        @autoreleasepool {
            NSData *fileData = [fileHandle readDataOfLength:CHUNK_SIZE];
            CC_SHA1_Update(&sha1, [fileData bytes], (int) [fileData length]);
            if ( [fileData length] == 0 ) done = YES;
        }
        
        sizeDigested = [NSNumber numberWithLongLong:(sizeDigested.longLongValue + CHUNK_SIZE)];
        
        if ( sizeDigested.longLongValue > progressPartSize.longLongValue ) {
            self.progress += PROGRESS_INCREMENT;
            
            NSString *notificationName = [NSString stringWithFormat:@"%@%@", progressNotification, self.hashType];
            [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:self];
            
            sizeDigested = [NSNumber numberWithInt:0];
        }
        
    }
    
    unsigned char digest [CC_SHA1_DIGEST_LENGTH];
    CC_SHA1_Final(digest, &sha1);
    
    NSMutableString *result = [[NSMutableString alloc] init];
    for (int i=0; i < CC_SHA1_DIGEST_LENGTH; i++ ) {
        [result appendFormat:@"%02x", digest[i]];
    }
    return result;
    
}



@end
