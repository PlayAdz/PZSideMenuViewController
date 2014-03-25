//
//  AppDelegate.h
//  PZSideMenuViewController
//
//  Created by Cyril CHANDELIER on 3/25/14.
//  Copyright (c) 2014 PlayAdz. All rights reserved.
//

@class RootViewController;



@interface AppDelegate : UIResponder <UIApplicationDelegate>

// Window
@property (strong, nonatomic) UIWindow *window;

// Root view controller
@property (nonatomic, strong, readonly) RootViewController *rootViewController;

@end
