//
//  StepView.m
//  cookerybook
//
//  Created by hmy2015 on 16/3/27.
//  Copyright © 2016年 何米颖大天才. All rights reserved.
//

#import "StepView.h"
#import "XYAddImageView.h"

@interface StepView () <UITextViewDelegate>
{
    UITextView *_descriptionTextField;
    XYAddImageView *_addImageView;
    BOOL _isContinue;
}
@end

@implementation StepView

- (instancetype)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self p_createSubviews];
        _isContinue = YES;
    }
    return self;
}

- (void)p_createSubviews {
    _descriptionTextField = [[UITextView alloc] initWithFrame:CGRectMake(5, 5, kScreenWidth - 10, 200)];
    _descriptionTextField.delegate = self;
    _descriptionTextField.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _descriptionTextField.layer.borderWidth = 0.5;
    _descriptionTextField.layer.cornerRadius = 5;
    _descriptionTextField.editable = YES;
    while (_isContinue) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantPast]];
    }
    [self addSubview:_descriptionTextField];
    
    // 图片
    _addImageView = [[XYAddImageView alloc] initWithFrame:CGRectMake(0, 220, kScreenWidth, kScreenHeight - 200) NumberOfImageForOneLine:2];
    [self addSubview:_addImageView];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
