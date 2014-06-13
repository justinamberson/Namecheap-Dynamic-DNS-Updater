//
//  AppDelegate.h
//  DNSUpdater
//
//  Created by Justin Amberson on 6/6/14.
//  Copyright (c) 2014 Justin Amberson. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "JADNSUpdateEngine.h"

@interface AppDelegate : NSObject <NSApplicationDelegate,NSURLConnectionDataDelegate,JADNSUpdaterEngine>

@property (assign) IBOutlet NSWindow *window;
@property (nonatomic,strong) JADNSUpdateEngine *updateEngine;
@property (nonatomic,strong) NSStatusItem *statusItem;
@property (nonatomic,strong) NSTimer *updateTimer;
@end
