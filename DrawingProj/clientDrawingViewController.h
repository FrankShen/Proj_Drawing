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
#import "ImageLibraryTableView.h"
#import "ImageLibraryCell.h"
@interface clientDrawingViewController : UIViewController<ClientDrawingGestureDelegate,GlobalVariableDelegate>
@property (weak, nonatomic) IBOutlet clientDrawingGestureView *gestureView;
@property (weak, nonatomic) UIPopoverController *popOver;

@property (nonatomic,weak) IBOutlet UIButton *markerButton;
@property (nonatomic,weak) IBOutlet UIButton *brushButton;
@property (nonatomic,weak) IBOutlet UIButton *eraserButton;
@property (weak, nonatomic) IBOutlet UIButton *undoButton;
@property (weak, nonatomic) IBOutlet ImageLibraryTableView *imageTableView;

@end
