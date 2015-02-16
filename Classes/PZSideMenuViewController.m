    //
//  PZSideMenuViewController.m
//  PZSideMenuViewController
//
//  Created by Cyril CHANDELIER on 3/10/14.
//  Copyright (c) 2014 Cyril Chandelier. All rights reserved.
//

#import "PZSideMenuViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "PZSideMenuProtocol.h"



#define kAnimationDuration   0.25f



@interface PZSideMenuViewController ()

// Current view controller
@property (nonatomic, strong) UIViewController *currentSideViewController;

// Gesture recognizers
@property (nonatomic, strong) UITapGestureRecognizer *centerTapGestureRecognizer;
@property (nonatomic, strong) UIPanGestureRecognizer *centerPanGestureRecognizer;

// Flags
@property (nonatomic, assign) BOOL leftSideOpen;
@property (nonatomic, assign) BOOL rightSideOpen;

@end



@implementation PZSideMenuViewController

#pragma mark - Constructor
- (id)init
{
    if (self = [super init])
    {
        // Default configuration
        [self defaultConfiguration];
    }
    
    return self;
}

- (id)initWithCenterViewController:(UIViewController *)centerViewController
{
    if (self = [super init])
    {
        // Default configuration
        [self defaultConfiguration];
        
        // Hold view controller
        self.centerViewController = centerViewController;
    }
    
    return self;
}

#pragma mark - Defaults
- (void)defaultConfiguration
{
    // Default values
    _zoomScale = 0.8f;
    _edgeOffset = (UIOffset) {
        .horizontal = 110.0f
    };
    _duration = kAnimationDuration;
    _shadowColor = [UIColor blackColor];
    _shadowRadius = 10.0f;
    _shadowOpacity = 0.4f;
    _gestureEnabled = YES;
}

#pragma mark - View management
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Manage center view controller
    NSAssert(_centerViewController != nil, @"Center view controller can't be nil");
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Display views and apply transforms in needed
    if (![_centerViewController.view superview])
    {
        // Prepare and display center
        [self prepareAndDisplayCenterViewControllerWithTransform:CGAffineTransformIdentity];
        
        if (_leftSideOpen)
            [self openLeftSideViewControllerAnimated:NO completion:nil];
        else if (_rightSideOpen)
            [self openRightSideViewControllerAnimated:NO completion:nil];
    }
}

#pragma mark - Public opening / closing methods
- (void)openLeftSideViewControllerAnimated:(BOOL)animated completion:(void (^)(void))completionBlock
{
    [self openChildView:[self leftView] left:YES animated:animated completion:completionBlock];
}

- (void)openRightSideViewControllerAnimated:(BOOL)animated completion:(void (^)(void))completionBlock
{
    [self openChildView:[self rightView] left:NO animated:animated completion:completionBlock];
}

- (void)openChildView:(UIView *)childView left:(BOOL)left animated:(BOOL)animated completion:(void (^)(void))completionBlock
{
    // Prevent empty view to start animation
    if (!childView)
        return;
    
    // Sent it to back
    [self.view sendSubviewToBack:childView];
    
    // Warn that view controller will grow
    if ([_centerViewController conformsToProtocol:@protocol(PZSideMenuProtocol)] && [_centerViewController respondsToSelector:@selector(viewWillReduceFromLeft:)])
        [_centerViewController performSelector:@selector(viewWillReduceFromLeft:) withObject:@(left)];
    
    // Add shadow
    [self addCenterViewControllerShadow];
    
    // Determine view controller to display
    UIViewController *viewControllerToDisplay = (left) ? self.leftViewController : self.rightViewController;
    
    // Final block
    void (^finalBlock)(BOOL) = ^(BOOL finished) {
            // Flag
            if (left)
                _leftSideOpen = YES;
            else
                _rightSideOpen = YES;
            
            // Warn that view controller will grow
            if ([_centerViewController conformsToProtocol:@protocol(PZSideMenuProtocol)] && [_centerViewController respondsToSelector:@selector(viewDidReduceFromLeft:)])
                [_centerViewController performSelector:@selector(viewDidReduceFromLeft:) withObject:@(left)];
            
            // Execute completion block
            if (completionBlock)
                completionBlock();
    };
    
    // Animable part
    if (animated)
    {
        [UIView animateWithDuration:_duration
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             // Position
                             viewControllerToDisplay.view.transform = CGAffineTransformIdentity;
                             self.centerViewController.view.transform = [self openTransformForView:_centerViewController.view left:left];
                         }
                         completion:finalBlock];
    }
    else
    {
        // Position
        viewControllerToDisplay.view.transform = CGAffineTransformIdentity;
        self.centerViewController.view.transform = [self openTransformForView:_centerViewController.view left:left];
        
        // Execute final block
        finalBlock(YES);
    }
}

