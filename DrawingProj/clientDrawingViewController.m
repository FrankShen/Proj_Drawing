//
//  clientDrawingViewController.m
//  DrawingProj
//
//  Created by BuG.BS on 12-8-28.
//  Copyright (c) 2012年 BuG.BS. All rights reserved.
//

#import "clientDrawingViewController.h"
#import "GlobalVariable.h"
@interface clientDrawingViewController ()<DrawingPadViewDelegate,UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>

@end

@implementation clientDrawingViewController
@synthesize imageTableView;
@synthesize gestureView;

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
    
    UIPanGestureRecognizer *panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self.gestureView action:@selector(pan:)];
    panGes.maximumNumberOfTouches = 2;
    panGes.minimumNumberOfTouches = 2;
    
    [[GlobalVariable getGlobalVariable].imageLibrary removeAllObjects];
    
    [self.gestureView addGestureRecognizer:panGes];
    
    self.gestureView.drawingPadView.delegate = self;
    self.gestureView.delegate = self;
    self.markerButton.selected = YES;
    [GlobalVariable getGlobalVariable].tempDelegate = self;
    [GlobalVariable getGlobalVariable].clientDrawingDelegate = self;

    
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
    [self.gestureView.drawingPadView refreshWithPicture:image Cover:YES];
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
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 111;
}

- (void)newIncome
{
    [self.imageTableView reloadData];
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
        [[GlobalVariable getGlobalVariable].selfSocket disconnectAfterReadingAndWriting];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
