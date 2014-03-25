PZSideMenuViewController
========================

##Description

The PZSideMenuViewController allows you to integrate a sliding panel mechanism in your projects

##Installation

There are two ways to use the library in your project:

1) Manually add the library files to your project

- PZSideMenuViewController.h
- PZSideMenuViewController.m
- PZSideMenuProtocol.h

2) Using CocoaPods

```Ruby
pod 'PZSideMenuViewController'
```

##Usage

Create a side menu view controller and give it at least the center view controller
```
// Prepare side menu view controller
_sideMenuViewController = [[PZSideMenuViewController alloc] init];
_sideMenuViewController.centerViewController = [[HomeViewController alloc] init];
```

You can, at any moment give the side menu view controller a left and/or a right side view controller:
```
_sideMenuViewController.leftViewController = [[LeftMenuViewController alloc] init];
_sideMenuViewController.rightViewController = [[RightMenuViewController alloc] init];
```

##Options

```
// Animation variables
@property (nonatomic, assign) CGFloat   zoomScale;
@property (nonatomic, assign) UIOffset  edgeOffset;
@property (nonatomic, assign) CGFloat   duration;

// Shadow variables
@property (nonatomic, strong) UIColor   *shadowColor;
@property (nonatomic, assign) CGFloat   shadowOpacity;
@property (nonatomic, assign) CGFloat   shadowRadius;
```


##Tests

- Works fine with iOS7 on iPhone 3.5" and 4"
- Not tested on iPad

##Contribute

The component has been developed for a single project, feel free to contribute to improve it.
