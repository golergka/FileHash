//
//  SHAppDelegate.h
//  hash
//
//  Created by Елена Чугреева on 08.06.12.
//  Copyright (c) 2012 e.chugreeva@gmail.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class SHHashComputerContainer;

@interface SHAppDelegate : NSObject <NSApplicationDelegate> {
    SHHashComputerContainer *computerContainer;
}

@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSView *resultsView;

@property (weak) IBOutlet NSTextField *fileName;
@property (weak) IBOutlet NSTextField *fileSize;
@property (weak) IBOutlet NSTextField *filePath;
@property (weak) IBOutlet NSTextField *fileModified;
@property (weak) IBOutlet NSImageView *fileIcon;

@property (strong) NSMutableSet *resultViewControllers;

- (IBAction)openFileButtonAction:(id)sender;

@end
