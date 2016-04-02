//
//  DetailNearbyTableViewCell.h
//  cookerybook
//
//  Created by hmy2015 on 15/10/11.
//  Copyright (c) 2015年 何米颖大天才. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NearbyRestaurantModel.h"

@interface DetailNearbyTableViewCell : UITableViewCell

@property (nonatomic, strong) NearbyRestaurantModel *nearbyModel;  // 附近的餐馆数据

@end
