

//
//  StepDetailViewController.m
//  cookerybook
//
//  Created by hmy2015 on 15/10/9.
//  Copyright (c) 2015年 何米颖大天才. All rights reserved.
//

#import "StepDetailViewController.h"
#import "StepDetailCollectionViewCell.h"

@interface StepDetailViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
{
    UICollectionView *_collectionView;
}
@end

@implementation StepDetailViewController

#pragma mark - lifeCycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_currentStep inSection:0];
    [_collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
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

#pragma mark - other
- (void)setDetailCookBookArray:(NSArray *)detailCookBookArray
{
    if (_detailCookBookArray != detailCookBookArray)
    {
        _detailCookBookArray = detailCookBookArray;
        [self p_createView];
    }
}

- (void)setDetailNewCookBookArray:(NSArray *)detailNewCookBookArray {
    _detailNewCookBookArray = detailNewCookBookArray;
    [self p_createView];
}

- (void)p_createView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.itemSize = CGSizeMake(kScreenWidth, kScreenHeight);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    _collectionView.contentSize = CGSizeMake(kScreenWidth * _detailCookBookArray.count, kScreenHeight);
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.pagingEnabled = YES;
    _collectionView.showsHorizontalScrollIndicator = NO;
    [_collectionView registerNib:[UINib nibWithNibName:@"StepDetailCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"stepDetailCell"];
    [self.view addSubview:_collectionView];
}

#pragma mark - delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (_detailNewCookBookArray) {
        return _detailNewCookBookArray.count;
    } else if (_detailCookBookArray) {
        return _detailCookBookArray.count;
    } else {
        return 0;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    StepDetailCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"stepDetailCell" forIndexPath:indexPath];
    cell.currentStep = indexPath.row;
    if (_detailNewCookBookArray) {
        cell.totalStep = _detailNewCookBookArray.count;
        cell.oneStepModel = _detailNewCookBookArray[indexPath.row];
    } else if (_detailCookBookArray) {
        cell.totalStep = _detailCookBookArray.count;
        cell.detailCookBookModel = _detailCookBookArray[indexPath.row];
    }
    return cell;
}

@end
