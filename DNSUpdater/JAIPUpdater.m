//
//  JAIPUpdater.m
//  DNSUpdater
//
//  Created by Justin Amberson on 6/6/14.
//  Copyright (c) 2014 Justin Amberson. All rights reserved.
//

#import "JAIPUpdater.h"
@interface JAIPUpdater ()
@property (nonatomic, copy) NSString *mostRecentIP;
@end

@implementation JAIPUpdater

-(void)forceUpdate {
    self.mostRecentIP = [[NSUserDefaults standardUserDefaults]objectForKey:@"JAIPUpdaterMostRecentIP"];
    
    NSURL *ipURL = [NSURL URLWithString:@"http://icanhazip.com"];
    NSURLRequest *req = [NSURLRequest requestWithURL:ipURL];
    NSURLConnection *conn = [NSURLConnection connectionWithRequest:req delegate:self];
    [conn start];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Detected Error trying to connect: %@",error.localizedDescription);
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    NSString *dataStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    if (dataStr) {
        NSString *noNewLine = [dataStr stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        self.currentIP = noNewLine;
        if ([self.delegate respondsToSelector:@selector(ipUpdater:didUpdateIP:)]) {
                [self.delegate ipUpdater:self didUpdateIP:self.currentIP];
        }
    
    }
    NSLog(@"My IP: %@",self.currentIP);
}

@end
