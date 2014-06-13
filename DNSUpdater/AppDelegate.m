//
//  AppDelegate.m
//  DNSUpdater
//
//  Created by Justin Amberson on 6/6/14.
//  Copyright (c) 2014 Justin Amberson. All rights reserved.
//

#import "AppDelegate.h"
#import "JADNSUpdateEngine.h"
#import "SetupController.h"
@interface AppDelegate ()
@property (nonatomic,strong) SetupController *setup;
@property (nonatomic,assign) BOOL hasBotheredUserOnce;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    self.hasBotheredUserOnce = NO;
    NSInteger interval = [[NSUserDefaults standardUserDefaults] integerForKey:@"NamecheapDynDNSUpdateInterval"];
    if (interval == 0) {
        interval = 60;
        [[NSUserDefaults standardUserDefaults]setInteger:interval forKey:@"NamecheapDynDNSUpdateInterval"];
    }
    _statusItem = [[NSStatusBar systemStatusBar]statusItemWithLength:NSVariableStatusItemLength];
    _statusItem.highlightMode = YES;
    _statusItem.image = [NSImage imageNamed:@"Globe.png"];
    _statusItem.alternateImage = [NSImage imageNamed:@"GlobeAlt.png"];
    [self setupMenu];

    
    [self updateDNS];
    
    
}

-(void)updaterEngine:(JADNSUpdateEngine *)engine updatedDNSWithIP:(NSString *)newIP {
    NSUserNotification *note = [[NSUserNotification alloc] init];
    note.deliveryDate = [NSDate date];
    note.title = @"Dynamic DNS Info Updated";
    note.informativeText = [NSString stringWithFormat:@"Host updated with new IP %@",newIP];
    note.hasActionButton = YES;
    note.actionButtonTitle = @"Dismiss";
    [[NSUserNotificationCenter defaultUserNotificationCenter]scheduleNotification:note];
    self.hasBotheredUserOnce = NO;
    _statusItem.image = [NSImage imageNamed:@"Globe.png"];
}

-(void)updaterEngine:(JADNSUpdateEngine *)engine receivedError:(NSString *)errorMessage {
    self.hasBotheredUserOnce = YES;
    NSUserNotification *note = [[NSUserNotification alloc]init];
    _statusItem.image = [NSImage imageNamed:@"GlobeError.png"];
    note.title = @"DNS Update Error";
    note.hasActionButton = YES;
    note.actionButtonTitle = @"Dismiss";
    note.informativeText = errorMessage;
    note.deliveryDate = [NSDate date];
    [[NSUserNotificationCenter defaultUserNotificationCenter]scheduleNotification:note];
    self.setup.currentIPLabel.stringValue = errorMessage;
    if (self.updateTimer) {
        [self.updateTimer invalidate];
    }
    [self openSetup];
}

-(void)updaterEngineReportingGoodConnection:(JADNSUpdateEngine *)engine {
    if (!self.hasBotheredUserOnce) {
        _statusItem.image = [NSImage imageNamed:@"Globe.png"];
    }
}

-(void)updateDNS {
    if (!_updateEngine) {
        self.updateEngine = [[JADNSUpdateEngine alloc]init];
        self.updateEngine.delegate = self;
        
    }
    NSString *domain = [[NSUserDefaults standardUserDefaults]objectForKey:@"NamecheapDynDNSDomain"];
    NSString *host = [[NSUserDefaults standardUserDefaults]objectForKey:@"NamecheapDynDNSHost"];
    NSString *password = [[NSUserDefaults standardUserDefaults]objectForKey:@"NamecheapDynDNSPassword"];
    self.updateEngine.password = password;
    if (self.hasBotheredUserOnce) {
        return;
    }
    if (self.updateEngine.password.length < 1) {
        [self openSetup];
        self.hasBotheredUserOnce = YES;
        _statusItem.image = [NSImage imageNamed:@"GlobeError.png"];
    } else {

        
        [[NSApplication sharedApplication] activateIgnoringOtherApps:YES];
        self.updateEngine.domain = domain;
        self.updateEngine.host = host;
        [self.updateEngine runFullUpdate];
        NSInteger interval = [[NSUserDefaults standardUserDefaults]integerForKey:@"NamecheapDynDNSUpdateInterval"];
        if (self.updateTimer) {
            [self.updateTimer invalidate];
        }
        self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:(interval * 60) target:self selector:@selector(updateDNS) userInfo:nil repeats:YES];
    
    }
    
}

-(void)setupMenu {
    NSMenu *menu = [[NSMenu alloc] init];
    [menu addItemWithTitle:@"Setup" action:@selector(openSetup) keyEquivalent:@""];
    [menu addItemWithTitle:@"Refresh" action:@selector(updateDNS) keyEquivalent:@""];
    [menu addItem:[NSMenuItem separatorItem]];
    [menu addItemWithTitle:@"Quit Updater" action:@selector(terminate) keyEquivalent:@""];
    self.statusItem.menu = menu;

}

-(void)openSetup {
    if (!_setup) {
        self.setup = [[SetupController alloc]init];
    }
    [self.setup showWindowWithCompletionHandler:^ {
        self.hasBotheredUserOnce = NO;
        self.updateEngine.needsDNSUpdate = YES;
        [self performSelector:@selector(updateDNS) withObject:nil afterDelay:1.0];
    }];
    
}


- (void)terminate
{
    [[NSApplication sharedApplication] terminate:self.statusItem.menu];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}



@end
