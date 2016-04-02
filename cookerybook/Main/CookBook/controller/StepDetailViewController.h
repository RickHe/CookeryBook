//
//  StepDetailViewController.h
//  cookerybook
//
//  Created by hmy2015 on 15/10/9.
//  Copyright (c) 2015年 何米颖大天才. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StepDetailViewController : UIViewController

@property (nonatomic, strong) NSArray *detailCookBookArray; // 详情数据
@property (nonatomic, assign) NSUInteger currentStep;       // 当前步骤
@property (nonatomic, strong) NSArray *detailNewCookBookArray; // 详情数据

@end
