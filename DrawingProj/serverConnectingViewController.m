//
//  serverConnectingViewController.m
//  DrawingProj
//
//  Created by BuG.BS on 12-8-23.
//  Copyright (c) 2012年 BuG.BS. All rights reserved.
//

#import "serverConnectingViewController.h"

@interface serverConnectingViewController ()<GlobalVariableDelegate>

@end

@implementation serverConnectingViewController
@synthesize deviceID;
@synthesize HUD = _HUD;
#pragma mark SystemMethod
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
    
    self.deviceID.text = [GlobalVariable getGlobalVariable].deviceID;
    [GlobalVariable getGlobalVariable].serverConnectingDelegate = self;
    [GlobalVariable getGlobalVariable].userType = USER_TYPE_SERVER;
    
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
    [self performSegueWithIdentifier:@"serverBackToMain" sender:self];
}

- (IBAction)createButtonPressed:(id)sender
{
    NSLog(@"Creating!");
    self.HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.HUD];
    
    self.HUD.delegate = self;
    self.HUD.labelText = @"创建中";
    
    [self.HUD show:YES];
    dispatch_queue_t createQueue = dispatch_queue_create("Server Create", NULL);
    dispatch_async(createQueue, ^{
        [[GlobalVariable getGlobalVariable] createNewMeeting];
    });
}

#pragma mark Delegate
- (void)createPortSuccessed
{
    self.HUD.mode = MBProgressHUDModeText;
    self.HUD.labelText = @"已建立";
    [self.HUD hide:YES afterDelay:1];
}

- (void)createPortFailed
{
    [self.HUD hide:YES];
    NSLog(@"hide");
}

- (void)hudWasHidden:(MBProgressHUD *)hud
{
    int stat = [GlobalVariable getGlobalVariable].networkStat;
    if (stat == NETWORK_STAT_CONNECT){
        NSLog(@"已建立");
        
        //... Write some code
        
        [hud removeFromSuperview];
        hud = nil;
        [self performSegueWithIdentifier:@"serverConnectSucess" sender:self];
    } else if (stat == NETWORK_STAT_ERROR){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"无法创建" message:@"请检查设备的网络状态" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"serverConnectSucess"]){
        //[self dismissModalViewControllerAnimated:YES];
    }
}

@end
