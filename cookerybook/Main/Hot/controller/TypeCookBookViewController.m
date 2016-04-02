//
//  TypeCookBookViewController.m
//  cookerybook
//
//  Created by hmy2015 on 15/10/9.
//  Copyright (c) 2015年 何米颖大天才. All rights reserved.
//

#import "TypeCookBookViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "CookBookModel.h"
#import "CookBookTableView.h"

@interface TypeCookBookViewController ()
{
     CookBookTableView *_CookBooktableView; // 菜谱表视图
}
@end

@implementation TypeCookBookViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)setTypeModel:(TypeModel *)typeModel
{
    if (_typeModel != typeModel)
    {
        _typeModel = typeModel;
        [self p_loadData];
    }
}

// 加载数据
- (void)p_loadData
{
    NSMutableArray *cookBookModelArray = [NSMutableArray array];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *uelString = @"http://apis.haoservice.com/lifeservice/cook/index";
    MBProgressHUD *progress = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:progress];
    [progress show:YES];
    
    NSMutableDictionary *params = [@{
                                     @"key" : kApiKey,
                                     @"cid" : _typeModel.typeId,
                                     @"pn" : @"1",
                                     @"rn" : @"20"
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
            _CookBooktableView.isFirstTabBar = NO;
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
