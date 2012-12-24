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

- (void)setHashType:(NSString*)hashType;

@end

@implementation SHHashResultViewController

@synthesize clipboardButton;
@synthesize textField;
@synthesize progressIndicator;
@synthesize label;
@synthesize state;

@synthesize result;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        // overall init
        
        [self loadView];
        [self.progressIndicator setUsesThreadedAnimation: YES];
        
        // state init
        
        self.state = NoFile;
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
    
    // registering for notifications
    
    // result notification
    
    NSString *notificationName = [NSString stringWithFormat:@"%@%@",
                                  gotResultNotification,
                                  _hashType];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(gotResult:)
                                                 name:notificationName
                                               object:nil];
    
    // progress notificaion
    
    notificationName = [NSString stringWithFormat:@"%@%@",
                        progressNotification,
                        _hashType];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(progress:)
                                                 name:notificationName
                                               object:nil];
}

- (void)gotPath {
    
    self.state = InProgress;
    [self.textField setHidden:YES];
    [self.progressIndicator startAnimation:self];
    [self.progressIndicator setHidden:NO];
    [self.clipboardButton setStringValue:@"Cancel"];
    
}

SHHashComputer *getComputerFromNotification(NSNotification *notification) {
    
    id computer = [notification object];
    
    if (computer == nil) {
        
        [NSException raise:@"No object"
                    format:@"Expected object with notification!"];
        return nil;
        
    } else if (![computer isKindOfClass:[SHHashComputer class]]) {
      
        [NSException raise:@"Not SHHashComputer"
                    format:@"Expected SHHashComputer object!"];
        return nil;
        
    } else
        return (SHHashComputer *)computer;
}

- (void)progress:(NSNotification *)progressNotification {
    
    SHHashComputer *computer = getComputerFromNotification(progressNotification);
    
    if (computer == nil)
        return;
    
    [self.progressIndicator setDoubleValue:computer.progress];
    
}

- (void)gotResult:(NSNotification *)newResultNotification {
    
    self.state = Ready;
    
    SHHashComputer *computer = getComputerFromNotification(newResultNotification);
    
    if (computer == nil)
        return;
    
    self.result = [getComputerFromNotification(newResultNotification) result];
    
    [self.textField setStringValue:self.result];
    [self.textField setHidden:NO];
    [self.progressIndicator stopAnimation:self];
    [self.progressIndicator setHidden:YES];
    [self.clipboardButton setStringValue:@"Copy"];
    [self.clipboardButton setEnabled:YES];
    
}

- (IBAction)copyToClipboard:(id)sender {
    
    NSPasteboard *pasteBoard = [NSPasteboard generalPasteboard];
    [pasteBoard declareTypes:[NSArray arrayWithObjects:NSStringPboardType, nil] owner:nil];
    [pasteBoard setString: self.result forType:NSStringPboardType];
    
}
@end
