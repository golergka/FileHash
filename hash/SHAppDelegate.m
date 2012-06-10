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

static const int resultViewHeight = 30;
static const int resultViewVerticalIndentation = 5;

@implementation SHAppDelegate

@synthesize window = _window;
@synthesize resultsView = _resultView;
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
    
    int resultViews = 0;
    
    for(NSString *hashType in hashTypes) {
        
        // create and init view controller
        SHHashResultViewController *resultViewController =
        [[SHHashResultViewController alloc] initWithHashType:hashType];
        
        // add controller to controller array
        [resultViewControllers addObject:resultViewController];
        
        // add view
        NSView *newView = resultViewController.view;
        [self.resultsView addSubview:newView];
        
        // set constraints
        
        // set width to be equal
        [self.resultsView addConstraint:
         [NSLayoutConstraint constraintWithItem:newView 
                                      attribute:NSLayoutAttributeWidth
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self.resultsView
                                      attribute:NSLayoutAttributeWidth
                                     multiplier:1
                                       constant:0 ]];
        
        // set height to constant
        [self.resultsView addConstraint:
         [NSLayoutConstraint constraintWithItem:newView 
                                      attribute:NSLayoutAttributeHeight
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self.resultsView
                                      attribute:NSLayoutAttributeHeight
                                     multiplier:0
                                       constant:resultViewHeight ]];
        
        // set left to be equal
        [self.resultsView addConstraint:
         [NSLayoutConstraint constraintWithItem:newView
                                      attribute:NSLayoutAttributeLeft
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self.resultsView
                                      attribute:NSLayoutAttributeLeft
                                     multiplier:1
                                       constant:0 ]];
        
        // set top to equal + (const width) * (amounf ot previous items) + vertical indentation
        [self.resultsView addConstraint:
         [NSLayoutConstraint constraintWithItem:newView
                                      attribute:NSLayoutAttributeTop
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self.resultsView
                                      attribute:NSLayoutAttributeTop
                                     multiplier:1
                                       constant:(resultViews*resultViewHeight)+resultViewVerticalIndentation ]];
        
        // increasing count of created result views
        resultViews++;
        
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

        // we get the path and send it to the model
        NSURL *newPath = [[dialog URLs] objectAtIndex:0];
        [computerContainer gotPath:newPath];
        
        // set file name for label
        [fileName setStringValue:
         [[NSFileManager defaultManager] displayNameAtPath:[newPath path]]
         ];
        
        // set file path for label
        [filePath setStringValue:
         [[newPath URLByDeletingLastPathComponent] path]
         ];
        
        // get file attributes
        NSDictionary *newFileAttributes =
        [[NSFileManager defaultManager]
         attributesOfItemAtPath:[newPath path] error:nil];
        
        // set file size for label
        NSNumber *newFileSize = [newFileAttributes objectForKey:NSFileSize];
        [fileSize setStringValue:[self stringFromFileSize:newFileSize]];
        
        // set modified date for label
        NSDate *newFileModified =
        [newFileAttributes objectForKey:NSFileModificationDate];
        [fileModified setStringValue:[NSString stringWithFormat:@"%@",
                                      newFileModified]];
        
        // set file icon
        NSSize iconSize = fileIcon.frame.size;
        NSImage *newFileIcon = [NSImage imageWithPreviewOfFileAtPath:[newPath path] ofSize:iconSize asIcon:YES];
        [fileIcon setImage:newFileIcon];
        
        // send gotPath message to all result view controllers
        
        for (SHHashResultViewController *resultViewController in resultViewControllers)
            [resultViewController gotPath];
        
    }
    
}
@end
