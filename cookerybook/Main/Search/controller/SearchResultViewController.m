//
//  SearchResultViewController.m
//  cookerybook
//
//  Created by hmy2015 on 15/10/12.
//  Copyright (c) 2015年 何米颖大天才. All rights reserved.
//

#import "SearchResultViewController.h"
#import "CookBookModel.h"
#import "AFNetworking.h"
#import "CookBookTableView.h"
#import "MBProgressHUD.h"

@interface SearchResultViewController ()
{
    CookBookTableView *_CookBooktableView;
}
@end

@implementation SearchResultViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [self p_loadDataWithText:_text];
}

// 加载数据
- (void)p_loadDataWithText:(NSString *)text
{
    NSMutableArray *cookBookModelArray = [NSMutableArray array];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *uelString = @"http://apis.haoservice.com/lifeservice/cook/query";
    
    MBProgressHUD *progress = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:progress];
    [progress show:YES];
    
    NSMutableDictionary *params = [@{
                                     @"key" : kApiKey,
                                     @"menu" : text,
                                     @"pn" : @10,
                                     @"rn" : @10
                                     } mutableCopy];
    [manager GET:uelString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
        NSArray *array = responseObject[@"result"];
        if ([array isKindOfClass:[NSNull class]])
        {
            [progress removeFromSuperview];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"查询无结果" message:@"请点击返回" delegate: self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [_CookBooktableView reloadData];
            [alert show];
            return;
        }
        for (NSDictionary *dic in array)
        {
            CookBookModel *model = [[CookBookModel alloc] initWithDataDic:dic];
            [cookBookModelArray addObject:model];
        }
        if (_CookBooktableView == nil)
        {
            _CookBooktableView = [[CookBookTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64 - 40) style:UITableViewStylePlain];
            _CookBooktableView.backgroundColor = [UIColor cyanColor];
            //_CookBooktableView.bottom = kScreenHeight;
            _CookBooktableView.isFirstTabBar = NO;
            if (cookBookModelArray.count == 0)
            {
                _CookBooktableView.hidden = YES;
            }
            else
            {
                _CookBooktableView.hidden = NO;
            }
        }
        _CookBooktableView.cookBookModelArray = cookBookModelArray;
        _CookBooktableView.bounces = NO;
        [self.view addSubview:_CookBooktableView];
        _CookBooktableView.backgroundColor = [UIColor redColor];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_CookBooktableView reloadData];
        });
        [progress removeFromSuperview];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@", error);
    }];
    
}

@end
