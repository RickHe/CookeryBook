//
//  AppDelegate.m
//  cookerybook
//
//  Created by hmy2015 on 15/9/29.
//  Copyright (c) 2015年 何米颖大天才. All rights reserved.
//

#import "AppDelegate.h"
#import "UserDB.h"
#import "MainTabBarController.h"
#import "CookBookModel.h"
#import <BmobSDK/Bmob.h>
#import "GuideViewController.h"
#import "LoginViewController.h"
#import "BaseNaviViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // 设置主 window
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    [self p_isFirstLuachtheApp];
    
    [self p_test];
    
    // 注册bomb服务
    [Bmob registerWithAppKey:@"e6b577e78d9a9f4fc9b837a8dffdcb00"];
    return YES;
}

- (void)p_isFirstLuachtheApp {
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"isFirstStart"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isFirstStart"];
        self.window.rootViewController = [[GuideViewController alloc] init];
    } else {
        [self p_isLoginOrNot];
    }
}

- (void)p_isLoginOrNot {
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    NSString *str = [user objectForKey:@"isLoginOrNot"];
    if ([str isEqualToString:@"1"]) {
        [user setObject:@"1" forKey:@"isLoginOrNot"];
       [self jumpToMainVC];
    }else if ([str isEqualToString:@"0"]){
        BaseNaviViewController *base = [[BaseNaviViewController alloc] initWithRootViewController:[[LoginViewController alloc] init]];
        self.window.rootViewController= base;
        [user setObject:@"0" forKey:@"isLoginOrNot"];
    }else{
        [user setObject:@"0" forKey:@"isLoginOrNot"];
    }
}

- (void)jumpToMainVC {
    MainTabBarController *mainTabBarContrller = [[MainTabBarController alloc]init];
    _baseViewController = [[BaseViewController alloc] initWithMainTabBarController:mainTabBarContrller];
    NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"LeftView" owner:nil options:nil];
    _baseViewController.leftView = [arr lastObject];
    self.window.rootViewController = _baseViewController;
  
    
    // 创建数据库,看是否存在
    NSString *filePath = [UserDB filePath];
    NSFileManager *manager = [NSFileManager defaultManager];
    if(![manager fileExistsAtPath:filePath])
    {
        [UserDB createTable];
    }
}

- (void)p_test
{
//    CookBookModel *model = [[CookBookModel alloc] init];
//    model.title = @"test";
//    model.tags = @"不错不错";
//    model.foodId = @"可以的";
//    model.albums = @"test";
//    [UserDB addUser:model];
    NSArray *arr = [UserDB queryUser];
    NSLog(@"%@", arr);
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
