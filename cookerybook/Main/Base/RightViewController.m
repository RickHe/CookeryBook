//
//  RightViewController.m
//  cookerybook
//
//  Created by hmy2015 on 15/10/9.
//  Copyright (c) 2015年 何米颖大天才. All rights reserved.
//

#import "RightViewController.h"
#import "AppDelegate.h"

@interface RightViewController ()

@end

@implementation RightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self p_createNaviItem];
}

// 右边主视图为所有视图的父视图
- (void)p_createNaviItem
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 32, 32);
    [btn setBackgroundImage:[UIImage imageNamed:@"note-on"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(p_showLeftViewController) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundImage:[UIImage imageNamed:@"note"] forState:UIControlStateHighlighted];
    UIBarButtonItem *barBtn = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = barBtn;
}

- (void)p_showLeftViewController
{
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    BaseViewController *baseVC = appDelegate.baseViewController;
    if (baseVC.isShowLeft)
    {
        [baseVC showLeft];
    }
    else
    {
        [baseVC showRight];
    }
}

@end
