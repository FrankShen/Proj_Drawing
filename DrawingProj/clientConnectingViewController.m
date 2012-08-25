//
//  clientConnectingViewController.m
//  DrawingProj
//
//  Created by BuG.BS on 12-8-23.
//  Copyright (c) 2012年 BuG.BS. All rights reserved.
//

#import "clientConnectingViewController.h"

@interface clientConnectingViewController ()<GlobalVariableDelegate>

@end

@implementation clientConnectingViewController
@synthesize deviceID;
@synthesize HUD = _HUD;
#pragma mark SystemFunction
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.deviceID.keyboardType = UIKeyboardTypeNumberPad;
    [GlobalVariable getGlobalVariable].clientConnectingDelegate = self;
    [GlobalVariable getGlobalVariable].userType = USER_TYPE_CLIENT;
}

- (void)viewDidUnload
{
    [self setDeviceID:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight || interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}

#pragma mark IBAction
- (IBAction)backButtonPressed:(id)sender
{
    [self performSegueWithIdentifier:@"clientBackToMain" sender:self];
}

- (IBAction)connectButtonPressed:(id)sender
{
    NSLog(@"Connecting!");
    self.HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.HUD];
    
    self.HUD.delegate = self;
    self.HUD.labelText = @"连接中";
    
    [self.HUD show:YES];
    dispatch_queue_t connectQueue = dispatch_queue_create("Client Conntect", NULL);
    dispatch_async(connectQueue, ^{
        [[GlobalVariable getGlobalVariable] connectToDevice:self.deviceID.text];
    });
}

#pragma mark Delegate
- (void)connectToHostSuccessed
{
    self.HUD.mode = MBProgressHUDModeText;
    self.HUD.labelText = @"已连接";
    [self.HUD hide:YES afterDelay:1];
}

- (void)connectToHostFailed
{
    [self.HUD hide:YES];
    NSLog(@"hide");
}

- (void)hudWasHidden:(MBProgressHUD *)hud
{
    int stat = [GlobalVariable getGlobalVariable].networkStat;
    if (stat == NETWORK_STAT_CONNECT){
        NSLog(@"已连接");
        
        //... Write some code
        
        [hud removeFromSuperview];
        hud = nil;
        
    } else if (stat == NETWORK_STAT_ERROR){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"无法连接" message:@"请检查设备号以及网络状态" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        [hud removeFromSuperview];
        hud = nil;
        [alert show];
    }

}

- (void)alertViewCancel:(UIAlertView *)alertView
{
    [alertView removeFromSuperview];
    alertView = nil;
}

@end
