//
//  GlobalVariable.h
//  DrawingProj
//
//  Created by BuG.BS on 12-8-21.
//  Copyright (c) 2012年 BuG.BS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DPAppDelegate.h"
#import "GCDAsyncSocket/GCDAsyncSocket.h"
#include <ifaddrs.h>
#include <arpa/inet.h>
@interface GlobalVariable : NSObject <GCDAsyncSocketDelegate>
@property (nonatomic, strong) GCDAsyncSocket *selfSocket;
@property (nonatomic, strong) NSString *localAddress;
@property (nonatomic, strong) NSArray *socketPool;
@property (nonatomic, strong) NSArray *dataPool;

+ (NSString *) getLocalAddress:(NSString*) interface;

@end
