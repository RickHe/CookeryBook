//
//  FindPasswordVC.m
//  XiaoYing
//
//  Created by 何米颖大天才 on 15/10/26.
//  Copyright © 2015年 何米颖大天才. All rights reserved.
//

#import "FindPasswordVC.h"
#import "LoginViewController.h"
#import "Masonry.h"
#import <BmobSDK/Bmob.h>
#import "RegexTool.h"

#define scaleX  kScreenWidth / 320
#define scaleY  kScreenHeight / 568

@interface FindPasswordVC (){
    UITextField *mailField;
    UIButton *getBtn;
    NSDate *date;
    UITextField *codeField;
    NSInteger count;
    NSTimer *timer;
    UIButton *confirmBtn;
    NSInteger flag;
    UIScrollView *scrollView;
    UIView *_headView;
    UILabel *_titleLab;
    UIButton *_leftBt;
}

@end

@implementation FindPasswordVC

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.view.backgroundColor = [UIColor colorWithHexString:@"efeff4"];
        
        self.view.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Tap:)];
        [self.view addGestureRecognizer:tap];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatView];
}

- (void)creatView{
    
    
    _headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
    _headView.backgroundColor=[UIColor colorWithHexString:@"f99740"];
    [self.view addSubview:_headView];
    
    _titleLab=[[UILabel alloc]initWithFrame:CGRectMake(0, 20, kScreenWidth, 44)];
    _titleLab.text=@"找回密码";
    _titleLab.textColor=[UIColor whiteColor];
    _titleLab.font=[UIFont systemFontOfSize:20];
    _titleLab.backgroundColor=[UIColor colorWithHexString:@"f99740"];
    _titleLab.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:_titleLab];
    
    _leftBt=[UIButton buttonWithType:UIButtonTypeCustom];
    [_leftBt setImage:[UIImage imageNamed:@"Arrow-white"] forState:UIControlStateNormal];
    [_leftBt addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_leftBt];
    [_leftBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(8*scaleX);
        make.centerY.mas_equalTo(_titleLab.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(20*scaleX, 30*scaleY));
    }];
    
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.top.mas_equalTo(_titleLab.mas_bottom).offset(30*scaleY);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 99.5*scaleY));
    }];
    
    
    UILabel *label1 = [[UILabel alloc]init];
    label1.text = @"邮箱";
    label1.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:label1];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(12*scaleX);
        make.top.mas_equalTo(view.mas_top).offset(18*scaleY);
        make.size.mas_equalTo(CGSizeMake(59*scaleX, 14*scaleY));
    }];
    
    
    //    UILabel *label2 = [[UILabel alloc] init];
    //    label2.text = @"验证码";
    //    label2.font = [UIFont systemFontOfSize:16];
    //    [self.view addSubview:label2];
    //    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.mas_equalTo(self.view.mas_left).offset(12*scaleX);
    //        make.top.mas_equalTo(_titleLab.mas_bottom).offset(97*scaleY);
    //        make.size.mas_equalTo(CGSizeMake(59*scaleX, 14*scaleY));
    //    }];
    
    
    
    //邮箱地址输入框
    mailField = [[UITextField alloc] init];
    mailField.font = [UIFont systemFontOfSize:15];
    mailField.tag = 100;
    mailField.placeholder = @"请输入邮箱";
    mailField.delegate=self;
    [mailField addTarget:self action:@selector(mailFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    mailField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [self.view addSubview:mailField];
    [mailField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(80*scaleX);
        make.centerY.mas_equalTo(label1.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(190*scaleX, 40*scaleY));
    }];
    
    
    UIView *lineView1 = [[UIView alloc] init];
    lineView1.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
    [self.view addSubview:lineView1];
    [lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(12*scaleX);
        make.centerY.mas_equalTo(view.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(296*scaleX, 0.5*scaleY));
        
    }];
    
    
    //    //验证码输入框
    //    codeField = [[UITextField alloc] init];
    //    codeField.font = [UIFont systemFontOfSize:15];
    //    codeField.placeholder = @"请输入您验证码";
    //    codeField.tag = 101;
    //    codeField.delegate = self;
    //    codeField.keyboardType = UIKeyboardTypeNumberPad;
    //    [self.view addSubview:codeField];
    //    [codeField mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.mas_equalTo(self.view.mas_left).offset(80*scaleX);
    //        make.centerY.mas_equalTo(label2.mas_centerY);
    //        make.size.mas_equalTo(CGSizeMake(120*scaleX, 40*scaleY));
    //    }];
    //
    //    //获取验证码按钮
    //    getBtn = [[UIButton alloc] init];
    //    getBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    //    getBtn.enabled = NO;
    //    [getBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    //    getBtn.backgroundColor = [UIColor colorWithHexString:@"#f99740"];
    //    getBtn.titleLabel.lineBreakMode = 0 ;
    //    getBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    //    [getBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //    [getBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    //    [getBtn addTarget:self action:@selector(getCodeAction:) forControlEvents:UIControlEventTouchUpInside];
    //    [self.view addSubview:getBtn];
    //    [getBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.right.mas_equalTo(self.view.mas_right);
    //        make.bottom.mas_equalTo(view.mas_bottom);
    //
    //        make.size.mas_equalTo(CGSizeMake(108*scaleX, 50*scaleY));
    //    }];
    
    //下一步按钮
    confirmBtn = [[UIButton alloc] init];
    confirmBtn.layer.cornerRadius = 22;
    
    [confirmBtn setTitle:@"通过邮件找回" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirmBtn setTitleShadowColor:[UIColor lightGrayColor] forState: UIControlStateHighlighted];
    [confirmBtn setBackgroundImage:[UIImage imageNamed:@"Button-forget"] forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confirmBtn];
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(self.view.top).offset(240*scaleY);
        make.size.mas_equalTo(CGSizeMake(215*scaleX, 44*scaleY));
    }];
    
    
}

