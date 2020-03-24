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

#import "BaseTableViewCell.h"
#import <Masonry.h>

#import "UIImageView+HeadImage.h"

@implementation BaseTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

//        self.multipleSelectionBackgroundView = [UIView new];
        _headerLongPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(headerLongPress:)];
        [self addGestureRecognizer:_headerLongPress];
        
        _titleImgV = [[UIImageView alloc] init];
        _titleImgV.image = [UIImage imageNamed:@"QQ"];
        _titleImgV.layer.masksToBounds = YES;
        _titleImgV.layer.cornerRadius = 20;
        [self.contentView addSubview:_titleImgV];
        
        _titleL = [[UILabel alloc] init];
        _titleL.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_titleL];
        
        _line = [[UILabel alloc] init];
        _line.backgroundColor = RYBackgroundColor;
        [self.contentView addSubview:_line];
        
        __weak __typeof(&*self)weakSelf = self;
        [_titleImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView).offset(10);
            make.centerY.equalTo(weakSelf.contentView);
            make.width.mas_equalTo(40);
            make.height.mas_equalTo(40);
        }];
        
        [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.titleImgV.mas_right).offset(10);
            make.centerY.equalTo(weakSelf.contentView);
        }];
        
        [_line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf).offset(10);
            make.right.equalTo(weakSelf.contentView.mas_right).offset(-10);
            make.bottom.equalTo(weakSelf.contentView.mas_bottom);
            make.height.mas_equalTo(0.5);

        }];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
    [super awakeFromNib];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    for (UIControl *control in self.subviews){
        if ([control isMemberOfClass:NSClassFromString(@"UITableViewCellEditControl")]){
            for (UIView *v in control.subviews)
            {
                if ([v isKindOfClass: [UIImageView class]]) {
                    UIImageView *img=(UIImageView *)v;
                    if (self.selected) {
                        img.image=[UIImage imageNamed:@"多选"];
                    }else
                    {
                        img.image=[UIImage imageNamed:@"未选中"];
                    }
                }
            }
        }
    }
    
    
}

//- (void)setSelected:(BOOL)selected animated:(BOOL)animated
//{
//    [super setSelected:selected animated:animated];
//    
//    for (UIControl *control in self.subviews){
//        if ([control isMemberOfClass:NSClassFromString(@"UITableViewCellEditControl")]){
//            for (UIView *v in control.subviews)
//            {
//                if ([v isKindOfClass: [UIImageView class]]) {
//                    UIImageView *img=(UIImageView *)v;
//                    if (self.selected) {
//                        img.image=[UIImage imageNamed:@"多选"];
//                    }else
//                    {
//                        img.image=[UIImage imageNamed:@"未选中"];
//                    }
//                }
//            }
//        }
//    }
//}

- (void)headerLongPress:(UILongPressGestureRecognizer *)longPress
{
    if (longPress.state == UIGestureRecognizerStateBegan) {
        if(_delegate && _indexPath && [_delegate respondsToSelector:@selector(cellImageViewLongPressAtIndexPath:)])
        {
            [_delegate cellImageViewLongPressAtIndexPath:self.indexPath];
        }
    }
}

- (void)setDict:(NSDictionary *)dict
{
    _dict = dict;
    NSString *username = [dict objectForKey:@"nickname"];
    [self.titleImgV af_setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"userIcon"]] placeholderImage:[UIImage imageNamed:@"占位图"]];
    self.titleL.text = username;
}



@end
