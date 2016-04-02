//
//  UserDB.m
//  cookerybook
//
//  Created by hmy2015 on 15/10/10.
//  Copyright (c) 2015年 何米颖大天才. All rights reserved.
//

#import "UserDB.h"
#import <sqlite3.h>

@implementation UserDB
/*
 @property (nonatomic, copy) NSString *title;
 @property (nonatomic, copy) NSString *foodId;
 @property (nonatomic, copy) NSString *albums;
 @property (nonatomic, copy) NSString *tags;
 */

+ (NSString *)filePath
{
    NSString *filePath = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@",@"sqlite.rdb"];
    return filePath;
}

// 创建表
+ (BOOL)createTable
{
    // 数据库路径
    NSString *filePath = [UserDB filePath];
    NSLog(@"%@", filePath);
    
    // 获取数据库句柄
    sqlite3 *sqlite = NULL;
    int result = sqlite3_open([filePath UTF8String], &sqlite);
    if(result != SQLITE_OK)
    {
        NSLog(@"打开数据库失败");
        return NO;
    }
    // sql 语句
    NSString *sql = @"create table t_user(title text,foodId text,albums text,tags text,isCollection integer)";
    // 执行数据库语句
    char *error = NULL;
    result = sqlite3_exec(sqlite, [sql UTF8String], NULL, NULL, &error);
    if(result != SQLITE_OK)
    {
        NSLog(@"表创建失败");
        sqlite3_close(sqlite);
        return NO;
    }
    sqlite3_close(sqlite);
    
    return YES;
}

// 添加数据
+ (BOOL)addUser:(CookBookModel *)cookBookModel
{
    // 打开数据库
    NSString *filePath = [UserDB filePath];
    sqlite3 *sqlite = NULL;
    int result = sqlite3_open([filePath UTF8String], &sqlite);
    if (result != SQLITE_OK)
    {
        NSLog(@"打开数据库失败");
        return NO;
    }
    // 先看是否有重复 有重复先删除重复的
    NSArray *cookBookArray = [UserDB queryUser];
    
    for (CookBookModel *model in cookBookArray)
    {
        // 填充数据
        NSString *foodId = [NSString stringWithFormat:@"%@", cookBookModel.foodId];
        NSString *modelFoodId = [NSString stringWithFormat:@"%@", model.foodId];
        if ([foodId isEqualToString:modelFoodId] && model.isCollection == cookBookModel.isCollection)
        {
            /*
             delete from people
             where   peopleName in (select peopleName    from people group by peopleName      having count(peopleName) > 1)
             and   peopleId not in (select min(peopleId) from people group by peopleName     having count(peopleName)>1)
             */
            NSString *sqlString = @"delete from t_user where foodId=? and isCollection=?";
            sqlite3_stmt *stmt = NULL;
            
            result = sqlite3_prepare(sqlite, [sqlString UTF8String], -1, &stmt, NULL);
            if (result != SQLITE_OK)
            {
                NSAssert1(1, @"失败",@"sibai");
                NSLog(@"预编译失败");
                sqlite3_close(sqlite);
                return NO;
            }
            sqlite3_bind_text(stmt, 1, [foodId UTF8String], -1, NULL);
            sqlite3_bind_int(stmt, 2, (int)model.isCollection);
            result = sqlite3_step(stmt);
            if (result != SQLITE_DONE)
            {
                NSLog(@"删除数据失败");
                sqlite3_close(sqlite);
                sqlite3_finalize(stmt);
                return NO;
            }
            sqlite3_reset(stmt);
            sqlite3_close(sqlite);
            sqlite3_finalize(stmt);
        }
    }

    // 若没有重复数据库语句
    NSString *sql = @"insert into t_user(title,foodId,albums,tags,isCollection) values(?,?,?,?,?)";
    //NSString *sql = @"INSERT INTO t_user(useId,userName,userAge) VALUES(?,?,?)";
    // 预编译
    sqlite3_stmt *stmt = NULL;
    
    result = sqlite3_prepare(sqlite, [sql UTF8String], -1, &stmt, NULL);
    if (result != SQLITE_OK)
    {
        NSAssert1(1, @"失败",@"sibai");
        NSLog(@"预编译失败");
        sqlite3_close(sqlite);
        return NO;
    }
    
    // 填充数据
    NSString *foodId = [NSString stringWithFormat:@"%@", cookBookModel.foodId];
    sqlite3_bind_text(stmt, 1, [cookBookModel.title UTF8String], -1, NULL);
    sqlite3_bind_text(stmt, 2, [foodId UTF8String], -1, NULL);
    sqlite3_bind_text(stmt, 3, [cookBookModel.albums UTF8String], -1, NULL);
    sqlite3_bind_text(stmt, 4, [cookBookModel.tags UTF8String], -1, NULL);
    sqlite3_bind_int(stmt, 5, (int)cookBookModel.isCollection);
    result = sqlite3_step(stmt);
    if (result != SQLITE_DONE)
    {
        NSLog(@"插入数据失败");
        sqlite3_close(sqlite);
        sqlite3_finalize(stmt);
        return NO;
    }
    sqlite3_reset(stmt);
    sqlite3_close(sqlite);
    sqlite3_finalize(stmt);
    return YES;
}

