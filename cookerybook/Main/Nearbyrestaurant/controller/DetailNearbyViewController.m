//
//  DetailNearbyViewController.m
//  cookerybook
//
//  Created by hmy2015 on 15/10/11.
//  Copyright (c) 2015年 何米颖大天才. All rights reserved.
//

#import "DetailNearbyViewController.h"
#import "DetailNearbyTableViewCell.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"

#define kAccessToken @"2.006o7GPE03reUF804f2e56b00XBv3X"

@interface DetailNearbyViewController () <UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate>
{
    NSMutableArray *_nearbyResArray;     // 附近的餐馆信息数组
    UITableView *_nearbyTable;           // 附近的餐馆表视图
    CLLocationManager *_loctionManager;  // 获取地理位置 manager
}


@end

@implementation DetailNearbyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _nearbyTable = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _nearbyTable.hidden = YES;
    [_nearbyTable registerNib:[UINib nibWithNibName:@"DetailNearbyTableViewCell" bundle:nil] forCellReuseIdentifier:@"nearbyCell"];
    _nearbyTable.delegate = self;
    _nearbyTable.dataSource = self;
    _nearbyTable.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    [self.view addSubview:_nearbyTable];
}

- (void)viewWillAppear:(BOOL)animated
{
    // 获取当前位置的经纬度
    if (_loctionManager == nil)
    {
        _loctionManager = [[CLLocationManager alloc] init];
        if ([[UIDevice currentDevice].systemVersion floatValue] > 7.9)
        {
            [_loctionManager requestWhenInUseAuthorization];
        }
    }
    _loctionManager.delegate = self;
    [_loctionManager startUpdatingLocation];
}

#pragma mark - delegate location
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
   
    if (locations.count > 0)
    {
        [manager stopUpdatingLocation];
        CLLocation *location = [locations lastObject];
        _coordinate = location.coordinate;
        [self p_loadData];
    }
}


// 加载数据
- (void)p_loadData
{
    _nearbyResArray = [NSMutableArray array];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *urlString = @"https://api.weibo.com/2/place/nearby/pois.json";
    NSMutableDictionary *params = [@{
                                     @"access_token" : kAccessToken,
                                     @"lat" : @(_coordinate.latitude),
                                     @"long" : @(_coordinate.longitude),
                                     @"count" : @50
                                     } mutableCopy];
    
    MBProgressHUD *_hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:_hud];
    _nearbyTable.hidden = YES;
    [_hud show:YES];
    [manager GET:urlString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *pois = responseObject[@"pois"];
        for (NSDictionary *dic in pois)
        {
            NearbyRestaurantModel *model = [[NearbyRestaurantModel alloc] initWithDataDic:dic];
            [_nearbyResArray addObject:model];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [_nearbyTable reloadData];
            _nearbyTable.hidden = NO;
        });
        [_hud removeFromSuperview];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSAssert(1, @"%@", error);
        NSLog(@"%@", error);
    }];
}

#pragma mark - delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _nearbyResArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 77;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailNearbyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"nearbyCell"];
    cell.nearbyModel = _nearbyResArray[indexPath.row];
    return cell;
}

@end
