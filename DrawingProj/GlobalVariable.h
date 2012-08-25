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

#define USER_TYPE_SERVER 0
#define USER_TYPE_CLIENT 1
#define NETWORK_STAT_NORMAL 0
#define NETWORK_STAT_ERROR 1
#define NETWORK_STAT_CONNECT 2
@protocol GlobalVariableDelegate <NSObject>

- (void)connectToHostSuccessed;
- (void)connectToHostFailed;
- (void)createPortSuccessed;
- (void)createPortFailed;

@end

@interface GlobalVariable : NSObject <GCDAsyncSocketDelegate>

@property (nonatomic, strong) GCDAsyncSocket *selfSocket;
@property (nonatomic, strong) NSString *localAddress;
@property (nonatomic, strong) NSString *localLAN;
@property (nonatomic, strong) NSString *deviceID;
@property (nonatomic, strong) NSMutableDictionary *socketPool;
@property (nonatomic, strong) NSMutableDictionary *dataPool;
@property (nonatomic) int userType;
@property (nonatomic) int networkStat;

@property (nonatomic, weak) id<GlobalVariableDelegate> clientConnectingDelegate;
@property (nonatomic, weak) id<GlobalVariableDelegate> serverConnectingDelegate;

+ (NSString *) getLocalAddress:(NSString*) interface;
+ (GlobalVariable *)getGlobalVariable;
- (void)connectToDevice:(NSString *)device;
- (void)createNewMeeting;
@end
