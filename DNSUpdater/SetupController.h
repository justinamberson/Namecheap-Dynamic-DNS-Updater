//
//  SetupController.h
//  DNSUpdater
//
//  Created by Justin Amberson on 6/7/14.
//  Copyright (c) 2014 Justin Amberson. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SetupController : NSWindowController
@property (nonatomic,weak) IBOutlet NSTextField *hostTextField;
@property (nonatomic,weak) IBOutlet NSTextField *domainTextField;
@property (nonatomic,weak) IBOutlet NSSecureTextField *passwordTextField;
@property (nonatomic,weak) IBOutlet NSButton *saveButton;
@property (nonatomic,weak) IBOutlet NSTextField *currentIPLabel;
@property (nonatomic,weak) IBOutlet NSTextField *intervalTextField;
//@property (nonatomic,weak) IBOutlet  *currentIPLabel;
//@property (nonatomic,weak)
-(IBAction)saveButtonClicked:(id)sender;
- (void)showWindowWithCompletionHandler:(void (^)())completionHandler;

@end
