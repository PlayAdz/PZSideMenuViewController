//
//  DetailViewController.h
//  PZSideMenuViewController
//
//  Created by Cyril CHANDELIER on 3/25/14.
//  Copyright (c) 2014 PlayAdz. All rights reserved.
//

#import "PZSideMenuProtocol.h"



@interface DetailViewController : UIViewController <PZSideMenuProtocol>

// Property
@property (nonatomic, assign) NSInteger number;

@end