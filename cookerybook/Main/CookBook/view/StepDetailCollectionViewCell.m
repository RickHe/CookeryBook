

//
//  StepDetailCollectionViewCell.m
//  cookerybook
//
//  Created by hmy2015 on 15/10/9.
//  Copyright (c) 2015年 何米颖大天才. All rights reserved.
//

#import "StepDetailCollectionViewCell.h"
#import "UIImageView+WebCache.h"

@interface StepDetailCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *ImageTitle;
@property (weak, nonatomic) IBOutlet UILabel *DetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentStepLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalStepLabel;


@end
@implementation StepDetailCollectionViewCell

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
    if (_oneStepModel) {
        _ImageTitle.image = [UIImage imageWithData:_oneStepModel.imageData];
        _DetailLabel.text = _oneStepModel.step;
        [UIView animateWithDuration:1 animations:^{
            _currentStepLabel.text = [NSString stringWithFormat:@"%lu", _currentStep + 1];
        }];
        
        _totalStepLabel.text = [NSString stringWithFormat:@"/%lu", (unsigned long)_totalStep];
    } else if (_detailCookBookModel) {
        [_ImageTitle sd_setImageWithURL:[NSURL URLWithString:_detailCookBookModel.img]];
        _DetailLabel.text = _detailCookBookModel.step;
        [UIView animateWithDuration:1 animations:^{
            _currentStepLabel.text = [NSString stringWithFormat:@"%lu", _currentStep + 1];
        }];
        
        _totalStepLabel.text = [NSString stringWithFormat:@"/%lu", (unsigned long)_totalStep];
    }
}

@end
