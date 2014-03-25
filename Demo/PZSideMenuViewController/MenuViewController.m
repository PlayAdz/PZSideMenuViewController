//
//  MenuViewController.m
//  PZSideMenuViewController
//
//  Created by Cyril CHANDELIER on 3/25/14.
//  Copyright (c) 2014 PlayAdz. All rights reserved.
//

#import "MenuViewController.h"
#import "SubmenuViewController.h"



@interface MenuViewController ()

// Submenu
@property (nonatomic, strong) SubmenuViewController *submenuViewController;

@end



@implementation MenuViewController

#pragma mark - Constructor
- (id)init
{
    self = [super initWithNibName:@"MenuViewController" bundle:nil];
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
    
    self.title = @"Menu";
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
    cell.textLabel.text = [NSString stringWithFormat:@"Menu cell %d", indexPath.row];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!_submenuViewController)
        _submenuViewController = [[SubmenuViewController alloc] init];
    
    [self.navigationController pushViewController:_submenuViewController animated:YES];
}

#pragma mark - Memory
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end