//
//  DrawingPadView.m
//  DrawingClass
//
//  Created by BuG.BS on 12-8-26.
//  Copyright (c) 2012年 BuG.BS. All rights reserved.
//

#import "DrawingPadView.h"

#define PEN_TYPE_TRASH 3
#define PEN_TYPE_UNDO 4
#define PEN_TYPE_REFRESH 5
#define PEN_TYPE_REFRESH_COVER 6
#define DEFAULT_COLOR [UIColor blackColor]
#define DEFAULT_WIDTH 1.0f
#define LOW_PASS_FILTER 0.5f

@interface DrawingPadView ()

#pragma mark Private Helper function

CGPoint midPoint(CGPoint p1, CGPoint p2);

@end

@implementation DrawingPadView
@synthesize lineColor = _lineColor;
@synthesize lineWidth = _lineWidth;
@synthesize currentPenType = _currentPenType;
@synthesize delegate = _delegate;

- (void)setCurrentPenType:(int)currentPenType
{
    previousPenType = _currentPenType;
    _currentPenType = currentPenType;
}

- (void)addTime
{
    timeInterval++;
}

-(void)setup
{
    NSLog(@"Setup OK!");
    history = [[NSMutableArray alloc] init];
    self.backgroundColor = [UIColor clearColor];
    timer = [[NSTimer alloc] init];
    self.lineWidth = DEFAULT_WIDTH;
    self.lineColor = DEFAULT_COLOR;
    self.currentPenType = PEN_TYPE_MARKER;
    doNotDraw = NO;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //[self setup];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

#pragma mark Private Helper function

CGPoint midPoint(CGPoint p1, CGPoint p2)
{
    return CGPointMake((p1.x + p2.x) * 0.5, (p1.y + p2.y) * 0.5);
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    previousTime = 0;
    previousSpeed = 0;
    previousWidth = 2;
    
    
    [timer invalidate];
    timer = [NSTimer scheduledTimerWithTimeInterval:0.001 target:self selector:@selector(addTime) userInfo:nil repeats:YES];
    [timer fire];
    if (touches.count  > 1) {
        [timer invalidate];
        doNotDraw = YES;
        return;
    }
    if (touches.count == 1){
        doNotDraw = NO;
    }
    
    UITouch *touch = [touches anyObject];
    
    previousPoint1 = [touch previousLocationInView:self];
    previousPoint2 = [touch previousLocationInView:self];
    currentPoint = [touch locationInView:self];
    

    if (doNotDraw == NO){
        if (history.count == 20){
            [history removeObjectAtIndex:19];
        }
        UIGraphicsBeginImageContext(self.frame.size);
        [self.layer renderInContext:UIGraphicsGetCurrentContext()];
        curImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [history insertObject:curImage atIndex:0];
        [self.delegate undoStatChanged];
        //NSLog(@"%d",history.count);
    }
    
    [self touchesMoved:touches withEvent:event];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (doNotDraw){
        [timer invalidate];
        return;
    }
    if (touches.count  > 1) {
        doNotDraw = YES;
        return;
    }
    UITouch *touch  = [touches anyObject];
    
    long currentTime = timeInterval;
    
    
    previousPoint2  = previousPoint1;
    previousPoint1 = currentPoint;
    currentPoint    = [touch locationInView:self];
    
    float speed = sqrt((currentPoint.x - previousPoint1.x)*(currentPoint.x - previousPoint1.x)+(currentPoint.y - previousPoint1.y)*(currentPoint.y - previousPoint1.y))/(currentTime - previousTime);
    
    speed = previousSpeed * LOW_PASS_FILTER + speed * (1 - LOW_PASS_FILTER);
    //NSLog(@"%g",speed);
    if (speed < 0){
        speed = 0;
    }
    previousSpeed = speed;
    
    if (self.currentPenType == PEN_TYPE_BRUSH) {
        self.lineWidth = speed * 20;
        if (self.lineWidth - previousWidth > 1){
            self.lineWidth = previousWidth + 1;
        }
        if (self.lineWidth - previousWidth < -1){
            self.lineWidth = previousWidth - 1;
        }
        
        if (self.lineWidth < 2)
            self.lineWidth = 2;
        if (self.lineWidth > 20)
            self.lineWidth = 20;
    } else if (self.currentPenType == PEN_TYPE_ERASER){
        self.lineWidth = 20;
    } else if (self.currentPenType == PEN_TYPE_MARKER){
        self.lineWidth = 10;
    }
    
    previousWidth = self.lineWidth;
    
    previousTime = currentTime;
    // calculate mid point
    CGPoint mid1    = midPoint(previousPoint1, previousPoint2);
    CGPoint mid2    = midPoint(currentPoint, previousPoint1);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, mid1.x, mid1.y);
    CGPathAddQuadCurveToPoint(path, NULL, previousPoint1.x, previousPoint1.y, mid2.x, mid2.y);
    CGRect bounds = CGPathGetBoundingBox(path);
    CGPathRelease(path);
    
    CGRect drawBox = bounds;
    
    //Pad our values so the bounding box respects our line width
    drawBox.origin.x        -= self.lineWidth * 2;
    drawBox.origin.y        -= self.lineWidth * 2;
    drawBox.size.width      += self.lineWidth * 4;
    drawBox.size.height     += self.lineWidth * 4;
    
    UIGraphicsBeginImageContext(drawBox.size);
	[self.layer renderInContext:UIGraphicsGetCurrentContext()];
	curImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
    
    [self setNeedsDisplayInRect:drawBox];
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [timer invalidate];
    timeInterval = 0;

}

