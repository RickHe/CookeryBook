//
//  OneStepModel.h
//  cookerybook
//
//  Created by hmy2015 on 16/3/27.
//  Copyright © 2016年 何米颖大天才. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OneStepModel : NSObject <NSCoding>

@property (nonatomic, copy) NSString *step;
@property (nonatomic, strong) NSData *imageData;

@end
