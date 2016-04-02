//
//  YourCookeryBookViewController.m
//  cookerybook
//
//  Created by hmy2015 on 16/3/26.
//  Copyright © 2016年 何米颖大天才. All rights reserved.
//

#import "YourCookeryBookViewController.h"
#import <BmobSDK/Bmob.h>
#import "NewCookeryBookModel.h"
#import "AFNetworking.h"
#import "OneStepModel.h"
#import "CookBookModel.h"
#import "CookBookTableView.h"
#import "CookBookTableViewCell.h"
#import "MBProgressHUD.h"
#import "CheckCookeryViewController.h"
#import "UpdateCookeryViewController.h"
#import "ModifyCookeryViewController.h"

@interface YourCookeryBookViewController () <UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray *_cookeryLists;
    UITableView *_cookerylistsTableView;
}
@end

@implementation YourCookeryBookViewController

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
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _cookeryLists = [NSMutableArray new];
    [self p_createViews];
    [self p_loadData];
}

- (void)p_createViews {
    _cookerylistsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) style:UITableViewStylePlain];
    _cookerylistsTableView.delegate = self;
    _cookerylistsTableView.dataSource = self;
    [_cookerylistsTableView registerNib:[UINib nibWithNibName:@"CookBookTableViewCell" bundle:nil] forCellReuseIdentifier:@"cookBookCell"];
    [self.view addSubview:_cookerylistsTableView];
    _cookerylistsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _cookerylistsTableView.tableFooterView = [UIView new];
}

- (void)p_loadData {
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"CookeryInfo"];
    MBProgressHUD *progress = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:progress];
    [progress show:YES];
    //查找GameScore表里面所有数据
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        for (int i = 0; i < array.count; i++) {
            BmobObject *obj = array[i];
            NewCookeryBookModel *model = [NewCookeryBookModel new];
            model.title = [obj objectForKey:@"title"];
            model.tags = [obj objectForKey:@"tags"];
            model.intro = [obj objectForKey:@"intro"];
            model.burden = [obj objectForKey:@"burden"];
            model.ingredients = [obj objectForKey:@"ingredients"];
            BmobFile *albumFile = [obj objectForKey:@"album"];
            NSString *albumUrl = albumFile.url;
            // 下载专辑文件
            NSURLSessionConfiguration *albumConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
            AFURLSessionManager *albumManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:albumConfiguration];
            NSURL *albumURL = [NSURL URLWithString:albumUrl];
            NSURLRequest *albumRequest = [NSURLRequest requestWithURL:albumURL];
            NSURLSessionDownloadTask *albumDownloadTask = [albumManager downloadTaskWithRequest:albumRequest progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
                NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
                return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
            } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
                NSLog(@"File downloaded to: %@", filePath);
                model.albumData = [NSData dataWithContentsOfURL:filePath];
                [_cookeryLists addObject:model];
                if (_cookeryLists.count == array.count) {
                    [progress removeFromSuperview];
                    [_cookerylistsTableView reloadData];
                }
            }];
            [albumDownloadTask resume];
        }
    }];
}


#pragma mark - delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _cookeryLists.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CookBookTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cookBookCell"];
    cell.myNewCookBookModel = _cookeryLists[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 72;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // 删除数据
        BmobObject *bmobObject = [BmobObject objectWithClassName:@"CookeryInfo"];
        NewCookeryBookModel *model = _cookeryLists[indexPath.row];
        [bmobObject setObject:model.title forKey:@"title"];
        [bmobObject deleteInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error) {
            NSString *message;
            if (isSuccessful) {
                //删除成功后的动作
                message = @"删除成功";
                [_cookeryLists removeObjectAtIndex:indexPath.row];
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            } else if (error){
                NSLog(@"%@",error);
                message = @"删除失败";
            } else {
                message = @"未知错误";
                NSLog(@"UnKnow error");
            }
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        }];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewCookeryBookModel *model = _cookeryLists[indexPath.row];
    if ([self.title isEqualToString:@"查看菜谱"]) {
        CheckCookeryViewController *checkVC = [[CheckCookeryViewController alloc] init];
        checkVC.title = model.title;
        checkVC.headerViewModel = _cookeryLists[indexPath.row];
        [self.navigationController pushViewController:checkVC animated:YES];
    }
    if ([self.title isEqualToString:@"修改菜谱"]) {
        ModifyCookeryViewController *updateVC = [[ModifyCookeryViewController alloc] init];
        updateVC.title = model.title;
        updateVC.cookeryBookModel = _cookeryLists[indexPath.row];
        [self.navigationController pushViewController:updateVC animated:YES];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
