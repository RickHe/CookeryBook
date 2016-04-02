//
//  CookBookTableViewCell.m
//  cookerybook
//
//  Created by hmy2015 on 15/10/9.
//  Copyright (c) 2015年 何米颖大天才. All rights reserved.
//

#import "CookBookTableViewCell.h"
#import "UIImageView+WebCache.h"

@interface CookBookTableViewCell  ()

@property (weak, nonatomic) IBOutlet UIImageView *image; // 照片
@property (weak, nonatomic) IBOutlet UILabel *nameLabel; // 姓名
@property (weak, nonatomic) IBOutlet UILabel *DescirptionLabel; // 秒数


@end

@implementation CookBookTableViewCell

- (void)awakeFromNib {
    [self setNeedsLayout];
}

- (void)setCookBookModel:(CookBookModel *)cookBookModel
{
    if (_cookBookModel != cookBookModel)
    {
        _cookBookModel = cookBookModel;
        [self setNeedsLayout];
    }
}

- (void)setMyNewCookBookModel:(NewCookeryBookModel *)myNewCookBookModel {
    _myNewCookBookModel = myNewCookBookModel;
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (_myNewCookBookModel) {
        _image.image = [UIImage imageWithData:_myNewCookBookModel.albumData];
        _nameLabel.text = _myNewCookBookModel.title;
        _DescirptionLabel.text = _myNewCookBookModel.tags;
    } else if(_cookBookModel) {
        [_image sd_setImageWithURL:[NSURL URLWithString:_cookBookModel.albums]];
        _nameLabel.text = _cookBookModel.title;
        _DescirptionLabel.text = _cookBookModel.tags;
    }
}

@end
