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
#import "serverDrawingSettingTableViewController.h"
#include <ifaddrs.h>
#include <arpa/inet.h>

#define USER_TYPE_SERVER 0
#define USER_TYPE_CLIENT 1
#define NETWORK_STAT_NORMAL 0
#define NETWORK_STAT_ERROR 1
#define NETWORK_STAT_CONNECT 2

#define INCOMING_SIGNAL 1000
#define PREPARE_FOR_IMAGE 1001
#define IMAGE_SENDING 1002
#define SEND_SUCCESS 1003

#define PREPARE_FOR_PULL 1004
#define IMAGE_PULLING 1005
#define PULL_SUCCESS 1006

@protocol GlobalVariableDelegate <NSObject>

- (void)connectToHostSuccessed;
- (void)connectToHostFailed;
- (void)createPortSuccessed;
- (void)createPortFailed;

- (void)recievedImage:(UIImage *)image;

- (UIImage *)grabImage;

@end

@interface GlobalVariable : NSObject <GCDAsyncSocketDelegate>

@property (nonatomic, strong) GCDAsyncSocket *selfSocket;
@property (nonatomic, strong) NSString *localAddress;
@property (nonatomic, strong) NSString *localLAN;
@property (nonatomic, strong) NSString *deviceID;
@property (nonatomic, strong) NSMutableDictionary *socketPool;
@property (nonatomic, strong) NSMutableDictionary *dataPool;
@property (nonatomic, strong) NSMutableDictionary *dataLengthPool;
@property (nonatomic) int userType;
@property (nonatomic) int networkStat;
@property (nonatomic) BOOL isOverlay;
@property (nonatomic) BOOL isAutoShow;
@property (nonatomic) int clientLength;
@property (nonatomic, strong) NSMutableData *clientData;
@property (nonatomic, strong) UIImage *imageToSend;
@property (nonatomic,weak) id tempDelegate;

@property (nonatomic, weak) id<GlobalVariableDelegate> clientConnectingDelegate;
@property (nonatomic, weak) id<GlobalVariableDelegate> serverConnectingDelegate;
@property (nonatomic, weak) id<GlobalVariableDelegate> clientDrawingDelegate;
@property (nonatomic, weak) id<GlobalVariableDelegate> serverDrawingDelegate;

+ (NSString *) getLocalAddress:(NSString*) interface;
+ (GlobalVariable *)getGlobalVariable;
- (void)connectToDevice:(NSString *)device;
- (void)createNewMeeting;
@end
