//
//  HBThirdController.m
//  NewProj
//
//  Created by 胡贝 on 2019/3/7.
//  Copyright © 2019年 胡贝. All rights reserved.
//

#import "HBThirdController.h"
#import "HBMineCell.h"
#import "HBLoginController.h"
#import "HBSettingController.h"
#import "HTSaveCachesFile.h"
#import "HBSpecialityEatenController.h"
#import "HBWantSpecialityController.h"
#import "HBApiTool.h"
#import <StoreKit/StoreKit.h>


@interface HBThirdController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) UILabel *declareL;

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong)NSMutableArray *dataSources;

@end

@implementation HBThirdController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tabBarController.tabBar setHidden:NO];
    
    //一进来就检查用户登陆没
    NSString *we;
    NSDictionary *userinfo = [HTSaveCachesFile loadDataList:@"HBUSER"];
    if ([userinfo objectForKey:@"company"]) {
        we = [userinfo objectForKey:@"company"];
        //获取用户最新信息
        kWEAK_SELF;
        [HBApiTool GetUserInfoWithsuccess:^(NSDictionary * _Nonnull dict) {
            if (dict) {
                kSTRONG_SELF;
                NSMutableDictionary * myHeader = [[NSMutableDictionary alloc] init];
                [myHeader setValue:we forKey:@"company"];
                //            NSDictionary *dataDict = [dict objectForKey:@"data"];
                [myHeader addEntriesFromDictionary:dict];
                
                //如果有 那么删除掉久的归档，新的dict重新归档沙盒
                [HTSaveCachesFile saveDataList:myHeader fileName:@"HBUSER"];
                [strong_self.tableView reloadData];
            }
        } failure:^(NSError * _Nonnull error) {
            
        }];
    }else{
        //说明退出登录了
        [self.tableView reloadData];
    }
    

    

    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.dataSources = @[
                         @{},
                         @{@"img":@"ic_ate",@"name":@"我吃过的招牌菜"},
                         @{@"img":@"ic_like",@"name":@"我想吃的招牌菜"},
                         @{@"img":@"ic_set",@"name":@"设置"},
//                         @{@"img":@"ic_vip",@"name":@"加入会员"}
                         ].mutableCopy;
    
    [self setupUI];
    
}


- (void)setupUI {
    self.title = @"我的";
    if (self.navigationController) {
        self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
        [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
        [self.navigationController.navigationBar setTranslucent:NO];
    }
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.tabBarController.tabBar.tintColor = [UIColor colorWithRed:252/255.0 green:13/255.0 blue:27/255.0 alpha:1.0f];
//    self.navigationController.tabBarItem.selectedImage = [self.navigationController.tabBarItem.selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = HBRedColor;
 
    [self.view addSubview:self.tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    return self.dataSources.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        static NSString *cellIdentifier = @"loginIcon";
        LoginIconCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[LoginIconCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        //每次进来就看用户登陆没
        NSDictionary *dict = [HTSaveCachesFile loadDataList:@"HBUSER"];
        if (dict) {
            //说明有登录
            cell.dict = dict;
        }else{
            //没登录
            [cell setNotLogging];
        }
        
        return cell;

    }else{
        static NSString *cellIdentifier = @"mine";
        HBMineCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[HBMineCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;//cell的右边有一个小箭头，距离右边有十几像素；
        }
        cell.dict = self.dataSources[indexPath.row];
        return cell;
    }
    
    return nil;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    
    NSDictionary *dict = [HTSaveCachesFile loadDataList:@"HBUSER"];
    if ([HTSaveCachesFile loadDataList:@"HBUSER"] == nil) {
        //如果为空就弹登录
        HBLoginController *loginVc = [[HBLoginController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVc];
        [self presentViewController:nav animated:YES completion:nil];

        return;
    }
    
    
    if (indexPath.row ==0){
        
        
    }if (indexPath.row == 1) {
        HBSpecialityEatenController *specialityVc = [[HBSpecialityEatenController alloc] init];
        specialityVc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:specialityVc animated:YES];
        
        
    }else if (indexPath.row == 2){
        HBWantSpecialityController *wantVc = [[HBWantSpecialityController alloc] init];
        wantVc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:wantVc animated:YES];
        
    }else if (indexPath.row == 3){
        HBSettingController *settingVc = [[HBSettingController alloc] init];
        settingVc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:settingVc animated:YES];
        
    }
    
    

    

    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 100;
    }
    return 70;
}




- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, KHeightL) style:UITableViewStyleGrouped];
        tableView.backgroundColor = RYBackgroundColor;
        tableView.separatorStyle = UITableViewCellEditingStyleNone;
        tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLineEtched;//推荐该方法

        tableView.delegate = self;
        tableView.dataSource = self;
        [self.view addSubview:tableView];
        _tableView = tableView;
        
    }
    return _tableView;
}
- (void)viewWillLayoutSubviews {
//    [self.declareL mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.navigationController.navigationBar.mas_bottom).offset(30);
//        make.left.equalTo(self.view).offset(20);
//        make.right.equalTo(self.view.mas_right).offset(-20);
//
//    }];
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

@interface LoginIconCell ()

@property (nonatomic, weak) UIImageView *imgV;

@property (nonatomic, weak) UILabel *loginNameL;

@property (nonatomic, weak) UIImageView *loginVIPImg;

@property (nonatomic, weak) UIView *bottomV;

@end

@implementation LoginIconCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //左边login
        UIImageView *imgV = [[UIImageView alloc] init];
        imgV.backgroundColor = [UIColor redColor];
        imgV.layer.cornerRadius = 35;
        imgV.layer.masksToBounds = YES;
        imgV.image = [UIImage imageNamed:@"ka"];
        [self.contentView addSubview:imgV];
        _imgV = imgV;
        
        //登录名字
        UILabel *loginNameL = [[UILabel alloc] init];
        loginNameL.text = @"未登录";
        loginNameL.font = [UIFont systemFontOfSize:18];
//        loginNameL.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:loginNameL];
        _loginNameL = loginNameL;
        
        //bottom图
        UIView *bottomV = [[UIView alloc] init];
        bottomV.backgroundColor = [UIColor whiteColor];
        bottomV.layer.borderColor =[UIColor colorWithRed:225/255.0 green:220/255.0  blue:135/255.0  alpha:1].CGColor;
        bottomV.layer.borderWidth = 1;
        bottomV.layer.cornerRadius = 12.5;
        bottomV.layer.masksToBounds = YES;
        [self.contentView addSubview:bottomV];
        _bottomV = bottomV;
        
        //bottom上的V
        UIImageView *vimgV = [[UIImageView alloc] init];
        vimgV.image = [UIImage imageNamed:@"ic_vip_head"];
        [bottomV addSubview:vimgV];
        
        UILabel *membershipL = [[UILabel alloc] init];
        membershipL.text = @"大咖会员";
        membershipL.textColor = [UIColor colorWithRed:206/255.0 green:202/255.0  blue:105/255.0  alpha:1];
        membershipL.font = [UIFont systemFontOfSize:15];
        [bottomV addSubview:membershipL];
        
        
        UIImageView *loginVIPImg = [[UIImageView alloc] init];
        loginVIPImg.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:loginVIPImg];
        _loginVIPImg = loginVIPImg;
        
        [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(15);
            make.centerY.equalTo(self.contentView);
            make.width.mas_equalTo(70);
            make.height.mas_equalTo(70);
        }];
        

        
        //bottom
        [bottomV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imgV.mas_right).offset(25);
            make.bottom.equalTo(imgV.mas_bottom).offset(-5);
            make.width.mas_equalTo(100);
            make.height.mas_equalTo(25);
        }];
        
        [vimgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bottomV).offset(5);
            make.centerY.equalTo(bottomV);
            make.width.mas_equalTo(20);
            make.height.mas_equalTo(20);
        }];
        
        [membershipL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(vimgV.mas_right).offset(2);
            make.centerY.equalTo(bottomV);
        }];
        
        [loginNameL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(bottomV).offset(-10);
            make.top.equalTo(imgV).offset(3);
        }];
        
//        [loginVIPImg mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(imgV.mas_right).offset(25);
//            make.bottom.equalTo(imgV.mas_bottom);
//            make.width.mas_equalTo(70);
//            make.height.mas_equalTo(35);
//        }];
        
    }
    return self;
}

- (void)setDict:(NSDictionary *)dict {
    _dict = dict;
    
    //用户名
    if (![[dict objectForKey:@"nickname"]isEqual:@""]) {
        self.loginNameL.text = [dict objectForKey:@"nickname"];
    }else{
        
        self.loginNameL.text = [dict objectForKey:@"name"];
    }
    
    //是否显示已经是  大咖会员 logo
    if ([[dict objectForKey:@"vipType"] isEqual:@""]) {
        //就不显示
        self.bottomV.hidden = YES;
    }else if ([[dict objectForKey:@"vipType"] isEqual:@"vip"]){
        self.bottomV.hidden = NO;
    }
}

- (void)setNotLogging {
    self.loginNameL.text = @"未登录";
    self.bottomV.hidden = YES;
}



@end
