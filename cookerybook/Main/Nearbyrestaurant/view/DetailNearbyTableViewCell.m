
//
//  DetailNearbyTableViewCell.m
//  cookerybook
//
//  Created by hmy2015 on 15/10/11.
//  Copyright (c) 2015年 何米颖大天才. All rights reserved.
//

#import "DetailNearbyTableViewCell.h"
#import "UIImageView+WebCache.h"

@interface DetailNearbyTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *icon; // 图标
@property (weak, nonatomic) IBOutlet UILabel *titleLabel; // 文字标题
@property (weak, nonatomic) IBOutlet UILabel *addressLabel; // 地址
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel; // 类别
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel; // 电话

@end

@implementation DetailNearbyTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setNearbyModel:(NearbyRestaurantModel *)nearbyModel
{
    if (_nearbyModel != nearbyModel)
    {
        _nearbyModel = nearbyModel;
        [self setNeedsLayout];
    }
}

// 更新 cell
- (void)layoutSubviews
{
    [super layoutSubviews];
    [_icon sd_setImageWithURL:[NSURL URLWithString:_nearbyModel.icon]];
    
    if ([_nearbyModel.phone isKindOfClass:[NSNull class]])
    {
        _phoneLabel.text    = @"";
    }
    else
    {
        NSString *phone = [[_nearbyModel.phone componentsSeparatedByString:@","] firstObject];
        _phoneLabel.text    = phone;
    }
    if ([_nearbyModel.address isKindOfClass:[NSNull class]]) {
        _addressLabel.text  = @"";
    }
    else
    {
        _addressLabel.text  = _nearbyModel.address;
    }
    _titleLabel.text    = _nearbyModel.title;
    _categoryLabel.text = _nearbyModel.category_name;
}

@end
