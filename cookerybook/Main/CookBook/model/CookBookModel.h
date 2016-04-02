//
//  CookBookModel.h
//  cookerybook
//
//  Created by hmy2015 on 15/10/9.
//  Copyright (c) 2015年 何米颖大天才. All rights reserved.
//

#import "BaseModel.h"

@interface CookBookModel : BaseModel

@property (nonatomic, copy) NSString *title;            // 食物名
@property (nonatomic, copy) NSString *foodId;           // 食物 id 可以获取详情
@property (nonatomic, copy) NSString *albums;           // 头像
@property (nonatomic, copy) NSString *tags;             // 标签
@property (nonatomic, assign) NSInteger isCollection;   // 1 已收藏, 0 未收藏


@end
