//
//  RootViewController.m
//  PZSideMenuViewController
//
//  Created by Cyril CHANDELIER on 3/25/14.
//  Copyright (c) 2014 PlayAdz. All rights reserved.
//

#import "RootViewController.h"
#import "PZSideMenuViewController.h"
#import "HomeViewController.h"
#import "MenuViewController.h"



@interface RootViewController ()

// Side menu
@property (nonatomic, strong) PZSideMenuViewController *sideMenuViewController;

@end



@implementation RootViewController

#pragma mark - Constructor
- (id)init
{
    self = [super initWithNibName:@"RootViewController" bundle:nil];
    if (self)
    {
        // Prepare side menu view controller
        _sideMenuViewController = [[PZSideMenuViewController alloc] initWithCenterViewController:[[HomeViewController alloc] init]];
        _sideMenuViewController.leftViewController = [[UINavigationController alloc] initWithRootViewController:[[MenuViewController alloc] init]];
    }
    
    return self;
}

#pragma mark - View management
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Add to view
    [self addChildViewController:_sideMenuViewController];
    [self.view addSubview:_sideMenuViewController.view];
    _sideMenuViewController.view.frame = self.view.bounds;
}

#pragma mark - Memory
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end