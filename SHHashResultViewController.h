//
//  SHHashResultViewController.h
//  hash
//
//  Created by Елена Чугреева on 09.06.12.
//  Copyright (c) 2012 e.chugreeva@gmail.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SHHashComputer.h"

typedef enum {
    
    NoFile,
    InProgress,
    Cancelled,
    Paused,
    Ready,
    
} SHHashResultState;

@interface SHHashResultViewController : NSViewController

@property (weak) IBOutlet NSButton *clipboardButton;
@property (weak) IBOutlet NSTextField *textField;
@property (weak) IBOutlet NSProgressIndicator *progressIndicator;
@property (weak) IBOutlet NSTextField *label;

@property SHHashResultState state;
@property (copy) NSString *result;

- (IBAction)copyToClipboard:(id)sender;

- (id)initWithHashType:(NSString*)hashType;

- (void)gotPath;
- (void)progress:(NSNotification*)progressNotification;
- (void)gotResult:(NSNotification*)newResultNotification;

@end
