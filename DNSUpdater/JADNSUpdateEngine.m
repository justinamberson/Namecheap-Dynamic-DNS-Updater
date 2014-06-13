//
//  JADNSUpdateEngine.m
//  DNSUpdater
//
//  Created by Justin Amberson on 6/6/14.
//  Copyright (c) 2014 Justin Amberson. All rights reserved.
//

#import "JADNSUpdateEngine.h"

@implementation JADNSUpdateEngine

-(void)runFullUpdate {
    if (!self.ipUpdater) {
        self.ipUpdater = [[JAIPUpdater alloc]init];
        self.ipUpdater.delegate = self;
    }
    if (!self.dnsUpdater) {
        self.dnsUpdater = [[JADNSUpdater alloc] init];
        self.dnsUpdater.delegate = self;
    }
    NSLog(@"Running Update");
    
    [self.ipUpdater forceUpdate];
    
    
}

-(void)runDNSUpdate {
    [self.dnsUpdater updateDNSWithDomain:self.domain host:self.host ip:self.currentIP pw:self.password];
}

-(void)dns:(JADNSUpdater *)updater updateFailedWithMessage:(NSString *)message {
    NSLog(@"Failed Updating DNS with Error: %@",message);
    self.needsDNSUpdate = YES;
    [self.delegate updaterEngine:self receivedError:message];

}

-(void)dns:(JADNSUpdater *)updater didUpdateDNSWithIP:(NSString *)newIP {
    NSLog(@"Successfully updated DNS");
    [self.delegate updaterEngine:self updatedDNSWithIP:self.ip];
    self.needsDNSUpdate = NO;
    [[NSUserDefaults standardUserDefaults]setObject:self.currentIP forKey:@"JAIPUpdaterMostRecentIP"];
}

-(void)ipUpdater:(JAIPUpdater *)updater didUpdateIP:(NSString *)ip {
    //The IP address that was just received is different from the one that
    //was currently set in the UserDefaults. Need to tell the delegate that
    //the IP has been updated, so the delegate can acknowledge the change
    NSString *oldIP = [[NSUserDefaults standardUserDefaults]stringForKey:@"JAIPUpdaterMostRecentIP"];
    if (![ip isEqualToString:oldIP] || self.needsDNSUpdate == YES) {
        NSLog(@"Updated IP, now attempting DNS Update");
        self.currentIP = ip;
        self.needsDNSUpdate = YES;
        [self runDNSUpdate];
    } else {
        NSLog(@"Existing IP on record is the same as current.");
    }
}

@end
