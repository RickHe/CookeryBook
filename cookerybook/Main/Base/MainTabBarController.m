//
//  MainTabBarController.m
//  cookerybook
//
//  Created by hmy2015 on 15/9/29.
//  Copyright (c) 2015年 何米颖大天才. All rights reserved.
//

#import "MainTabBarController.h"
#import "BaseNaviViewController.h"
#import "BaseViewController.h"

@interface MainTabBarController ()

@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self p_createViewControllers];
}

- (void)p_createViewControllers
{
    // 添加新的 tabbarItem
    NSArray *buttonImageName = @[
                                 @"48-fork-and-knife",
                                 @"hot",
                                 @"06-magnify",
                                 @"20-gear-2"
                                 ];
    NSArray *titles = @[@"菜谱",
                        @"类别",
                        @"搜索",
                        @"自定义"];
    NSArray *buttonHighLightImageName = @[
                                          @"48-fork-and-knife-on",
                                          @"hot-on",
                                          @"06-magnify-on",
                                          @"20-gear-2-on"
                                          ];
    NSArray *viewControllerNames = @[
                                     @"CookBook",
                                     @"Hot",
                                     @"Search",
                                     @"Nearby"
                                     ];
    NSMutableArray *viewCtrls = [NSMutableArray array];
    for (int i = 0; i < viewControllerNames.count; i++)
    {
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:viewControllerNames[i] bundle:nil];
        BaseNaviViewController *baseNavi = [storyBoard instantiateInitialViewController];
        [viewCtrls addObject:baseNavi];
        baseNavi.tabBarItem.image = [UIImage imageNamed:buttonImageName[i]];
        RightViewController *vc = [baseNavi.viewControllers lastObject];
        vc.title = titles[i];
        baseNavi.tabBarItem.title = titles[i];
        baseNavi.tabBarItem.selectedImage = [UIImage imageNamed:buttonHighLightImageName[i]];
    }
    self.viewControllers = viewCtrls;
}

@end
