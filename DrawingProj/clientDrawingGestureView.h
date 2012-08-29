//
//  clientDrawingGestureView.h
//  DrawingProj
//
//  Created by BuG.BS on 12-8-28.
//  Copyright (c) 2012年 BuG.BS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrawingPadView.h"

@protocol ClientDrawingGestureDelegate <NSObject>

- (void)sendImage;

@end

@interface clientDrawingGestureView : UIView
@property (nonatomic, weak) IBOutlet DrawingPadView *drawingPadView;
@property (nonatomic, weak) id<ClientDrawingGestureDelegate> delegate;
- (void)pan:(UIPanGestureRecognizer *)gesture;
@end
