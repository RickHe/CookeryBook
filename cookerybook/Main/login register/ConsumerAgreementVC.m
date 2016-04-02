//
//  ConsumerAgreementVC.m
//  XiaoYing
//
//  Created by 何米颖大天才 on 15/11/23.
//  Copyright © 2015年 何米颖大天才. All rights reserved.
//

#import "ConsumerAgreementVC.h"

@interface ConsumerAgreementVC ()

@end

@implementation ConsumerAgreementVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav-background"] forBarMetrics:0];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil]];
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    self.title=@"用户协议";
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden=NO;
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
