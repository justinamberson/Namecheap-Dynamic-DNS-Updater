//
//  JAIPUpdater.h
//  DNSUpdater
//
//  Created by Justin Amberson on 6/6/14.
//  Copyright (c) 2014 Justin Amberson. All rights reserved.
//

#import <Foundation/Foundation.h>
@class JAIPUpdater;

@protocol JAIPUpdaterDelegate <NSObject>
-(void)ipUpdater:(JAIPUpdater *)updater didUpdateIP:(NSString *)ip;
@end

@interface JAIPUpdater : NSObject <NSURLConnectionDataDelegate>
-(void)forceUpdate;
@property (nonatomic,strong) NSString *currentIP;
@property (nonatomic,weak) id <JAIPUpdaterDelegate> delegate;
@end
