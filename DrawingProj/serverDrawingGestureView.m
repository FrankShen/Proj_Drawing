//
//  serverDrawingGestureView.m
//  DrawingProj
//
//  Created by BuG.BS on 12-8-27.
//  Copyright (c) 2012年 BuG.BS. All rights reserved.
//

#import "serverDrawingGestureView.h"

@implementation serverDrawingGestureView
@synthesize drawingPadView = _drawingPadView;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)pan:(UIPanGestureRecognizer *)gesture
{
    //NSLog(@"(%g,%g)", self.frame.origin.x, self.frame.origin.y);
    //NSLog(@"%g",self.alpha);
    if (gesture.state == UIGestureRecognizerStateBegan) {
        [self.drawingPadView undo];
    } else if (gesture.state == UIGestureRecognizerStateChanged){
        CGPoint translation = [gesture translationInView:self];
        if ((self.frame.origin.y + translation.y) <= 0){
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y + translation.y, self.frame.size.width, self.frame.size.height);
            self.drawingPadView.alpha += translation.y * 0.002;
        }
        [gesture setTranslation:CGPointZero inView:self];
    } else if (gesture.state == UIGestureRecognizerStateEnded){
        CGPoint translation = [gesture translationInView:self];
        if ((self.frame.origin.y + translation.y) <= 0){
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y + translation.y, self.frame.size.width, self.frame.size.height);
            self.drawingPadView.alpha += translation.y * 0.002;
        }
        [gesture setTranslation:CGPointZero inView:self];
        
        if (self.frame.origin.y < -200) {
            NSLog(@"YES");
            /*
             [UIView animateWithDuration:0.5 animations:^{
             self.frame = CGRectMake(self.frame.origin.x, -480, self.frame.size.width, self.frame.size.height);
             self.imageView.alpha = 0.0;
             }];
             */
            [UIView animateWithDuration:0.5 animations:^{
                self.frame = CGRectMake(self.frame.origin.x, -768, self.frame.size.width, self.frame.size.height);
                self.drawingPadView.alpha = 0.0;
            }completion:^(BOOL isFinished){
                self.frame = CGRectMake(self.frame.origin.x, 0, self.frame.size.width, self.frame.size.height);
                [UIView animateWithDuration:0.5 animations:^{
                    self.drawingPadView.alpha = 1.0;
                }];
            }];
            
        } else {
            NSLog(@"NO");
            [UIView animateWithDuration:0.5 animations:^{
                self.frame = CGRectMake(self.frame.origin.x, 0, self.frame.size.width, self.frame.size.height);
                self.drawingPadView.alpha = 1.0;
            }];
        }
        
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
