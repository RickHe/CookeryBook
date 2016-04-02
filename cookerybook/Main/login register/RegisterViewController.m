//
//  RegisterViewController.m
//  XiaoYing
//
//  Created by 何米颖大天才 on 15/10/26.
//  Copyright © 2015年 何米颖大天才. All rights reserved.
//

#import "RegisterViewController.h"
#import "LoginViewController.h"
#import "ConsumerAgreementVC.h"
#import "Masonry.h"
#import <BmobSDK/Bmob.h>
#import "MBProgressHUD.h"

//判断iphone4
#define IS_IPHONE_4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

//判断iphone5
#define IS_IPHONE_5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

//判断iphone6
#define IS_iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)

//判断iphone6+
#define IS_iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)

#define scaleX  kScreenWidth / 320
#define scaleY  kScreenHeight / 568

@interface RegisterViewController ()<UITextFieldDelegate>
{
    
    //添加一个uiscrollview
    UIScrollView *scrollview;
    //用户名
    UITextField *NameField;
    //密码
    UITextField *PassField;
    //重新输入
    UITextField *RePassField;
    //电子邮箱
    UITextField *MailField;
    //提示文字
    UILabel *labnum;
    // 电话
    UITextField *TelNumberField;
    NSString *queueidStr;
    //注册什么不符合标准
    NSString *messageStr;
    UIImageView *imageviewSelect;
    UIImageView *imageviewSelect1;
}

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //标题
    _RegisterBackView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    if (IS_IPHONE_4 || IS_IPHONE_5) {
        UIScrollView *scrollview1 = [[UIScrollView alloc] initWithFrame:CGRectMake(0, -20, kScreenWidth, kScreenHeight)];
        scrollview1.contentSize = CGSizeMake(kScreenWidth, kScreenHeight+80);
        [scrollview1 addSubview:_RegisterBackView];
        [self.view addSubview:scrollview1];
    }else{
        [self.view addSubview:_RegisterBackView];
    }
    self.view.backgroundColor=[UIColor colorWithHexString:@"#e0e2e5"];
    _viewhead = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
    _viewhead.backgroundColor=[UIColor colorWithHexString:@"f99740"];
    [self.view addSubview:_viewhead];
    
    _titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, kScreenWidth, 44)];
    _titleLab.text=@"注册";
    _titleLab.textColor=[UIColor whiteColor];
    _titleLab.font=[UIFont systemFontOfSize:20];
    _titleLab.backgroundColor=[UIColor colorWithHexString:@"f99740"];
    _titleLab.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:_titleLab];
    
    _LeftBt=[[UIButton alloc]init];
    [_LeftBt setImage:[UIImage imageNamed:@"Arrow-white"] forState:UIControlStateNormal];
    
    [_LeftBt addTarget:self action:@selector(BackLast:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_LeftBt];
    [_LeftBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(8*scaleY);
        make.centerY.mas_equalTo(_titleLab.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(20*scaleX, 30*scaleY));
    }];
    
    _rightBt=[UIButton buttonWithType:UIButtonTypeCustom];
    [_rightBt setTitle:@"提交" forState:UIControlStateNormal];
    _rightBt.titleLabel.font=[UIFont systemFontOfSize:16];
    [_rightBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_rightBt addTarget:self action:@selector(BackANDFinish:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_rightBt];
    [_rightBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(276*scaleX);
        make.centerY.mas_equalTo(_titleLab.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(38*scaleX, 33*scaleY));
    }];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gestureTap)];
    [self.view addGestureRecognizer:tap];
    [_RegisterBackView addSubview:scrollview];
    //用户名背景
    UIView *viewUserName=[[UIView alloc]init];
    viewUserName.backgroundColor=[UIColor whiteColor];
    [_RegisterBackView addSubview:viewUserName];
    [viewUserName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_RegisterBackView.mas_left);
        make.top.mas_equalTo(_RegisterBackView.mas_top).offset(94*scaleY);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 49.5*scaleY));
    }];
    
    UILabel *labUserName=[[UILabel alloc]init];
    labUserName.text=@"用户名";
    labUserName.font=[UIFont systemFontOfSize:16];
    labUserName.textColor=[UIColor colorWithHexString:@"#333333"];
    [viewUserName addSubview:labUserName];
    [labUserName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(viewUserName.mas_left).offset(15*scaleX);
        make.centerY.mas_equalTo(viewUserName.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(64*scaleX, 20*scaleY));
    }];
    
    //姓名
    NameField=[[UITextField alloc]init];
    NameField.placeholder=@"请输入用户名";
    NameField.delegate=self;
    NameField.font=[UIFont systemFontOfSize:14];
    NameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    NameField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [viewUserName addSubview:NameField];
    [NameField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(viewUserName.mas_left).offset(79*scaleX);
        make.centerY.mas_equalTo(viewUserName.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(220*scaleX, 49.5*scaleY));
    }];
    
    //邮箱背景
    UIView *viewMail=[[UIView alloc]init];
    viewMail.backgroundColor=[UIColor whiteColor];
    [_RegisterBackView addSubview:viewMail];
    [viewMail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_RegisterBackView.mas_left);
        make.top.mas_equalTo(_RegisterBackView.mas_top).offset(144*scaleY);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 49.5*scaleY));
    }];
    
    UILabel *labEmail=[[UILabel alloc]init];
    labEmail.text=@"邮箱";
    labEmail.font=[UIFont systemFontOfSize:16];
    labEmail.textColor=[UIColor colorWithHexString:@"#333333"];
    [viewMail addSubview:labEmail];
    [labEmail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(viewMail.mas_left).offset(15*scaleX);
        make.centerY.mas_equalTo(viewMail.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(64*scaleX, 16*scaleY));
    }];
    
    //姓名
    MailField=[[UITextField alloc]init];
    MailField.placeholder=@"请输入邮箱";
    MailField.delegate=self;
    MailField.font=[UIFont systemFontOfSize:14];
    MailField.clearButtonMode = UITextFieldViewModeWhileEditing;
    MailField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [viewMail addSubview:MailField];
    [MailField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(viewMail.mas_left).offset(79*scaleX);
        make.centerY.mas_equalTo(viewMail.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(220*scaleX, 49.5*scaleY));
    }];
    
    //密码背景
    UIView *viewPassword=[[UIView alloc]init];
    viewPassword.backgroundColor=[UIColor whiteColor];
    
    [_RegisterBackView addSubview:viewPassword];
    
    [viewPassword mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_RegisterBackView.mas_left);
        make.top.mas_equalTo(_RegisterBackView.mas_top).offset(194*scaleY);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 49.5*scaleY));
    }];
    
    UILabel *labPassword=[[UILabel alloc]init];
    labPassword.text=@"密码";
    labPassword.font=[UIFont systemFontOfSize:16];
    labPassword.textColor=[UIColor colorWithHexString:@"#333333"];
    [viewPassword addSubview:labPassword];
    [labPassword mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(viewPassword.mas_left).offset(15*scaleX);
        make.top.mas_equalTo(viewPassword.mas_top).offset(17*scaleY);
        make.size.mas_equalTo(CGSizeMake(64*scaleX, 16*scaleY));
    }];
    
    //密码
    PassField=[[UITextField alloc]init];
    PassField.placeholder=@"请输入密码";
    PassField.delegate=self;
    PassField.font=[UIFont systemFontOfSize:14];
    PassField.secureTextEntry=YES;
    PassField.clearButtonMode = UITextFieldViewModeWhileEditing;
    PassField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [PassField addTarget:self action:@selector(PassFieldChanged) forControlEvents:UIControlEventEditingChanged];
    
    [viewPassword addSubview:PassField];
    [PassField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(viewPassword.mas_left).offset(79*scaleX);
        make.top.mas_equalTo(viewPassword.mas_top);
        make.size.mas_equalTo(CGSizeMake(220*scaleX, 49.5*scaleY));
    }];
    
    //重新输入密码背景
    UIView *viewRePassword=[[UIView alloc]init];
    viewRePassword.backgroundColor=[UIColor whiteColor];
    
    [_RegisterBackView addSubview:viewRePassword];
    [viewRePassword mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_RegisterBackView.mas_left);
        make.top.mas_equalTo(_RegisterBackView.mas_top).offset(244*scaleY);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 49.5*scaleY));
    }];
    UILabel *labRePassword=[[UILabel alloc]init];
    labRePassword.text=@"确认密码";
    labRePassword.font=[UIFont systemFontOfSize:16];
    labRePassword.textColor=[UIColor colorWithHexString:@"#333333"];
    [viewRePassword addSubview:labRePassword];
    [labRePassword mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(viewRePassword.mas_left).offset(15*scaleX);
        make.top.mas_equalTo(viewRePassword.mas_top).offset(17*scaleY);
        make.size.mas_equalTo(CGSizeMake(64*scaleX, 16*scaleY));
    }];
    
    //重写密码
    RePassField=[[UITextField alloc]init];
    RePassField.placeholder=@"请重复输入您的密码";
    RePassField.delegate=self;
    RePassField.font=[UIFont systemFontOfSize:14];
    RePassField.secureTextEntry=YES;
    RePassField.clearButtonMode = UITextFieldViewModeWhileEditing;
    RePassField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [viewRePassword addSubview:RePassField];
    [RePassField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(viewRePassword.mas_left).offset(79*scaleX);
        make.top.mas_equalTo(viewRePassword.mas_top);
        make.size.mas_equalTo(CGSizeMake(220*scaleX, 49.5*scaleY));
    }];
    
    //电话背景
    UIView *viewTelNumber=[[UIView alloc]init];
    viewTelNumber.backgroundColor=[UIColor whiteColor];
    [_RegisterBackView addSubview:viewTelNumber];
    [viewTelNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_RegisterBackView.mas_left);
        make.top.mas_equalTo(_RegisterBackView.mas_top).offset(294*scaleY);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 49.5*scaleY));
    }];
    UILabel *labTelNumber=[[UILabel alloc]init];
    labTelNumber.text=@"电话";
    labTelNumber.font=[UIFont systemFontOfSize:16];
    labTelNumber.textColor=[UIColor colorWithHexString:@"#333333"];
    [viewTelNumber addSubview:labTelNumber];
    [labTelNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(viewTelNumber.mas_left).offset(15*scaleX);
        make.top.mas_equalTo(viewTelNumber.mas_top).offset(17*scaleY);
        make.size.mas_equalTo(CGSizeMake(64*scaleX, 16*scaleY));
    }];
    // 号码
    TelNumberField=[[UITextField alloc]init];
    TelNumberField.placeholder=@"请输入电话号码";
    TelNumberField.delegate=self;
    TelNumberField.font=[UIFont systemFontOfSize:14];
    TelNumberField.clearButtonMode = UITextFieldViewModeWhileEditing;
    TelNumberField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [viewTelNumber addSubview:TelNumberField];
    [TelNumberField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(viewTelNumber.mas_left).offset(79*scaleX);
        make.top.mas_equalTo(viewTelNumber.mas_top);
        make.size.mas_equalTo(CGSizeMake(220*scaleX, 49.5*scaleY));
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden=YES;
}

