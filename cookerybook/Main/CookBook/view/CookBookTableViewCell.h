//
//  CookBookTableViewCell.h
//  cookerybook
//
//  Created by hmy2015 on 15/10/9.
//  Copyright (c) 2015年 何米颖大天才. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CookBookModel.h"
#import "NewCookeryBookModel.h"

@interface CookBookTableViewCell : UITableViewCell

@property (nonatomic, strong) CookBookModel *cookBookModel;
@property (nonatomic, strong) NewCookeryBookModel *myNewCookBookModel;

@end
