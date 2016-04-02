//
//  CoreDataUserDB.m
//  cookerybook
//
//  Created by hmy2015 on 15/10/10.
//  Copyright (c) 2015年 何米颖大天才. All rights reserved.
//

#import "CoreDataUserDB.h"
#import <CoreData/CoreData.h>
#import "User.h"

@interface CoreDataUserDB ()
{
    
}

@end

@implementation CoreDataUserDB

static NSManagedObjectContext *_context;

+ (void)p_openStoredMedia
{
    // 创建NSManagedObjectModel
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"xcdatamodeld"];
    NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:  url];
    // 创建 psc ,将 psc 联系物理文件与模型文件的桥梁,通过psc 实现将数据保存到物理文件中去
    NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    NSString *filePath = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/CoreData.rdb"];
    NSURL *fileURL = [NSURL fileURLWithPath:filePath];
    [psc addPersistentStoreWithType:NSSQLiteStoreType
                      configuration:nil
                                URL:fileURL
                            options:nil error:nil];
    
    // 通过上下文来实现以上操作
    _context = [[NSManagedObjectContext alloc] init];
    _context.persistentStoreCoordinator = psc;
}

+ (BOOL)addUser:(CookBookModel *)cookBookModel
{
    User *user = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:_context];
    user.albums = cookBookModel.albums;
    user.foodId = cookBookModel.foodId;
    user.tags = cookBookModel.tags;
    user.title = cookBookModel.title;
    user.isCollection = [NSNumber numberWithInteger:cookBookModel.isCollection];
    
    [_context save:nil];
    
    return NO;
}

+ (NSArray *)queryUser
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"User"];
    NSMutableArray *cookBookArray = [NSMutableArray array];
//    request.entity = [NSEntityDescription ]
//    request.predicate = [NSPredicate predicateWithFormat:@"select * from User"];
    NSArray *array = [_context executeFetchRequest:request error:nil];
    for (User *user in array)
    {
        CookBookModel *cookBookModel = [[CookBookModel alloc] init];
        cookBookModel.albums = user.albums;
        cookBookModel.foodId = user.foodId;
        cookBookModel.tags = user.tags;
        cookBookModel.title = user.title;
        cookBookModel.isCollection = [user.isCollection integerValue];
        [cookBookArray addObject:cookBookModel];
    }
    
    return cookBookArray;
}

+ (BOOL)deleteUsersisCollection:(NSInteger)isCollection
{
    return NO;
}

+ (BOOL)deleteUser:(CookBookModel *)cookModel
{
    return YES;
}


@end
