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
@synthesize localLAN = _localLAN;
@synthesize userType = _userType;
@synthesize networkStat = _networkStat;
@synthesize isOverlay = _isOverlay;
@synthesize isAutoShow = _isAutoShow;
@synthesize clientConnectingDelegate = _clientConnectingDelegate;
@synthesize serverConnectingDelegate = _serverConnectingDelegate;
- (GCDAsyncSocket *)selfSocket
{
    if (!_selfSocket)
        _selfSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    return _selfSocket;
}

- (NSMutableDictionary *)socketPool{
    if (!_socketPool)
        _socketPool = [[NSMutableDictionary alloc] init];
    return _socketPool;
}

- (NSMutableDictionary *)dataPool{
    if (!_dataPool)
        _dataPool = [[NSMutableDictionary alloc] init];
    return _dataPool;
}

- (NSMutableDictionary *)dataLengthPool{
    if (!_dataLengthPool)
        _dataLengthPool = [[NSMutableDictionary alloc] init];
    return _dataLengthPool;
}

- (GlobalVariable *)init
{
    self = [super init];
    self.localAddress = [GlobalVariable getLocalAddress:@"en"];
    NSArray *temp = [self.localAddress componentsSeparatedByString:@"."];
    self.localLAN = [NSString stringWithFormat:@"%@.%@.%@.", [temp objectAtIndex:0], [temp objectAtIndex:1], [temp objectAtIndex:2]];
    self.deviceID = [temp objectAtIndex:3];
    NSLog(@"%@", self.localLAN);
    NSLog(@"%@", self.deviceID);

    self.isOverlay = YES;
    self.isAutoShow = NO;
    
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

+ (GlobalVariable *)getGlobalVariable
{
    return ((DPAppDelegate *)[[UIApplication sharedApplication] delegate]).globalVairable;
}

- (void)connectToDevice:(NSString *)device
{
    sleep(1);
    NSError *err = nil;
    [self.selfSocket disconnect];
    self.networkStat = NETWORK_STAT_NORMAL;
    [self.socketPool removeAllObjects];
    [self.dataPool removeAllObjects];
    if([self.selfSocket connectToHost:[NSString stringWithFormat:@"%@%@", self.localLAN, device] onPort:1992 withTimeout:1.5 error:&err]){
        dispatch_queue_t statQueue = dispatch_queue_create("Stat Queue", NULL);
        dispatch_async(statQueue, ^{
            sleep(2.5);
            if (self.networkStat != NETWORK_STAT_CONNECT){
                self.networkStat = NETWORK_STAT_ERROR;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.clientConnectingDelegate connectToHostFailed];
                });
            }
        });
    } else {
        self.networkStat = NETWORK_STAT_ERROR;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.clientConnectingDelegate connectToHostFailed];
        });
    }
    
}

- (void)createNewMeeting
{
    sleep(1);
    NSError *err = nil;
    [self.selfSocket disconnect];
    self.networkStat = NETWORK_STAT_NORMAL;
    [self.socketPool removeAllObjects];
    [self.dataPool removeAllObjects];
    if ([self.selfSocket acceptOnPort:1992 error:&err]){
        
        self.networkStat = NETWORK_STAT_CONNECT;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.serverConnectingDelegate createPortSuccessed];
        });
        
    } else {
        self.networkStat = NETWORK_STAT_ERROR;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.serverConnectingDelegate createPortFailed];
        });
    }
}

#pragma mark Delegate

- (void)socket:(GCDAsyncSocket *)sock didAcceptNewSocket:(GCDAsyncSocket *)newSocket
{
    [self.socketPool setObject:newSocket forKey:newSocket.connectedHost];
    [newSocket readDataWithTimeout:-1 tag:INCOMING_SIGNAL];
}

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    self.networkStat = NETWORK_STAT_CONNECT;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.clientConnectingDelegate connectToHostSuccessed];
    });
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    if (tag == INCOMING_SIGNAL){
        NSString *recieveStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        if ([recieveStr isEqualToString:@"PREPARE_FOR_IMAGE"]){
            [sock readDataWithTimeout:-1 tag:PREPARE_FOR_IMAGE];
        } else if ([recieveStr isEqualToString:@"PREPARE_FOR_PULL"]){
            self.imageToSend = [self.serverDrawingDelegate grabImage];
            
            [sock writeData:[[NSString stringWithFormat:@"%d", UIImagePNGRepresentation(self.imageToSend).length] dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:PREPARE_FOR_PULL];
            [sock writeData:UIImagePNGRepresentation(self.imageToSend) withTimeout:-0 tag:IMAGE_PULLING];
            [sock readDataWithTimeout:-1 tag:INCOMING_SIGNAL];
        }
    } else if (tag == PREPARE_FOR_IMAGE){
        NSString *recieveStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        [self.dataPool setObject:[[NSMutableData alloc] init] forKey:sock.connectedHost];
        [self.dataLengthPool setObject:[NSNumber numberWithInt:[recieveStr intValue]] forKey:sock.connectedHost];
        [sock readDataWithTimeout:-1 tag:IMAGE_SENDING];
    } else if (tag == IMAGE_SENDING){
        [((NSMutableData *)[self.dataPool objectForKey:sock.connectedHost]) appendData:data];
        if (((NSMutableData *)[self.dataPool objectForKey:sock.connectedHost]).length < [[self.dataLengthPool objectForKey:sock.connectedHost] intValue]){
            NSLog(@"%d, %d", ((NSMutableData *)[self.dataPool objectForKey:sock.connectedHost]).length, [[self.dataLengthPool objectForKey:sock.connectedHost] intValue]);
            [sock readDataWithTimeout:-1 tag:IMAGE_SENDING];
        }else {
            NSLog(@"%d, %d", ((NSMutableData *)[self.dataPool objectForKey:sock.connectedHost]).length, [[self.dataLengthPool objectForKey:sock.connectedHost] intValue]);
            [self.serverDrawingDelegate recievedImage:[UIImage imageWithData:[self.dataPool objectForKey:sock.connectedHost]]];
            [sock writeData:nil withTimeout:-1 tag:SEND_SUCCESS];
            [sock readDataWithTimeout:-1 tag:INCOMING_SIGNAL];
        }
    } else if (tag == SEND_SUCCESS){
        NSLog(@"send Ok");
    } else if (tag == PREPARE_FOR_PULL){
        self.clientData = [[NSMutableData alloc] init];
        NSString *recieveStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        self.clientLength = [recieveStr intValue];
        [self.selfSocket readDataWithTimeout:-1 tag:IMAGE_PULLING];
    } else if (tag == IMAGE_PULLING){
        [self.clientData appendData:data];
        if (self.clientData.length < self.clientLength){
            NSLog(@"%d,%d", self.clientData.length, self.clientLength);
            [self.selfSocket readDataWithTimeout:-1 tag:IMAGE_PULLING];
        } else {
            NSLog(@"%d,%d", self.clientData.length, self.clientLength);
            [self.clientDrawingDelegate recievedImage:[UIImage imageWithData:self.clientData]];
        }
    }
}

@end
