//
//  serverDrawingGestureView.h
//  DrawingProj
//
//  Created by BuG.BS on 12-8-27.
//  Copyright (c) 2012年 BuG.BS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrawingPadView.h"
@interface serverDrawingGestureView : UIView
@property (nonatomic,weak) IBOutlet DrawingPadView *drawingPadView;
- (void)pan:(UIPanGestureRecognizer *)gesture;
@end
