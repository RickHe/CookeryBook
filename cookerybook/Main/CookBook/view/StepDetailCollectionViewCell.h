//
//  StepDetailCollectionViewCell.h
//  cookerybook
//
//  Created by hmy2015 on 15/10/9.
//  Copyright (c) 2015年 何米颖大天才. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailCookBookModel.h"
#import "OneStepModel.h"

@interface StepDetailCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) DetailCookBookModel *detailCookBookModel; // 详情数据模型
@property (nonatomic, strong) OneStepModel *oneStepModel;
@property (nonatomic, assign) NSUInteger currentStep;// 当前步骤
@property (nonatomic, assign) NSUInteger totalStep;  // 总步骤

@end
