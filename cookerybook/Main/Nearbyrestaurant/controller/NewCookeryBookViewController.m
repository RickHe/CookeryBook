//
//  NewCookeryBookViewController.m
//  cookerybook
//
//  Created by hmy2015 on 18/3/26.
//  Copyright © 2018年 何米颖大天才. All rights reserved.
//

#import "NewCookeryBookViewController.h"
#import "XYDorpDownMenu.h"
#import "NewStepsViewController.h"
#import "NewCookeryBookModel.h"
#import "XYAddImageView.h"

@interface NewCookeryBookViewController () <UITextFieldDelegate>
{
    UITextField *_titleTextField;
    UITextField *_tagsTextField;
    UITextField *_introTextField;
    UITextField *_burdenTextField;
    UITextField *_ingreidentTextField;
    XYAddImageView *_addImageView;
    XYDorpDownMenu *_stepsNumberList;
    NewCookeryBookModel *_cookeryBookModel;
}
@end

@implementation NewCookeryBookViewController

- (void)viewWillAppear:(BOOL)animated
{
    [UIView animateWithDuration:.5 animations:^{
        self.navigationController.tabBarController.tabBar.top = kScreenHeight;
    }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [UIView animateWithDuration:.5 animations:^{
        self.navigationController.tabBarController.tabBar.bottom = kScreenHeight;
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _cookeryBookModel = [NewCookeryBookModel new];
    [self p_createViews];
    // rightBar
    UIButton *nextBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [nextBtn setTitleColor:[UIColor colorWithRed:0.0 green:122.0 / 255 blue:255.0 / 255 alpha:1] forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(nextStep:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:nextBtn];
}

- (void)nextStep:(UIButton *)btn {
    NewStepsViewController *newStepVC = [NewStepsViewController new];
    _cookeryBookModel.title = _titleTextField.text;
    _cookeryBookModel.intro = _introTextField.text;
    _cookeryBookModel.tags = _tagsTextField.text;
    _cookeryBookModel.burden = _burdenTextField.text;
    _cookeryBookModel.ingredients = _ingreidentTextField.text;
    _cookeryBookModel.albumData = _addImageView.firstImageData;
    newStepVC.albumName = _addImageView.firstImageName;
    newStepVC.cookeryBookModel = _cookeryBookModel;
    newStepVC.stepsNumber = [_stepsNumberList.selectedString integerValue];
    NSString *message;
    if (!_cookeryBookModel.albumData) {
        message = @"请选择菜谱图片";
    }
    if (!newStepVC.stepsNumber) {
        message = @"请输入步骤数";
    }
    if ([_burdenTextField.text  isEqualToString: @""]) {
        message = @"请输入调料";
    }
    if ([_ingreidentTextField.text isEqualToString:@""]) {
        message = @"请输入原料";
    }
    if ([_cookeryBookModel.intro  isEqualToString: @""]) {
        message = @"请输入简介";
    }
    if ([_cookeryBookModel.tags isEqualToString:@""]) {
        message = @"请输入标签";
    }
    if ([_cookeryBookModel.title isEqualToString:@""]) {
        message = @"请输入标题";
    }
    if (message) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    } else {
        [self.navigationController pushViewController:newStepVC animated:YES];
    }
}

/**
 *  创建label
 *
 *  @param str   title
 *  @param frame
 *
 *  @return label
 */
- (UILabel *)createLabelWithTitle:(NSString *)str andFrame:(CGRect)frame{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = str;
    //label.backgroundColor = [UIColor lightGrayColor];
    label.font = [UIFont systemFontOfSize:13];
    return label;
}

- (void)p_createViews {
    // 菜谱名字
    UILabel *titleLab = [self createLabelWithTitle:@"菜谱名字" andFrame:CGRectMake(12, 18 + 64 ,58 ,18)];
    [self.view addSubview:titleLab];
    
    _titleTextField = [[UITextField alloc] initWithFrame:CGRectMake(65, 18 + 64, kScreenWidth - 100, 18)];
    _titleTextField.delegate = self;
    _titleTextField.placeholder = @"请输入菜谱名字";
    [self.view addSubview:_titleTextField];
    
    UIView *titleLine = [[UIView alloc] initWithFrame:CGRectMake(65, 18 + 64 + 20 + 0.5, kScreenWidth - 100, 0.5)];
    titleLine.backgroundColor = [UIColor colorWithHexString:@"#dfdfdf"];
    [self.view addSubview:titleLine];
    
    // 标签
    UILabel *kindLab = [self createLabelWithTitle:@"菜谱类型" andFrame:CGRectMake(12, 52 + 64 ,58 ,18)];
    [self.view addSubview:kindLab];
    
    _tagsTextField = [[UITextField alloc] initWithFrame:CGRectMake(65, 52 + 64, kScreenWidth - 100, 18)];
    _tagsTextField.delegate = self;
    _tagsTextField.placeholder = @"请输入菜类型";
    [self.view addSubview:_tagsTextField];
    
    UIView *kindLine = [[UIView alloc] initWithFrame:CGRectMake(65, 52 + 64 + 20 + 0.5, kScreenWidth - 100, 0.5)];
    kindLine.backgroundColor = [UIColor colorWithHexString:@"#dfdfdf"];
    [self.view addSubview:kindLine];
    
    // 设计介绍
    UILabel *introLab = [self createLabelWithTitle:@"设计简介" andFrame:CGRectMake(12, 86 + 64 ,58 ,18)];
    [self.view addSubview:introLab];

    _introTextField = [[UITextField alloc] initWithFrame:CGRectMake(65, 86 + 64, kScreenWidth - 100, 18)];
    _introTextField.delegate = self;
    _introTextField.placeholder = @"请输入设计简介";
    [self.view addSubview:_introTextField];
    
    UIView *introLine = [[UIView alloc] initWithFrame:CGRectMake(65, 86 + 64 + 20 + 0.5, kScreenWidth - 100, 0.5)];
    introLine.backgroundColor = [UIColor colorWithHexString:@"#dfdfdf"];
    [self.view addSubview:introLine];
    
    // 调料
    UILabel *burdenLab = [self createLabelWithTitle:@"菜谱调料" andFrame:CGRectMake(12, 120 + 64 ,58 ,18)];
    [self.view addSubview:burdenLab];
    
    _burdenTextField = [[UITextField alloc] initWithFrame:CGRectMake(65, 120 + 64, kScreenWidth - 100, 18)];
    _burdenTextField.delegate = self;
    _burdenTextField.placeholder = @"请输入菜谱调料";
    [self.view addSubview:_burdenTextField];
    
    UIView *burdenLine = [[UIView alloc] initWithFrame:CGRectMake(65, 120 + 64 + 20 + 0.5, kScreenWidth - 100, 0.5)];
    burdenLine.backgroundColor = [UIColor colorWithHexString:@"#dfdfdf"];
    [self.view addSubview:burdenLine];
    
    // 原料
    UILabel *ingreidentLab = [self createLabelWithTitle:@"菜谱原料" andFrame:CGRectMake(12, 154 + 64 ,58 ,18)];
    [self.view addSubview:ingreidentLab];
    
    _ingreidentTextField = [[UITextField alloc] initWithFrame:CGRectMake(65, 154 + 64, kScreenWidth - 100, 18)];
    _ingreidentTextField.delegate = self;
    _ingreidentTextField.placeholder = @"请输入菜谱原料";
    [self.view addSubview:_ingreidentTextField];
    
    UIView *ingreidentLine = [[UIView alloc] initWithFrame:CGRectMake(65, 154 + 64 + 20 + 0.5, kScreenWidth - 100, 0.5)];
    ingreidentLine.backgroundColor = [UIColor colorWithHexString:@"#dfdfdf"];
    [self.view addSubview:ingreidentLine];

    // 请输入菜谱步骤数
    UILabel *stepsNumberLab = [self createLabelWithTitle:@"菜谱步骤" andFrame:CGRectMake(12, 188 + 64 ,58 ,18)];
    [self.view addSubview:stepsNumberLab];

    _stepsNumberList = [[XYDorpDownMenu alloc] initWithFrame:CGRectMake(65, 188 + 64, kScreenWidth - 100, 18) MenuTitle:@"请输入菜谱步骤数,最多10步" DataSource:@[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10"]];
    _stepsNumberList.font = [UIFont systemFontOfSize:16];
    _stepsNumberList.meneItemTextFont = [UIFont systemFontOfSize:18];
    _stepsNumberList.menuItemBackgroundColor = [UIColor colorWithHexString:@"#808080"];
    _stepsNumberList.meneItemTextColor = [UIColor whiteColor];
    _stepsNumberList.sectionColor = [UIColor whiteColor];
    _stepsNumberList.placeholderColor = [UIColor colorWithHexString:@"#d5d7dc"];
    [self.view addSubview:_stepsNumberList];
    
    // 专辑图片
    _addImageView = [[XYAddImageView alloc] initWithFrame:CGRectMake(0, 228 + 64, kScreenWidth, kScreenHeight - 220) NumberOfImageForOneLine:2];
    [self.view insertSubview:_addImageView atIndex:0];
}

- (void)p_resignFirstResponder {
    [_titleTextField resignFirstResponder];
    [_introTextField resignFirstResponder];
    [_tagsTextField resignFirstResponder];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self p_resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    _cookeryBookModel.title = _titleTextField.text;
    _cookeryBookModel.tags = _tagsTextField.text;
    _cookeryBookModel.intro = _introTextField.text;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
