//
//  NSArray+Log.m
//  cookerybook
//
//  Created by hmy2015 on 15/10/9.
//  Copyright (c) 2015年 何米颖大天才. All rights reserved.
//

#import "NSArray+Log.h"

@implementation NSArray (Log)

- (NSString *)descriptionWithLocale:(id)locale
{
    NSMutableString *log = [NSMutableString stringWithString:@"(\n"];
    for (NSString *string in self)
    {
        [log appendFormat:@"        %@\n", string];
    }
    [log appendFormat:@"}"];
    return log;
}

@end
