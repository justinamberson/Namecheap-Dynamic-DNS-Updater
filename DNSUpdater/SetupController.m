//
//  SetupController.m
//  DNSUpdater
//
//  Created by Justin Amberson on 6/7/14.
//  Copyright (c) 2014 Justin Amberson. All rights reserved.
//

#import "SetupController.h"

@interface SetupController ()
@property (copy, nonatomic) void (^completionHandler)(NSURLCredential *credential);

@end

@implementation SetupController

- (id)init
{
    return [self initWithWindowNibName:@"SetupController" owner:self];
}


- (void)showWindowWithCompletionHandler:(void (^)())completionHandler
{
    [self showWindow:nil];
    self.completionHandler = completionHandler;
}


- (void)windowDidLoad
{
    [super windowDidLoad];
    NSString *hostName = [[NSUserDefaults standardUserDefaults]stringForKey:@"NamecheapDynDNSHost"];
    NSString *domainName = [[NSUserDefaults standardUserDefaults]stringForKey:@"NamecheapDynDNSDomain"];
    NSString *credential = [[NSUserDefaults standardUserDefaults]stringForKey:@"NamecheapDynDNSPassword"];
    NSInteger interval = [[NSUserDefaults standardUserDefaults]integerForKey:@"NamecheapDynDNSUpdateInterval"];
    if (credential) {
        self.passwordTextField.stringValue = credential;
    }
    if (hostName) {
        self.hostTextField.stringValue = hostName;
    }
    if (domainName) {
        self.domainTextField.stringValue = domainName;
    }
    self.intervalTextField.stringValue = [NSString stringWithFormat:@"%li",(long)interval];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

-(IBAction)saveButtonClicked:(id)sender {
    if (self.intervalTextField.stringValue.intValue <= 0) {
        NSAlert *alert = [NSAlert alertWithMessageText:@"Invalid Update Interval" defaultButton:@"Dismiss" alternateButton:nil otherButton:nil informativeTextWithFormat:@"Please specify a new value, in minutes, to update the DNS entry."];
        [alert runModal];
        return;
        
    }
    if (self.passwordTextField.stringValue.length == 0) {
        NSAlert *alert = [NSAlert alertWithMessageText:@"Invalid Password" defaultButton:@"Dismiss" alternateButton:nil otherButton:nil informativeTextWithFormat:@"Please enter a valid password."];
        [alert runModal];
        return;
    }
    if (self.hostTextField.stringValue.length == 0) {
        NSAlert *alert = [NSAlert alertWithMessageText:@"Invalid Host" defaultButton:@"Dismiss" alternateButton:nil otherButton:nil informativeTextWithFormat:@"Please enter a valid hostname."];
        [alert runModal];
        return;
    }
    if (self.domainTextField.stringValue.length == 0) {
        NSAlert *alert = [NSAlert alertWithMessageText:@"Invalid Domain" defaultButton:@"Dismiss" alternateButton:nil otherButton:nil informativeTextWithFormat:@"Please enter a valid domain name."];
        [alert runModal];
        return;
    }
    if (self.passwordTextField.stringValue.length > 0) {
        
        [[NSUserDefaults standardUserDefaults]setObject:self.domainTextField.stringValue forKey:@"NamecheapDynDNSDomain"];
        [[NSUserDefaults standardUserDefaults]setObject:self.hostTextField.stringValue forKey:@"NamecheapDynDNSHost"];
        [[NSUserDefaults standardUserDefaults]setObject:self.passwordTextField.stringValue forKey:@"NamecheapDynDNSPassword"];
        [[NSUserDefaults standardUserDefaults]setInteger:self.intervalTextField.intValue forKey:@"NamecheapDynDNSUpdateInterval"];
        self.completionHandler(nil);
        self.currentIPLabel.stringValue = @"";
        
    } 
    
    [self close];
}

@end
