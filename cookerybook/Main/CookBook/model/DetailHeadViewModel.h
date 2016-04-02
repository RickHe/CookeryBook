//
//  DetailHeadViewModel.h
//  cookerybook
//
//  Created by hmy2015 on 15/10/9.
//  Copyright (c) 2015年 何米颖大天才. All rights reserved.
//

#import "BaseModel.h"

@interface DetailHeadViewModel : BaseModel

@property (nonatomic, copy) NSString *title;// 名字
@property (nonatomic, copy) NSString *tags;// 标签
@property (nonatomic, copy) NSString *intro;// 简介
@property (nonatomic, copy) NSString *albums;//原图
@property (nonatomic, copy) NSString *burden;//调料
@property (nonatomic, copy) NSString *ingredients;//原料

@end
