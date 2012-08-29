//
//  serverDrawingSettingTableViewController.h
//  DrawingProj
//
//  Created by BuG.BS on 12-8-29.
//  Copyright (c) 2012年 BuG.BS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DPAppDelegate.h"
#import "GlobalVariable.h"

@protocol ServerSettingDelegate <NSObject>

- (void)dismissVC;

@end

@interface serverDrawingSettingTableViewController : UITableViewController

@property (nonatomic,weak) id<ServerSettingDelegate> delegate;
@property (weak, nonatomic) IBOutlet UISwitch *overlaySwitch;
@property (weak, nonatomic) IBOutlet UISwitch *autoShowSwitch;
@end
