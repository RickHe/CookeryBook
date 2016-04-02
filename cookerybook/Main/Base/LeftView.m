//
//  LeftView.m
//  cookerybook
//
//  Created by hmy2015 on 15/10/8.
//  Copyright (c) 2015年 何米颖大天才. All rights reserved.
//

#import "LeftView.h"
#import "CollectionViewController.h"
#import "BrowseRecordViewController.h"
#import "UIView+ViewController.h"
#import "BaseViewController.h"
#import "BaseNaviViewController.h"
#import "UserDB.h"
#import "AppDelegate.h"
#import "LoginViewController.h"

@implementation LeftView

- (void)awakeFromNib
{
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.height = kScreenHeight;
}

// 收藏界面跳转
- (IBAction)CollectionAction:(id)sender
{
    CollectionViewController *collectionVC = [[CollectionViewController alloc] init];
    BaseViewController *baseVC = (BaseViewController *)self.viewController;
    [baseVC showRight];
    NSInteger index = baseVC.mainTabBarController.selectedIndex;
    BaseNaviViewController *rightVC = baseVC.mainTabBarController.viewControllers[index];
    [UIView animateWithDuration:.5 animations:^{
        rightVC.tabBarController.tabBar.top = kScreenHeight;
    }];
    [rightVC pushViewController:collectionVC animated:YES];
}

// 浏览记录页面跳转
- (IBAction)browseRecordAction:(id)sender
{
    BrowseRecordViewController *browseRecordVC = [[BrowseRecordViewController alloc] init];
    BaseViewController *baseVC = (BaseViewController *)self.viewController;
    [baseVC showRight];
    NSInteger index = baseVC.mainTabBarController.selectedIndex;
    BaseNaviViewController *rightVC = baseVC.mainTabBarController.viewControllers[index];
    [UIView animateWithDuration:.5 animations:^{
        rightVC.tabBarController.tabBar.top = kScreenHeight;
    }];
    [rightVC pushViewController:browseRecordVC animated:YES];
}

// 删除浏览记录
- (IBAction)clearBrowseRecordAction:(id)sender
{
    [UserDB deleteUsersisCollection:0];
}

// 删除收藏记录
- (IBAction)clearCollectionAction:(id)sender
{
    [UserDB deleteUsersisCollection:1];
}

// 退出登录
- (IBAction)exitLogin:(id)sender {
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"isLoginOrNot"];
    AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    BaseNaviViewController *base = [[BaseNaviViewController alloc] initWithRootViewController:[[LoginViewController alloc] init]];
    app.window.rootViewController = base;
}


@end
