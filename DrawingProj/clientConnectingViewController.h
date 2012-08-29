//
//  clientConnectingViewController.h
//  DrawingProj
//
//  Created by BuG.BS on 12-8-23.
//  Copyright (c) 2012年 BuG.BS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalVariable.h"
#import "MBProgressHUD/MBProgressHUD.h"
#import "DPViewController.h"

@interface clientConnectingViewController : UIViewController <UITextFieldDelegate, MBProgressHUDDelegate, UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *deviceID;
@property (strong, nonatomic) MBProgressHUD *HUD;
@end
