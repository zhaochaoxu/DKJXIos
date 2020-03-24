//
//  RYSegmentView.m
//  HRRongYaoApp
//
//  Created by fabs on 2017/4/27.
//  Copyright © 2017年 fabs. All rights reserved.
//

#import "RYSegmentView.h"

@interface RYSegmentViewCell : UICollectionViewCell

@property (retain, nonatomic) UILabel *titleLabel;

@end

@implementation RYSegmentViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.titleLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.titleLabel setFrame:self.contentView.bounds];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = RGB0X(0xffffff);
        _titleLabel.customEdgeInsets = YES;
        _titleLabel.edgeInsets = UIEdgeInsetsMake(10, 0, 10, 0);
    }
    return _titleLabel;
}

@end

@interface RYSegmentView ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>

@property (retain, nonatomic) UICollectionView *collectionView;

@property (retain, nonatomic) UIImageView *animatedView;

@end

@implementation RYSegmentView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.collectionView];
        [self addSubview:self.animatedView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray<NSString *> *)titles {
    self = [super initWithFrame:frame];
    if (self) {
        self.titles = [titles copy];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.collectionView setFrame:self.bounds];
    if (CGRectIsEmpty(self.animatedView.frame)) {
        NSInteger itemNumber = self.titles.count > 4 ? 4 : self.titles.count;
        CGFloat width = CGRectGetWidth(self.bounds) / itemNumber;
        [self.animatedView setFrame:CGRectMake(15.0, 33.0, width - 30, 1)];
    }
}

#pragma mark - UICollectionView Delegate and DataSource Methods
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.titles.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger itemNumber = self.titles.count > 4 ? 4 : self.titles.count;
    return CGSizeMake(floorf(CGRectGetWidth(collectionView.bounds)/itemNumber), CGRectGetHeight(collectionView.bounds));
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RYSegmentViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RYSegmentViewCellIdentifier" forIndexPath:indexPath];
    [cell.titleLabel setText:[self.titles objectAtIndex:indexPath.row]];
    if (self.scale) {
        cell.titleLabel.font = [UIFont systemFontOfSize:indexPath.row == self.index ? 16.0 : 14.0];
    }   else {
        cell.titleLabel.font = [UIFont systemFontOfSize:14.0];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.index = indexPath.row;
}
#pragma mark -

- (void)resetAnimatedView {
    NSInteger itemNumber = self.titles.count > 4 ? 4 : self.titles.count;
    CGFloat width = CGRectGetWidth(self.bounds) / itemNumber;
    [UIView animateWithDuration:0.5 animations:^{
        CGRect rect = self.animatedView.frame;
        rect.origin.x = self.index * width + 12;
        rect.size.width = width - 30;
        self.animatedView.frame = rect;
    }];
    if (_delegate && [_delegate respondsToSelector:@selector(segementView:didSeletcedIndex:)]) {
        [_delegate segementView:self didSeletcedIndex:self.index];
    }
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:_index inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    [self.collectionView reloadData];
}

#pragma mark - Setting and Getting Methods
- (void)setTitles:(NSArray<NSString *> *)titles {
    _titles = [titles copy];
    self.index = 0;
}

- (void)setIndex:(NSInteger)index {
    _index = index;
    [self resetAnimatedView];
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.minimumLineSpacing = 0.0f;
        flowLayout.minimumInteritemSpacing = 0.0f;
#if __IPHONE_8_0
        flowLayout.estimatedItemSize = CGSizeZero;
#endif
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = self.backgroundColor;
        [_collectionView setDelegate:self];
        [_collectionView setDataSource:self];
        [_collectionView setShowsHorizontalScrollIndicator:NO];
        [_collectionView registerClass:[RYSegmentViewCell class] forCellWithReuseIdentifier:@"RYSegmentViewCellIdentifier"];
    }
    return _collectionView;
}

- (UIImageView *)animatedView {
    if (!_animatedView) {
        _animatedView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _animatedView.backgroundColor = RGB0X(0xffffff);
    }
    return _animatedView;
}
#pragma mark -

@end
