//
//  SearchViewController.m
//  cookerybook
//
//  Created by hmy2015 on 15/9/29.
//  Copyright (c) 2015年 何米颖大天才. All rights reserved.
//

#import "SearchViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "CookBookModel.h"
#import "CookBookTableView.h"
#import "SearchResultViewController.h"

#define kSearchHistoryTextArray @"SearchHistoryTextArray"

@interface SearchViewController () <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>
{
    
    UISearchBar *_searchBar;
    UITableView *_searchHistoryTable;
    NSMutableArray *_searchHistoryTextArray;
}
@end

@implementation SearchViewController

#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    _searchHistoryTextArray = [NSMutableArray array];
    [self p_createViews];
}

// 创建表视图,和搜索框
- (void)p_createViews
{
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(10, 69, kScreenWidth - 20, 30)];
    _searchBar.delegate = self;
    _searchBar.backgroundColor = [UIColor cyanColor];
    _searchBar.barTintColor = [UIColor whiteColor];
    _searchBar.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _searchBar.layer.borderWidth = .5;
    _searchBar.layer.cornerRadius = 5;
    _searchBar.layer.masksToBounds = YES;
    _searchBar.placeholder = @"请输入关键字";
    _searchBar.showsSearchResultsButton = YES;
    [self.view addSubview:_searchBar];
    
    _searchHistoryTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 100, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
    _searchHistoryTable.delegate = self;
    _searchHistoryTable.dataSource = self;
    [_searchHistoryTable registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    _searchHistoryTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    _searchHistoryTable.tableFooterView =[[UIView alloc]init];
    [self.view addSubview:_searchHistoryTable];
}

// 加载本地化数据
- (void)viewWillAppear:(BOOL)animated
{
    NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:kSearchHistoryTextArray];
    if (array.count > 0 || array != nil)
    {
        
    }
    else
    {
        _searchHistoryTextArray = [NSMutableArray arrayWithArray:array];
    }
    [_searchHistoryTable reloadData];
}

#pragma mark - delegate tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _searchHistoryTextArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"浏览记录";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, kScreenWidth - 20, 30)];
    textLabel.text = _searchHistoryTextArray[indexPath.row];
    textLabel.font = [UIFont systemFontOfSize:13];
    textLabel.textColor = [UIColor darkGrayColor];
    [cell.contentView addSubview:textLabel];
    //cell.textLabel.text = _searchHistoryTextArray[indexPath.row];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 100, 20)];
    textLabel.text = @"   浏览记录:";
    textLabel.font = [UIFont systemFontOfSize:13];
    textLabel.textColor = [UIColor lightGrayColor];
    return textLabel;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SearchResultViewController *resultVC = [[SearchResultViewController alloc] init];
    resultVC.text = _searchHistoryTextArray[indexPath.row];
    [self.navigationController pushViewController:resultVC animated:YES];
}

#pragma mark - delegate searchBar
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [UIView animateWithDuration:0.5 animations:^{
        searchBar.frame = CGRectMake(10, 69, kScreenWidth - 20, 30);
    }];
    SearchResultViewController *resultVC = [[SearchResultViewController alloc] init];
    resultVC.text = searchBar.text;
    [self.navigationController pushViewController:resultVC animated:YES];
    [searchBar resignFirstResponder];
    
    [_searchHistoryTextArray addObject:searchBar.text];
    [[NSUserDefaults standardUserDefaults] setObject:_searchHistoryTextArray forKey:kSearchHistoryTextArray];
}

- (void)searchBarResultsListButtonClicked:(UISearchBar *)searchBar
{
    [UIView animateWithDuration:1.0 animations:^{
        searchBar.top = 69;
        searchBar.height = 30;
    }];
    SearchResultViewController *resultVC = [[SearchResultViewController alloc] init];
    resultVC.text = searchBar.text;
    [self.navigationController pushViewController:resultVC animated:YES];
    [searchBar resignFirstResponder];
    
    [_searchHistoryTextArray addObject:searchBar.text];
    [[NSUserDefaults standardUserDefaults] setObject:_searchHistoryTextArray forKey:kSearchHistoryTextArray];
}

@end
