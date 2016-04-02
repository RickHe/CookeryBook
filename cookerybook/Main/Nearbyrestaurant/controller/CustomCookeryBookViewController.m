//
//  CustomCookeryBookViewController.m
//  cookerybook
//
//  Created by hmy2015 on 16/3/25.
//  Copyright © 2016年 何米颖大天才. All rights reserved.
//

#import "CustomCookeryBookViewController.h"
#import "NewCookeryBookViewController.h"
#import "YourCookeryBookViewController.h"
#import "UIColor+Expend.h"

@interface CustomCookeryBookViewController () <UITableViewDelegate, UITableViewDataSource>
{
    NSArray *_datas;
}

@property (weak, nonatomic) IBOutlet UITableView *CustomTableView;

@end

@implementation CustomCookeryBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _CustomTableView.backgroundColor = [UIColor whiteColor];
    _datas = @[@"添加菜谱", @"删除菜谱", @"修改菜谱", @"查看菜谱"];
    _CustomTableView.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0);
    _CustomTableView.tableFooterView = [UIView new];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]){
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.textLabel.text = _datas[indexPath.row];
    cell.textLabel.textColor = [UIColor darkGrayColor];
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        NewCookeryBookViewController *newCookeryBookVC = [[NewCookeryBookViewController alloc] init];
        self.title = _datas[0];
        [self.navigationController pushViewController:newCookeryBookVC animated:YES];
    } else {
        YourCookeryBookViewController *yourCookeryBookVC = [[YourCookeryBookViewController alloc] init];
        yourCookeryBookVC.title = _datas[indexPath.row];
        [self.navigationController pushViewController:yourCookeryBookVC animated:YES];
    }
}

@end
