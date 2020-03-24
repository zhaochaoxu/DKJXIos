//
//  HBSecondViewController.m
//  NewProj
//
//  Created by 胡贝 on 2019/3/7.
//  Copyright © 2019年 胡贝. All rights reserved.
//

#import "HBSecondViewController.h"
#import "GoodsListCell.h"
#import "RYMacro.h"
#import "HBApiTool.h"
#import "MWPhoto.h"
#import "MWPhotoBrowser.h"
#import "HBStoryListCell.h"
#import <WXApi.h>
#import "HBPaySuccessController.h"
#import <UIImageView+WebCache.h>
#import "HBLoginController.h"


@interface HBSecondViewController ()<UITableViewDelegate,UITableViewDataSource,WXApiDelegate>
{
    NSInteger _storyNumber;
}

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSources;

@property (nonatomic, strong) UIView *backgroundV;

@end

@implementation HBSecondViewController

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tabBarController.tabBar setHidden:NO];
    
    NSDictionary *userinfo = [HTSaveCachesFile loadDataList:@"HBUSER"];
    if ([[userinfo objectForKey:@"vipType"] isEqual:@"vip"]) {
        
        [HBApiTool GetMembershipExpiresWithCheckDate:[userinfo objectForKey:@"date"]
                                             success:^(NSDictionary * _Nonnull dict) {
                                                 if (dict) {
                                                     //是否会员过期
                                                     BOOL isExpire = [dict objectForKey:@"checkDate"];
                                                     if (isExpire == YES) {
                                                         //然后展示
                                                         [self setup2UI];
                                                     }else{
                                                         //隐藏UI
                                                         [self setupUI];
                                                     }
                                                 }
                                             } failure:^(NSError * _Nonnull error) {

                                             }];
    }else{
        //不是vip  就得显示充值页面
        [self setupUI];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self.navigationController.navigationBar setHidden:NO];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ReturnSucceedPay:) name:@"ZLWXReturnSucceedPayNotification" object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ReturnFailedPay:) name:@"ZLWXReturnFailedPayNotification" object:nil];
//    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationController.navigationBar.translucent=NO;

    
    
  
    
    
    //判断登录没有没有的话
    NSDictionary *dict = [HTSaveCachesFile loadDataList:@"HBUSER"];
    NSString *userid = [[dict objectForKey:@"id"] stringValue];
    if (!userid) {
        [self setupUI];
        return;
    }
    
 
    //获取个人信息
    [HBApiTool GetUserInfoWithsuccess:^(NSDictionary * _Nonnull dic) {
        if (dic) {
            //存到本地然后再请求

            if ([[dic objectForKey:@"vipType"] isEqual:@"vip"]) {
                [HBApiTool GetMembershipExpiresWithCheckDate:[dic objectForKey:@"date"]
                                                     success:^(NSDictionary * _Nonnull dict) {
                                                         if (dict) {
                                                             //是否会员过期
                                                             NSNumber *num = [dict objectForKey:@"checkDate"];
                                                             BOOL isExpire = [num boolValue];
                                                             if (isExpire == YES) {
                                                                 //然后展示
                                                                 [self setup2UI];
                                                             }else{
                                                                 //隐藏UI
                                                                 [self setupUI];
                                                             }
                                                         }
                                                     } failure:^(NSError * _Nonnull error) {
                                                         
                                                     }];
                
            }else{
                //隐藏UI
                [self setupUI];
            }
            
        }
    } failure:^(NSError * _Nonnull error) {
        
    }];
    
    


}

//查询是否是vip


