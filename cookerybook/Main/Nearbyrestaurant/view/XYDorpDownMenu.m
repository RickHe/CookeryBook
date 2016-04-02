//
//  XYDorpDownMenu.m
//  XYDropDownListDemo
//
//  Created by hemiying on 16/1/18.
//  Copyright © 2016年 hemiying. All rights reserved.
//

#import "XYDorpDownMenu.h"

@interface XYDorpDownMenu () <UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_tableView;
    NSString *_menuTitle;
    UIButton *_clickStartBtn;
    UIImageView *_clickStartTip;
    UILabel *_menuTitleLab;
    NSArray *_tempDataSource;
    CGRect _headViewFrame;
    UIView *_backgroundView;
}

@property (nonatomic, readwrite, strong) NSArray *dataSource;

@end

@implementation XYDorpDownMenu

#pragma mark - LifeCycle
/**
 *  使用数剧初始化
 *
 *  @param frame      大小
 *  @param MenuTitle  菜单名称
 *  @param dataSource 菜单选项数据
 *
 *  @return self
 */
- (instancetype)initWithFrame:(CGRect)frame
                    MenuTitle:(NSString *)title
                   DataSource:(NSArray *)dataSource {
    if (self = [super initWithFrame:frame]) {
        _headViewFrame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        _menuTitle = title;
        _dataSource = dataSource;
        _tempDataSource = [[NSArray alloc] initWithArray:_dataSource copyItems:YES];
        _dataSource = nil;
        [self p_createSubviews];
    }
    return self;
}

/**
 *  默认初始化屏蔽
 *
 *  @return nil
 */
- (instancetype)init {
    NSAssert(true, @"请输入菜单数据参数");
    return nil;
}

/**
 *  默认初始化屏蔽
 *
 *  @param frame
 *
 *  @return nil
 */
- (instancetype)initWithFrame:(CGRect)frame {
    NSAssert(true, @"请输入菜单数据参数");
    return nil;
}

#pragma mark - SubViews
/**
 *  创建子视图
 */
- (void)p_createSubviews {
    // 点击展开按钮
    _clickStartBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _clickStartBtn.frame = CGRectMake(0, 0, _headViewFrame.size.width, _headViewFrame.size.height);
    [_clickStartBtn addTarget:self action:@selector(clickToStartAction:) forControlEvents:UIControlEventTouchUpInside];
    _clickStartBtn.backgroundColor = [UIColor whiteColor];
    [self addSubview:_clickStartBtn];
    
    // 菜单名字
    _menuTitleLab = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 100, 14)];
    _menuTitleLab.text = _menuTitle;
    _menuTitleLab.backgroundColor = [UIColor clearColor];
    [_clickStartBtn addSubview:_menuTitleLab];
    
    // 菜单点击展开按钮
    _clickStartTip = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width - 5 - 10.5, _headViewFrame.size.height - 8 - 10.5, 10.5, 10.5)];
    _clickStartTip.image = [UIImage imageNamed:@"opinion_read"];
    [_clickStartBtn addSubview:_clickStartTip];
    
    // 线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, _headViewFrame.size.height, _headViewFrame.size.width, 0.5)];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#d5d7dc"];
    [self addSubview:lineView];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorColor = [UIColor whiteColor];
    _tableView.backgroundColor = [UIColor blackColor];
    [self addSubview:_tableView];
}

#pragma mark - ShowViews
/**
 *  显示展开的视图
 */
- (void)p_showOpenMenuView {
    // 黑色背景
    CGRect rect = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
//    rect = [self convertRect:rect fromView:self.superview];
    _backgroundView = [[UIView alloc] initWithFrame:rect];
    _backgroundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
    [self.superview addSubview:_backgroundView];
    
    _dataSource = [[NSArray alloc] initWithArray:_tempDataSource copyItems:YES];
    CGFloat rows = _dataSource.count;
    if (_dataSource.count > 6) {
        rows = 6;
    }
    CGRect frame = self.frame;
    frame.size.height += rows * 30;
    self.frame = frame;
    _tableView.frame = CGRectMake(0, _headViewFrame.size.height, _headViewFrame.size.width, rows * 30);
    _clickStartTip.image = [UIImage imageNamed:@"opinion_reading"];
    [_tableView reloadData];
    UIView *view = self.superview;
    [view addSubview:self];
}

/**
 *  显示收起的视图
 */
- (void)p_showCloseMenuView {
    [_backgroundView removeFromSuperview];
    
    CGFloat rows = _dataSource.count;
    if (_dataSource.count > 6) {
        rows = 6;
    }
    CGRect frame = self.frame;
    frame.size.height -= rows * 30;
    self.frame = frame;
    _tableView.frame = CGRectZero;
    _clickStartTip.image = [UIImage imageNamed:@"opinion_read"];
    _dataSource = nil;
    [_tableView reloadData];
}

#pragma mark - Setter
/**
 *  设置背景颜色
 *
 *  @param color
 */
- (void)setMenuItemBackgroundColor:(UIColor *)menuItemBackgroundColor {
    _menuItemBackgroundColor = menuItemBackgroundColor;
    _tableView.backgroundColor = _menuItemBackgroundColor;
}

- (void)setSectionColor:(UIColor *)sectionColor {
    _sectionColor = sectionColor;
    //_clickStartBtn.backgroundColor = _sectionColor;
}

/**
 *  设置分割线颜色
 *
 *  @param separationLineColor
 */
- (void)setSeparationLineColor:(UIColor *)separationLineColor {
    _separationLineColor = separationLineColor;
    _tableView.separatorColor = _separationLineColor;
}

/**
 *  字体大小
 *
 *  @param font
 */
- (void)setFont:(UIFont *)font {
    _font = font;
    _menuTitleLab.font = _font;
}

/**
 *  默认颜色
 *
 *  @param placeholderColor
 */
- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    _placeholderColor = placeholderColor;
    _menuTitleLab.textColor = placeholderColor;
}

#pragma mark - ButtonAction
/**
 *  点击展开按钮事件
 *
 *  @param btn
 */
- (void)clickToStartAction:(UIButton *)btn {
    btn.selected = !btn.selected;
    if (btn.selected) {
        [self p_showOpenMenuView];
    } else {
        [self p_showCloseMenuView];
    }
}

#pragma mark - UITableViewDataSource
// 区数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// 行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSource.count;
}

// cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, 100, 10)];
    label.text = _dataSource[indexPath.row];
    // 字体
    if (_meneItemTextFont) {
        label.font = _meneItemTextFont;
    } else {
        label.font = [UIFont systemFontOfSize:10];
    }
    // 字体颜色
    if (_meneItemTextColor) {
        label.textColor = _meneItemTextColor;
    } else {
        label.textColor = [UIColor blackColor];
    }
    label.backgroundColor = [UIColor clearColor];
    cell.backgroundColor = [UIColor clearColor];
    [cell.contentView addSubview:label];
    return cell;
}

#pragma mark - UITableViewDelegate
/**
 *  调整分割线位置
 *
 *  @param tableView
 *  @param cell
 *  @param indexPath
 */
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:_separationLineInsets];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:_separationLineInsets];
    }
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
}

//高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30;
}

// 区尾高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}

// 选中
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _menuTitleLab.text = _tempDataSource[indexPath.row];
    _selectedString = _menuTitleLab.text;
    [_delegate XYDropDownMenu:self didSelectAtIndexPath:indexPath];
    _clickStartBtn.selected = NO;
    [self p_showCloseMenuView];
    _menuTitleLab.textColor = [UIColor blackColor];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
