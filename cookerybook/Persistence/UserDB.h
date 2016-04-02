//
//  UserDB.h
//  cookerybook
//
//  Created by hmy2015 on 15/10/10.
//  Copyright (c) 2015年 何米颖大天才. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CookBookModel.h"

@interface UserDB : NSObject

// 创建表
+ (BOOL)createTable;
// 添加数据
+ (BOOL)addUser:(CookBookModel *)cookBookModel;
// 查询数据
+ (NSArray *)queryUser;
// 获取当前数据库路径
+ (NSString *)filePath;
// 删除数据(根据是否收藏)
+ (BOOL)deleteUsersisCollection:(NSInteger)isCollection;
// 删除所有数据
+ (BOOL)deleteUser:(CookBookModel *)cookModel;

@end
