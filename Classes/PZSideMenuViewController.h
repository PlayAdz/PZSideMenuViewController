//
//  PZSideMenuViewController.h
//  PZSideMenuViewController
//
//  Created by Cyril CHANDELIER on 3/10/14.
//  Copyright (c) 2014 Cyril Chandelier. All rights reserved.
//

@interface PZSideMenuViewController : UIViewController <UIGestureRecognizerDelegate>

// Open / Close side view controllers
- (void)openLeftSideViewControllerAnimated:(BOOL)animated;
- (void)openRightSideViewControllerAnimated:(BOOL)animated;
- (void)closeSideViewController;

// Present center view controller
- (void)presentCenterViewController:(UIViewController *)aViewController;

// View controllers
@property (nonatomic, strong) UIViewController *centerViewController;
@property (nonatomic, strong) UIViewController *leftViewController;
@property (nonatomic, strong) UIViewController *rightViewController;

// Animation variables
@property (nonatomic, assign) CGFloat   zoomScale;
@property (nonatomic, assign) UIOffset  edgeOffset;
@property (nonatomic, assign) CGFloat   duration;

// Shadow variables
@property (nonatomic, strong) UIColor   *shadowColor;
@property (nonatomic, assign) CGFloat   shadowOpacity;
@property (nonatomic, assign) CGFloat   shadowRadius;

@end