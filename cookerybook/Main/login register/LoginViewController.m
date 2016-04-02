//
//  LoginViewController.m
//  XiaoYing
//
//  Created by 何米颖大天才 on 15/10/21.
//  Copyright © 2015年 何米颖大天才. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "AppDelegate.h"
#import "FindPasswordVC.h"
#import "Masonry.h"
#import "MainTabBarController.h"
#import "RegexTool.h"
#import "MBProgressHUD.h"
#import <BmobSDK/Bmob.h>

#define scaleX  kScreenWidth / 320
#define scaleY  kScreenHeight / 568

@interface LoginViewController ()<UITextFieldDelegate,NSURLConnectionDelegate,NSURLConnectionDataDelegate>
{
    //设定缓冲区将数据保存在缓冲区中
    NSMutableData *data_;
    //标题
    UILabel *titleLab;
    //头像
    UIImageView *imageviewHead;
    //用户名
    UITextField *userNameField;
    //密码
    UITextField *passWordField;
    //登录按钮
    UIButton *loginBt;
    //注册
    UIButton *registerBt;
    //找回密码
    UIButton *FindPassWord;
    //登录url
    NSString *LOGIN;
    NSDictionary *UserDic;
    UIScrollView *scroll_;
    //保存密码的图片
    UIImageView *imageviewSelect;
    //初始化
    NSUserDefaults *usermy;
    NSMutableArray * friendArr; //好友数组
}
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    usermy = [NSUserDefaults standardUserDefaults];
    self.view.backgroundColor=[UIColor colorWithHexString:@"#efeff4"];
    data_=[[NSMutableData alloc]init];
    self.view.userInteractionEnabled=YES;
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hide:)];
    [self.view addGestureRecognizer:tap];
    [self initUI];
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden=YES;
}

-(void)hide:(UITapGestureRecognizer*)tap{
    [userNameField resignFirstResponder];
    [passWordField resignFirstResponder];
}

