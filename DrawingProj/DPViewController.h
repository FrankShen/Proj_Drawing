//
//  DPViewController.h
//  DrawingProj
//
//  Created by BuG.BS on 12-8-20.
//  Copyright (c) 2012年 BuG.BS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DPAppDelegate.h"
#import "GlobalVariable.h"
#import "clientConnectingViewController.h"


@interface DPViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *serverButton;
@property (weak, nonatomic) IBOutlet UIButton *clientButton;
@end
