//
//  GuideViewController.m
//  XiaoYing
//
//  Created by 何米颖大天才 on 15/10/12.
//  Copyright (c) 2015年 何米颖大天才. All rights reserved.
//

#import "GuideViewController.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "BaseNaviViewController.h"

#define PageCOUNT  3

@interface GuideViewController ()<UIScrollViewDelegate>
{
    UIPageControl *pageControl;
    UIScrollView  *dyScrollView;
}
@end

@implementation GuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden=YES;
    self.view.backgroundColor=[UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:100];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    [self  p_initGuide];   //加载新用户指导页面
    [self  p_initpagecontrol];
}

-(void)p_initpagecontrol
{
    pageControl = [[UIPageControl alloc] init];
    pageControl.backgroundColor=[UIColor  clearColor];
    pageControl.frame=CGRectMake((self.view.frame.size.width-100)/2,self.view.frame.size.height-130, 100, 30) ;
    pageControl.numberOfPages = PageCOUNT; // 一共显示多少个圆点（多少页）
    // 设置非选中页的圆点颜色
    pageControl.pageIndicatorTintColor = [UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:100];
    // 设置选中页的圆点颜色
    pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:37.0/255.0 green:174.0/255.0 blue:96.0/255.0 alpha:100];
    // 禁止默认的点击功能
    pageControl.enabled = NO;
    [self.view addSubview:pageControl];
}


-(void)p_initGuide
{
    NSArray *iPhone4Garray=@[@"nav_1.jpg",@"nav_2.jpg",@"nav_3.jpg"];//iphone5
    dyScrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, self.view.frame.size.height)];
    dyScrollView.delegate=self;
    dyScrollView.backgroundColor=[UIColor clearColor];
    dyScrollView.contentSize=CGSizeMake(kScreenWidth * PageCOUNT, kScreenHeight);
    dyScrollView.showsVerticalScrollIndicator=NO;
    dyScrollView.pagingEnabled=YES;
    //    dyScrollView.bounces=NO;       //取消弹性
    dyScrollView.showsHorizontalScrollIndicator=NO;
    [self.view addSubview:dyScrollView];
    for (int i=0; i<[iPhone4Garray  count]; i++)
    {
        UIImageView *imgView=[[UIImageView alloc] initWithFrame:CGRectMake(i*kScreenWidth, 0,kScreenWidth , kScreenHeight)];
        imgView.image=[UIImage  imageNamed:iPhone4Garray[i]];
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        [dyScrollView addSubview:imgView];
        
        if (i == [iPhone4Garray  count]-1)
        {
            [imgView setUserInteractionEnabled:YES];
            //开始使用
            UIButton   *UserButton=[UIButton  buttonWithType:UIButtonTypeCustom];
            UserButton.frame=CGRectMake((kScreenWidth-100)/2,kScreenHeight-100,100, 35);
            UserButton.backgroundColor=[UIColor   clearColor];
            UserButton.tag=1001;
            [UserButton.layer setCornerRadius:5];
            UserButton.backgroundColor=[UIColor colorWithRed:37.0/255.0 green:174.0/255.0 blue:96.0/255.0 alpha:100];
            [UserButton  setTitle:@"立即使用" forState:UIControlStateNormal];
            [UserButton  addTarget:self action:@selector(ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [imgView  addSubview:UserButton];
        }
    }
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //更新UIPageControl的当前页
    CGPoint offset = scrollView.contentOffset;
    CGRect bounds = scrollView.frame;
    [pageControl setCurrentPage:offset.x / bounds.size.width];
}

-(void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = self.view.frame.size.width;
    // 在滚动超过页面宽度的50%的时候，切换到新的页面
    int page = floor((dyScrollView.contentOffset.x + pageWidth/2)/pageWidth) ;
    pageControl.currentPage = page;
}

//点击button跳转到根视图
- (void)firstpressed:(UIButton*)sender
{
    [UIView  animateWithDuration:1.2 animations:^{
        self.view.frame=CGRectMake(0, 0, kScreenWidth * 2, kScreenHeight * 2);
        self.view.alpha=0.0;
        
    } completion:^(BOOL finished) {
        [self.view  removeFromSuperview];
        
    }];
    //   [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

//按钮点击
-(void)ButtonClick:(UIButton *)sender
{
    NSLog(@"立即使用");
    AppDelegate *app =(AppDelegate*)[UIApplication sharedApplication].delegate;
    BaseNaviViewController *base = [[BaseNaviViewController alloc] initWithRootViewController:[[LoginViewController alloc] init]];
    app.window.rootViewController =base;
}


-(void)viewWillDisappear:(BOOL)animated
{
    self.view=nil;
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
