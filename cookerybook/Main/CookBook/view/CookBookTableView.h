//
//  CookBookTableView.h
//  cookerybook
//
//  Created by hmy2015 on 15/10/9.
//  Copyright (c) 2015年 何米颖大天才. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CookBookTableView : UITableView

@property (nonatomic, strong) NSArray *cookBookModelArray; // 菜谱数据模型
@property (nonatomic, assign) BOOL isFirstTabBar;          // 是否有头视图

@end
