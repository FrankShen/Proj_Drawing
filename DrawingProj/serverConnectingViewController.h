//
//  serverConnectingViewController.h
//  DrawingProj
//
//  Created by BuG.BS on 12-8-23.
//  Copyright (c) 2012年 BuG.BS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalVariable.h"
#import "MBProgressHUD/MBProgressHUD.h"
@interface serverConnectingViewController : UIViewController<MBProgressHUDDelegate, UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *deviceID;
@property (nonatomic, strong) MBProgressHUD *HUD;
@end
