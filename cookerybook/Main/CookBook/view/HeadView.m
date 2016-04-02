//
//  HeadView.m
//  cookerybook
//
//  Created by hmy2015 on 15/10/9.
//  Copyright (c) 2015年 何米颖大天才. All rights reserved.
//

#import "HeadView.h"
#import "AFNetworking.h"
#import "CookBookModel.h"
#import "MBProgressHUD.h"
#import "CookBookTableView.h"
#import "CookBookViewController.h"

@interface HeadView () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>


@end

@implementation HeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 5;
        flowLayout.minimumInteritemSpacing = 5;
        flowLayout.itemSize = CGSizeMake(50, 30);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:flowLayout];
        collectionView.userInteractionEnabled = YES;
        [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"HeadViewCell"];
        collectionView.delegate = self;
        collectionView.backgroundColor = [UIColor whiteColor];
        collectionView.contentSize = CGSizeMake(10000, 30);
        collectionView.scrollEnabled = YES;
        collectionView.pagingEnabled = YES;
        collectionView.showsHorizontalScrollIndicator = NO;
        collectionView.dataSource = self;
        [self addSubview:collectionView];
    }
    return self;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *titles = @[@"番茄",
                        @"鸡蛋",
                        @"肉丝",
                        @"鸡翅",
                        @"牛肉",
                        @"青菜",
                        @"豆腐",
                        @"排骨",
                        @"鸡蛋",
                        @"黑木耳"];
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HeadViewCell" forIndexPath:indexPath];
    if (cell.contentView.subviews != nil)
    {
        for (UIView *view in cell.contentView.subviews)
        {
            [view removeFromSuperview];
        }
    }
    UILabel *textLabel = [[UILabel alloc] initWithFrame:cell.bounds];
    textLabel.font = [UIFont systemFontOfSize:12];
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.text = titles[indexPath.row];
    textLabel.layer.cornerRadius = 3;
    textLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
    textLabel.tag = 100;
    textLabel.layer.borderWidth = .6;
    [cell.contentView addSubview:textLabel];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    UILabel *textLabel = (UILabel *)[cell.contentView viewWithTag:100];
    [self p_loadDataWithMenu:textLabel.text];
}

- (void)p_loadDataWithMenu:(NSString *)menu
{
    NSMutableArray *cookBookModelArray = [NSMutableArray array];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *uelString = @"http://apis.haoservice.com/lifeservice/cook/query";
    NSLog(@"%@", [self.nextResponder class]);
    
    UIView *cookBookView = (UIView *)self.nextResponder.nextResponder;
    MBProgressHUD *progress = [[MBProgressHUD alloc] initWithView:cookBookView];
    [cookBookView addSubview:progress];
    progress.labelText = @"加载中";
    [progress show:YES];
    NSMutableDictionary *params = [@{
                                     @"key" : kApiKey,
                                     @"menu" : menu,
                                     @"pn" : @20,
                                     @"rn" : @20
                                     } mutableCopy];
    [manager GET:uelString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
        NSArray *array = responseObject[@"result"];
        for (NSDictionary *dic in array)
        {
            CookBookModel *model = [[CookBookModel alloc] initWithDataDic:dic];
            [cookBookModelArray addObject:model];
        }
        _reloadTableViewBlock(cookBookModelArray);
        [progress removeFromSuperview];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@", error);
    }];
}

@end
