//
//  clientDrawingToolboxView.h
//  DrawingProj
//
//  Created by BuG.BS on 12-8-28.
//  Copyright (c) 2012年 BuG.BS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface clientDrawingToolboxView : UIView

@property (nonatomic,weak) IBOutlet UIButton *markerButton;
@property (nonatomic,weak) IBOutlet UIButton *brushButton;
@property (nonatomic,weak) IBOutlet UIButton *eraserButton;
@property (weak, nonatomic) IBOutlet UIButton *undoButton;

@end
