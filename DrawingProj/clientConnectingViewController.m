//
//  clientConnectingViewController.m
//  DrawingProj
//
//  Created by BuG.BS on 12-8-23.
//  Copyright (c) 2012年 BuG.BS. All rights reserved.
//

#import "clientConnectingViewController.h"

@interface clientConnectingViewController ()

@end

@implementation clientConnectingViewController
@synthesize deviceID;

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
    
    self.deviceID.keyboardType = UIKeyboardTypeNumberPad;
}

- (void)viewDidUnload
{
    [self setDeviceID:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight || interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}

- (IBAction)backButtonPressed:(id)sender
{
    [self performSegueWithIdentifier:@"clientBackToMain" sender:self];
}

- (IBAction)connectButtonPressed:(id)sender
{
    NSLog(@"Connecting!");
}

@end
