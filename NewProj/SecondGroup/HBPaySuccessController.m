//
//  HBPaySuccessController.m
//  NewProj
//
//  Created by 胡贝 on 2019/7/1.
//  Copyright © 2019年 胡贝. All rights reserved.
//

#import "HBPaySuccessController.h"
#import "HBApiTool.h"

@interface HBPaySuccessController ()

@end

@implementation HBPaySuccessController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupUI];
}


- (void)setupUI {
    self.title = @"支付结果";
    
    UIImageView *img = [[UIImageView alloc] init];
    img.image = [UIImage imageNamed:@"pay_success"];
    [self.view addSubview:img];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"支付成功";
    [self.view addSubview:label];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = HBRedColor;
    btn.layer.cornerRadius = 4.0;
    [btn setTitle:@"确定" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    
    
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(100);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(80);
    }];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(img.mas_bottom).offset(30);
        
    }];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(5);
        make.bottom.equalTo(self.view.mas_bottom).offset(-40);
        make.width.mas_equalTo(kWidth-10);
        make.height.mas_equalTo(50);
    }];
}


//查询
- (void)btnClick:(UIButton *)sender {
    
    kWEAK_SELF;
    [HBApiTool GetQueryPaySuccessOrderWithID:@""
                                     success:^(NSDictionary * _Nonnull dic) {
                                         if (dic) {
//                                             [self showHint:[dict objectForKey:@"msg"]];
                                             [self.view makeToast:[dic objectForKey:@"msg"]];
                                             
                                             //获取用户最新信息
                                             [HBApiTool GetUserInfoWithsuccess:^(NSDictionary * _Nonnull dict) {
                                                 if (dict) {
                                                     kSTRONG_SELF;
                                                     //如果有 那么删除掉久的归档，新的dict重新归档沙盒
                                                     NSMutableDictionary * myHeader = [[NSMutableDictionary alloc] init];
                                                     [myHeader setValue:[dict objectForKey:@"company"] forKey:@"company"];
                                                     
                                                     NSDictionary *dataDict = [dic objectForKey:@"data"];
                                                     [myHeader addEntriesFromDictionary:dataDict];
                                                     [HTSaveCachesFile saveDataList:dict fileName:@"HBUSER"];

                                                 }
                                             } failure:^(NSError * _Nonnull error) {
                                                 
                                             }];
                                             
                                             
                                             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                 [self dismissViewControllerAnimated:YES completion:nil];
                                             });
                                         }
                                     } failure:^(NSError * _Nonnull error) {
                                         
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
