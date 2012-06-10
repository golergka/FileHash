//
//  SHHashResultViewController.m
//  hash
//
//  Created by Елена Чугреева on 09.06.12.
//  Copyright (c) 2012 e.chugreeva@gmail.com. All rights reserved.
//

#import "SHHashResultViewController.h"

@interface SHHashResultViewController () {
    NSString *_hashType;
}

@end

@implementation SHHashResultViewController

@synthesize clipboardButton;
@synthesize textField;
@synthesize progressIndicator;
@synthesize label;

@synthesize result;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self loadView];
        // subscribe to notification about new path
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(gotPath:)
                                                     name:gotFilePathNotification
                                                   object:nil];
        [self.progressIndicator setHidden:YES];
        [self.clipboardButton setEnabled:NO];
    }
    
    return self;
}

- (id)initWithHashType:(NSString *)hashType {
    
    self = [self initWithNibName:@"SHHashResultView" bundle:[NSBundle mainBundle]];
    if (self) {
        [self setHashType:hashType];
    }
    
    return self;
}

- (void)setHashType:(NSString *)hashType {
    
    [self.label setStringValue:[NSString stringWithFormat:@"%@:", hashType]];
    
    _hashType = hashType;
    NSString *notificationName = [NSString stringWithFormat:@"%@%@",
                                  gotResultNotification,
                                  _hashType];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(gotResult:)
                                                 name:notificationName
                                               object:nil];
}

- (void)gotPath:(NSNotification *)newPathNotification {
    
    [self.textField setStringValue:@""];
    [self.progressIndicator startAnimation:self];
    [self.progressIndicator setHidden:NO];
    [self.clipboardButton setEnabled:NO];
    
}

- (void)gotResult:(NSNotification *)newResultNotification {
    
    id newResult = [newResultNotification object];
    
    if (newResult == nil)
        [NSException raise:@"No object"
                    format:@"Expected object with notification!"];
    else if (![newResult isKindOfClass:[NSString class]])
        [NSException raise:@"Not NSString"
                    format:@"Expected NSString object!"];
    else
        self.result = (NSString*) newResult;
    
    [self.textField setStringValue:self.result];
    [self.progressIndicator stopAnimation:self];
    [self.progressIndicator setHidden:YES];
    [self.clipboardButton setEnabled:YES];
    
}

- (IBAction)copyToClipboard:(id)sender {
    
    NSPasteboard *pasteBoard = [NSPasteboard generalPasteboard];
    [pasteBoard declareTypes:[NSArray arrayWithObjects:NSStringPboardType, nil] owner:nil];
    [pasteBoard setString: self.result forType:NSStringPboardType];
    
}
@end