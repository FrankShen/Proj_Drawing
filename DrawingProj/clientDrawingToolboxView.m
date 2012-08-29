//
//  clientDrawingToolboxView.m
//  DrawingProj
//
//  Created by BuG.BS on 12-8-28.
//  Copyright (c) 2012年 BuG.BS. All rights reserved.
//

#import "clientDrawingToolboxView.h"

@implementation clientDrawingToolboxView
@synthesize isShow = _isShow;
@synthesize markerButton = _markerButton;
@synthesize brushButton = _brushButton;
@synthesize eraserButton = _eraserButton;
@synthesize toolboxButton = _toolboxButton;
@synthesize undoButton = _undoButton;
@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.isShow = NO;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)swipeOpen:(UISwipeGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateChanged ||
        gesture.state == UIGestureRecognizerStateEnded) {
        [self.delegate swipeLeftFromRightDetect];
        NSLog(@"open");
    }
}

- (void)swipeClose:(UISwipeGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateChanged ||
        gesture.state == UIGestureRecognizerStateEnded) {
        [self.delegate swipeRightFromLeftDetect];
        NSLog(@"close");
    }
}

@end