- (void)drawRect:(CGRect)rect
{
    if (self.currentPenType == PEN_TYPE_REFRESH){
        // Drawing code
        [curImage drawAtPoint:CGPointMake(0, 0)];
        [imageForRefresh drawAtPoint:CGPointMake(0, 0)];
        self.currentPenType = previousPenType;
        NSLog(@"refreshed");
        return;
    }
    if (self.currentPenType == PEN_TYPE_REFRESH_COVER){
        // Drawing code
        [imageForRefresh drawAtPoint:CGPointMake(0, 0)];
        self.currentPenType = previousPenType;
        NSLog(@"refreshed");
        return;
    }
    
    
    if (self.currentPenType == PEN_TYPE_UNDO){
        
        if (history.count != 0){
            curImage = [history objectAtIndex:0];
            [history removeObjectAtIndex:0];
            
            //NSLog(@"%@",curImage);
            //NSLog(@"%d",history.count);
        }
        [curImage drawAtPoint:CGPointMake(0, 0)];
        self.currentPenType = previousPenType;
        NSLog(@"undo!");
        [self.delegate undoStatChanged];
        return;
    }
    
    [curImage drawAtPoint:CGPointMake(0, 0)];
    CGPoint mid1 = midPoint(previousPoint1, previousPoint2);
    CGPoint mid2 = midPoint(currentPoint, previousPoint1);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [self.layer renderInContext:context];
    
    if (self.currentPenType == PEN_TYPE_TRASH){
        
        CGContextSetBlendMode(context, kCGBlendModeClear);
        CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
        CGContextFillRect(context, rect);
        self.currentPenType = previousPenType;
        [super drawRect:rect];
        return;
    }
    
    CGContextMoveToPoint(context, mid1.x, mid1.y);
    CGContextAddQuadCurveToPoint(context, previousPoint1.x, previousPoint1.y, mid2.x, mid2.y);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, self.lineWidth);
    CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);
    
    
    if (self.currentPenType == PEN_TYPE_ERASER){
        //CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);
        CGContextSetBlendMode(context, kCGBlendModeClear);
        CGContextSetLineWidth(context, 30.0);
    } else {
        CGContextSetBlendMode(context, kCGBlendModeNormal);
        CGContextSetLineWidth(context, self.lineWidth);
        
    }
    CGContextStrokePath(context);
    [super drawRect:rect];
}

- (void)undo
{
    self.currentPenType = PEN_TYPE_UNDO;
    [self setNeedsDisplay];
}

- (void)cleanUp
{
    if (history.count == 20){
        [history removeObjectAtIndex:19];
    }
    UIGraphicsBeginImageContext(self.frame.size);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    curImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [history insertObject:curImage atIndex:0];
    //NSLog(@"%d",history.count);
    [self.delegate undoStatChanged];
    self.currentPenType = PEN_TYPE_TRASH;
    [self setNeedsDisplay];
}

- (void)refreshWithPicture:(UIImage *)image Cover:(BOOL)needCover
{
    if (history.count == 20){
        [history removeObjectAtIndex:19];
    }
    UIGraphicsBeginImageContext(self.frame.size);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    curImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [history insertObject:curImage atIndex:0];
    [self.delegate undoStatChanged];
    //NSLog(@"%d",history.count);
    
    if (needCover){
        self.currentPenType = PEN_TYPE_REFRESH_COVER;
    } else {
        self.currentPenType = PEN_TYPE_REFRESH;
    }
    imageForRefresh = image;
    [self setNeedsDisplay];
}

- (UIImage *)getCurrentPicture
{
    /*
    UIImage *tempImage = [[UIImage alloc] init];
    UIGraphicsBeginImageContext(self.frame.size);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    tempImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return tempImage;
     */
    return curImage;
}

- (BOOL)haveSomeToUndo
{
    return (history.count > 0);
}
@end
