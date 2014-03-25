//
//  PZSideMenuProtocol.h
//  MyMonteCarlo
//
//  Created by Cyril CHANDELIER on 3/19/14.
//  Copyright (c) 2014 PlayAdz. All rights reserved.
//

@class PZSideMenuViewController;



@protocol PZSideMenuProtocol <NSObject>

@optional
- (void)viewWillReduceFromLeft:(NSNumber *)fromLeft;
- (void)viewDidReduceFromLeft:(NSNumber *)fromLeft;
- (void)viewWillGrow;
- (void)viewDidGrow;

@end
