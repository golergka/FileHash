//
//  SHAppDelegate.m
//  hash
//
//  Created by Елена Чугреева on 08.06.12.
//  Copyright (c) 2012 e.chugreeva@gmail.com. All rights reserved.
//

#import "SHAppDelegate.h"
#import "SHHashResultViewController.h"
#import "SHHashComputerContainer.h"
#import "NSImage+QuickLook.h"
#import <QuickLook/QuickLook.h>

@implementation SHAppDelegate

@synthesize window = _window;
@synthesize resultView = _resultView;
@synthesize fileName;
@synthesize fileSize;
@synthesize filePath;
@synthesize fileModified;
@synthesize fileIcon;

@synthesize resultViewControllers;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    
    computerContainer = [[SHHashComputerContainer alloc] init];
    NSSet *hashTypes = computerContainer.hashTypes;
    resultViewControllers = [NSMutableSet setWithCapacity:[hashTypes count]];
    
    for(NSString *hashType in hashTypes) {
        
        SHHashResultViewController *resultViewController =
        [[SHHashResultViewController alloc] initWithHashType:hashType];
        
        [resultViewControllers addObject:resultViewController];
        
        [self.resultView addSubview:resultViewController.view];
        
    }
    
}

- (NSString *)stringFromFileSize:(NSNumber*)size
{
    unsigned long long theSize = size.unsignedLongLongValue;
	float floatSize = theSize;
    
	if (theSize<1023)
		return([NSString stringWithFormat:@"%i bytes",theSize]);
	floatSize = floatSize / 1024;
	if (floatSize<1023)
		return([NSString stringWithFormat:@"%1.1f KB",floatSize]);
	floatSize = floatSize / 1024;
	if (floatSize<1023)
		return([NSString stringWithFormat:@"%1.1f MB",floatSize]);
	floatSize = floatSize / 1024;
    if (floatSize<1023)
		return([NSString stringWithFormat:@"%1.1f GB",floatSize]);
	floatSize = floatSize / 1024;
    if (floatSize<1023)
		return([NSString stringWithFormat:@"%1.1f TB",floatSize]);
	floatSize = floatSize / 1024;
    
	return([NSString stringWithFormat:@"%1.1f PB",floatSize]);
}

- (IBAction)openFileButtonAction:(id)sender {
    
    NSOpenPanel *dialog = [NSOpenPanel openPanel];

    dialog.canChooseFiles = YES;
    dialog.canCreateDirectories = NO;
    dialog.canChooseDirectories = NO;
    dialog.allowsMultipleSelection = NO;
    
    if ([dialog runModal] == NSFileHandlingPanelOKButton) {
        NSURL *newPath = [[dialog URLs] objectAtIndex:0];
        [computerContainer gotPath:newPath];
        
        [fileName setStringValue:
         [[NSFileManager defaultManager] displayNameAtPath:[newPath path]]
         ];
        
        [filePath setStringValue:
         [[newPath URLByDeletingLastPathComponent] path]
         ];
        
        NSDictionary *newFileAttributes =
        [[NSFileManager defaultManager]
         attributesOfItemAtPath:[newPath path] error:nil];
        
        NSNumber *newFileSize = [newFileAttributes objectForKey:NSFileSize];
        [fileSize setStringValue:[self stringFromFileSize:newFileSize]];
        
        NSDate *newFileModified =
        [newFileAttributes objectForKey:NSFileModificationDate];
        
        [fileModified setStringValue:[NSString stringWithFormat:@"%@",
                                      newFileModified]];
        
        NSSize iconSize = fileIcon.frame.size;
        NSImage *newFileIcon = [NSImage imageWithPreviewOfFileAtPath:[newPath path] ofSize:iconSize asIcon:YES];
        [fileIcon setImage:newFileIcon];
        
    }
    
}
@end
