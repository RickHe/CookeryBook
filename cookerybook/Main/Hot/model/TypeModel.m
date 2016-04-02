//
//  TypeModel.m
//  cookerybook
//
//  Created by hmy2015 on 15/10/9.
//  Copyright (c) 2015年 何米颖大天才. All rights reserved.
//

#import "TypeModel.h"

@implementation TypeModel

- (id)initWithDataDic:(NSDictionary *)dataDic
{
    if (self = [super initWithDataDic:dataDic])
    {
        _typeId = dataDic[@"id"];
    }
    return self;
}

@end