- (void)setup2UI {
   
    if (self.navigationController) {
        self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
        [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
        [self.navigationController.navigationBar setTranslucent:NO];
    }
    //    self.tabBarController.tabBar.tintColor = [UIColor colorWithRed:252/255.0 green:13/255.0 blue:27/255.0 alpha:1.0f];
    self.tabBarController.tabBar.tintColor = HBRedColor;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navigationController.navigationBar.barTintColor = HBRedColor;
    self.view.backgroundColor = [UIColor whiteColor];

    self.navigationItem.title = @"会员";
    
    UIView *backgroundV = [[UIView alloc] init];
    backgroundV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backgroundV];
    _backgroundV = backgroundV;
    
    
    UIImageView *img = [[UIImageView alloc] init];
    img.image = [UIImage imageNamed:@"ic_qrcode_top"];
    [backgroundV addSubview:img];
    
    UIImageView *bottomImg = [[UIImageView alloc] init];
    bottomImg.image = [UIImage imageNamed:@"ic_qrcode_bottom"];
    [backgroundV addSubview:bottomImg];
    

    UIImageView *qrcodeImg = [[UIImageView alloc] init];
//    http://124.204.45.69:6666/consumer/qrcode/{id}
    NSDictionary *dict = [HTSaveCachesFile loadDataList:@"HBUSER"];
    qrcodeImg.backgroundColor = HBRedColor;
    NSString *uid = [NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]];
    NSString *url = [NSString stringWithFormat:@"%@/consumer/qrcode/%@",RYServiceAddress,uid];
    [qrcodeImg sd_setImageWithURL:[NSURL URLWithString:url]];
    [backgroundV addSubview:qrcodeImg];
    
    
    
    
    [backgroundV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.view);
        make.width.mas_equalTo(kWidth);
        make.height.mas_equalTo(KHeightL);
    }];
    
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.view).offset(0);
        make.width.mas_equalTo(kWidth);
        make.height.mas_equalTo((kWidth/2-30));
    }];
    
    [bottomImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(img.mas_bottom);
        make.left.equalTo(self.view);
        make.width.mas_equalTo(kWidth);
        make.height.mas_equalTo(KHeightL-(kWidth/2-40));
    }];
    
    [qrcodeImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backgroundV);
        make.top.equalTo(img.mas_bottom).offset(40);
        make.width.mas_equalTo(138);
        make.height.mas_equalTo(138);
    }];
    
}


- (void)setupUI {
    self.navigationController.navigationItem.title = @"加入会员";
    if (self.navigationController) {
        self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
        [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
        [self.navigationController.navigationBar setTranslucent:NO];
    }
//    self.tabBarController.tabBar.tintColor = [UIColor colorWithRed:252/255.0 green:13/255.0 blue:27/255.0 alpha:1.0f];
    self.tabBarController.tabBar.tintColor = HBRedColor;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navigationController.navigationBar.barTintColor = HBRedColor;
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    UIImageView *imgV = [[UIImageView alloc] init];
    imgV.backgroundColor = [UIColor colorWithRed:47/255.0 green:47/255.0 blue:47/255.0 alpha:1];
    imgV.layer.cornerRadius = 10;
    [self.view addSubview:imgV];
    
    UIImageView *vipV = [[UIImageView alloc] init];
    vipV.image = [UIImage imageNamed:@"vip"];
    [imgV addSubview:vipV];
    
    UIImageView *add_vipV = [[UIImageView alloc] init];
    add_vipV.image = [UIImage imageNamed:@"add_vip"];
    [imgV addSubview:add_vipV];
    
    
    
    NSString *string = @"     大咖精选，会籍制美食精选APP，用户花99元成为会员，会员去大咖精选合作的餐厅吃饭，任意消费就送一道招牌菜品。每个会员每家餐厅只享受一次免费菜品";
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 7; // 调整行间距
    NSRange range = NSMakeRange(0, [string length]);
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
    
    UILabel *contentL = [[UILabel alloc] init];
    contentL.attributedText = attributedString;
    contentL.numberOfLines = 0;
    contentL.textColor = [UIColor colorWithRed:209/255.0 green:204/255.0 blue:112/255.0 alpha:1];
    contentL.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:contentL];
    
    UILabel *paymethodL = [[UILabel alloc] init];
    paymethodL.text = @"支付方式:";
    paymethodL.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:paymethodL];
    
    UIImageView *wximgV = [[UIImageView alloc] init];
    wximgV.image = [UIImage imageNamed:@"wxpay_logo"];
    [self.view addSubview:wximgV];
    
    UIButton *payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    payBtn.layer.cornerRadius = 4.0;
    [payBtn addTarget:self action:@selector(payBtn:) forControlEvents:UIControlEventTouchUpInside];
    payBtn.backgroundColor = HBRedColor;
    [payBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [payBtn setTitle:@"立即支付99元" forState:UIControlStateNormal];
    [self.view addSubview:payBtn];
    
    
    [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(15);
        make.width.mas_equalTo(kWidth-40);
        make.height.mas_equalTo((kWidth-40)*3/5);
    }];
    
    [vipV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(imgV);
        make.centerY.equalTo(imgV).offset(-30);
        make.width.mas_equalTo(kWidth/5.3);
        make.height.mas_equalTo(kWidth/5.3*3/4);
    }];
    
    [add_vipV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(imgV);
        make.centerY.equalTo(imgV).offset(35);
        make.width.mas_equalTo(kWidth/2);
        make.height.mas_equalTo(kWidth/2*138/508);
    }];
    
    [contentL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imgV.mas_bottom).offset(15);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.centerX.equalTo(self.view);
    }];
    
    [paymethodL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.top.equalTo(contentL.mas_bottom).offset(15);
        
    }];
    
    [wximgV mas_makeConstraints:^(MASConstraintMaker *make) {

        make.top.equalTo(paymethodL).offset(40);
        make.left.equalTo(self.view).offset(20);
        make.width.mas_equalTo(kWidth/3);
        make.height.mas_equalTo((kWidth)/12);

     }];
    
    [payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.top.equalTo(wximgV.mas_bottom).offset(20);
        make.width.equalTo(@(kWidth-40));
        make.height.mas_equalTo(50);
        
    }];

}

