//
//  NewCookeryBookModel.h
//  cookerybook
//
//  Created by hmy2015 on 16/3/27.
//  Copyright © 2016年 何米颖大天才. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewCookeryBookModel : NSObject <NSCoding>

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *tags;
@property (nonatomic, copy) NSString *intro;
@property (nonatomic, copy) NSData *albumData;
@property (nonatomic, strong) NSMutableArray *steps;
@property (nonatomic, copy) NSString *burden;//调料
@property (nonatomic, copy) NSString *ingredients;//原料

@end
