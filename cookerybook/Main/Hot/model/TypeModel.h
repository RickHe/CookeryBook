//
//  TypeModel.h
//  cookerybook
//
//  Created by hmy2015 on 15/10/9.
//  Copyright (c) 2015年 何米颖大天才. All rights reserved.
//

#import "BaseModel.h"

@interface TypeModel : BaseModel

@property (nonatomic, strong) NSString *type; // 类型
@property (nonatomic, copy) NSString *tid;    // 类型 id 获取菜谱
@property (nonatomic, copy) NSString *typeId; // 类型 id 获取菜谱

@end
