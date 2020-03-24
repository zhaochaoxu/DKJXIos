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

#import "EaseConversationCell.h"

#import <HyphenateLite/EMConversation.h>
#import "UIImageView+WebCache.h"
#import <Masonry.h>

CGFloat const EaseConversationCellPadding = 10;

@interface EaseConversationCell()

@property (nonatomic) NSLayoutConstraint *titleWithAvatarLeftConstraint;

@property (nonatomic) NSLayoutConstraint *titleWithoutAvatarLeftConstraint;

@property (nonatomic) NSLayoutConstraint *detailWithAvatarLeftConstraint;

@property (nonatomic) NSLayoutConstraint *detailWithoutAvatarLeftConstraint;

@end

@implementation EaseConversationCell

+ (void)initialize
{
    // UIAppearance Proxy Defaults
    /** @brief 默认配置 */
    EaseConversationCell *cell = [self appearance];
    cell.titleLabelColor = [UIColor blackColor];
    cell.titleLabelFont = [UIFont systemFontOfSize:17];
    cell.detailLabelColor = [UIColor lightGrayColor];
    cell.detailLabelFont = [UIFont systemFontOfSize:15];
    cell.timeLabelColor = [UIColor blackColor];
    cell.timeLabelFont = [UIFont systemFontOfSize:13];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _showAvatar = YES;
        [self _setupSubview];
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
    self.accessibilityIdentifier = @"table_cell";

    _avatarView = [[EaseImageView alloc] init];
    _avatarView.imageCornerRadius = 15;
    _avatarView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_avatarView];
    
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _timeLabel.font = _timeLabelFont;
    _timeLabel.textColor = _timeLabelColor;
    _timeLabel.textAlignment = NSTextAlignmentRight;
    _timeLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_timeLabel];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.accessibilityIdentifier = @"title";
    _titleLabel.font = [UIFont systemFontOfSize:15];
    _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _titleLabel.numberOfLines = 1;
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.font = _titleLabelFont;
    _titleLabel.textColor = _titleLabelColor;
    [self.contentView addSubview:_titleLabel];
    
    _detailLabel = [[UILabel alloc] init];
    _detailLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _detailLabel.backgroundColor = [UIColor clearColor];
    _detailLabel.font = [UIFont systemFontOfSize:13];
    _detailLabel.textColor = _detailLabelColor;
    [self.contentView addSubview:_detailLabel];
    
    UILabel *line = [[UILabel alloc] init];
    line.backgroundColor = RYBackgroundColor;
    [self.contentView addSubview:line];
    
    __weak __typeof(&*self)weakSelf = self;
    [_avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView).offset(10);
        make.top.equalTo(weakSelf.contentView).offset(15);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(30);
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.contentView.mas_right).offset(-10);
        make.top.equalTo(weakSelf.contentView).offset(15);
        
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.avatarView.mas_right).offset(10);
        make.right.equalTo(weakSelf.timeLabel).offset(-60);
        make.top.equalTo(weakSelf.contentView).offset(15);
    }];
    
    [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.avatarView.mas_right).offset(10);
        make.right.equalTo(weakSelf.contentView.mas_right).offset(-10);
        make.top.equalTo(weakSelf.titleLabel.mas_bottom).offset(10);
    }];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView).offset(10);
        make.right.equalTo(weakSelf.contentView.mas_right).offset(-5);
        make.bottom.equalTo(weakSelf.contentView.mas_bottom);
        make.height.mas_equalTo(0.5);
    }];
    
    
//    [self _setupAvatarViewConstraints];
//    [self _setupTimeLabelConstraints];
//    [self _setupTitleLabelConstraints];
//    [self _setupDetailLabelConstraints];
}

#pragma mark - Setup Constraints

/*!
 @method
 @brief 设置avatarView的约束
 @discussion
 @return
 */
- (void)_setupAvatarViewConstraints
{
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.avatarView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:EaseConversationCellPadding]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.avatarView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-EaseConversationCellPadding]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.avatarView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:EaseConversationCellPadding]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.avatarView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.avatarView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.avatarView attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0]];
}

/*!
 @method
 @brief 设置timeLabel的约束
 @discussion
 @return
 */
- (void)_setupTimeLabelConstraints
{
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.timeLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:EaseConversationCellPadding]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.timeLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-EaseConversationCellPadding]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.timeLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeHeight multiplier:0.5 constant:0]];
}

/*!
 @method
 @brief 设置titleLabel的约束
 @discussion
 @return
 */
- (void)_setupTitleLabelConstraints
{
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:EaseConversationCellPadding]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeHeight multiplier:0.5 constant:-EaseConversationCellPadding]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.timeLabel attribute:NSLayoutAttributeLeft multiplier:1.0 constant:-EaseConversationCellPadding]];
    
    self.titleWithAvatarLeftConstraint = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.avatarView attribute:NSLayoutAttributeRight multiplier:1.0 constant:EaseConversationCellPadding];
    self.titleWithoutAvatarLeftConstraint = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:EaseConversationCellPadding];
    [self addConstraint:self.titleWithAvatarLeftConstraint];
}

/*!
 @method
 @brief 设置detailLabel的约束
 @discussion
 @return
 */
- (void)_setupDetailLabelConstraints
{
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.detailLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.titleLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.detailLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-EaseConversationCellPadding]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.detailLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-EaseConversationCellPadding]];
    
    self.detailWithAvatarLeftConstraint = [NSLayoutConstraint constraintWithItem:self.detailLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.avatarView attribute:NSLayoutAttributeRight multiplier:1.0 constant:EaseConversationCellPadding];
    self.detailWithoutAvatarLeftConstraint = [NSLayoutConstraint constraintWithItem:self.detailLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:EaseConversationCellPadding];
    [self addConstraint:self.detailWithAvatarLeftConstraint];
}

