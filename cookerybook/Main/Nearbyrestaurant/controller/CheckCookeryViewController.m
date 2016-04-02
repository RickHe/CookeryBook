//
//  CheckCookeryViewController.m
//  cookerybook
//
//  Created by hmy2015 on 16/3/28.
//  Copyright © 2016年 何米颖大天才. All rights reserved.
//

#import "CheckCookeryViewController.h"
#import "DetailCookBookTableViewCell.h"
#import "DetailHeadView.h"
#import "StepDetailViewController.h"
#import <BmobSDK/Bmob.h>
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "NewCookeryBookModel.h"
#import "OneStepModel.h"

@interface CheckCookeryViewController () <UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_detailTableView;
    DetailHeadView *_headView;
    NSMutableArray *_deatilBookModelArray;
}
@end

@implementation CheckCookeryViewController

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
    // Do any additional setup after loading the view.
    _deatilBookModelArray = [NSMutableArray new];
    [self p_createViews];
    [self p_loadData];
}

- (void)p_loadData {
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"CookeryInfo"];
    MBProgressHUD *progress = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:progress];
    [progress show:YES];
    [bquery whereKey:@"title" equalTo:self.title];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        BmobObject *obj = [array lastObject];
        BmobFile *file = [obj objectForKey:@"Steps"];
        NSString *fileUrl = file.url;
        // 下载菜谱步骤文件
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        NSURL *URL = [NSURL URLWithString:fileUrl];
        NSURLRequest *request = [NSURLRequest requestWithURL:URL];
        NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
            NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
            return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
        } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
            NSLog(@"File downloaded to: %@", filePath);
            NSData *data = [NSData dataWithContentsOfURL:filePath];
            NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            for (OneStepModel *model in array) {
                [_deatilBookModelArray addObject:model];
            }
            [progress removeFromSuperview];
            [_detailTableView reloadData];
        }];
        [downloadTask resume];
    }];
}

- (void)p_createViews {
    // 加载完成数据后用表视图显示
    _detailTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _detailTableView.delegate = self;
    _detailTableView.dataSource = self;
    _detailTableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    _detailTableView.bounces = YES;
    [_detailTableView registerNib:[UINib nibWithNibName:@"DetailCookBookTableViewCell" bundle:nil] forCellReuseIdentifier:@"detailCell"];
    [self.view addSubview:_detailTableView];
    
    // 头视图
    if (!_headView) {
        NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"DetailHeadView" owner:nil options:nil];
        _headView = (DetailHeadView *)[arr lastObject];
        _detailTableView.tableHeaderView = _headView;
        _headView.yOffSet = 0;
        _headView.myNewCookeryBookModel = _headerViewModel;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setHeaderViewModel:(NewCookeryBookModel *)headerViewModel {
    _headerViewModel = headerViewModel;
}

#pragma mark - delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _deatilBookModelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailCookBookTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detailCell"];
    cell.oneStepModel = _deatilBookModelArray[indexPath.row];
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
    stepDetailVC.detailNewCookBookArray = _deatilBookModelArray;
    stepDetailVC.currentStep = indexPath.row;
    [self.navigationController pushViewController:stepDetailVC animated:YES];
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
