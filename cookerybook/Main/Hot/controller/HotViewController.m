 //
//  HotViewController.m
//  cookerybook
//
//  Created by hmy2015 on 15/9/29.
//  Copyright (c) 2015年 何米颖大天才. All rights reserved.
//

#import "HotViewController.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "TypeModel.h"
#import "TypeCookBookViewController.h"

@interface HotViewController () <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>
{
    UICollectionView *_collectionView; // 瀑布流
    NSMutableArray *_typeArray; // 菜谱类别数组
    NSInteger _currentIndex;   // 当前页面数
}
@end

@implementation HotViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self p_createView];
    [self p_loadData];
    
}

#pragma mark - 业务逻辑
// 加载数据
- (void)p_loadData
{
    _typeArray = [NSMutableArray array];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *uelString = @"http://apis.haoservice.com/lifeservice/cook/category";
    MBProgressHUD *progress = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:progress];
    [progress show:YES];
    NSMutableDictionary *params = [@{
                                     @"key" : kApiKey,
                                     } mutableCopy];
    [manager GET:uelString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
        NSArray *result = responseObject[@"result"];
        for (NSDictionary *dic in result)
        {
            TypeModel *typeModel = [[TypeModel alloc] initWithDataDic:dic];
            [_typeArray addObject:typeModel];
        }
        [_typeArray insertObject:_typeArray.lastObject atIndex:0];
        [_typeArray addObject:_typeArray[1]];
        [progress removeFromSuperview];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_collectionView reloadData];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
            [_collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        });
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@", error);
    }];
}

// 创建视图
- (void)p_createView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.itemSize = CGSizeMake(kScreenWidth, kScreenHeight);
    //CGSizeMake(kScreenWidth - 100, kScreenHeight - 64 - 48 - 100);
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    _collectionView.contentSize = CGSizeMake(9 * kScreenWidth, kScreenHeight);
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.pagingEnabled = YES;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"hotCell"];
    [self.view addSubview:_collectionView];
}


#pragma mark - delegate scrollView

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    _currentIndex = (scrollView.contentOffset.x + kScreenWidth/2) / kScreenWidth;
    if (_typeArray.count > 0)
    {
        if (_currentIndex == 0)
        {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(_typeArray.count - 2) inSection:0];
            [_collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
            
        }
        if (_currentIndex == _typeArray.count - 1)
        {
            [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    _currentIndex = (scrollView.contentOffset.x + kScreenWidth/2) / kScreenWidth;
    if (_typeArray.count > 0)
    {
        if (_currentIndex == 0)
        {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(_typeArray.count - 2) inSection:0];
            [_collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
            
        }
        if (_currentIndex == _typeArray.count - 1)
        {
            [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        }
    }
}

#pragma mark - delegate CollectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _typeArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"hotCell" forIndexPath:indexPath];
    NSArray *arr = cell.contentView.subviews;
    if (arr != nil)
    {
        for (UIView *view in arr)
        {
            [view removeFromSuperview];
        }
    }
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0 , 0, kScreenWidth - 100, kScreenHeight - 64 - 48 - 100)];
    imageView.center = CGPointMake(kScreenWidth / 2, kScreenHeight / 2);
    TypeModel *model = _typeArray[indexPath.row];
    imageView.layer.cornerRadius = 10;
    imageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    imageView.layer.borderWidth = .8;
    imageView.layer.masksToBounds = YES;
    imageView.image = [UIImage imageNamed:model.type];
    [cell.contentView addSubview:imageView];
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, kScreenWidth, 30)];
    textLabel.top = imageView.bottom + 5;
    textLabel.font = [UIFont systemFontOfSize:20];
    textLabel.textColor = [UIColor blackColor];
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.text = model.type;
    [cell.contentView addSubview:textLabel];
    cell.contentView.layer.cornerRadius = 1;
    cell.contentView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    cell.contentView.layer.borderWidth = .8;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    TypeModel *typeModel = _typeArray[indexPath.row];
    TypeCookBookViewController *typeCookBookVC = [[TypeCookBookViewController alloc] init];
    typeCookBookVC.typeModel = typeModel;
    [self.navigationController pushViewController:typeCookBookVC animated:YES];
}

@end
