//
//  clientDrawingSettingTableViewController.h
//  DrawingProj
//
//  Created by BuG.BS on 12-8-28.
//  Copyright (c) 2012年 BuG.BS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DPAppDelegate.h"

@protocol ClientSettingDelegate <NSObject>

- (void)dismissVC;

@end

@interface clientDrawingSettingTableViewController : UITableViewController
@property (nonatomic,weak) id<ClientSettingDelegate> delegate;
@property (weak, nonatomic) IBOutlet UISwitch *overlaySwitch;
@end
