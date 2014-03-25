//
//  DetailViewController.m
//  PZSideMenuViewController
//
//  Created by Cyril CHANDELIER on 3/25/14.
//  Copyright (c) 2014 PlayAdz. All rights reserved.
//

#import "DetailViewController.h"
#import "RightViewController.h"



@interface DetailViewController ()

// Outlets
@property (nonatomic, weak) IBOutlet UILabel *numberLabel;

@end



@implementation DetailViewController

#pragma mark - Constructor
- (id)init
{
    if (self = [super initWithNibName:@"DetailViewController" bundle:nil])
    {
        // Subscribe to KVO notification
        [self addObserver:self
               forKeyPath:@"number"
                  options:NSKeyValueObservingOptionNew
                  context:nil];
    }
    
    return self;
}

#pragma mark - View management
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Force refresh UI
    [self refreshUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Setup right view controller
    SIDE_MENU_CONTROLLER.rightViewController = [[RightViewController alloc] init];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // Setup right view controller
    SIDE_MENU_CONTROLLER.rightViewController = nil;
}

- (void)refreshUI
{
    // Update label
    _numberLabel.text = [NSString stringWithFormat:@"%d", _number];
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"number"] && [self isViewLoaded])
    {
        [self refreshUI];
    }
}

#pragma mark - Memory
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    // Unsubscribe KVO notifications
    [self removeObserver:self forKeyPath:@"number"];
}

@end