//
//  DetailHeadView.m
//  cookerybook
//
//  Created by hmy2015 on 15/10/9.
//  Copyright (c) 2015年 何米颖大天才. All rights reserved.
//

#import "UIImageView+WebCache.h"
#import "DetailHeadView.h"

@interface DetailHeadView ()

@property (weak, nonatomic) IBOutlet UIImageView *imageTitle;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *tagLabel;
@property (weak, nonatomic) IBOutlet UILabel *burdenLabel;
@property (weak, nonatomic) IBOutlet UILabel *ingredientsLabel;

@end

@implementation DetailHeadView

- (void)setDetailHeadViewModel:(DetailHeadViewModel *)detailHeadViewModel
{
    if (_detailHeadViewModel != detailHeadViewModel)
    {
        _detailHeadViewModel = detailHeadViewModel;
        [self setNeedsLayout];
    }
}

- (void)setMyNewCookeryBookModel:(NewCookeryBookModel *)myNewCookeryBookModel {
    _myNewCookeryBookModel = myNewCookeryBookModel;
    [self setNeedsLayout];
}

- (void)setYOffSet:(CGFloat)yOffSet
{
    if (_yOffSet != yOffSet)
    {
        _yOffSet = yOffSet;
        [self setNeedsLayout];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    CGFloat scale = (_yOffSet + _imageTitle.frame.size.height) / _imageTitle.frame.size.height;
    if (_detailHeadViewModel) {
         [_imageTitle sd_setImageWithURL:[NSURL URLWithString:_detailHeadViewModel.albums]];
    } else if(_myNewCookeryBookModel) {
        _imageTitle.image = [UIImage imageWithData:_myNewCookeryBookModel.albumData];
    }
    CGRect frame = _imageTitle.frame;
    static CGFloat top;
    if (scale - 1 <= 0.0001)
    {
         top = _imageTitle.top;
    }
    frame.size.height = scale * frame.size.height;
    _imageTitle.frame = frame;
    _imageTitle.top = top - _yOffSet;
    
    if (_detailHeadViewModel) {
        _title.text = _detailHeadViewModel.title;
        _detailLabel.text = _detailHeadViewModel.intro;
        _tagLabel.text = _detailHeadViewModel.tags;
        _burdenLabel.text = _detailHeadViewModel.burden;
        _ingredientsLabel.text = _detailHeadViewModel.ingredients;
    } else if(_myNewCookeryBookModel) {
        _title.text = _myNewCookeryBookModel.title;
        _detailLabel.text = _myNewCookeryBookModel.intro;
        _tagLabel.text = _myNewCookeryBookModel.tags;
        _burdenLabel.text = _myNewCookeryBookModel.burden;
        _ingredientsLabel.text = _myNewCookeryBookModel.ingredients;
    }

}

@end
