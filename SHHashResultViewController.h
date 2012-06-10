//
//  SHHashResultViewController.h
//  hash
//
//  Created by Елена Чугреева on 09.06.12.
//  Copyright (c) 2012 e.chugreeva@gmail.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SHHashComputer.h"

@interface SHHashResultViewController : NSViewController

@property (weak) IBOutlet NSButton *clipboardButton;
@property (weak) IBOutlet NSTextField *textField;
@property (weak) IBOutlet NSProgressIndicator *progressIndicator;
@property (weak) IBOutlet NSTextField *label;

@property (copy) NSString *result;

- (IBAction)copyToClipboard:(id)sender;

- (id)initWithHashType:(NSString*)hashType;

- (void)setHashType:(NSString*)hashType;
- (void)gotPath;
- (void)gotResult:(NSNotification*)newResultNotification;

@end
