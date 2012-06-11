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

- (void)gotPath {
    
    [self.textField setStringValue:@""];
    [self.progressIndicator startAnimation:self];
    [self.progressIndicator setHidden:NO];
    [self.clipboardButton setEnabled:NO];
    
}

- (void)gotResult:(NSNotification *)newResultNotification {
    
    id computer = [newResultNotification object];
    
    if (computer == nil)
        [NSException raise:@"No object"
                    format:@"Expected object with notification!"];
    else if (![computer isKindOfClass:[SHHashComputer class]])
        [NSException raise:@"Not SHHashComputer"
                    format:@"Expected SHHashComputer object!"];
    else
        self.result = [((SHHashComputer*) computer) result];
    
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
