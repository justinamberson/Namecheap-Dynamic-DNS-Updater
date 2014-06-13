//
//  JADNSUpdater.m
//  DNSUpdater
//
//  Created by Justin Amberson on 6/6/14.
//  Copyright (c) 2014 Justin Amberson. All rights reserved.
//

#import "JADNSUpdater.h"
#import "XMLReader.h"
@interface JADNSUpdater ()
@property (nonatomic,copy) NSString *ip;
@end


@implementation JADNSUpdater

-(void)updateDNSWithDomain:(NSString *)domain host:(NSString *)host ip:(NSString *)ip pw:(NSString *)pw {
    
    NSString *urlString = [NSString stringWithFormat:@"http://dynamicdns.park-your-domain.com/update?host=%@&domain=%@&password=%@&ip=%@",host,domain,pw,ip];
    self.ip = ip;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
    NSLog(@"Starting connection");
    [connection start];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    NSError *error = nil;
    NSDictionary *dict = [XMLReader dictionaryForXMLData:data error:&error];
    if (!error) {
        NSLog(@"%@",dict);
        NSDictionary *responses = [dict objectForKey:@"interface-response"];
        NSLog(@"Keys: %@",responses.allKeys);
        NSDictionary *errorDict = [responses objectForKey:@"errors"];
        if (errorDict) {
            NSLog(@"Errors: %@",errorDict);
            for (NSString *key in errorDict.allKeys) {
                NSDictionary *errorReport = [errorDict objectForKey:key];
                NSString *message = [errorReport objectForKey:@"text"];
                if ([self.delegate respondsToSelector:@selector(dns:updateFailedWithMessage:)]) {
                    [self.delegate dns:self updateFailedWithMessage:message];
                    return;
                }
                
            }
        }
    } else {
        if ([self.delegate respondsToSelector:@selector(dns:updateFailedWithMessage:)]) {
            [self.delegate dns:self updateFailedWithMessage:error.localizedDescription];
        }
        return;

    }
    if ([self.delegate respondsToSelector:@selector(dns:didUpdateDNSWithIP:)]) {
        [self.delegate dns:self didUpdateDNSWithIP:self.ip];
    
    }
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Error: %@",error.localizedDescription);
    if ([self.delegate respondsToSelector:@selector(dns:updateFailedWithMessage:)]) {
        [self.delegate dns:self updateFailedWithMessage:error.localizedDescription];
    }
}

@end
