//
//  DPViewController.m
//  DrawingProj
//
//  Created by BuG.BS on 12-8-20.
//  Copyright (c) 2012年 BuG.BS. All rights reserved.
//

#import "DPViewController.h"

@interface DPViewController ()

@end

@implementation DPViewController
@synthesize serverButton;
@synthesize clientButton;
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.serverButton.frame = CGRectMake(self.serverButton.frame.origin.x, 768, 304, 310);
    self.clientButton.frame = CGRectMake(self.clientButton.frame.origin.x, 768, 304, 310);
    
    [UIView animateWithDuration:1.0 delay:0.5 options:UIViewAnimationCurveEaseOut animations:^{
        self.serverButton.frame = CGRectMake(self.serverButton.frame.origin.x, 229, 304, 310);
        self.clientButton.frame = CGRectMake(self.clientButton.frame.origin.x, 229, 304, 310);
    }completion:^(BOOL isFinished){
        NSLog(@"OK");
    }];
}

- (void)viewDidUnload
{
    [self setServerButton:nil];
    [self setClientButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight || interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}

- (IBAction)serverButtonPressed:(id)sender
{
    [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationCurveEaseIn animations:^{
        self.serverButton.frame = CGRectMake(self.serverButton.frame.origin.x, 768, 304, 310);
        self.clientButton.frame = CGRectMake(self.clientButton.frame.origin.x, 768, 304, 310);
    }completion:^(BOOL isFinished){
        NSLog(@"Server");
        [GlobalVariable getGlobalVariable].userType = USER_TYPE_SERVER;
        [self performSegueWithIdentifier:@"chooseServer" sender:self];
    }];
}

- (IBAction)clientButtonPressed:(id)sender
{
    [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationCurveEaseIn animations:^{
        self.serverButton.frame = CGRectMake(self.serverButton.frame.origin.x, 768, 304, 310);
        self.clientButton.frame = CGRectMake(self.clientButton.frame.origin.x, 768, 304, 310);
    }completion:^(BOOL isFinished){
        NSLog(@"Client");
        [GlobalVariable getGlobalVariable].userType = USER_TYPE_CLIENT;
        [self performSegueWithIdentifier:@"chooseClient" sender:self];
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //[segue.sourceViewController dismissModalViewControllerAnimated:NO];
}



@end
