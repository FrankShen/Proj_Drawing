//
//  clientDrawingToolboxView.h
//  DrawingProj
//
//  Created by BuG.BS on 12-8-28.
//  Copyright (c) 2012年 BuG.BS. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ClientDrawingToolBoxViewDelegate <NSObject>

- (void)swipeLeftFromRightDetect;
- (void)swipeRightFromLeftDetect;

@end

@interface clientDrawingToolboxView : UIView

@property (nonatomic) BOOL isShow;
@property (nonatomic,weak) IBOutlet UIButton *markerButton;
@property (nonatomic,weak) IBOutlet UIButton *brushButton;
@property (nonatomic,weak) IBOutlet UIButton *eraserButton;
@property (weak, nonatomic) IBOutlet UIButton *toolboxButton;
@property (weak, nonatomic) IBOutlet UIButton *undoButton;

@property (weak, nonatomic) id<ClientDrawingToolBoxViewDelegate> delegate;

- (void)swipeOpen:(UISwipeGestureRecognizer *)gesture;
- (void)swipeClose:(UISwipeGestureRecognizer *)gesture;

@end
