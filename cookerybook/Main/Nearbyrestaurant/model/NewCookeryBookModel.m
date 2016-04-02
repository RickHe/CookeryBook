//
//  NewCookeryBookModel.m
//  cookerybook
//
//  Created by hmy2015 on 16/3/27.
//  Copyright © 2016年 何米颖大天才. All rights reserved.
//

#import "NewCookeryBookModel.h"

@implementation NewCookeryBookModel

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super init])) {
        _title = [aDecoder decodeObjectForKey:@"title"];
        _tags = [aDecoder decodeObjectForKey:@"tags"];
        _steps = [aDecoder decodeObjectForKey:@"steps"];
        _intro = [aDecoder decodeObjectForKey:@"intro"];
        _albumData = [aDecoder decodeObjectForKey:@"albumData"];
        _burden = [aDecoder decodeObjectForKey:@"burden"];
        _ingredients = [aDecoder decodeObjectForKey:@"ingredients"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_title forKey:@"title"];
    [aCoder encodeObject:_tags forKey:@"tags"];
    [aCoder encodeObject:_steps forKey:@"steps"];
    [aCoder encodeObject:_intro forKey:@"intro"];
    [aCoder encodeObject:_albumData forKey:@"albumData"];
    [aCoder encodeObject:_burden forKey:@"burden"];
    [aCoder encodeObject:_ingredients forKey:@"ingredients"];
}

@end
