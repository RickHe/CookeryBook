//
//  ModifyCookeryViewController.m
//  cookerybook
//
//  Created by hmy2015 on 16/3/29.
//  Copyright © 2016年 何米颖大天才. All rights reserved.
//

#import "ModifyCookeryViewController.h"
#import "XYAddImageView.h"
#import "XYDorpDownMenu.h"
#import "NewCookeryBookModel.h"

@interface ModifyCookeryViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    UITextField *_titleTextField;
    UITextField *_tagsTextField;
    UITextField *_introTextField;
    UITextField *_burdenTextField;
    UITextField *_ingreidentTextField;
    UIImageView *_ImageView;
    XYDorpDownMenu *_stepsNumberList;
}
@end

@implementation ModifyCookeryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self p_createViews];
    // Do any additional setup after loading the view.
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
    
    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [self.view addSubview:scroll];
    scroll.backgroundColor = [UIColor cyanColor];
    
    // 菜谱名字
    UILabel *titleLab = [self createLabelWithTitle:@"菜谱名字" andFrame:CGRectMake(12, 18 + 0 ,58 ,18)];
    [scroll addSubview:titleLab];
    
    _titleTextField = [[UITextField alloc] initWithFrame:CGRectMake(65, 18 + 0, kScreenWidth - 100, 18)];
    _titleTextField.delegate = self;
    _titleTextField.placeholder = @"请输入菜谱名字";
    [scroll addSubview:_titleTextField];
    
    UIView *titleLine = [[UIView alloc] initWithFrame:CGRectMake(65, 18 + 0 + 20 + 0.5, kScreenWidth - 100, 0.5)];
    titleLine.backgroundColor = [UIColor colorWithHexString:@"#dfdfdf"];
    [scroll addSubview:titleLine];
    
    // 标签
    UILabel *kindLab = [self createLabelWithTitle:@"菜谱类型" andFrame:CGRectMake(12, 52 + 0 ,58 ,18)];
    [scroll addSubview:kindLab];
    
    _tagsTextField = [[UITextField alloc] initWithFrame:CGRectMake(65, 52 + 0, kScreenWidth - 100, 18)];
    _tagsTextField.delegate = self;
    _tagsTextField.placeholder = @"请输入菜类型";
    [scroll addSubview:_tagsTextField];
    
    UIView *kindLine = [[UIView alloc] initWithFrame:CGRectMake(65, 52 + 0 + 20 + 0.5, kScreenWidth - 100, 0.5)];
    kindLine.backgroundColor = [UIColor colorWithHexString:@"#dfdfdf"];
    [scroll addSubview:kindLine];
    
    // 设计介绍
    UILabel *introLab = [self createLabelWithTitle:@"设计简介" andFrame:CGRectMake(12, 86 + 0 ,58 ,18)];
    [scroll addSubview:introLab];
    
    _introTextField = [[UITextField alloc] initWithFrame:CGRectMake(65, 86 + 0, kScreenWidth - 100, 18)];
    _introTextField.delegate = self;
    _introTextField.placeholder = @"请输入设计简介";
    [scroll addSubview:_introTextField];
    
    UIView *introLine = [[UIView alloc] initWithFrame:CGRectMake(65, 86 + 0 + 20 + 0.5, kScreenWidth - 100, 0.5)];
    introLine.backgroundColor = [UIColor colorWithHexString:@"#dfdfdf"];
    [scroll addSubview:introLine];
    
    // 调料
    UILabel *burdenLab = [self createLabelWithTitle:@"菜谱调料" andFrame:CGRectMake(12, 120 + 0 ,58 ,18)];
    [scroll addSubview:burdenLab];
    
    _burdenTextField = [[UITextField alloc] initWithFrame:CGRectMake(65, 120 + 0, kScreenWidth - 100, 18)];
    _burdenTextField.delegate = self;
    _burdenTextField.placeholder = @"请输入菜谱调料";
    [scroll addSubview:_burdenTextField];
    
    UIView *burdenLine = [[UIView alloc] initWithFrame:CGRectMake(65, 120 + 0 + 20 + 0.5, kScreenWidth - 100, 0.5)];
    burdenLine.backgroundColor = [UIColor colorWithHexString:@"#dfdfdf"];
    [scroll addSubview:burdenLine];
    
    // 原料
    UILabel *ingreidentLab = [self createLabelWithTitle:@"菜谱原料" andFrame:CGRectMake(12, 154 + 0 ,58 ,18)];
    [scroll addSubview:ingreidentLab];
    
    _ingreidentTextField = [[UITextField alloc] initWithFrame:CGRectMake(65, 154 + 0, kScreenWidth - 100, 18)];
    _ingreidentTextField.delegate = self;
    _ingreidentTextField.placeholder = @"请输入菜谱原料";
    [scroll addSubview:_ingreidentTextField];
    
    UIView *ingreidentLine = [[UIView alloc] initWithFrame:CGRectMake(65, 154 + 0 + 20 + 0.5, kScreenWidth - 100, 0.5)];
    ingreidentLine.backgroundColor = [UIColor colorWithHexString:@"#dfdfdf"];
    [scroll addSubview:ingreidentLine];
    
    // 专辑图片
    _ImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 188 + 0, kScreenWidth, 150)];
    _ImageView.image = [UIImage imageWithData:_cookeryBookModel.albumData];
    [scroll insertSubview:_ImageView atIndex:0];
    
    // 点击修改图片
    UIButton *changeImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    changeImageBtn.frame = CGRectMake(80, 188 + 153, kScreenWidth - 160, 30);
    [changeImageBtn setTitle:@"修改图片" forState:UIControlStateNormal];
    [changeImageBtn addTarget:self action:@selector(changeImage:) forControlEvents:UIControlEventTouchUpInside];
    [scroll addSubview:changeImageBtn];
    
    //
    UIButton *changeStepBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    changeStepBtn.frame = CGRectMake(80, 188 + 153 + 30 + 3, kScreenWidth - 160, 30);
    [changeStepBtn setTitle:@"修改步骤" forState:UIControlStateNormal];
    [changeStepBtn addTarget:self action:@selector(changeStep:) forControlEvents:UIControlEventTouchUpInside];
    [scroll addSubview:changeStepBtn];
    
    _titleTextField.text = _cookeryBookModel.title;
    _ingreidentTextField.text = _cookeryBookModel.ingredients;
    _burdenTextField.text = _cookeryBookModel.burden;
    _tagsTextField.text = _cookeryBookModel.tags;
    _introTextField.text = _cookeryBookModel.intro;
}

