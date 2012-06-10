//
//  SHHashComputerContainer.h
//  hash
//
//  Created by Елена Чугреева on 10.06.12.
//  Copyright (c) 2012 e.chugreeva@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHHashComputerContainer : NSObject

@property (strong) NSMutableSet *hashComputers;

- (NSSet*) hashTypes;
- (void)gotPath:(NSURL*)path;

@end
