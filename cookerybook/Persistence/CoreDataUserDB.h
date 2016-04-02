//
//  CoreDataUserDB.h
//  cookerybook
//
//  Created by hmy2015 on 15/10/10.
//  Copyright (c) 2015年 何米颖大天才. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CookBookModel.h"

@interface CoreDataUserDB : NSObject

// 配置 coredata 基本信息
+ (void)p_openStoredMedia;
// 添加数据
+ (BOOL)addUser:(CookBookModel *)cookBookModel;
// 查询数据
+ (NSArray *)queryUser;
+ (BOOL)deleteUsersisCollection:(NSInteger)isCollection;
+ (BOOL)deleteUser:(CookBookModel *)cookModel;


@end