- (void)changeStep:(UIButton *)btn {
    
}

- (void)changeImage:(UIButton *)btn {
    //调用相机的相关功能
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction* OpenPhotoAction = [UIAlertAction actionWithTitle:@"打开相机" style:UIAlertActionStyleDefault                                                                 handler:^(UIAlertAction * action){
        [self p_takePhoto];
    }];
    UIAlertAction* fromPhotoAction = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault                                                                 handler:^(UIAlertAction * action){
        [self p_getLocalPhoto];
        
    }];
    [alertController addAction:fromPhotoAction];
    [alertController addAction:OpenPhotoAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - ImageManipulate
/**
 *  打开本地相册
 */
- (void)p_getLocalPhoto {
    // 本地相册
    UIImagePickerController *pick = [[UIImagePickerController alloc] init];
    pick.delegate = self;
    [self presentViewController:pick animated:YES completion:nil];
}

/**
 *  拍照
 */
- (void)p_takePhoto {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *pick = [[UIImagePickerController alloc] init];
        pick.delegate = self;
        pick.allowsEditing = YES;
        pick.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:pick animated:YES completion:nil];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有摄像头" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }
}

#pragma mark - UINavigationControllerDelegate
/**
 *  照片获取完成
 *
 *  @param picker
 *  @param info
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    _ImageView.image = info[@"UIImagePickerControllerOriginalImage"];
    _cookeryBookModel.albumData = UIImageJPEGRepresentation(_ImageView.image, 1);
    [picker dismissViewControllerAnimated:YES completion:nil];
}

/**
 *  取消获取照片
 *
 *  @param picker
 */
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
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
