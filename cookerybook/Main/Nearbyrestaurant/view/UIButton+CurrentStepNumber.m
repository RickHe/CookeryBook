//
//  UIButton+CurrentStepNumber.m
//  cookerybook
//
//  Created by hmy2015 on 16/3/27.
//  Copyright © 2016年 何米颖大天才. All rights reserved.
//

#import "UIButton+CurrentStepNumber.h"
#import <objc/runtime.h>

@implementation UIButton (CurrentStepNumber)

const static void *currentStepNumberKey = @"currentStepNumberKey";

- (void)setCurrentStepNumber:(NSUInteger)currentStepNumber {
    objc_setAssociatedObject(self, currentStepNumberKey, @(currentStepNumber), OBJC_ASSOCIATION_ASSIGN);
}

- (NSUInteger)currentStepNumber {
    return [objc_getAssociatedObject(self, currentStepNumberKey) integerValue];
}

@end