#pragma mark - setter

- (void)setShowAvatar:(BOOL)showAvatar
{
    if (_showAvatar != showAvatar) {
        _showAvatar = showAvatar;
        self.avatarView.hidden = !showAvatar;
        if (_showAvatar) {
            [self removeConstraint:self.titleWithoutAvatarLeftConstraint];
            [self removeConstraint:self.detailWithoutAvatarLeftConstraint];
            [self addConstraint:self.titleWithAvatarLeftConstraint];
            [self addConstraint:self.detailWithAvatarLeftConstraint];
        }
        else{
            [self removeConstraint:self.titleWithAvatarLeftConstraint];
            [self removeConstraint:self.detailWithAvatarLeftConstraint];
            [self addConstraint:self.titleWithoutAvatarLeftConstraint];
            [self addConstraint:self.detailWithoutAvatarLeftConstraint];
        }
    }
}

- (void)setModel:(id<IConversationModel>)model
{
    _model = model;


    if (_model.conversation.type == EMConversationTypeGroupChat) {
        NSDictionary *dict = model.conversation.latestMessage.ext;
        NSDictionary *itemDict;
        if (dict == nil) {
            return;
        }
        
        if ([dict objectForKey:@"money_from_group_id"]) {
            itemDict = [[NSUserDefaults standardUserDefaults] valueForKey:[dict objectForKey:@"money_from_group_id"]];
        }else{
            itemDict = [[NSUserDefaults standardUserDefaults] valueForKey:[dict objectForKey:@"family_to_id"]];
        }
        NSLog(@"--%@",itemDict);
        self.titleLabel.text = [dict objectForKey:@"family_to_name"];
        NSString *imgurl = [NSURL URLWithString:[dict objectForKey:@"family_to_icon"]].absoluteString;
        [self.avatarView.imageView af_setImageWithURL:[NSURL URLWithString:imgurl] placeholderImage:[UIImage imageNamed:@"groupPublicHeader"]];
        
    }else if (_model.conversation.type == EMConversationTypeChat){
        NSDictionary *dict = model.conversation.latestMessage.ext;
        
        if ([dict objectForKey:@"family_from_icon"]) {
            NSString *fromUrl = [NSURL URLWithString:[dict objectForKey:@"family_from_icon"]].absoluteString;
            NSString *toUrl = [NSURL URLWithString:[dict objectForKey:@"family_to_icon"]].absoluteString;
            NSString *uid = [RYUserInfo uid];
            NSString *uidd = [dict objectForKey:@"family_from_id"];
            if (![uid isEqual:uidd]) {
                self.titleLabel.text = [dict objectForKey:@"family_from_name"];
                [self.avatarView.imageView af_setImageWithURL:[NSURL URLWithString:fromUrl] placeholderImage:_model.avatarImage];
            }else{
                self.titleLabel.text = [dict objectForKey:@"family_to_name"];
                [self.avatarView.imageView af_setImageWithURL:[NSURL URLWithString:toUrl] placeholderImage:_model.avatarImage];
            }
        }else if ([dict objectForKey:@"money_sender"]){//能走进来说明没看到id name icon
            NSDictionary *itemDict;
            if (![[RYUserInfo imId] isEqual:[dict objectForKey:@"money_sender"]]) {
                itemDict = [[NSUserDefaults standardUserDefaults] valueForKey:[dict objectForKey:@"money_sender"]];
            }else{
                itemDict = [[NSUserDefaults standardUserDefaults] valueForKey:[dict objectForKey:@"money_receiver"]];
            }
            NSLog(@"--%@",itemDict);
            self.titleLabel.text = [itemDict objectForKey:@"family_to_name"];
//            NSString *url = [NSString stringWithFormat:@"%@/%@",RYBaseImageAddress,[itemDict objectForKey:@"family_to_icon"]];
            [self.avatarView.imageView af_setImageWithURL:[NSURL URLWithString:[itemDict objectForKey:@"family_to_icon"]] placeholderImage:_model.avatarImage];
          
            
        }


    }
    

    
    if (_model.conversation.unreadMessagesCount == 0) {
        _avatarView.showBadge = NO;
    }
    else{
        _avatarView.showBadge = YES;
        _avatarView.badge = _model.conversation.unreadMessagesCount;
    }
}

- (void)setTitleLabelFont:(UIFont *)titleLabelFont
{
    _titleLabelFont = titleLabelFont;
    _titleLabel.font = _titleLabelFont;
}

- (void)setTitleLabelColor:(UIColor *)titleLabelColor
{
    _titleLabelColor = titleLabelColor;
    _titleLabel.textColor = _titleLabelColor;
}

- (void)setDetailLabelFont:(UIFont *)detailLabelFont
{
    _detailLabelFont = detailLabelFont;
    _detailLabel.font = _detailLabelFont;
}

- (void)setDetailLabelColor:(UIColor *)detailLabelColor
{
    _detailLabelColor = detailLabelColor;
    _detailLabel.textColor = _detailLabelColor;
}

- (void)setTimeLabelFont:(UIFont *)timeLabelFont
{
    _timeLabelFont = timeLabelFont;
    _timeLabel.font = _timeLabelFont;
}

- (void)setTimeLabelColor:(UIColor *)timeLabelColor
{
    _timeLabelColor = timeLabelColor;
    _timeLabel.textColor = _timeLabelColor;
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
    return @"EaseConversationCell";
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
    return EaseConversationCellMinHeight;
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
