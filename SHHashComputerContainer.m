//
//  SHHashComputerContainer.m
//  hash
//
//  Created by Елена Чугреева on 10.06.12.
//  Copyright (c) 2012 e.chugreeva@gmail.com. All rights reserved.
//

#import "SHHashComputerContainer.h"
#import "SHHashComputer.h"

@implementation SHHashComputerContainer

@synthesize hashComputers;

- (id)init
{
    self = [super init];
    if (self) {
        hashComputers = [NSMutableSet setWithCapacity:1];
        // adding one unimplemented computer as an example
        [hashComputers addObject:[[SHHashComputer alloc] init]]; 
    }
    return self;
}

-(NSSet*)hashTypes {
    
    NSMutableSet *result = [NSMutableSet setWithCapacity:[hashComputers count]];
    
    for(SHHashComputer *hashComputer in hashComputers)
        [result addObject:hashComputer.hashType];
    
    return result;
    
}

-(void)gotPath:(NSURL *)path {
    
    for(SHHashComputer *hashComputer in hashComputers)
        [hashComputer gotPath:path];
    
}

@end