#pragma mark -- UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField.tag == 101) {
        
        flag = 101;
    }
    else flag = 100;
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [mailField resignFirstResponder];
    [codeField resignFirstResponder];
    return YES;
}

#pragma mark --Action

- (void)backAction:(UIButton *)btn{
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)getCodeAction:(UIButton *)btn{
    
    //    if([RegexTool validateUserPhone:mailField.text] || [RegexTool validateEmail:mailField.text]){
    //
    //        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    //        [params setObject:mailField.text forKey:@"account"];
    //
    //        [AFNetClient POST_Path:SendCode params:params completed:^(NSData *stringData, id JSONDict) {
    //
    //            NSNumber *code = [JSONDict objectForKey:@"Code"];
    //            if ([code isEqual:@1]) {
    //                NSString *message = [JSONDict objectForKey:@"Message"];
    //                [MBProgressHUD showError:message toView:self.view];
    //
    //
    //            }else if ([code isEqual:@0]){
    //                date = [NSDate date];
    //                count = 60;
    //                getBtn.enabled = NO;
    //                timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    //            }
    //        } failed:^(NSError *error) {
    //            [MBProgressHUD showError:@"连接失败" toView:self.view];
    //        }];
    //    }else{
    //        [MBProgressHUD showError:@"请输入正确邮箱名" toView:self.view];
    //    }
}


-(void)Tap:(UITapGestureRecognizer *)tap
{
    [self.view endEditing:YES];
    
}

-(void)mailFieldDidChange:(UITextField *)mailField1{
    if (mailField.text.length > 0 ){
        getBtn.enabled = YES;
    }else{
        getBtn.enabled = NO;
    }
}

-(void)timerAction{
    count--;
    [getBtn setTitle:[NSString stringWithFormat:@"重新获取验证码（%liS）",(long)count] forState:UIControlStateNormal];
    mailField.enabled = NO;
    if(count < 0){
        getBtn.enabled = YES;
        [getBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    }
}

-(void)confirmAction:(UIButton *)btn{
    [self.view endEditing:YES];
    if([RegexTool validateEmail:mailField.text]) {
        [BmobUser requestPasswordResetInBackgroundWithEmail:mailField.text];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请登录邮箱查询" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入正确的邮箱" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
