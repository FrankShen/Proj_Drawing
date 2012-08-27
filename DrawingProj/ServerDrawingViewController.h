//
//  ServerDrawingViewController.h
//  DrawingProj
//
//  Created by BuG.BS on 12-8-26.
//  Copyright (c) 2012年 BuG.BS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "serverDrawingGestureView.h"
#import "serverDrawingToolboxView.h"
@interface ServerDrawingViewController : UIViewController
@property (weak, nonatomic) IBOutlet serverDrawingGestureView *gestureView;
@property (weak, nonatomic) IBOutlet serverDrawingToolboxView *toolboxView;


@end
