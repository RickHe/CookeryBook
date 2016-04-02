
//
//  NSDictionary+Log.m
//  cookerybook
//
//  Created by hmy2015 on 15/10/9.
//  Copyright (c) 2015年 何米颖大天才. All rights reserved.
//

#import "NSDictionary+Log.h"

@implementation NSDictionary (Log)

- (NSString *)descriptionWithLocale:(id)locale
{
    NSMutableString *log = [NSMutableString stringWithString:@"{\n"];
    for (NSString *key in self)
    {
        NSString *value = self[key];
        [log appendFormat:@" %@ = %@ \n",key, value];
    }
    [log appendString:@"}"];
    return log;
}

@end
