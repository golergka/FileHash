//
//  SHMD5Computer.m
//  hash
//
//  Created by Елена Чугреева on 10.06.12.
//  Copyright (c) 2012 e.chugreeva@gmail.com. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>

#import "SHMD5Computer.h"

static const int CHUNK_SIZE = 512;
static const double PROGRESS_INCREMENT = 0.01;

@implementation SHMD5Computer

- (NSString*)hashType {
    return @"MD5";
}

- (NSString*)computeHash {
    
    // first, we'll get file size (so we'll be able to send out progress notifications later)
    
    NSDictionary *fileAttributes =
    [[NSFileManager defaultManager] attributesOfItemAtPath:[self.path path]
                                                     error:nil];
    
    NSNumber *fileSize = [fileAttributes objectForKey:NSFileSize];
    NSNumber *progressPartSize =
    [NSNumber numberWithLongLong: (fileSize.longLongValue * PROGRESS_INCREMENT)];
    self.progress = 0;
    
    // now we open the file itself
    
    NSFileHandle *fileHandle =
    [NSFileHandle fileHandleForReadingFromURL:self.path
                                        error:nil];
    
    if ( fileHandle == nil ) return @"Error reading file";
    
    // create the MD5 stuff
    
    CC_MD5_CTX md5;
    CC_MD5_Init(&md5);
    NSNumber *sizeDigested = [NSNumber numberWithInt:0];
    
    // iterate over chunks of data
    
    BOOL done = NO;
    while(!done) {
        
        if ([self.operation isCancelled]) return nil;
        
        @autoreleasepool {
            NSData *fileData = [fileHandle readDataOfLength: CHUNK_SIZE];
            CC_MD5_Update(&md5, [fileData bytes], (int) [fileData length]);
            if ( [fileData length] == 0 ) done = YES;   
        }
        
        // check progress
        
        sizeDigested =
        [NSNumber numberWithLongLong:(sizeDigested.longLongValue + CHUNK_SIZE)];
        
        if ( sizeDigested.longLongValue > progressPartSize.longLongValue ) {
            
            // set progress
            
            self.progress += PROGRESS_INCREMENT;
            
            // send notification
            
            NSString *notificationName = [NSString stringWithFormat:@"%@%@",
                                          progressNotification,
                                          self.hashType];
            [[NSNotificationCenter defaultCenter] postNotificationName:notificationName
                                                                object:self];
            
            // reset progress counter
            
            sizeDigested = [NSNumber numberWithInt:0];
        }
        
    }
    
    // finally compose and return the result
    
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(digest, &md5);

    NSMutableString *result = [[NSMutableString alloc] init];
    for (int i=0; i < CC_MD5_DIGEST_LENGTH; i++ ) {
        [result appendFormat:@"%02x", digest[i]];
    }
    return result;
    
//    return [NSString stringWithFormat: @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
//            digest[0], digest[1], 
//            digest[2], digest[3],
//            digest[4], digest[5],
//            digest[6], digest[7],
//            digest[8], digest[9],
//            digest[10], digest[11],
//            digest[12], digest[13],
//            digest[14], digest[15]];
    
//    NSData *data = [fileHandle availableData];
//    
//    return [data md5];
}

@end
