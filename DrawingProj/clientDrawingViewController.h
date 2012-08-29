//
//  clientDrawingViewController.h
//  DrawingProj
//
//  Created by BuG.BS on 12-8-28.
//  Copyright (c) 2012年 BuG.BS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "clientDrawingGestureView.h"
#import "clientDrawingToolboxView.h"
#import "GlobalVariable.h"
@interface clientDrawingViewController : UIViewController<ClientDrawingGestureDelegate,GlobalVariableDelegate>
@property (weak, nonatomic) IBOutlet clientDrawingGestureView *gestureView;
@property (weak, nonatomic) IBOutlet clientDrawingToolboxView *toolboxView;
@property (weak, nonatomic) UIPopoverController *popOver;
@end
