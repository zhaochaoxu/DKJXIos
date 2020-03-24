//
//  RYHomeTopView.m
//  HRRongYaoApp
//
//  Created by fabs on 2017/5/4.
//  Copyright © 2017年 fabs. All rights reserved.
//

#import "RYHomeTopView.h"
#import "RYHomeTopViewCell.h"
#import "CHTCollectionViewWaterfallLayout.h"

@interface RYHomeTopView ()<CHTCollectionViewDelegateWaterfallLayout,UICollectionViewDataSource>

@property (retain, nonatomic) UICollectionView *collectionView;

@property (retain, nonatomic) UIView *animatedView;

@end

@implementation RYHomeTopView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.collectionView];
        [self addSubview:self.animatedView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.collectionView setFrame:self.bounds];
    if (CGRectIsEmpty(self.animatedView.frame)) {
        CGFloat width = (CGRectGetWidth(self.collectionView.bounds) - (self.titles.count-1) * 15)/self.titles.count;
        CGSize size = [[self.titles objectAtIndex:self.currentIndex] boundingRectWithSize:CGSizeMake(200, 50) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.0]} context:NULL].size;
        

        
        [self.animatedView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset((width - size.width) *0.5);
            make.bottom.equalTo(self.mas_bottom).offset(1);
            make.width.mas_equalTo(size.width);
            make.height.mas_equalTo(3);
        }];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.titles.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = (CGRectGetWidth(collectionView.bounds) - (self.titles.count-1) * 15)/self.titles.count;
    return CGSizeMake(width, CGRectGetHeight(collectionView.bounds));
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RYHomeTopViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RYHomeTopViewCellIdentifier" forIndexPath:indexPath];
    cell.titleLabel.text = [self.titles objectAtIndex:indexPath.row];
    cell.titleLabel.textColor = (indexPath.row == self.currentIndex) ? RYNavigationBarColor : RGB0X(0x333333);
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.currentIndex = indexPath.row;
}

- (void)resetAnimatedView {
    CGFloat width = (CGRectGetWidth(self.collectionView.bounds) - MAX(0, self.titles.count -1) * 15)/self.titles.count;
    CGSize size = [[self.titles objectAtIndex:self.currentIndex] boundingRectWithSize:CGSizeMake(200, 50) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.0]} context:NULL].size;
    

    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rect = self.animatedView.frame;
        rect.origin.x = (width - size.width) *0.5 + self.currentIndex *(width + 15);
        rect.size.width = size.width;
        self.animatedView.frame = rect;
    }];
}

- (void)setTitles:(NSArray<NSString *> *)titles {
    _titles = titles;
    [(CHTCollectionViewWaterfallLayout *)self.collectionView.collectionViewLayout setColumnCount:titles.count];
//    [self.collectionView reloadData];
}

- (void)setCurrentIndex:(NSInteger)currentIndex {
    if (_currentIndex != currentIndex) {
        _currentIndex = currentIndex;
        if (_currentIndex > self.titles.count) {
            return;
        }
        [self resetAnimatedView];
        [self.collectionView reloadData];
        if (self.didSelectedRowAtIndexPathHandler) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_currentIndex inSection:0];
            self.didSelectedRowAtIndexPathHandler(indexPath,[self.titles objectAtIndex:indexPath.row]);
        }   
    }
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        CHTCollectionViewWaterfallLayout *flowLayout = [[CHTCollectionViewWaterfallLayout alloc] init];
        flowLayout.minimumColumnSpacing = 15.0;
        flowLayout.minimumInteritemSpacing = 0.0;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.scrollEnabled = YES;
        [_collectionView setBackgroundColor:[UIColor whiteColor]];
        [_collectionView setDelegate:self];
        [_collectionView setDataSource:self];
        [_collectionView registerClass:[RYHomeTopViewCell class] forCellWithReuseIdentifier:@"RYHomeTopViewCellIdentifier"];
    }
    return _collectionView;
}

- (UIView *)animatedView {
    if (!_animatedView) {
        _animatedView = [[UIView alloc] initWithFrame:CGRectZero];
        _animatedView.backgroundColor = RYNavigationBarColor;
    }
    return _animatedView;
}

@end
