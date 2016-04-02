//
//  DetailCookBookTableViewCell.h
//  cookerybook
//
//  Created by hmy2015 on 15/10/9.
//  Copyright (c) 2015年 何米颖大天才. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailCookBookModel.h"
#import "OneStepModel.h"

@interface DetailCookBookTableViewCell : UITableViewCell

@property (nonatomic, strong) DetailCookBookModel *detailCookBookModel;
@property (nonatomic, strong) OneStepModel *oneStepModel;

@end
