//
//  serverDrawingSettingTableViewController.m
//  DrawingProj
//
//  Created by BuG.BS on 12-8-29.
//  Copyright (c) 2012年 BuG.BS. All rights reserved.
//

#import "serverDrawingSettingTableViewController.h"

@interface serverDrawingSettingTableViewController ()

@end

@implementation serverDrawingSettingTableViewController
@synthesize overlaySwitch;
@synthesize autoShowSwitch;

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
    [self.overlaySwitch setOn:[GlobalVariable getGlobalVariable].isOverlay];
    [self.autoShowSwitch setOn:[GlobalVariable getGlobalVariable].isAutoShow];
    
}

- (void)viewDidUnload
{
    [self setOverlaySwitch:nil];
    [self setAutoShowSwitch:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

- (IBAction)disconnectPressed:(id)sender
{
    [((DPAppDelegate *)[[UIApplication sharedApplication] delegate]).globalVairable.selfSocket disconnectAfterWriting];
    [self performSegueWithIdentifier:@"serverDisconnect" sender:self];
}

- (IBAction)overlaySwitch:(UISwitch *)sender
{
    if (sender.isOn) {
        ((DPAppDelegate *)[[UIApplication sharedApplication] delegate]).globalVairable.isOverlay = YES;
    } else {
        ((DPAppDelegate *)[[UIApplication sharedApplication] delegate]).globalVairable.isOverlay = NO;
    }
}
- (IBAction)showAutoSwitch:(UISwitch *)sender
{
    if (sender.isOn) {
        ((DPAppDelegate *)[[UIApplication sharedApplication] delegate]).globalVairable.isAutoShow = YES;
    } else {
        ((DPAppDelegate *)[[UIApplication sharedApplication] delegate]).globalVairable.isAutoShow = NO;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"serverDisconnect"]){
        //[self dismissModalViewControllerAnimated:NO];
        [self.delegate dismissVC];
    }
}
@end
