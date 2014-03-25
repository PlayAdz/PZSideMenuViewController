//
//  SubmenuViewController.m
//  PZSideMenuViewController
//
//  Created by Cyril CHANDELIER on 3/25/14.
//  Copyright (c) 2014 PlayAdz. All rights reserved.
//

#import "SubmenuViewController.h"
#import "DetailViewController.h"



@interface SubmenuViewController ()

// View controllers
@property (nonatomic, strong) DetailViewController *detailViewController;

@end



@implementation SubmenuViewController

#pragma mark - Constructor
- (id)init
{
    self = [super initWithNibName:@"SubmenuViewController" bundle:nil];
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
    
    self.title = @"Submenu";
}

#pragma mark - UITableViewDataSource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell_ID"];
    if (!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell_ID"];
    
    return cell;
}

#pragma mark - UITableViewDelegate methods
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.textLabel.text = [NSString stringWithFormat:@"Submenu cell %d", indexPath.row];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!_detailViewController)
        _detailViewController = [[DetailViewController alloc] init];
    
    // Configure
    _detailViewController.number = indexPath.row;
    
    // Present it
    [SIDE_MENU_CONTROLLER presentCenterViewController:_detailViewController];
}

#pragma mark - Memory
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end