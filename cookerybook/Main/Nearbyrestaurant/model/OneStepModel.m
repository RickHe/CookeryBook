//
//  OneStepModel.m
//  cookerybook
//
//  Created by hmy2015 on 16/3/27.
//  Copyright © 2016年 何米颖大天才. All rights reserved.
//

#import "OneStepModel.h"

@implementation OneStepModel

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super init])) {
        _step = [aDecoder decodeObjectForKey:@"step"];
        _imageData = [aDecoder decodeObjectForKey:@"imageData"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_step forKey:@"step"];
    [aCoder encodeObject:_imageData forKey:@"imageData"];
}


@end
