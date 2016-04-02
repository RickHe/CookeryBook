//
//  CollectionViewController.m
//  cookerybook
//
//  Created by hmy2015 on 15/10/10.
//  Copyright (c) 2015年 何米颖大天才. All rights reserved.
//

#import "CollectionViewController.h"
#import "BaseViewController.h"
#import "AppDelegate.h"
#import "CookBookTableView.h"
#import "UserDB.h"

@interface CollectionViewController ()
{
    CookBookTableView *_cookBookTableView;
    NSArray *_cookBookModelArray;
}
@end

@implementation CollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the v
    self.view.backgroundColor = [UIColor whiteColor];
    _cookBookTableView = [[CookBookTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self p_loadData];
    [UIView animateWithDuration:.5 animations:^{
        self.navigationController.tabBarController.tabBar.top = kScreenHeight;
    }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [UIView animateWithDuration:.5 animations:^{
        self.navigationController.tabBarController.tabBar.bottom = kScreenHeight;
    }];
}

- (void)p_loadData
{
    _cookBookModelArray = [NSArray array];
    _cookBookModelArray = [UserDB queryUser];
    NSMutableArray *array = [NSMutableArray array];
    for (CookBookModel *model in _cookBookModelArray)
    {
        if (model.isCollection == 1)
        {
            [array addObject:model];
        }
    }
    NSMutableArray *tempArray = [NSMutableArray array];
    for (NSInteger index = array.count - 1; index >= 0; index--)
    {
        [tempArray addObject:array[index]];
    }
    _cookBookTableView.isFirstTabBar = NO;
    if (tempArray.count <= 0)
    {
        _cookBookTableView.hidden = YES;
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"您暂无收藏" message:@"请点击返回" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
    }
    else
    {
        _cookBookTableView.hidden = NO;
    }
    _cookBookTableView.cookBookModelArray = tempArray;
    _cookBookTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    _cookBookTableView.bounces = YES;
    _cookBookTableView.bottom = kScreenHeight;
    [self.view addSubview:_cookBookTableView];
    [_cookBookTableView reloadData];
}

@end
