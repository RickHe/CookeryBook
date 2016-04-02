//
//  BaseViewController.h
//  cookerybook
//
//  Created by hmy2015 on 15/9/29.
//  Copyright (c) 2015年 何米颖大天才. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RightViewController.h"
#import "MainTabBarController.h"
#import "LeftView.h"

@interface BaseViewController : UIViewController

@property (nonatomic, strong) MainTabBarController *mainTabBarController; // 右边视图
@property (nonatomic, strong) LeftView *leftView; // 侧边栏视图
@property (nonatomic, assign) BOOL isShowLeft; // 判断是否显示侧边栏

- (instancetype)initWithMainTabBarController:(MainTabBarController *)mainTabBarController;
- (void)showRight; // 显示右边视图
- (void)showLeft;  // 显示侧边栏

@end