//立即支付0.01
- (void)payBtn:(UIButton *)sender {
    
    //还未登录
    NSDictionary *dict = [HTSaveCachesFile loadDataList:@"HBUSER"];
    if ([HTSaveCachesFile loadDataList:@"HBUSER"] == nil) {
        //如果为空就弹登录
        HBLoginController *loginVc = [[HBLoginController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVc];
        [self presentViewController:nav animated:YES completion:nil];
        
        return;
    }
    
    kWEAK_SELF;
    [HBApiTool PostWeiXinPayWithTotalPrice:@"99.0"
                                      body:@"大咖精选-会员充值"
                                  trade_no:[self getCurrentTimes]
                                consumerID:@""
                                   success:^(NSDictionary * _Nonnull dict) {
                                       if (dict) {
                                           kSTRONG_SELF;
                                           //后台生成了标准订单
                                           PayReq *request = [[PayReq alloc] init];
                                           /** 微信分配的公众账号ID -> APPID */
                                           
                                           request.partnerId = [dict objectForKey:@"partnerid"];
                                           /** 预支付订单 从服务器获取 */
                                           request.prepayId = [dict objectForKey:@"prepayid"];
                                           /** 商家根据财付通文档填写的数据和签名 <暂填写固定值Sign=WXPay>*/
                                           request.package =  [dict objectForKey:@"package"];
                                           /** 随机串，防重发 */
                                           request.nonceStr = [dict objectForKey:@"noncestr"];
                                           /** 时间戳，防重发 */
                                           NSString *timestr = [dict objectForKey:@"timestamp"];
                                           int timesta = [timestr intValue];
                                           request.timeStamp = (UInt32) timesta;
                                           /** 商家根据微信开放平台文档对数据做的签名, 可从服务器获取，也可本地生成*/
                                           request.sign= [dict objectForKey:@"sign"];
                                           /* 调起支付 */
                                           if ([WXApi isWXAppInstalled])
                                           {
                                               [WXApi sendReq:request];
                                           }else{
                                               
                                               [WXApi sendAuthReq:request viewController:strong_self delegate:strong_self];
                                           }
                                          
                                           
//                                           [self showHint:[dict objectForKey:@"msg"]];
                                       }
                                       
                                   } failure:^(NSError * _Nonnull error) {
                                       
                                   }];
}

- (NSString *)getCurrentTimes {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    [formatter setDateFormat:@"YYYYMMddHHmmss"];
    
    //现在时间,你可以输出来看下是什么格式
    
    NSDate *datenow = [NSDate date];
    
    //----------将nsdate按formatter格式转成nsstring
    
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    
    NSInteger x = (NSInteger )(arc4random() % 100);
    
    NSDictionary *dict = [HTSaveCachesFile loadDataList:@"HBUSER"];
    NSString *userid = [[dict objectForKey:@"id"] stringValue];
    
    NSString *allCurrentTimeString = [NSString stringWithFormat:@"%@%ld%@",currentTimeString,(long)x,userid];
    
    NSLog(@"currentTimeString =  %@",currentTimeString);
    
    return allCurrentTimeString;
    
}

- (void)ReturnSucceedPay:(NSNotification *)notification {
//    NSDictionary *theData = [notification userInfo];
//    NSString *thename = [theData objectForKey:@"username"];
//    self.username.text = thename;
//    NSLog(@"%@",thename);
    
//    [self.view makeToast:@"支付成功"];
//    [self showHint:@"支付成功"];
    
    

    
    //push 到下一个页面
    HBPaySuccessController *paySuccessVc = [[HBPaySuccessController alloc] init];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:paySuccessVc];
    [self presentViewController:nav animated:NO completion:nil];

    
}

- (void)ReturnFailedPay:(NSNotification *)notification {
    [self.view makeToast:@"支付失败"];
    [self showHint:@"支付失败"];
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
