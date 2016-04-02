//
//  NewStepsViewController.h
//  cookerybook
//
//  Created by hmy2015 on 16/3/27.
//  Copyright © 2016年 何米颖大天才. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewCookeryBookModel.h"

@interface NewStepsViewController : UIViewController

@property (nonatomic, strong) NewCookeryBookModel *cookeryBookModel;
@property (nonatomic, copy) NSString *albumName;
@property (nonatomic, assign) NSUInteger stepsNumber;

@end
