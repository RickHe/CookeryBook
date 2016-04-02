//
//  DetailCookBookViewController.m
//  cookerybook
//
//  Created by hmy2015 on 15/10/9.
//  Copyright (c) 2015年 何米颖大天才. All rights reserved.
//

// 明天完成数据持久化
// coreData

#import "DetailCookBookViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "DetailCookBookModel.h"
#import "DetailCookBookTableViewCell.h"
#import "DetailHeadViewModel.h"
#import "DetailHeadView.h"
#import "UserDB.h"
#import "StepDetailViewController.h"

@interface DetailCookBookViewController () <UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_detailTableView;             // 详情表视图
    NSMutableArray *_deatilBookModelArray;     // 详情表视图数据
    DetailHeadViewModel *_detailHeadViewModel; // 详情透视图数据
    DetailHeadView *_headView;                  // 详情透视图
}
@end

@implementation DetailCookBookViewController

#pragma - lifeCycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"详情";
    
    [self p_createViews];
}

- (void)viewWillAppear:(BOOL)animated
{
    [UIView animateWithDuration:.5 animations:^{
        self.navigationController.tabBarController.tabBar.top = kScreenHeight;
    }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [UIView animateWithDuration:.5 animations:^{
        self.navigationController.tabBarController.tabBar.bottom = kScreenHeight;
    }];
    // 浏览记录
    [UserDB addUser:_cookBookModel];
    if (_cookBookModel.isCollection == 1)
    {
        //_cookBookModel.isCollection = 0;
        [UserDB addUser:_cookBookModel];
    }
    else
    {
        [UserDB deleteUser:_cookBookModel];
    }
}

#pragma mark - other
- (void)collectionAction:(UIButton *)btn
{
    btn.selected = !btn.selected;
    if (btn.selected)
    {
        self.cookBookModel.isCollection = 1;
    }
    else
    {
        self.cookBookModel.isCollection = 0;
    }
}

- (void)setCookBookModel:(CookBookModel *)cookBookModel
{
    if (_cookBookModel != cookBookModel)
    {
        _cookBookModel = cookBookModel;
        [self p_loadData];
    }
}

// 创建视图
- (void)p_createViews
{
    // 加载完成数据后用表视图显示
    _detailTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _detailTableView.delegate = self;
    _detailTableView.dataSource = self;
    _detailTableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    _detailTableView.bounces = YES;
    [_detailTableView registerNib:[UINib nibWithNibName:@"DetailCookBookTableViewCell" bundle:nil] forCellReuseIdentifier:@"detailCell"];
    [self.view addSubview:_detailTableView];
    
    // 头视图
    NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"DetailHeadView" owner:nil options:nil];
    _headView = (DetailHeadView *)[arr lastObject];
    _detailTableView.tableHeaderView = _headView;
    _headView.yOffSet = 0;
    
    // 创建收藏按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 80, 80);
    [btn setTitle:@"收藏" forState:UIControlStateNormal];
    [btn setFont:[UIFont systemFontOfSize:11]];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"playing_btn_in_myfavor_h"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"playing_btn_in_myfavor"] forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(collectionAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    // 读取数据看是否收藏
    NSArray *array = [UserDB queryUser];
    for (CookBookModel *model in array)
    {
        if ([model.foodId isEqualToString:_cookBookModel.foodId])
        {
            if (model.isCollection == 1)
            {
                btn.selected = YES;
            }
        }
    }
}

// 加载数据
- (void)p_loadData
{
    _deatilBookModelArray = [NSMutableArray array];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *uelString = @"http://apis.haoservice.com/lifeservice/cook/queryid";
    MBProgressHUD *progress = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:progress];
    [progress show:YES];
    NSMutableDictionary *params = [@{
                                     @"key" : kApiKey,
                                     @"id" : _cookBookModel.foodId
                                     } mutableCopy];
    [manager GET:uelString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
        NSDictionary *result = responseObject[@"result"];
        
        _detailHeadViewModel = [[DetailHeadViewModel alloc] initWithDataDic:result];
        
        NSArray *array = result[@"steps"];
        for (NSDictionary *dic in array)
        {
            DetailCookBookModel *model = [[DetailCookBookModel alloc] initWithDataDic:dic];
            [_deatilBookModelArray addObject:model];
        }
        
        [progress removeFromSuperview];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (_deatilBookModelArray.count == 0)
            {
                _detailTableView.hidden = YES;
            }
            else
            {
                _detailTableView.hidden = NO;
            }

            [_detailTableView reloadData];
            _headView.detailHeadViewModel = _detailHeadViewModel;
        });
        [UserDB addUser:_cookBookModel];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@", error);
    }];
}

#pragma mark - delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _deatilBookModelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailCookBookTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detailCell"];
    cell.detailCookBookModel = _deatilBookModelArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"%f", scrollView.contentOffset.y);
    if (scrollView.contentOffset.y < -64)
    {
        _headView.yOffSet = -(scrollView.contentOffset.y + 64);
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    StepDetailViewController *stepDetailVC = [[StepDetailViewController alloc] init];
    stepDetailVC.detailCookBookArray = _deatilBookModelArray;
    stepDetailVC.currentStep = indexPath.row;
    [self.navigationController pushViewController:stepDetailVC animated:YES];
}

@end
