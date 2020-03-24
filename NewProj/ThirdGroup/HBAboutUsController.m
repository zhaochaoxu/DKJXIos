//
//  HBAboutUsController.m
//  NewProj
//
//  Created by 胡贝 on 2019/5/27.
//  Copyright © 2019年 胡贝. All rights reserved.
//

#import "HBAboutUsController.h"

@interface HBAboutUsController ()

@end

@implementation HBAboutUsController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}

- (void)setupUI {
    self.title = @"关于我们";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imgV = [[UIImageView alloc] init];
    imgV.image = [UIImage imageNamed:@"ka"];
    [self.view addSubview:imgV];
    
    UILabel *nameL = [[UILabel alloc] init];
    nameL.text = @"大咖精选";
    nameL.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:nameL];
    
    UILabel *versionL = [[UILabel alloc] init];
    versionL.text = @"Version 1.0";
    versionL.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:versionL];

    
    NSDictionary *dict = [HTSaveCachesFile loadDataList:@"HBUSER"];
    
    UILabel *descriptionL = [[UILabel alloc] init];
    descriptionL.text = [dict objectForKey:@"company"];
    descriptionL.numberOfLines = 0;
    descriptionL.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:descriptionL];
    
    [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(20);
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(85);
        make.height.mas_equalTo(85);
    }];
    
    [nameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imgV.mas_bottom).offset(20);
        make.centerX.equalTo(self.view);

    }];
    
    [versionL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameL.mas_bottom).offset(20);
        make.centerX.equalTo(self.view);
        
    }];
    
    [descriptionL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(versionL.mas_bottom).offset(20);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.centerX.equalTo(self.view);

    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
