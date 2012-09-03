//
//  ServerDrawingViewController.m
//  DrawingProj
//
//  Created by BuG.BS on 12-8-26.
//  Copyright (c) 2012年 BuG.BS. All rights reserved.
//

#import "ServerDrawingViewController.h"
#import "DrawingPadView.h"
#import "GlobalVariable.h"
@interface ServerDrawingViewController ()<DrawingPadViewDelegate,UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>

@end

@implementation ServerDrawingViewController
@synthesize gestureView;

@synthesize markerButton = _markerButton;
@synthesize brushButton = _brushButton;
@synthesize eraserButton = _eraserButton;
@synthesize undoButton = _undoButton;
@synthesize imageTableView = _imageTableView;

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
    [[GlobalVariable getGlobalVariable].imageLibrary removeAllObjects];
    
    self.markerButton.selected = YES;
    self.gestureView.drawingPadView.delegate = self;
    [GlobalVariable getGlobalVariable].serverDrawingDelegate = self;
    [GlobalVariable getGlobalVariable].imageLibrary = [[NSMutableArray alloc] init];
    
}

- (void)viewDidUnload
{
    [self setGestureView:nil];
    [self setImageTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight || interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}


- (IBAction)markButtonPressed:(id)sender
{
    self.gestureView.drawingPadView.currentPenType = PEN_TYPE_MARKER;
    self.markerButton.selected = YES;
    self.brushButton.selected = NO;
    self.eraserButton.selected = NO;
}

- (IBAction)brushButtonPressed:(id)sender
{
    self.gestureView.drawingPadView.currentPenType = PEN_TYPE_BRUSH;
    self.markerButton.selected = NO;
    self.brushButton.selected = YES;
    self.eraserButton.selected = NO;
}

- (IBAction)eraserButtonPressed:(id)sender
{
    self.gestureView.drawingPadView.currentPenType = PEN_TYPE_ERASER;
    self.markerButton.selected = NO;
    self.brushButton.selected = NO;
    self.eraserButton.selected = YES;
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
        self.undoButton.selected = YES;
    } else {
        self.undoButton.selected = NO;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //
    //
    //
}

- (void)recievedImage:(UIImage *)image
{
    [self.gestureView.drawingPadView refreshWithPicture:image Cover:YES];
}

- (UIImage *)grabImage
{
    return [self.gestureView.drawingPadView getCurrentPicture];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [GlobalVariable getGlobalVariable].imageLibrary.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ImageLibraryCell *cell = [self.imageTableView dequeueReusableCellWithIdentifier:@"imageCell"];
    if (!cell)
        cell = [[ImageLibraryCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"imageCell"];
    
    cell.tag = indexPath.row;
    cell.image.image = ((imageInfo *)[[GlobalVariable getGlobalVariable].imageLibrary objectAtIndex:indexPath.row]).image;
    if (((imageInfo *)[[GlobalVariable getGlobalVariable].imageLibrary objectAtIndex:indexPath.row]).isRead){
        cell.unreadSignal.image = [UIImage imageNamed:@"read_signal.png"];
    } else {
        cell.unreadSignal.image = [UIImage imageNamed:@"unread_signal.png"];
    }
    return  cell;
}

- (void)newIncome
{
    [self.imageTableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 111;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ((ImageLibraryCell *)[tableView cellForRowAtIndexPath:indexPath]).unreadSignal.image = [UIImage imageNamed:@"read_signal.png"];
    ((imageInfo *)[[GlobalVariable getGlobalVariable].imageLibrary objectAtIndex:indexPath.row]).isRead = YES;
    UIImage *tempImage = ((imageInfo *)[[GlobalVariable getGlobalVariable].imageLibrary objectAtIndex:indexPath.row]).image;
    [self.gestureView.drawingPadView refreshWithPicture:tempImage Cover:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (IBAction)disconnectButtonPressed:(UIButton *)sender
{
    UIActionSheet *menu = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"断开链接" otherButtonTitles:nil];
    [menu showFromRect:sender.frame inView:self.view animated:YES];

}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0){
        [[GlobalVariable getGlobalVariable].selfSocket disconnectAfterWriting];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
