//
//  NearbyRestaurantModel.h
//  cookerybook
//
//  Created by hmy2015 on 15/10/11.
//  Copyright (c) 2015年 何米颖大天才. All rights reserved.
//

#import "BaseModel.h"

@interface NearbyRestaurantModel : BaseModel

@property (nonatomic, copy) NSString *title; // 餐馆名字
@property (nonatomic, copy) NSString *address; // 地址
@property (nonatomic, copy) NSString *category_name; // 类别
@property (nonatomic, copy) NSString *phone; // 电话
@property (nonatomic, copy) NSString *distance; // 距离
@property (nonatomic, copy) NSString *icon; //图标

@end
