//
//  PZSideMenuViewController.h
//  PZSideMenuViewController
//
//  Created by Cyril CHANDELIER on 3/10/14.
//  Copyright (c) 2014 Cyril Chandelier. All rights reserved.
//

// Notifications
#define PZ_SIDE_MENU_VIEW_CONTROLLER_WILL_CLOSE_NOTIFICATION @"PZ_SIDE_MENU_VIEW_CONTROLLER_WILL_CLOSE_NOTIFICATION"
#define PZ_SIDE_MENU_VIEW_CONTROLLER_DID_CLOSE_NOTIFICATION  @"PZ_SIDE_MENU_VIEW_CONTROLLER_DID_CLOSE_NOTIFICATION"

@interface PZSideMenuViewController : UIViewController <UIGestureRecognizerDelegate>

// Constructors
- (id)init;
- (id)initWithCenterViewController:(UIViewController *)centerViewController;

// Open / Close side view controllers
- (void)openLeftSideViewControllerAnimated:(BOOL)animated completion:(void(^)(void))completionBlock;
- (void)openRightSideViewControllerAnimated:(BOOL)animated completion:(void(^)(void))completionBlock;
- (void)closeSideViewControllerAnimated:(BOOL)animated completion:(void(^)(void))completionBlock;

// Present center view controller
- (void)presentCenterViewController:(UIViewController *)aViewController animated:(BOOL)animated;

// Gestur recognizer
@property (nonatomic, strong, readonly) UIPanGestureRecognizer *centerPanGestureRecognizer;

// Enable swipe gesture
@property (nonatomic, assign, getter = isGestureEnabled) BOOL gestureEnabled;

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