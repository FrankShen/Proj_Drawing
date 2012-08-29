//
//  clientDrawingViewController.m
//  DrawingProj
//
//  Created by BuG.BS on 12-8-28.
//  Copyright (c) 2012年 BuG.BS. All rights reserved.
//

#import "clientDrawingViewController.h"
#import "GlobalVariable.h"
#import "clientDrawingSettingTableViewController.h"
@interface clientDrawingViewController ()<DrawingPadViewDelegate,ClientDrawingToolBoxViewDelegate,ClientSettingDelegate>

@end

@implementation clientDrawingViewController
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
    
    UIPanGestureRecognizer *ges = [[UIPanGestureRecognizer alloc] initWithTarget:self.gestureView action:@selector(pan:)];
    ges.maximumNumberOfTouches = 2;
    ges.minimumNumberOfTouches = 2;
    [self.gestureView addGestureRecognizer:ges];
    
    UISwipeGestureRecognizer *gesOpen = [[UISwipeGestureRecognizer alloc] initWithTarget:self.toolboxView action:@selector(swipeOpen:)];
    gesOpen.numberOfTouchesRequired = 1;
    gesOpen.direction = UISwipeGestureRecognizerDirectionRight;
    
    UISwipeGestureRecognizer *gesClose = [[UISwipeGestureRecognizer alloc] initWithTarget:self.toolboxView action:@selector(swipeClose:)];
    gesClose.numberOfTouchesRequired = 1;
    gesClose.direction = UISwipeGestureRecognizerDirectionLeft;
    
    [self.toolboxView addGestureRecognizer:gesOpen];
    [self.toolboxView addGestureRecognizer:gesClose];
    
    self.toolboxView.frame = CGRectMake(-424, 650, 424, 69);
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.5 animations:^{
            self.toolboxView.frame = CGRectMake(-360, 650, 424, 69);
        }];
    });
    self.toolboxView.markerButton.selected = YES;
    
        
    self.gestureView.drawingPadView.delegate = self;
    self.gestureView.delegate = self;
    [GlobalVariable getGlobalVariable].tempDelegate = self;
    [GlobalVariable getGlobalVariable].clientDrawingDelegate = self;

    
}

- (void)viewDidUnload
{
    [self setGestureView:nil];
    [self setToolboxView:nil];
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
                self.toolboxView.frame = CGRectMake(-360, 650, 424, 69);
            }];
        });
        self.toolboxView.isShow = NO;
        [self changeToolboxButton];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.5 animations:^{
                self.toolboxView.frame = CGRectMake(0, 650, 424, 69);
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

- (IBAction)pullButtonPressed:(id)sender
{
    if (!([GlobalVariable getGlobalVariable].selfSocket.isConnected)){
        [[GlobalVariable getGlobalVariable] connectToDevice:[GlobalVariable getGlobalVariable].backupAddress];
    }
    [[GlobalVariable getGlobalVariable].selfSocket writeData:[@"PREPARE_FOR_PULL" dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:INCOMING_SIGNAL];
    [[GlobalVariable getGlobalVariable].selfSocket readDataWithTimeout:-1 tag:PREPARE_FOR_PULL];

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
                self.toolboxView.frame = CGRectMake(-360, 650, 424, 69);
            }];
        });
        self.toolboxView.isShow = NO;
        [self changeToolboxButton];
    }
}

- (void)swipeLeftFromRightDetect
{
    if (!self.toolboxView.isShow){
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.5 animations:^{
                self.toolboxView.frame = CGRectMake(0, 650, 424, 69);
            }];
        });
        self.toolboxView.isShow = YES;
        [self.toolboxView.toolboxButton setImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
    }
}

- (void)swipeRightFromLeftDetect
{
    if (self.toolboxView.isShow) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.5 animations:^{
                self.toolboxView.frame = CGRectMake(-360, 650, 424, 69);
            }];
        });
        self.toolboxView.isShow = NO;
        [self changeToolboxButton];
    }
}

- (IBAction)settingButtonPressed:(id)sender
{
    [self performSegueWithIdentifier:@"clientSetting" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"clientSetting"]){
        //
        self.popOver = ((UIStoryboardPopoverSegue *)segue).popoverController;
    }
}

- (void)dismissVC
{
    [self dismissModalViewControllerAnimated:YES];
    [self.popOver dismissPopoverAnimated:NO];
}

- (void)sendImage
{
    if (!([GlobalVariable getGlobalVariable].selfSocket.isConnected)){
        NSLog(@"123");
        [[GlobalVariable getGlobalVariable] connectToDevice:[GlobalVariable getGlobalVariable].backupAddress];
    }
    
    [GlobalVariable getGlobalVariable].imageToSend = [self.gestureView.drawingPadView getCurrentPicture];
    
    [[GlobalVariable getGlobalVariable].selfSocket writeData:[@"PREPARE_FOR_IMAGE" dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:INCOMING_SIGNAL];
    [[GlobalVariable getGlobalVariable].selfSocket writeData:[[NSString stringWithFormat:@"%d", UIImagePNGRepresentation([GlobalVariable getGlobalVariable].imageToSend).length] dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:PREPARE_FOR_IMAGE];
    
    [[GlobalVariable getGlobalVariable].selfSocket writeData:UIImagePNGRepresentation([GlobalVariable getGlobalVariable].imageToSend) withTimeout:-1 tag:IMAGE_SENDING];
    
    //[[GlobalVariable getGlobalVariable].selfSocket readDataWithTimeout:-1 tag:SEND_SUCCESS];
}

- (void)recievedImage:(UIImage *)image
{
    [self.gestureView.drawingPadView refreshWithPicture:image Cover:[GlobalVariable getGlobalVariable].isOverlay];
}
@end
