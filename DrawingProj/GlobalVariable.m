//
//  GlobalVariable.m
//  DrawingProj
//
//  Created by BuG.BS on 12-8-21.
//  Copyright (c) 2012年 BuG.BS. All rights reserved.
//

#import "GlobalVariable.h"

@implementation GlobalVariable
@synthesize selfSocket = _selfSocket;
@synthesize socketPool = _socketPool;
@synthesize dataPool = _dataPool;
@synthesize localAddress = _localAddress;

- (GCDAsyncSocket *)selfSocket
{
    if (!_selfSocket)
        _selfSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    return _selfSocket;
}

- (NSArray *)socketPool{
    if (!_socketPool)
        _socketPool = [[NSArray alloc] init];
    return _socketPool;
}

- (NSArray *)dataPool{
    if (!_dataPool)
        _dataPool = [[NSArray alloc] init];
    return _dataPool;
}

- (GlobalVariable *)init
{
    self = [super init];
    self.localAddress = [GlobalVariable getLocalAddress:@"en"];
    return self;
}

+ (NSString *) getLocalAddress:(NSString*) interface
{
    NSString *address = nil;
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    success = getifaddrs(&interfaces);
    if (success == 0)
    {
        temp_addr = interfaces;
        while(temp_addr != NULL)
        {
            if(temp_addr->ifa_addr->sa_family == AF_INET)
            {
                NSRange range = [[NSString stringWithUTF8String:temp_addr->ifa_name] rangeOfString : interface];
                
                if(range.location != NSNotFound)
                {
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    freeifaddrs(interfaces);
    
    return address;
}

@end
