//
//  HomeViewController.m
//  PZSideMenuViewController
//
//  Created by Cyril CHANDELIER on 3/25/14.
//  Copyright (c) 2014 PlayAdz. All rights reserved.
//

#import "HomeViewController.h"



@interface HomeViewController ()

@end



@implementation HomeViewController

#pragma mark - Constructor
- (id)init
{
    self = [super initWithNibName:@"HomeViewController" bundle:nil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

#pragma mark - View management
- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - UI Actions
- (IBAction)openLeft
{
    [SIDE_MENU_CONTROLLER openLeftSideViewControllerAnimated:YES];
}

#pragma mark - Memory
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end