//
//  HBMenuListDetailController.h
//  NewProj
//
//  Created by 胡贝 on 2019/4/5.
//  Copyright © 2019年 胡贝. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface HBMenuListDetailController : UIViewController

@property (nonatomic, strong) NSDictionary *dict;

@end



@interface HBMenuListDetailCollectionViewCell :UICollectionViewCell

//@property (nonatomic,strong)UIImageView *imgV;
//@property (nonatomic,strong)UILabel *nameL;

@property (nonatomic,strong) NSDictionary *dict;

@end