//是否完成注册
-(void)BackANDFinish:(UIButton*)bt{
    //提交注册
    [self RegisWay];
}

#pragma mark ---添加手势点击按钮
-(void)gestureTap{
    [NameField  resignFirstResponder];
    [PassField resignFirstResponder];
    [RePassField resignFirstResponder];
    [MailField resignFirstResponder];
}

#pragma mark ---UITextFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark ---注册
-(void)RegisWay{
    [NameField  resignFirstResponder];
    [PassField resignFirstResponder];
    [RePassField resignFirstResponder];
    [MailField resignFirstResponder];
    NSString *message = @"";
    if ([PassField.text isEqualToString:@""]) {
        message = @"密码为空";
    }
    if (![RePassField.text isEqualToString:PassField.text]) {
        message = @"输入密码不一致";
    }
    if (TelNumberField.text.length != 11) {
        message = @"请输入11位号码";
    }
    if ([MailField.text isEqualToString:@""]) {
        message = @"邮箱为空";
    }
    if ([NameField.text isEqualToString:@""]) {
        message = @"用户名为空";
    }
    if (![message isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    } else {
        // 注册
        BmobUser *bUser = [[BmobUser alloc] init];
        [bUser setUsername:NameField.text];
        [bUser setPassword:PassField.text];
        [bUser setObject:TelNumberField.text forKey:@"mobilePhoneNumber"];
        [bUser setObject:MailField.text forKey:@"email"];
        MBProgressHUD *progress = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:progress];
        [progress show:YES];
        //异步保存到服务器
        [bUser signUpInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error) {
            [progress removeFromSuperview];
            if (isSuccessful) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"注册成功" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self.navigationController popViewControllerAnimated:YES];
                }];
                [alert addAction:action];
                [self presentViewController:alert animated:YES completion:nil];
            } else {
                NSString *message = error.userInfo[@"error"];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
            }
        }];
    }
    return ;
}

#pragma mark ---获取验证码
-(void)BackLast:(UIButton *)btn{
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)PassFieldChanged{
    if (PassField.text.length == 0) {
        RePassField.text = @"";
    }
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

