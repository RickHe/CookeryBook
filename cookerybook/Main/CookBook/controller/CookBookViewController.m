//
//  CookBookViewController.m
//  cookerybook
//
//  Created by hmy2015 on 15/9/29.
//  Copyright (c) 2015年 何米颖大天才. All rights reserved.
//

#import "CookBookViewController.h"
#import "AFNetworking.h"
#import "CookBookTableView.h"
#import "CookBookModel.h"
#import "HeadView.h"
#import "MBProgressHUD.h"

@interface CookBookViewController ()
{
    CookBookTableView *_CookBooktableView; // 菜谱表视图
}
@end

@implementation CookBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self p_loadData];
}

// 加载数据
- (void)p_loadData
{
    NSMutableArray *cookBookModelArray = [NSMutableArray array];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *uelString = @"http://apis.haoservice.com/lifeservice/cook/query";
    MBProgressHUD *progress = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:progress];
    [progress show:YES];
    NSMutableDictionary *params = [@{
                                     @"key" : kApiKey,
                                     @"menu" : @"番茄",
                                     @"pn" : @10,
                                     @"rn" : @10
                                     } mutableCopy];
    [manager GET:uelString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
        NSArray *array = responseObject[@"result"];
        for (NSDictionary *dic in array)
        {
            CookBookModel *model = [[CookBookModel alloc] initWithDataDic:dic];
            [cookBookModelArray addObject:model];
        }
        if (_CookBooktableView == nil)
        {
            _CookBooktableView = [[CookBookTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
            _CookBooktableView.isFirstTabBar = YES;
            if (cookBookModelArray.count == 0)
            {
                _CookBooktableView.hidden = YES;
            }
            else
            {
                _CookBooktableView.hidden = NO;
            }
            _CookBooktableView.cookBookModelArray = cookBookModelArray;
            _CookBooktableView.bounces = NO;
            [self.view addSubview:_CookBooktableView];
            _CookBooktableView.backgroundColor = [UIColor redColor];
            
        }
        [progress removeFromSuperview];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@", error);
    }];

}

@end
