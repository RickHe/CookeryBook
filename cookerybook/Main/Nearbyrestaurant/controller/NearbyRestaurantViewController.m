//
//  NearbyRestaurantViewController.m
//  cookerybook
//
//  Created by hmy2015 on 15/9/29.
//  Copyright (c) 2015年 何米颖大天才. All rights reserved.
//

#import "NearbyRestaurantViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "DetailNearbyTableViewCell.h"
#import "DetailNearbyViewController.h"

@interface NearbyRestaurantViewController () <CLLocationManagerDelegate>
{
    
    DetailNearbyViewController *_detailVC; // 详情表视图
}
@property (weak, nonatomic) IBOutlet UIButton *nearbyRestaurant; 

@end

@implementation NearbyRestaurantViewController

#pragma mark - lifeCycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - other
// 附近餐馆按钮
- (IBAction)nearbyButtonAction:(id)sender
{
    _detailVC = [[DetailNearbyViewController alloc] init];
    [self.navigationController pushViewController:_detailVC animated:YES];
}

@end
