//
//  serverDrawingImageLibraryViewController.m
//  DrawingProj
//
//  Created by BuG.BS on 12-8-29.
//  Copyright (c) 2012年 BuG.BS. All rights reserved.
//

#import "serverDrawingImageLibraryViewController.h"

@interface serverDrawingImageLibraryViewController ()

@end

@implementation serverDrawingImageLibraryViewController
@synthesize imageLibrary;

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
    [self.imageLibrary reloadData];
}

- (void)viewDidUnload
{
    [self setImageLibrary:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"serverSettingNext"]){
        
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [GlobalVariable getGlobalVariable].imageLibrary.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ImageLibraryTableViewCell *cell = [self.imageLibrary dequeueReusableCellWithIdentifier:@"imageCell"];
    if (!cell)
        cell = [[ImageLibraryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"imageCell"];
    cell.tag = indexPath.row;
    cell.imageView.image = [[GlobalVariable getGlobalVariable].imageLibrary objectAtIndex:indexPath.row];
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[GlobalVariable getGlobalVariable].serverDrawingDelegate recievedImage:[[GlobalVariable getGlobalVariable].imageLibrary objectAtIndex:indexPath.row]];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
