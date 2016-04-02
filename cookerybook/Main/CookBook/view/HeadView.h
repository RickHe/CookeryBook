//
//  headView.h
//  cookerybook
//
//  Created by hmy2015 on 15/10/9.
//  Copyright (c) 2015年 何米颖大天才. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

typedef void(^ ReloadTableViewBlock)(NSArray *modelArray);


@interface HeadView : UIView

@property (nonatomic, copy) ReloadTableViewBlock reloadTableViewBlock; // 回掉 block

@end
