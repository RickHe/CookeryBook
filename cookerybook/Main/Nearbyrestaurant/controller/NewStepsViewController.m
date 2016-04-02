//
//  NewStepsViewController.m
//  cookerybook
//
//  Created by hmy2015 on 16/3/27.
//  Copyright © 2016年 何米颖大天才. All rights reserved.
//

#import "NewStepsViewController.h"
#import "StepView.h"
#import "UIButton+CurrentStepNumber.h"
#import "XYAddImageView.h"
#import "OneStepModel.h"
#import <BmobSDK/Bmob.h>
#import "MBProgressHUD.h"

@interface NewStepsViewController ()
{
    UIButton *_nextStepBtn;
    UIButton *_lastStepBtn;
    UITextView *_descriptionTextField;
    XYAddImageView *_addImageView;
    NSMutableArray *_steps;
}
@end

@implementation NewStepsViewController

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
    _steps = [NSMutableArray new];
    // rightBar
    _nextStepBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    [_nextStepBtn setTitle:@"下一步" forState:UIControlStateNormal];
    _nextStepBtn.currentStepNumber = 1;
    [_nextStepBtn setTitleColor:[UIColor colorWithRed:0.0 green:122.0 / 255 blue:255.0 / 255 alpha:1] forState:UIControlStateNormal];
    [_nextStepBtn addTarget:self action:@selector(nextStep:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_nextStepBtn];
    
    // 上一步
    _lastStepBtn = [[UIButton alloc] initWithFrame:CGRectMake(50, kScreenHeight - 30 - 64, kScreenWidth - 100, 30)];
    [_lastStepBtn setTitle:@"上一步" forState:UIControlStateNormal];
    _lastStepBtn.layer.borderColor = [[UIColor lightGrayColor] CGColor];;
    _lastStepBtn.layer.borderWidth = 0.5;
    _lastStepBtn.layer.cornerRadius = 5;
    _lastStepBtn.backgroundColor = [UIColor cyanColor];
    _lastStepBtn.currentStepNumber = 1;
    [_lastStepBtn setTitleColor:[UIColor colorWithRed:0.0 green:122.0 / 255 blue:255.0 / 255 alpha:1] forState:UIControlStateNormal];
    [_lastStepBtn addTarget:self action:@selector(lastStep:) forControlEvents:UIControlEventTouchUpInside];
    _lastStepBtn.hidden = YES;
    [self.view addSubview:_lastStepBtn];
}

- (void)nextStep:(UIButton *)btn {
    OneStepModel *model = [OneStepModel new];
    model.step = _descriptionTextField.text;
    model.imageData = _addImageView.firstImageData;
    NSString *message;
    if ([model.step  isEqual: @""]) {
        message = @"请输入描述";
    }
    if (!model.imageData) {
        message = @"请选择图片";
    }
    if (message) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    } else {
        [_steps addObject:model];
        if (btn.currentStepNumber == _stepsNumber) {
            // 菜谱步骤写入文件
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_steps];
            NSString *filePath = [NSString stringWithFormat:@"%@/%@", NSHomeDirectory(), _addImageView.firstImageName];
            NSMutableString *file = [NSMutableString stringWithString:filePath];
            file = [[file stringByDeletingLastPathComponent] mutableCopy];
            filePath = [file stringByAppendingPathExtension:@"txt"];
            [data writeToFile:filePath atomically:YES];
            // 专辑图片写入文件
            NSString *imagePath = [NSString stringWithFormat:@"%@/%@", NSHomeDirectory(), _albumName];
            [_cookeryBookModel.albumData writeToFile:imagePath atomically:YES];
            // 上传
            MBProgressHUD *progress = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:progress];
            [progress show:YES];
            progress.labelText = @"上传中";
            _cookeryBookModel.steps = _steps;
            // 保存数据
            BmobObject  *cookeryInfo = [BmobObject objectWithClassName:@"CookeryInfo"];
            [cookeryInfo setObject:_cookeryBookModel.title forKey:@"title"];
            [cookeryInfo setObject:_cookeryBookModel.tags forKey:@"tags"];
            [cookeryInfo setObject:_cookeryBookModel.intro forKey:@"intro"];
            [cookeryInfo setObject:_cookeryBookModel.burden forKey:@"burden"];
            [cookeryInfo setObject:_cookeryBookModel.ingredients forKey:@"ingredients"];
            // 菜谱封面文件添加
            BmobFile *albumFile = [[BmobFile alloc] initWithClassName:@"CookeryInfo"
                                                        withFilePath:imagePath];
            if ([albumFile save]) {
                [cookeryInfo setObject:albumFile forKey:@"album"];
            }
            // 菜谱步骤文件添加
            BmobFile *bmobFile = [[BmobFile alloc] initWithClassName:@"CookeryInfo"
                                                        withFilePath:filePath];
            if ([bmobFile save]) {
                [cookeryInfo setObject:bmobFile forKey:@"Steps"];
            }
            
            [cookeryInfo saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                if (isSuccessful) {
                    NSLog(@"%@",_steps);
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"添加成功" preferredStyle:UIAlertControllerStyleAlert];
                    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    }]];
                    [progress removeFromSuperview];
                    [self presentViewController:alert animated:YES completion:nil];
                } else if (error){
                    //发生错误后的动作
                    NSLog(@"%@",error);
                } else {
                    NSLog(@"Unknow error");
                }
            }];
        } else {
            _nextStepBtn.currentStepNumber++;
            _lastStepBtn.currentStepNumber++;
            self.title = [NSString stringWithFormat:@"%li / %li", _nextStepBtn.currentStepNumber, _stepsNumber];
            [self p_removeViews];
            [self p_createViews];
            if (btn.currentStepNumber == _stepsNumber) {
                [btn setTitle:@"完成" forState:UIControlStateNormal];
                return;
            }
            if (btn.currentStepNumber == 1) {
                _lastStepBtn.hidden = YES;
            } else {
                _lastStepBtn.hidden = NO;
            }
        }
    }
}

- (void)setStepsNumber:(NSUInteger)stepsNumber {
    _stepsNumber = stepsNumber;
    if (_stepsNumber == 1) {
        [_nextStepBtn setTitle:@"完成" forState:UIControlStateNormal];
    }
    self.title = [NSString stringWithFormat:@"1 / %li", _stepsNumber];
    [self p_createViews];
}

- (void)lastStep:(UIButton *)btn {
    _lastStepBtn.currentStepNumber--;
    _nextStepBtn.currentStepNumber--;
    self.title = [NSString stringWithFormat:@"%li / %li", _lastStepBtn.currentStepNumber, _stepsNumber];
    [self p_removeViews];
    [self p_createViews];
    if (btn.currentStepNumber == 1) {
        btn.hidden = YES;
    } else {
        btn.hidden = NO;
    }
}

- (void)p_removeViews {
    [_addImageView removeFromSuperview];
    [_descriptionTextField removeFromSuperview];
}

- (void)p_createViews {
    // 图片
    _addImageView = [[XYAddImageView alloc] initWithFrame:CGRectMake(0, 220 + 64, kScreenWidth, kScreenHeight - 220) NumberOfImageForOneLine:2];
    [self.view insertSubview:_addImageView atIndex:0];
    
    _descriptionTextField = [[UITextView alloc] initWithFrame:CGRectMake(5, 69, kScreenWidth - 10, 200)];
    _descriptionTextField.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _descriptionTextField.layer.borderWidth = 0.5;
    _descriptionTextField.layer.cornerRadius = 5;
    _descriptionTextField.editable = YES;
    [self.view addSubview:_descriptionTextField];
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
