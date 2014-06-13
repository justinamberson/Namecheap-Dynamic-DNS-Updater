//
//  JADNSUpdateEngine.h
//  DNSUpdater
//
//  Created by Justin Amberson on 6/6/14.
//  Copyright (c) 2014 Justin Amberson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JAIPUpdater.h"
#import "JADNSUpdater.h"
@class JADNSUpdateEngine;
@protocol JADNSUpdaterEngine <NSObject>

-(void)updaterEngine:(JADNSUpdateEngine *)engine receivedError:(NSString *)errorMessage;
-(void)updaterEngine:(JADNSUpdateEngine *)engine updatedDNSWithIP:(NSString *)newIP;
-(void)updaterEngineReportingGoodConnection:(JADNSUpdateEngine *)engine;

@end

@interface JADNSUpdateEngine : NSObject <JADNSUpdaterDelegate,JAIPUpdaterDelegate>
@property (nonatomic,strong) NSString *host;
@property (nonatomic,strong) NSString *ip;
@property (nonatomic,strong) NSString *domain;
@property (nonatomic,strong) NSString *password;
@property (nonatomic,copy) NSString *currentIP;
@property (nonatomic,assign) BOOL needsDNSUpdate;
@property (nonatomic,weak) id <JADNSUpdaterEngine> delegate;
@property (nonatomic,strong) JAIPUpdater *ipUpdater;
@property (nonatomic,strong) JADNSUpdater *dnsUpdater;
-(void)runFullUpdate;
-(void)runDNSUpdate;

@end
