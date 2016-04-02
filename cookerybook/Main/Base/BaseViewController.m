//
//  BaseViewController.m
//  cookerybook
//
//  Created by hmy2015 on 15/9/29.
//  Copyright (c) 2015年 何米颖大天才. All rights reserved.
//

#import "BaseViewController.h"
#import "LeftView.h"

@interface BaseViewController ()
{
    UIView *_centerView;
}
@end

@implementation BaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (instancetype)initWithMainTabBarController:(MainTabBarController *)mainTabBarController
{
    if (self = [super init])
    {
        self.mainTabBarController = mainTabBarController;
        _centerView = mainTabBarController.view;
        _centerView.frame = self.view.bounds;
        [self.view addSubview:_centerView];
        _isShowLeft = YES;
    }
    return self;
}

- (void)setMainTabBarController:(MainTabBarController *)mainTabBarController
{
    if (_mainTabBarController != mainTabBarController)
    {
        
        if (_mainTabBarController != nil) {
            [_mainTabBarController removeFromParentViewController];
            [_mainTabBarController.view removeFromSuperview];
        }
        
        _mainTabBarController = mainTabBarController;
        [self addChildViewController:_mainTabBarController];
        [self showRight];
    }
}

- (void)setLeftView:(LeftView *)leftView
{
    if (_leftView != leftView)
    {
        _leftView = leftView;
        _leftView.right = 0;
        [self.view addSubview:_leftView];
    }
}

- (void)showLeft
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.3];
    _leftView.left = 0;
    _isShowLeft = NO;
    _centerView.left = _leftView.right;
    [UIView commitAnimations];
}

- (void)showRight
{
    _isShowLeft = YES;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.3];
    _centerView.frame = self.view.bounds;
    _leftView.right = 0;
    [UIView commitAnimations];
}

@end
