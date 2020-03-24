/************************************************************
 *  * Hyphenate CONFIDENTIAL
 * __________________
 * Copyright (C) 2016 Hyphenate Inc. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of Hyphenate Inc.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Hyphenate Inc.
 */

#import "EaseUserCell.h"

#import "EaseImageView.h"
#import "UIImageView+WebCache.h"
#import <Masonry.h>

CGFloat const EaseUserCellPadding = 10;

@interface EaseUserCell()

@property (nonatomic) NSLayoutConstraint *titleWithAvatarLeftConstraint;

@property (nonatomic) NSLayoutConstraint *titleWithoutAvatarLeftConstraint;

@end

@implementation EaseUserCell

+ (void)initialize
{
    // UIAppearance Proxy Defaults
    /** @brief 默认配置 */
    EaseUserCell *cell = [self appearance];
    cell.titleLabelColor = [UIColor blackColor];
    cell.titleLabelFont = [UIFont systemFontOfSize:15];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.accessibilityIdentifier = @"table_cell";

        [self _setupSubview];
        
        UILongPressGestureRecognizer *headerLongPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(headerLongPress:)];
        [self addGestureRecognizer:headerLongPress];
    }
    
    return self;
}

#pragma mark - private layout subviews

/*!
 @method
 @brief 加载视图
 @discussion
 @return
 */
- (void)_setupSubview
{
    _avatarView = [[EaseImageView alloc] init];
    [self.contentView addSubview:_avatarView];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.numberOfLines = 2;
    _titleLabel.font = [UIFont systemFontOfSize:15];
    _titleLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_titleLabel];
    
    UILabel *line = [[UILabel alloc] init];
    line.backgroundColor = RYBackgroundColor;
    [self.contentView addSubview:line];
    
    
    __weak __typeof(&*self)weakSelf = self;
    [_avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView).offset(10);
        make.centerY.equalTo(weakSelf.contentView);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(30);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.avatarView.mas_right).offset(10);
        make.centerY.equalTo(weakSelf.contentView);
    }];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView).offset(10);
        make.right.equalTo(weakSelf.contentView.mas_right).offset(-5);
        make.bottom.equalTo(weakSelf.contentView.mas_bottom);
        make.height.mas_equalTo(0.5);
    }];
    

    
}


#pragma mark - setter

- (void)setShowAvatar:(BOOL)showAvatar
{
//    if (_showAvatar != showAvatar) {
//        _showAvatar = showAvatar;
//        self.avatarView.hidden = !showAvatar;
//        if (_showAvatar) {
//            [self removeConstraint:self.titleWithoutAvatarLeftConstraint];
//            [self addConstraint:self.titleWithAvatarLeftConstraint];
//        }
//        else{
//            [self removeConstraint:self.titleWithAvatarLeftConstraint];
//            [self addConstraint:self.titleWithoutAvatarLeftConstraint];
//        }
//    }
}

- (void)setDict:(NSDictionary *)dict
{
    _dict = dict;
    if ([dict objectForKey:@"nickname"]) {
        self.titleLabel.text = [dict objectForKey:@"nickname"];
    }
    if ([dict objectForKey:@"userIcon"]) {
//        NSString *imgurl = [NSString stringWithFormat:@"%@/%@",RYBaseImageAddress,[dict objectForKey:@"userIcon"]];
         [self.avatarView.imageView af_setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"userIcon"]] placeholderImage:[UIImage imageNamed:@"占位图"]];
    }
    
}

- (void)setModel:(id<IUserModel>)model
{
    _model = model;
    
    if ([_model.nickname length] > 0) {
        self.titleLabel.text = _model.nickname;
    }
    else{
       self.titleLabel.text = _model.buddy;
    }
    
    if ([_model.avatarURLPath length] > 0){
//        [self.avatarView.imageView sd_setImageWithURL:[NSURL URLWithString:@"http://www.hbtv.com.cn/lh/kaohe/img/bcg_slide-1.jpg"] placeholderImage:_model.avatarImage];
    } else {
        if (_model.avatarImage) {
            self.avatarView.image = _model.avatarImage;
        }
    }
}




#pragma mark - class method

/*!
 @method
 @brief 获取cell的重用标识
 @discussion
 @param model   消息model
 @return 返回cell的重用标识
 */
+ (NSString *)cellIdentifierWithModel:(id)model
{
    return @"EaseUserCell";
}

/*!
 @method
 @brief 获取cell的高度
 @discussion
 @param model   消息model
 @return  返回cell的高度
 */
+ (CGFloat)cellHeightWithModel:(id)model
{
    return EaseUserCellMinHeight;
}

#pragma mark - action

/*!
 @method
 @brief 头像长按事件
 @discussion
 @param longPress  长按手势
 @return
 */
- (void)headerLongPress:(UILongPressGestureRecognizer *)longPress
{
    if (longPress.state == UIGestureRecognizerStateBegan) {
        if(_delegate && _indexPath && [_delegate respondsToSelector:@selector(cellLongPressAtIndexPath:)])
        {
            [_delegate cellLongPressAtIndexPath:self.indexPath];
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    if (_avatarView.badge) {
        _avatarView.badgeBackgroudColor = [UIColor redColor];
    }
}

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:animated];
    if (_avatarView.badge) {
        _avatarView.badgeBackgroudColor = [UIColor redColor];
    }
}

@end