-(void)initUI{
    UIButton *CacleBt=[[UIButton alloc]init];
    [self.view addSubview:CacleBt];
    [CacleBt addTarget:self action:@selector(cacle) forControlEvents:UIControlEventTouchUpInside];
    [CacleBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(12*scaleX);
        make.top.equalTo(self.view).with.offset(30*scaleY);
        make.size.mas_equalTo(CGSizeMake(30*scaleX, 30*scaleY));
    }];
    UIImageView *imaheView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"x"]];
    [CacleBt addSubview:imaheView];
    [imaheView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(CacleBt);
        make.size.mas_equalTo(CGSizeMake(15*scaleX, 15*scaleY));
    }];
    
    //头像
    imageviewHead = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ying"]];
    [self.view addSubview:imageviewHead];
    imageviewHead.layer.masksToBounds = YES;
    imageviewHead.layer.cornerRadius = 50*scaleX;
    [imageviewHead mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.centerY.mas_equalTo(self.view.mas_top).offset(140*scaleY);
        make.size.mas_equalTo(CGSizeMake(100*scaleX, 100*scaleX));
    }];
    
    //账号
    UIView *userNameView=[[UIView alloc]init];
    userNameView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:userNameView];
    [userNameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.top.mas_equalTo(self.view.mas_top).offset(219*scaleY);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 50*scaleY));
    }];

    UIImageView *imageviewName=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"username"]];
    [userNameView addSubview:imageviewName];
    [imageviewName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(userNameView.mas_left).offset(10*scaleX);
        make.centerY.mas_equalTo(userNameView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(23*scaleX, 23*scaleY));
    }];
    
    //密码
    UIView *passWordView=[[UIView alloc]init];
    passWordView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:passWordView];
    [passWordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.top.mas_equalTo(self.view.mas_top).offset(269.5*scaleY);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 50*scaleY));
    }];
    
    UIImageView *imageviewpass = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"password"]];
    [passWordView addSubview:imageviewpass];
    [imageviewpass mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(passWordView.mas_left).offset(10*scaleX);
        make.centerY.mas_equalTo(passWordView.center.y);
        make.size.mas_equalTo(CGSizeMake(23*scaleX, 23*scaleY));
    }];
    
    userNameField=[[UITextField alloc]init];
    userNameField.placeholder=@"请输入账号";
    userNameField.delegate=self;
    userNameField.font=[UIFont systemFontOfSize:16];
    [userNameField addTarget:self action:@selector(userNameFileChanged) forControlEvents:UIControlEventEditingChanged];
    userNameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    userNameField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [userNameView addSubview:userNameField];
    [userNameField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(userNameView.mas_left).offset(43*scaleX);
        make.top.mas_equalTo(userNameView.top);
        make.size.mas_equalTo(CGSizeMake(265*scaleX, 50*scaleY));
    }];
    
    //密码
    passWordField=[[UITextField alloc]init];
    passWordField.placeholder=@"密码";
    passWordField.delegate=self;
    passWordField.secureTextEntry=YES;
    passWordField.font=[UIFont systemFontOfSize:16];
    passWordField.clearButtonMode = UITextFieldViewModeWhileEditing;
    passWordField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [passWordView addSubview:passWordField];
    [passWordField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(passWordView.mas_left).offset(43*scaleX);
        make.top.mas_equalTo(passWordView.top);
        make.size.mas_equalTo(CGSizeMake(265*scaleX, 50*scaleY));
    }];
    
    loginBt=[UIButton buttonWithType:UIButtonTypeCustom];
    loginBt.layer.cornerRadius=5;
    loginBt.backgroundColor=[UIColor colorWithHexString:@"#f99740"];
    [loginBt setTitle:@"登录" forState:UIControlStateNormal];
    loginBt.titleLabel.font=[UIFont systemFontOfSize:15];
    [loginBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginBt addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBt];
    [loginBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(self.view.mas_top).offset(374.5*scaleY);
        make.size.mas_equalTo(CGSizeMake(300*scaleX, 45*scaleY));
    }];
    
    registerBt=[UIButton buttonWithType:UIButtonTypeCustom];
    registerBt.layer.cornerRadius=5;
    registerBt.tag=101;
    registerBt.backgroundColor=[UIColor colorWithHexString:@"#f99740"];
    [registerBt setTitle:@"注册" forState:UIControlStateNormal];
    [registerBt addTarget:self action:@selector(jump:) forControlEvents:UIControlEventTouchUpInside];
    registerBt.titleLabel.font=[UIFont systemFontOfSize:15];
    [self.view addSubview:registerBt];
    [registerBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(self.view.mas_top).offset(429.5*scaleY);
        make.size.mas_equalTo(CGSizeMake(300*scaleX, 45*scaleY));
    }];
    
    //保存密码
    UIView *view1 = [[UIView alloc]init];
    [self.view addSubview:view1];
    [view1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(11*scaleX);
        make.top.mas_equalTo(self.view.mas_top).offset(329.5*scaleY);
        make.size.mas_equalTo(CGSizeMake(26, 26));
    }];
    
    imageviewSelect=[[UIImageView alloc]init];
    [view1 addSubview:imageviewSelect];
    [imageviewSelect mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(view1.mas_left).offset(7*scaleX);
        make.top.mas_equalTo(view1.mas_top).offset(3.5*scaleY);
        make.size.mas_equalTo(CGSizeMake(16, 14));
    }];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([[userDefaults objectForKey:@"FLAGKEEPPASSWORD"] isEqualToString:@"1"]) {
        flagKeepPassword = 1;
        imageviewSelect.image=[UIImage imageNamed:@"Login-choose"];
        imageviewSelect.size = CGSizeMake(14, 14);
    }else{
        flagKeepPassword = 0;
        imageviewSelect.image=[UIImage imageNamed:@"Login-choose-none"];
    }
    
    NSString *userName = [userDefaults objectForKey:@"UserName"];
    NSString *password = [userDefaults objectForKey:@"Password"];
    if (flagKeepPassword==1) {
        userNameField.text = userName;
        passWordField.text = password;
        
    }else{
        userNameField.text = @"";
        passWordField.text = @"";
    }
    view1.tag=111;
    view1.userInteractionEnabled=YES;
    UITapGestureRecognizer *tap1=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(KeepPassword2:)];
    [view1 addGestureRecognizer:tap1];
    
    UILabel *labkeepPassword=[[UILabel alloc]init];
    labkeepPassword.text=@"保存密码";
    labkeepPassword.font=[UIFont systemFontOfSize:13.5];
    labkeepPassword.textColor=[UIColor colorWithHexString:@"#646464"];
    [self.view addSubview:labkeepPassword];
    [labkeepPassword mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(35*scaleX);
        make.top.mas_equalTo(self.view.mas_top).offset(329.5*scaleY);
        make.size.mas_equalTo(CGSizeMake(60, 20));
    }];
    
    FindPassWord=[UIButton buttonWithType:UIButtonTypeCustom];
    FindPassWord.layer.cornerRadius=5;
    FindPassWord.tag=102;
    FindPassWord.titleLabel.font=[UIFont systemFontOfSize:14];
    [FindPassWord setTitle:@"忘记密码？" forState:UIControlStateNormal];
    [FindPassWord setTitleColor:[UIColor colorWithHexString:@"#646464"] forState:UIControlStateNormal];
    [FindPassWord addTarget:self action:@selector(jump:) forControlEvents:UIControlEventTouchUpInside];
    FindPassWord.titleLabel.font=[UIFont systemFontOfSize:13];
    [self.view addSubview:FindPassWord];
    [FindPassWord mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(250*scaleX);
        make.top.mas_equalTo(self.view.mas_top).offset(329.5*scaleY);
        make.size.mas_equalTo(CGSizeMake(70*scaleX, 20*scaleY));
    }];
    [self addkeyBoardObservew];
}

