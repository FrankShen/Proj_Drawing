//
//  clientDrawingSettingTableViewController.m
//  DrawingProj
//
//  Created by BuG.BS on 12-8-28.
//  Copyright (c) 2012年 BuG.BS. All rights reserved.
//

#import "clientDrawingSettingTableViewController.h"

@interface clientDrawingSettingTableViewController ()

@end

@implementation clientDrawingSettingTableViewController
@synthesize overlaySwitch;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.delegate = [GlobalVariable getGlobalVariable].tempDelegate;
    [self.overlaySwitch setOn:([GlobalVariable getGlobalVariable].isOverlay)];
}

- (void)viewDidUnload
{
    [self setOverlaySwitch:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (IBAction)overlaySwitch:(UISwitch *)sender
{
    if (sender.isOn) {
        ((DPAppDelegate *)[[UIApplication sharedApplication] delegate]).globalVairable.isOverlay = YES;
        NSLog(@"isOverlay");
    } else {
        ((DPAppDelegate *)[[UIApplication sharedApplication] delegate]).globalVairable.isOverlay = NO;
        NSLog(@"notOverlay");
    }
}
- (IBAction)disconnectPressed:(id)sender
{
    [((DPAppDelegate *)[[UIApplication sharedApplication] delegate]).globalVairable.selfSocket disconnectAfterReadingAndWriting];
    [self performSegueWithIdentifier:@"clientDisconnect" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"clientDisconnect"]){
        //[self dismissModalViewControllerAnimated:NO];
        [self.delegate dismissVC];
    }
}
@end
