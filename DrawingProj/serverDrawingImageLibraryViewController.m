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
}

- (void)viewDidUnload
{
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

@end