- (void)closeSideViewControllerAnimated:(BOOL)animated completion:(void (^)(void))completionBlock
{
    void (^finalBlock)(BOOL) = ^(BOOL finished) {
        // Remove from superview
        [_currentSideViewController.view removeFromSuperview];
        
        // Remove from parent view controller
        [_currentSideViewController removeFromParentViewController];
        
        // Release view controller
        _currentSideViewController = nil;
        
        // Flag
        _leftSideOpen = _rightSideOpen = NO;
        
        // Warn that view controller did grow
        if ([_centerViewController conformsToProtocol:@protocol(PZSideMenuProtocol)] && [_centerViewController respondsToSelector:@selector(viewDidGrow)])
            [_centerViewController performSelector:@selector(viewDidGrow) withObject:nil];
        
        // Post did close notification
        [[NSNotificationCenter defaultCenter] postNotificationName:PZ_SIDE_MENU_VIEW_CONTROLLER_DID_CLOSE_NOTIFICATION object:nil];
        
        // Execute completion block
        if (completionBlock)
            completionBlock();
    };
    
    // Remove gesture recognizer
    [_centerTapGestureRecognizer.view removeFromSuperview];
    _centerTapGestureRecognizer = nil;
    
    // Warn that view controller will grow
    if ([_centerViewController conformsToProtocol:@protocol(PZSideMenuProtocol)] && [_centerViewController respondsToSelector:@selector(viewWillGrow)])
        [_centerViewController performSelector:@selector(viewWillGrow) withObject:nil];
    
    // Add shadow
    [self removeCenterViewControllerShadow];
    
    // Post will close notification
    [[NSNotificationCenter defaultCenter] postNotificationName:PZ_SIDE_MENU_VIEW_CONTROLLER_WILL_CLOSE_NOTIFICATION object:nil];
    
    // Animable part
    if (animated)
    {
        // Animate
        [UIView animateWithDuration:_duration
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             // Reset transform
                             self.centerViewController.view.transform = CGAffineTransformIdentity;
                         }
                         completion:finalBlock];
    }
    else
    {
        // Reset transform
        self.centerViewController.view.transform = CGAffineTransformIdentity;
        
        // Execute completion block
        finalBlock(YES);
    }
}

- (void)presentCenterViewController:(UIViewController *)aViewController animated:(BOOL)animated
{
    if (aViewController != _centerViewController)
    {
        // Reset display view controller transform
        CGAffineTransform transform = aViewController.view.transform = CGAffineTransformIdentity;
        
        if ([_centerViewController.view superview])
        {
            // Compute frame
            transform = _centerViewController.view.transform;
            
            // Remove old view controller
            [_centerViewController.view removeFromSuperview];
            [_centerViewController removeFromParentViewController];
        }
        
        // Hold as new center view controller
        _centerViewController = aViewController;
        
        // Display center
        [self prepareAndDisplayCenterViewControllerWithTransform:transform];
    }
    
    // Close side panel
    [self closeSideViewControllerAnimated:animated completion:nil];
}

#pragma mark - Animations
- (CGAffineTransform)openTransformForView:(UIView *)view left:(BOOL)left
{
    // Transform variables
    CGFloat transformSize = _zoomScale;
    
    // Transform
    CGAffineTransform newTransform;
    
    if (left)
        newTransform = CGAffineTransformTranslate(view.transform, CGRectGetMidX(view.bounds) + _edgeOffset.horizontal, _edgeOffset.vertical);
    else
        newTransform = CGAffineTransformTranslate(view.transform, -(CGRectGetMidX(view.bounds) + _edgeOffset.horizontal), _edgeOffset.vertical);
    
    return CGAffineTransformScale(newTransform, transformSize, transformSize);
}

- (CGAffineTransform)closeTransformForMenuView:(BOOL)left
{
    // Transform variables
    CGFloat transformSize = 1.0f / _zoomScale;

    // Transform
    CGAffineTransform transform = CGAffineTransformScale(self.centerViewController.view.transform, transformSize, transformSize);

    if (left)
        return CGAffineTransformTranslate(transform, -(CGRectGetMidX(self.view.bounds)) - _edgeOffset.horizontal, -_edgeOffset.vertical);
    else
        return CGAffineTransformTranslate(transform, (CGRectGetMidX(self.view.bounds)) + _edgeOffset.horizontal, _edgeOffset.vertical);
}

