//
//  ServerDrawingViewController.h
//  DrawingProj
//
//  Created by BuG.BS on 12-8-26.
//  Copyright (c) 2012年 BuG.BS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalVariable.h"
#import "serverDrawingGestureView.h"
#import "ImageLibraryTableView.h"
#import "ImageLibraryCell.h"
@interface ServerDrawingViewController : UIViewController<GlobalVariableDelegate>
@property (weak, nonatomic) IBOutlet serverDrawingGestureView *gestureView;

@property (nonatomic,weak) IBOutlet UIButton *markerButton;
@property (nonatomic,weak) IBOutlet UIButton *brushButton;
@property (nonatomic,weak) IBOutlet UIButton *eraserButton;
@property (weak, nonatomic) IBOutlet UIButton *undoButton;
@property (weak, nonatomic) IBOutlet ImageLibraryTableView *imageTableView;

@end
