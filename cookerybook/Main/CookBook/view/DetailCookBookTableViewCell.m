


//
//  DetailCookBookTableViewCell.m
//  cookerybook
//
//  Created by hmy2015 on 15/10/9.
//  Copyright (c) 2015年 何米颖大天才. All rights reserved.
//

#import "UIImageView+WebCache.h"
#import "DetailCookBookTableViewCell.h"

@interface DetailCookBookTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *image; // 头像
@property (weak, nonatomic) IBOutlet UILabel *text;      // 文字

@end

@implementation DetailCookBookTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setDetailCookBookModel:(DetailCookBookModel *)detailCookBookModel
{
    if (_detailCookBookModel != detailCookBookModel)
    {
        _detailCookBookModel = detailCookBookModel;
        [self setNeedsLayout];
    }
}

- (void)setOneStepModel:(OneStepModel *)oneStepModel {
    _oneStepModel = oneStepModel;
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _image.layer.cornerRadius = 3;
    _image.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _image.layer.borderWidth = .5;
    _image.layer.masksToBounds = YES;
    if (_detailCookBookModel) {
        [_image sd_setImageWithURL:[NSURL URLWithString:_detailCookBookModel.img]];
        _text.text = _detailCookBookModel.step;
    } else if(_oneStepModel) {
        _image.image = [UIImage imageWithData:_oneStepModel.imageData];
        _text.text = _oneStepModel.step;
    }
}

@end
