//
//  DrawingPadView.h
//  DrawingClass
//
//  Created by BuG.BS on 12-8-26.
//  Copyright (c) 2012年 BuG.BS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#define PEN_TYPE_BRUSH 0
#define PEN_TYPE_MARKER 1
#define PEN_TYPE_ERASER 2

@protocol DrawingPadViewDelegate <NSObject>

- (void)undoStatChanged;

@end

@interface DrawingPadView : UIView
{
    @private
    NSMutableArray *history;
    UIImage *imageForRefresh;
    CGPoint currentPoint;
    CGPoint previousPoint1;
    CGPoint previousPoint2;
    UIImage *curImage;
    NSTimer *timer;
    long timeInterval;
    long previousTime;
    long previousSpeed;
    long previousWidth;
    BOOL doNotDraw;
    int previousPenType;
}

@property (nonatomic,strong) UIColor *lineColor;
@property (nonatomic) CGFloat lineWidth;
@property (nonatomic) int currentPenType;
@property (nonatomic, weak) id<DrawingPadViewDelegate> delegate;

- (UIImage *)getCurrentPicture;
- (BOOL)haveSomeToUndo;
- (void)refreshWithPicture:(UIImage *)image Cover:(BOOL) needCover;
- (void)undo;
- (void)cleanUp;

@end