// 删除所有数据
+ (BOOL)deleteUser:(CookBookModel *)cookModel
{
    // 打开数据库
    NSString *filePath = [UserDB filePath];
    sqlite3 *sqlite = NULL;
    int result = sqlite3_open([filePath UTF8String], &sqlite);
    if (result != SQLITE_OK)
    {
        NSLog(@"打开数据库失败");
        return NO;
    }
    NSArray *cookBookArray = [UserDB queryUser];
    for (CookBookModel *model in cookBookArray)
    {
        if (model.isCollection == 1 && [cookModel.foodId isEqualToString:model.foodId])
        {
            /*
             delete from people
             where   peopleName in (select peopleName    from people group by peopleName      having count(peopleName) > 1)
             and   peopleId not in (select min(peopleId) from people group by peopleName     having count(peopleName)>1)
             
             */
            NSString *sqlString = @"delete from t_user where foodId=? and isCollection=?";
            sqlite3_stmt *stmt = NULL;
            result = sqlite3_prepare(sqlite, [sqlString UTF8String], -1, &stmt, NULL);
            if (result != SQLITE_OK)
            {
                NSAssert1(1, @"失败",@"sibai");
                NSLog(@"预编译失败");
                sqlite3_close(sqlite);
                return NO;
            }
            sqlite3_bind_text(stmt, 1, [model.foodId UTF8String], -1, NULL);
            sqlite3_bind_int(stmt, 2, (int)model.isCollection);
            result = sqlite3_step(stmt);
            if (result != SQLITE_DONE)
            {
                NSLog(@"删除数据失败");
                sqlite3_close(sqlite);
                sqlite3_finalize(stmt);
                return NO;
            }
            sqlite3_reset(stmt);
            sqlite3_close(sqlite);
            sqlite3_finalize(stmt);
        }
    }
    return NO;
}

// 删除收藏数据或者浏览数据
+ (BOOL)deleteUsersisCollection:(NSInteger)isCollection
{
    // 打开数据库
    NSString *filePath = [UserDB filePath];
    sqlite3 *sqlite = NULL;
    int result = sqlite3_open([filePath UTF8String], &sqlite);
    if (result != SQLITE_OK)
    {
        NSLog(@"打开数据库失败");
        return NO;
    }
    NSArray *cookBookArray = [UserDB queryUser];
    for (CookBookModel *model in cookBookArray)
    {
        if (model.isCollection == isCollection)
        {
            NSString *sqlString = @"delete from t_user where isCollection=?";
            sqlite3_stmt *stmt = NULL;
            result = sqlite3_prepare(sqlite, [sqlString UTF8String], -1, &stmt, NULL);
            if (result != SQLITE_OK)
            {
                NSAssert1(1, @"失败",@"sibai");
                NSLog(@"预编译失败");
                sqlite3_close(sqlite);
                return NO;
            }
            sqlite3_bind_int(stmt, 1, (int)model.isCollection);
            result = sqlite3_step(stmt);
            if (result != SQLITE_DONE)
            {
                NSLog(@"删除数据失败");
                sqlite3_close(sqlite);
                sqlite3_finalize(stmt);
                return NO;
            }
            sqlite3_reset(stmt);
            sqlite3_close(sqlite);
            sqlite3_finalize(stmt);
        }
    }
    return NO;
}

// 查询数据
+ (NSArray *)queryUser
{
    // 打开数据库
    NSString *filePath = [UserDB filePath];
    sqlite3 *sqlite = NULL;
    NSLog(@"%@", filePath);
    
    int result = sqlite3_open([filePath UTF8String], &sqlite);
    if (result != SQLITE_OK)
    {
        NSLog(@"打开数据库失败");
        return nil;
    }
    
    // 数据库语句
    NSString *sql = @"select * from t_user";
    
    // 预编译
    sqlite3_stmt *stmt = NULL;
    result = sqlite3_prepare(sqlite, [sql UTF8String], -1, &stmt, NULL);
    if (result != SQLITE_OK)
    {
        NSAssert1(1, @"失败",@"sibai");
        NSLog(@"预编译失败");
        sqlite3_close(sqlite);
        return nil;
    }
    
    // 获取数据
    NSMutableArray *cookBookModelArray = [NSMutableArray array];
    int hasData = sqlite3_step(stmt);
    while (hasData == SQLITE_ROW)
    {
        const unsigned char *title = sqlite3_column_text(stmt, 0);
        const unsigned char *foodId = sqlite3_column_text(stmt, 1);
        const unsigned char *albums = sqlite3_column_text(stmt, 2);
        const unsigned char *tags = sqlite3_column_text(stmt, 3);
        int isCollection = sqlite3_column_int(stmt, 4);
        
        CookBookModel *model = [[CookBookModel alloc] init];
        model.title = [NSString stringWithUTF8String:(char *)title];
        model.foodId = [NSString stringWithUTF8String:(char *)foodId];
        model.albums = [NSString stringWithUTF8String:(char *)albums];
        model.tags = [NSString stringWithUTF8String:(char *)tags];
        model.isCollection = isCollection;
        [cookBookModelArray addObject:model];
        
        hasData = sqlite3_step(stmt);
    }
    return cookBookModelArray;
}

@end
