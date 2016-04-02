//
//  CookBookTableView.m
//  cookerybook
//
//  Created by hmy2015 on 15/10/9.
//  Copyright (c) 2015年 何米颖大天才. All rights reserved.
//

#import "CookBookTableView.h"
#import "CookBookTableViewCell.h"
#import "HeadView.h"
#import "DetailCookBookViewController.h"
#import "UIView+ViewController.h"

@interface CookBookTableView () <UITableViewDelegate, UITableViewDataSource>


@end

@implementation CookBookTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    if (self = [super initWithFrame:frame style:style])
    {
        [self p_init];
    }
    return self;
}

- (void)setIsFirstTabBar:(BOOL)isFirstTabBar
{
    if (_isFirstTabBar != isFirstTabBar)
    {
        _isFirstTabBar = isFirstTabBar;
        if (_isFirstTabBar) {
            // 头视图
            HeadView *headView = [[HeadView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
            __weak CookBookTableView *weakSelf = self;
            headView.reloadTableViewBlock = ^(NSArray *arr){
                __strong CookBookTableView *strongSelf = weakSelf;
                strongSelf->_cookBookModelArray = arr;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self reloadData];
                });
            };
            self.tableHeaderView = headView;
        }
    }
}

- (void)p_init
{
    self.delegate = self;
    self.dataSource = self;
    [self registerNib:[UINib nibWithNibName:@"CookBookTableViewCell" bundle:nil] forCellReuseIdentifier:@"cookBookCell"];


   // [self addSubview:headView];
}

#pragma mark - delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _cookBookModelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CookBookTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cookBookCell"];
    cell.cookBookModel = _cookBookModelArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 72;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailCookBookViewController *detailVC = [[DetailCookBookViewController alloc] init];
    CookBookModel *model = _cookBookModelArray[indexPath.row];
    detailVC.cookBookModel = model;
    [self.viewController.navigationController pushViewController:detailVC animated:YES];
}

@end