#pragma mark - Shadow
- (void)addCenterViewControllerShadow
{
    // Rect
    CGRect rect = _centerViewController.view.layer.bounds;
    rect.origin.y -= 10.0f;
    rect.size.width += 20.0f;
    rect.size.height += 20.0f;
    
    // Shadow
    _centerViewController.view.layer.shadowPath = [UIBezierPath bezierPathWithRect:rect].CGPath;
    _centerViewController.view.layer.shadowColor = _shadowColor.CGColor;
    _centerViewController.view.layer.shadowOffset = CGSizeMake(-10.0f, 0);
    _centerViewController.view.layer.shadowRadius = _shadowRadius;
    
    // Animation
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"shadowOpacity"];
    anim.fromValue = [NSNumber numberWithFloat:0.0];
    anim.toValue = [NSNumber numberWithFloat:_shadowOpacity];
    anim.duration = _duration;
    [_centerViewController.view.layer addAnimation:anim forKey:@"shadowOpacity"];
    _centerViewController.view.layer.shadowOpacity = _shadowOpacity;
}

- (void)removeCenterViewControllerShadow
{
    // Animation
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"shadowOpacity"];
    anim.fromValue = [NSNumber numberWithFloat:_shadowOpacity];
    anim.toValue = [NSNumber numberWithFloat:0.0];
    anim.duration = _duration;
    [_centerViewController.view.layer addAnimation:anim forKey:@"shadowOpacity"];
    _centerViewController.view.layer.shadowOpacity = 0.0;
}

#pragma mark - Gesture recognizers
- (void)centerViewTapped:(UIGestureRecognizer *)gestureRecognizer
{
    if (!_currentSideViewController)
        return;
    
    // Close side view controller
    [self closeSideViewControllerAnimated:YES completion:nil];
}

- (void)movePanel:(UIPanGestureRecognizer *)sender
{
    CGPoint velocity = [(UIPanGestureRecognizer *)sender velocityInView:[sender view]];
    
    // Gesture ended
    if([(UIPanGestureRecognizer *)sender state] == UIGestureRecognizerStateEnded)
    {
        if(velocity.x > 0)
            [self openLeftSideViewControllerAnimated:YES completion:nil];
        else
            [self openRightSideViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - UIGestureRecognizerDelegate methods
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (_centerPanGestureRecognizer && (_leftSideOpen || _rightSideOpen))
        return NO;
    
    return YES;
}

#pragma mark - Getters
- (UIView *)leftView
{
    if (!_leftViewController)
        return nil;
    
    // Prepare view controller
    [self prepareViewController:_leftViewController];
    
    return _leftViewController.view;
}

- (UIView *)rightView
{
    if (!_rightViewController)
        return nil;
    
    // Prepare view controller
    [self prepareViewController:_rightViewController];
    
    return _rightViewController.view;
}

#pragma mark - Utils
- (void)prepareViewController:(UIViewController *)aViewController
{
    // Add view as subview
    [self.view addSubview:aViewController.view];
    
    // View controller containment
    [self addChildViewController:aViewController];
    
    // Current side view controller
    self.currentSideViewController = aViewController;
    
    // Resize view
    aViewController.view.frame = self.view.bounds;
    
    // Gesture recognizer
    _centerTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(centerViewTapped:)];
    _centerTapGestureRecognizer.cancelsTouchesInView = YES;
    UIView *tappableView = [[UIView alloc] initWithFrame:_centerViewController.view.frame];
    tappableView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [tappableView addGestureRecognizer:_centerTapGestureRecognizer];
    [_centerViewController.view addSubview:tappableView];
}

- (void)prepareAndDisplayCenterViewControllerWithTransform:(CGAffineTransform)transform
{
    if (_gestureEnabled)
    {
        // Add gestures
        _centerPanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(movePanel:)];
        [_centerPanGestureRecognizer setMinimumNumberOfTouches:1];
        [_centerPanGestureRecognizer setMaximumNumberOfTouches:1];
        [_centerPanGestureRecognizer setDelegate:self];
        
        [_centerViewController.view addGestureRecognizer:_centerPanGestureRecognizer];
    }
    
    // Add center view as subview
    [self.view addSubview:_centerViewController.view];
    
    // Resize center view
    _centerViewController.view.frame = self.view.frame;
    _centerViewController.view.transform = transform;
    
    // View controller containment
    [self addChildViewController:_centerViewController];
}

@end