static int flagKeepPassword=0;

-(void)KeepPassword2:(UITapGestureRecognizer *)tap{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (flagKeepPassword==1) {
        imageviewSelect.image=[UIImage imageNamed:@"Login-choose-none"];
        imageviewSelect.size = CGSizeMake(14, 14);
        flagKeepPassword=0;
        [userDefaults setObject:@"0" forKey:@"FLAGKEEPPASSWORD"];
    }else{
        imageviewSelect.image=[UIImage imageNamed:@"Login-choose"];
        imageviewSelect.size = CGSizeMake(16, 14);
        flagKeepPassword=1;
        [userDefaults setObject:@"1" forKey:@"FLAGKEEPPASSWORD"];
    }
}

-(void)cacle{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
    }];
}

-(void)userNameFileChanged{
    if (userNameField.text.length == 0) {
        passWordField.text = @"";
    }
}

-(void)addkeyBoardObservew{
    //监听键盘的出现
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    //监听键盘的消失
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHidden:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)keyboardHidden:(NSNotification *)notification
{
    self.view.frame=CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    [UIView commitAnimations];
}

-(void)keyboardShow:(NSNotification *)notification
{
    self.view.frame=CGRectMake(0, -100*scaleY, kScreenWidth, kScreenHeight);
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if ([textField isEqual:userNameField]&&![textField.text isEqualToString:@""]) {
        [passWordField becomeFirstResponder];
    }else if ([textField isEqual:passWordField]){
        [textField resignFirstResponder];
    }
    return YES;
}

#pragma mark --注册 找回密码
-(void)jump:(UIButton*)bt{
    if (bt.tag==101) {
        RegisterViewController *Re=[[RegisterViewController alloc]init];
        self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
        [self.navigationController pushViewController:Re animated:YES];
    }else if (bt.tag==102){
        FindPasswordVC *find=[[FindPasswordVC alloc]init];
        self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
        [self.navigationController pushViewController:find animated:YES];
    }
}

#pragma mark --登录
//登录按钮
-(void)login:(UIButton*)bt{
    NSString *message = @"";
    if ([userNameField.text isEqualToString:@""]||[passWordField.text isEqualToString:@""]) {
        message = @"账户或密码为空";
    }
    if (![message isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }
    MBProgressHUD *progress = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:progress];
    [progress show:YES];
    [BmobUser loginInbackgroundWithAccount:userNameField.text andPassword:passWordField.text block:^(BmobUser *user, NSError *error) {
        if (user) {
            NSLog(@"%@",user);
            AppDelegate *app=(AppDelegate*)[UIApplication sharedApplication].delegate;
            [app jumpToMainVC];
            // 保存数据
            [[NSUserDefaults standardUserDefaults] setObject:userNameField.text forKey:@"UserName"];
            [[NSUserDefaults standardUserDefaults] setObject:passWordField.text forKey:@"Password"];
        } else {
            NSLog(@"%@",error);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"密码错误" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        }
    }];
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



