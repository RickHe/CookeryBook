//
//  DetailHeadView.h
//  cookerybook
//
//  Created by hmy2015 on 15/10/9.
//  Copyright (c) 2015年 何米颖大天才. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailHeadViewModel.h"
#import "NewCookeryBookModel.h"

@interface DetailHeadView : UIView

@property (nonatomic, strong) NewCookeryBookModel *myNewCookeryBookModel;
@property (nonatomic, strong) DetailHeadViewModel *detailHeadViewModel;
@property (nonatomic, assign) CGFloat yOffSet;   

@end
