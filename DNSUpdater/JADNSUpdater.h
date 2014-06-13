//
//  JADNSUpdater.h
//  DNSUpdater
//
//  Created by Justin Amberson on 6/6/14.
//  Copyright (c) 2014 Justin Amberson. All rights reserved.
//

#import <Foundation/Foundation.h>
@class JADNSUpdater;
@protocol JADNSUpdaterDelegate <NSObject>
-(void)dns:(JADNSUpdater *)updater didUpdateDNSWithIP:(NSString *)newIP;
-(void)dns:(JADNSUpdater *)updater updateFailedWithMessage:(NSString *)message;
@end

@interface JADNSUpdater : NSObject <NSURLConnectionDataDelegate>


@property (nonatomic,weak) id <JADNSUpdaterDelegate> delegate;
-(void)updateDNSWithDomain:(NSString *)domain host:(NSString *)host ip:(NSString *)ip pw:(NSString *)pw;
@end
