//
//  ServerDrawingViewController.m
//  DrawingProj
//
//  Created by BuG.BS on 12-8-26.
//  Copyright (c) 2012年 BuG.BS. All rights reserved.
//

#import "ServerDrawingViewController.h"
#import "DrawingPadView.h"
#import "serverDrawingToolboxView.h"
#import "GlobalVariable.h"
@interface ServerDrawingViewController ()<DrawingPadViewDelegate,ServerSettingDelegate>

@end

@implementation ServerDrawingViewController
@synthesize settingButton;
@synthesize gestureView;
@synthesize toolboxView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    /*
    UIPanGestureRecognizer *ges = [[UIPanGestureRecognizer alloc] initWithTarget:self.gestureView action:@selector(pan:)];
    ges.maximumNumberOfTouches = 2;
    ges.minimumNumberOfTouches = 2;
    [self.gestureView addGestureRecognizer:ges];
     */
    
    UISwipeGestureRecognizer *gesOpen = [[UISwipeGestureRecognizer alloc] initWithTarget:self.toolboxView action:@selector(swipeOpen:)];
    gesOpen.numberOfTouchesRequired = 1;
    gesOpen.direction = UISwipeGestureRecognizerDirectionRight;
    
    UISwipeGestureRecognizer *gesClose = [[UISwipeGestureRecognizer alloc] initWithTarget:self.toolboxView action:@selector(swipeClose:)];
    gesClose.numberOfTouchesRequired = 1;
    gesClose.direction = UISwipeGestureRecognizerDirectionLeft;
    
    [self.toolboxView addGestureRecognizer:gesOpen];
    [self.toolboxView addGestureRecognizer:gesClose];
    
    self.toolboxView.frame = CGRectMake(-364, 650, 364, 69);
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.5 animations:^{
            self.toolboxView.frame = CGRectMake(-300, 650, 364, 69);
        }];
    });
    self.toolboxView.markerButton.selected = YES;
    self.gestureView.drawingPadView.delegate = self;
    [GlobalVariable getGlobalVariable].serverDrawingDelegate = self;
    [GlobalVariable getGlobalVariable].imageLibrary = [[NSMutableArray alloc] init];
    
}

- (void)viewDidUnload
{
    [self setGestureView:nil];
    [self setToolboxView:nil];
    
    [self setSettingButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight || interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}

- (void)changeToolboxButton
{
    if (self.gestureView.drawingPadView.currentPenType == PEN_TYPE_MARKER){
        [self.toolboxView.toolboxButton setImage:[UIImage imageNamed:@"marker_active.png"] forState:UIControlStateNormal];
    } else if (self.gestureView.drawingPadView.currentPenType == PEN_TYPE_BRUSH) {
        [self.toolboxView.toolboxButton setImage:[UIImage imageNamed:@"brush_active.png"] forState:UIControlStateNormal];
    } else if (self.gestureView.drawingPadView.currentPenType == PEN_TYPE_ERASER) {
        [self.toolboxView.toolboxButton setImage:[UIImage imageNamed:@"eraser_active.png"] forState:UIControlStateNormal];
    }
}

- (IBAction)toolboxButtonPressed:(id)sender
{
    if (self.toolboxView.isShow) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.5 animations:^{
                self.toolboxView.frame = CGRectMake(-300, 650, 364, 69);
            }];
        });
        self.toolboxView.isShow = NO;
        [self changeToolboxButton];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.5 animations:^{
                self.toolboxView.frame = CGRectMake(0, 650, 364, 69);
            }];
        });
        self.toolboxView.isShow = YES;
                [self.toolboxView.toolboxButton setImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
    }
}

- (IBAction)markButtonPressed:(id)sender
{
    self.gestureView.drawingPadView.currentPenType = PEN_TYPE_MARKER;
    self.toolboxView.markerButton.selected = YES;
    self.toolboxView.brushButton.selected = NO;
    self.toolboxView.eraserButton.selected = NO;
}

- (IBAction)brushButtonPressed:(id)sender
{
    self.gestureView.drawingPadView.currentPenType = PEN_TYPE_BRUSH;
    self.toolboxView.markerButton.selected = NO;
    self.toolboxView.brushButton.selected = YES;
    self.toolboxView.eraserButton.selected = NO;
}

- (IBAction)eraserButtonPressed:(id)sender
{
    self.gestureView.drawingPadView.currentPenType = PEN_TYPE_ERASER;
    self.toolboxView.markerButton.selected = NO;
    self.toolboxView.brushButton.selected = NO;
    self.toolboxView.eraserButton.selected = YES;
}

- (IBAction)trashButtonPressed:(id)sender
{
    [self.gestureView.drawingPadView cleanUp];
}

- (IBAction)undoButtonPressed:(id)sender
{
    [self.gestureView.drawingPadView undo];
}

- (void)undoStatChanged
{
    if ([self.gestureView.drawingPadView haveSomeToUndo]){
        self.toolboxView.undoButton.selected = YES;
    } else {
        self.toolboxView.undoButton.selected = NO;
    }
}

- (void)startDrawing
{
    if (self.toolboxView.isShow) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.5 animations:^{
                self.toolboxView.frame = CGRectMake(-300, 650, 364, 69);
            }];
        });
        self.toolboxView.isShow = NO;
        [self changeToolboxButton];
    }
}

- (IBAction)settingButtonPressed:(UIButton *)sender
{
    [sender setImage:[UIImage imageNamed:@"setting_center.png"] forState:UIControlStateNormal];
    [self performSegueWithIdentifier:@"serverSetting" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"serverSetting"]){
        //
        [GlobalVariable getGlobalVariable].tempDelegate = self;
        self.popOver = ((UIStoryboardPopoverSegue *)segue).popoverController;
    }
}

- (void)dismissVC
{
    [self dismissModalViewControllerAnimated:YES];
    [self.popOver dismissPopoverAnimated:NO];
}

- (void)recievedImage:(UIImage *)image
{
    [self.gestureView.drawingPadView refreshWithPicture:image Cover:[GlobalVariable getGlobalVariable].isOverlay];
}

- (UIImage *)grabImage
{
    return [self.gestureView.drawingPadView getCurrentPicture];
}

- (void)newIncome
{
    [self.settingButton setImage:[UIImage imageNamed:@"setting_center_new.png"] forState:UIControlStateNormal];
}

@end
