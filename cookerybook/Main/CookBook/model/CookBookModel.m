//
//  CookBookModel.m
//  cookerybook
//
//  Created by hmy2015 on 15/10/9.
//  Copyright (c) 2015年 何米颖大天才. All rights reserved.
//

#import "CookBookModel.h"

@implementation CookBookModel

- (id)initWithDataDic:(NSDictionary *)dataDic
{
    if (self = [super initWithDataDic:dataDic])
    {
        _foodId = [NSString stringWithFormat:@"%@", dataDic[@"id"]];
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ %@ %@ %@", _title, _albums, _foodId, _tags];
}

@end
