//
//  HBMenuListDetailController.m
//  NewProj
//
//  Created by 胡贝 on 2019/4/5.
//  Copyright © 2019年 胡贝. All rights reserved.
//

#import "HBMenuListDetailController.h"
#import "HBApiTool.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "SDCycleScrollView.h"


@interface HBMenuListDetailController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,SDCycleScrollViewDelegate>

@property (nonatomic, weak) UIScrollView *scrollView;

@property (nonatomic, weak) UICollectionView *collectionView;

@property (nonatomic, weak) SDCycleScrollView *cycleScrollView;

@property (nonatomic, strong) NSMutableArray *dataSources;

@property (nonatomic, weak) UILabel *nameL;//菜名字
//餐厅售价
@property (nonatomic, weak) UILabel *restaurantPriceL;

@property (nonatomic, weak) UILabel *memberNameL;//商店名字

@property (nonatomic, weak) UILabel *addrL;//商家地址

@property (nonatomic, weak) UILabel *businessHoursL;//营业时间

@property (nonatomic, weak) UILabel *moneyL;//每人的价格

@property (nonatomic, strong) NSString *merchantPhone;//商家电话

//@property (nonatomic, strong) NSMutableArray *merchantNotices;

@property (nonatomic, weak) UILabel *recommendReasonL;//推荐理由

@property (nonatomic, strong) NSDictionary *sd_dict;


@end

@implementation HBMenuListDetailController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}


- (void)viewDidLoad {
    [super viewDidLoad];

    self.extendedLayoutIncludesOpaqueBars = YES;
    self.view.backgroundColor = [UIColor whiteColor];
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
//    [self.tabBarController.tabBar setHidden:YES];
    self.dataSources = [NSMutableArray array];

    
    [self loadData];
}

- (void)loadData {
    
    kWEAK_SELF;
    [HBApiTool GetMechantDetailsWithMechantId:[[self.dict objectForKey:@"id"] stringValue]
                                      success:^(NSDictionary * _Nonnull dict) {
                                          kSTRONG_SELF;
                                          if (dict) {
                                              //菜名
//                                              //电话
                                              strong_self.merchantPhone = [[dict objectForKey:@"merchant"] objectForKey:@"tel"];
//                                              //平均价格
//
//
//                                              //其他推荐菜
//                                              //推荐理由

                                              
                                              [self setupUI:dict];
                                              self.dataSources = [dict objectForKey:@"dishes"];

                                              
                                          }
                                          
                                      } failure:^(NSError * _Nonnull error) {
                                          
                                      }];
}

- (void)setDataSources:(NSMutableArray *)dataSources {
    _dataSources = dataSources;
    [self.collectionView reloadData];
}

//推荐理由
- (void)setupUI:(NSDictionary *)dict {
    
    self.sd_dict = dict;
    
    self.title = @"详情";
    if (self.navigationController) {
        self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
        [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
        [self.navigationController.navigationBar setTranslucent:NO];
    }
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.cycleScrollView];
    [self.scrollView addSubview:self.collectionView];
    [self.collectionView reloadData];

    //轮播图
    [self.cycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView);
        make.top.equalTo(self.scrollView);
        make.width.mas_equalTo(kWidth);
        make.height.mas_equalTo(kWidth*200/368);
    }];
    
    //菜名
    UILabel *nameL = [[UILabel alloc] init];
    nameL.text = @"烤鱼";
    nameL.text = [dict objectForKey:@"cuisineTypeName"];
    [self.scrollView addSubview:nameL];
    _nameL = nameL;
    
    [nameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView).offset(20);
        make.top.equalTo(self.cycleScrollView.mas_bottom).offset(20);
        
    }];
    
    //收藏按钮
    
    UIButton *loveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    loveBtn.backgroundColor = [UIColor cyanColor];
    [loveBtn setBackgroundImage:[UIImage imageNamed:@"ic_heart_gray"] forState:UIControlStateNormal];
    [loveBtn addTarget:self action:@selector(loveClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:loveBtn];
    
    [loveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cycleScrollView.mas_bottom).offset(15);
        make.right.equalTo(self.view.mas_right).offset(-40);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);
    }];
    

    
    //餐厅售价
    UILabel *restaurantPriceL = [[UILabel alloc] init];
    restaurantPriceL.textColor = [UIColor grayColor];
    //restaurantPriceL.backgroundColor = [UIColor cyanColor];
    restaurantPriceL.numberOfLines = 0;
//    restaurantPriceL.text = @"餐厅售价：¥22.0";
    restaurantPriceL.text = [NSString stringWithFormat:@"餐厅售价：¥%@",[self.dict objectForKey:@"iosPrice"]];
    restaurantPriceL.font = [UIFont systemFontOfSize:14.0];
    [self.scrollView addSubview:restaurantPriceL];
    _restaurantPriceL = restaurantPriceL;
    
    
    UILabel *priceLine = [[UILabel alloc] init];
    priceLine.backgroundColor = [UIColor grayColor];
    [restaurantPriceL addSubview:priceLine];
    
    [restaurantPriceL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameL);
        make.top.equalTo(nameL).offset(40);
    }];
    
    [priceLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(restaurantPriceL).offset(70);
        make.centerY.equalTo(restaurantPriceL);
        make.right.equalTo(restaurantPriceL.mas_right);
        make.height.mas_equalTo(1);
    }];
    
    //大咖会员免费
    UIImageView *dakaImg = [[UIImageView alloc] init];
    [dakaImg setImage:[ UIImage imageNamed:@"mark_free"]];
    [self.scrollView addSubview:dakaImg];
    
    [dakaImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(restaurantPriceL.mas_right).offset(10);
        make.centerY.equalTo(restaurantPriceL);
        make.width.mas_equalTo(75);
        make.height.mas_equalTo(24);
    }];
    
    //商店名称
    UILabel *memberNameL = [[UILabel alloc] init];
    memberNameL.text = [self.dict objectForKey:@"merchName"];
    [self.scrollView addSubview:memberNameL];
    _memberNameL = memberNameL;
    
    [memberNameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(restaurantPriceL);
        make.top.equalTo(restaurantPriceL).offset(40);
        
    }];
    
    //餐厅地址

    UIImageView *locationImg = [[UIImageView alloc] init];
    locationImg.image = [UIImage imageNamed:@"ic_location"];
    [self.scrollView addSubview:locationImg];
    
    
    [locationImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView).offset(20);
        make.top.equalTo(memberNameL).offset(55);
        make.width.mas_equalTo(23);
        make.height.mas_equalTo(22);
    }];
    
    UILabel *addrL = [[UILabel alloc] init];
    addrL.text = @"北京市海淀区苏州街20号院-1号楼5.89km";
    addrL.numberOfLines = 0;
    addrL.font = [UIFont systemFontOfSize:12];
    addrL.textColor = [UIColor grayColor];
    [self.scrollView addSubview:addrL];
    _addrL = addrL;
    
    //获取地址
    CLLocationDegrees latitude = [[self.dict objectForKey:@"latitude"] doubleValue];
    CLLocationDegrees longitude = [[self.dict objectForKey:@"longitude"] doubleValue];
    CLLocation *location = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    
    
    //根据经纬度解析成位置
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemark,NSError *error)
     {
         CLPlacemark *mark = [placemark objectAtIndex:0];
         NSLog(@"city %@ subcity %@",mark.locality,mark.subLocality);
         NSString *address = [NSString stringWithFormat:@"%@%@%@",mark.locality,mark.subLocality,mark.thoroughfare];
         NSLog(@"address = %@",address);
         
         
         double distanceNum = [[self.dict objectForKey:@"iosDistance"] doubleValue];
         if (distanceNum >1000.0) {
             double bigDistanceNum = distanceNum/1000;
             self.addrL.text = [NSString stringWithFormat:@"%@%.1fkm",address,bigDistanceNum];
         
         }else if(distanceNum<1000.0 && distanceNum>500.0){
             self.addrL.text = [NSString stringWithFormat:@"%@%@",address,@"<1000m"];

         }else if(distanceNum<500.0  && distanceNum>100.0){
             self.addrL.text = [NSString stringWithFormat:@"%@%@",address,@"<500m"];
         }else if (distanceNum<100.0){
             self.addrL.text = [NSString stringWithFormat:@"%@%@",address,@"<100m"];
         }
//         self.addrL.text = [NSString stringWithFormat:@"%@%@m",address,[self.dict objectForKey:@"iosDistance"]];
     }];
    
    
    
    [addrL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(locationImg.mas_right).offset(10);
        make.centerY.equalTo(locationImg);
        make.right.equalTo(self.view.mas_right).offset(-150);
    }];
    
    
    
    //电话按钮
    UIButton *phoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [phoneBtn setImage:[UIImage imageNamed:@"phone"] forState:UIControlStateNormal];
    [phoneBtn addTarget:self action:@selector(phoneClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:phoneBtn];
    
    [phoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(locationImg).offset(-6);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.width.mas_equalTo(35);
        make.height.mas_equalTo(35);
        
    }];
    
    UIView *suLine = [[UILabel alloc] init];
    suLine.backgroundColor = [UIColor lightGrayColor];
    [self.scrollView addSubview:suLine];
    
    [suLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(phoneBtn).offset(-25);
        make.centerY.equalTo(phoneBtn);
        make.width.mas_equalTo(1);
        make.height.mas_equalTo(35);
    }];
    //灰色的线条
    UIView *oneLine = [[UIView alloc] init];
    oneLine.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    [self.scrollView addSubview:oneLine];
    
    [oneLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(addrL.mas_bottom).offset(30);
        make.width.mas_equalTo(kWidth);
        make.height.mas_equalTo(10);
    }];
    //营业时间
    UIImageView *timeImg = [[UIImageView alloc] init];
    timeImg.image = [UIImage imageNamed:@"ic_horologe"];
    [self.scrollView addSubview:timeImg];
    
    [timeImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(locationImg);
        make.top.equalTo(oneLine).offset(20);
        make.width.mas_equalTo(28);
        make.height.mas_equalTo(26);
    }];
    
    UILabel *businessHoursL = [[UILabel alloc] init];
    businessHoursL.text = @"营业至23:00";
    businessHoursL.textColor = [UIColor grayColor];
    businessHoursL.font = [UIFont systemFontOfSize:11];
    [self.scrollView addSubview:businessHoursL];
    _businessHoursL = businessHoursL;
    
    //判断今天是星期几
    NSDictionary *nowdata = [self getWeekData];
    NSString *weekday = [nowdata objectForKey:@"week"];
    NSString *daytime = [nowdata objectForKey:@"date"];
    
    __block NSString *business;
    NSArray *weeks = [dict objectForKey:@"weeksVOS"];
    [weeks enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([[obj objectForKey:@"weekName"] isEqual:weekday]) {
            //星期几相等
            NSInteger isS = [self compareDate:[obj objectForKey:@"startTime"] withDate:daytime];
            NSInteger isE = [self compareDate:[obj objectForKey:@"endTime"] withDate:daytime];
            if (isS == 1 && isE == -1) {
                //营业中
                business = @"营业中";
                businessHoursL.text = [NSString stringWithFormat:@"营业时间:%@~%@(%@)",[obj objectForKey:@"startTime"],[obj objectForKey:@"endTime"],business];
            }else{
                business = @"休息中";
                businessHoursL.text = business;
            }
            NSLog(@"---%ld---%ld",(long)isS,(long)isE);
        }
    }];
    
    
    [businessHoursL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(timeImg).offset(30);
        make.centerY.equalTo(timeImg);
        
    }];
    
    UIImageView *moneyImg = [[UIImageView alloc] init];
    moneyImg.image = [UIImage imageNamed:@"ic_currency"];
    [self.scrollView addSubview:moneyImg];
    
    [moneyImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-75);
        make.centerY.equalTo(timeImg);
        make.width.mas_equalTo(28);
        make.height.mas_equalTo(26);
    }];
    
    UILabel *moneyL = [[UILabel alloc] init];
    moneyL.text = @"120.0元/人";
    if ([[dict objectForKey:@"merchant"] objectForKey:@"avge"]) {
          NSString *price = [[dict objectForKey:@"merchant"] objectForKey:@"avge"];
          NSString *allprice = [NSString stringWithFormat:@"%@.0元/人",price];
          moneyL.text = allprice;
      }
    moneyL.textColor = [UIColor grayColor];
    moneyL.font = [UIFont systemFontOfSize:13];
    [self.scrollView addSubview:moneyL];
    _moneyL = moneyL;
    
    [moneyL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(moneyImg).offset(30);
        make.centerY.equalTo(moneyImg);
        
    }];
    
    //灰色的线条
    UIView *twoLine = [[UIView alloc] init];
    twoLine.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    [self.scrollView addSubview:twoLine];
    
    [twoLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(timeImg.mas_bottom).offset(10);
        make.width.mas_equalTo(kWidth);
        make.height.mas_equalTo(10);
    }];
    //其他推荐菜
    UILabel *recommendDishesL = [[UILabel alloc] init];
    recommendDishesL.text = @"其他推荐菜";
    recommendDishesL.font = [UIFont systemFontOfSize:14];
    [self.scrollView addSubview:recommendDishesL];
    
    [recommendDishesL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.top.equalTo(twoLine).offset(30);
        
    }];
    
    //collectionView
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView);
        make.top.equalTo(recommendDishesL.mas_bottom).offset(5);
        make.width.mas_equalTo(kWidth);
        make.height.mas_equalTo((kWidth-25)/4+20);
    }];
    
    //collectionView
    
    
    //菜名图片
//    UIImageView *otherDishImg = [[UIImageView alloc ] init];
//    otherDishImg.image = [UIImage imageNamed:@"empty"];
//    [self.scrollView addSubview:otherDishImg];
//
//    [otherDishImg mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.view).offset(50);
//        make.top.equalTo(recommendDishesL.mas_bottom).offset(25);
//        make.width.mas_equalTo(80);
//        make.height.mas_equalTo(80);
//    }];
    
    //灰色的线条
    UIView *threeLine = [[UIView alloc] init];
    threeLine.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    [self.scrollView addSubview:threeLine];
    
    [threeLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(recommendDishesL.mas_bottom).offset(110);
        make.width.mas_equalTo(kWidth);
        make.height.mas_equalTo(10);
    }];
    
    //推荐理由
    UILabel *recommendReasonL = [[UILabel alloc] init];
    recommendReasonL.text = @"推荐理由";
    recommendReasonL.font = [UIFont systemFontOfSize:13];
    recommendReasonL.textColor = [UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:1];
    [self.scrollView addSubview:recommendReasonL];
    _recommendReasonL = recommendReasonL;
    
    [recommendReasonL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(threeLine).offset(40);
    }];
    
    UIImageView *arrowImg = [[UIImageView alloc] init];
    arrowImg.image = [UIImage imageNamed:@"line_left"];
    [self.scrollView addSubview:arrowImg];

    [arrowImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(recommendReasonL).offset(-60);
        make.centerY.equalTo(recommendReasonL);
        make.width.mas_equalTo(91);
        make.height.mas_equalTo(5);
    }];
    
    UIImageView *arrowTwoImg = [[UIImageView alloc] init];
    arrowTwoImg.image = [UIImage imageNamed:@"line_right"];
    [self.scrollView addSubview:arrowTwoImg];
    
    [arrowTwoImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(recommendReasonL.mas_right).offset(5);
        make.centerY.equalTo(recommendReasonL);
        make.width.mas_equalTo(91);
        make.height.mas_equalTo(5);
    }];
    
    //两条理由
    __block NSInteger allheight = 0;
    NSArray *recommendReasons = [dict objectForKey:@"recommendReasons"];
    for (int i=0; i<recommendReasons.count; i++) {
        UIImageView *imgV = [[UIImageView alloc] init];
        imgV.image = [UIImage imageNamed:@"shouzhiyou"];
        [self.scrollView addSubview:imgV];

        UILabel * reasonL = [[UILabel alloc] init];
        reasonL.numberOfLines = 0;
        reasonL.text = [recommendReasons[i] objectForKey:@"context"];
        reasonL.font = [UIFont systemFontOfSize:13];
        reasonL.textColor = [UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:1];
        [self.scrollView addSubview:reasonL];

        [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(20);
            if (recommendReasons.count == 1) {
                make.top.equalTo(recommendReasonL).offset(40);
                NSInteger height = [self getStringHeightWithText:[recommendReasons[i] objectForKey:@"context"] font:[UIFont systemFontOfSize:13] viewWidth:(kWidth-100)];
                allheight = height;
            }
            if (i==0) {
                make.top.equalTo(recommendReasonL).offset(40);
            }else if(i>=1){
                NSInteger height = [self getStringHeightWithText:[recommendReasons[i-1] objectForKey:@"context"] font:[UIFont systemFontOfSize:13] viewWidth:(kWidth-100)];
                allheight = allheight + height+10;
                make.top.equalTo(recommendReasonL).offset(40+allheight);
            }

            make.width.mas_equalTo(20);
            make.height.mas_equalTo(16);
        }];

        [reasonL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imgV).offset(30);
            make.right.equalTo(self.view.mas_right).offset(-10);
            make.top.equalTo(imgV);

        }];
    }
    
    UIView *fourthLine = [[UIView alloc] init];
    fourthLine.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    [self.scrollView addSubview:fourthLine];
    
    [fourthLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
//        make.top.equalTo(recommendReasonL.mas_bottom).offset(20+recommendReasons.count*40);
        make.top.equalTo(recommendReasonL.mas_bottom).offset(20+allheight+recommendReasons.count*20);
        make.width.mas_equalTo(kWidth);
        make.height.mas_equalTo(10);
    }];
    
    //店铺信息
    //推荐理由
    UILabel *storeNewsL = [[UILabel alloc] init];
    storeNewsL.text = @"店铺信息";
    storeNewsL.font = [UIFont systemFontOfSize:13];
    storeNewsL.textColor = [UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:1];
    [self.scrollView addSubview:storeNewsL];
    
    [storeNewsL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(fourthLine).offset(40);
    }];
    
    UIImageView *arrowthreeImg = [[UIImageView alloc] init];
    arrowthreeImg.image = [UIImage imageNamed:@"line_left"];
    [self.scrollView addSubview:arrowthreeImg];
    
    [arrowthreeImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(storeNewsL).offset(-60);
        make.centerY.equalTo(storeNewsL);
        make.width.mas_equalTo(91);
        make.height.mas_equalTo(5);
    }];

    UIImageView *arrowFourthImg = [[UIImageView alloc] init];
    arrowFourthImg.image = [UIImage imageNamed:@"line_right"];
    [self.scrollView addSubview:arrowFourthImg];
    
    [arrowFourthImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(storeNewsL.mas_right).offset(5);
        make.centerY.equalTo(storeNewsL);
        make.width.mas_equalTo(91);
        make.height.mas_equalTo(5);
    }];
    
    
    //店铺信息详情
    UILabel *storeDetailsL = [[UILabel alloc] init];
    storeDetailsL.font = [UIFont systemFontOfSize:13];
    storeDetailsL.numberOfLines = 0;
    storeDetailsL.textColor = [UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:1];
//    storeDetailsL.text = @"阿斯蒂芬撒旦法阿斯蒂芬发发";
    storeDetailsL.text = [[dict objectForKey:@"merchant"] objectForKey:@"description"];
//    storeDetailsL.text = [dict objectForKey:@""];

    [self.scrollView addSubview:storeDetailsL];
    
    [storeDetailsL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(22);
        make.right.equalTo(self.view).offset(-20);
        make.top.equalTo(storeNewsL).offset(40);
    }];
    //分割线

    UIView *fiveLine = [[UIView alloc] init];
    fiveLine.backgroundColor = [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1];
    [self.scrollView addSubview:fiveLine];
    
    [fiveLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.top.equalTo(storeDetailsL.mas_bottom).offset(25);
//        make.width.mas_equalTo(kWidth);
        make.height.mas_equalTo(1.5);
    }];
    //营业时间
    UILabel *allBusinessHoursL = [[UILabel alloc] init];
    allBusinessHoursL.text = @"营业时间";
    allBusinessHoursL.font = [UIFont systemFontOfSize:13];
    allBusinessHoursL.textColor = [UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:1];
    [self.scrollView addSubview:allBusinessHoursL];
    
    [allBusinessHoursL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.top.equalTo(fiveLine).offset(20);
        
    }];
    
    //7条信息
    NSArray *weeksVOS = [dict objectForKey:@"weeksVOS"];
    for (int i=0; i<weeksVOS.count; i++) {
        UIImageView *timeImg = [[UIImageView alloc] init];
        timeImg.image = [UIImage imageNamed:@"ic_horologe"];
        [self.scrollView addSubview:timeImg];
        
        [timeImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(20);
            make.top.equalTo(allBusinessHoursL).offset(30+i*25);
            make.width.mas_equalTo(22);
            make.height.mas_equalTo(19);
        }];
        
        UILabel *oneBusinessTimeL = [[UILabel alloc] init];
        oneBusinessTimeL.text = @"星期一 9:00 - 23:00";
        oneBusinessTimeL.text = [NSString stringWithFormat:@"%@ %@——%@",[weeksVOS[i] objectForKey:@"weekName"],[weeksVOS[i] objectForKey:@"startTime"],[weeksVOS[i] objectForKey:@"endTime"]];
        oneBusinessTimeL.font = [UIFont systemFontOfSize:13];
        oneBusinessTimeL.textColor = [UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:1];
        [self.scrollView addSubview:oneBusinessTimeL];
        
        [oneBusinessTimeL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(timeImg.mas_right).offset(10);
            make.centerY.equalTo(timeImg);
        }];
    }
    //分割线
    UIView *sixLine = [[UIView alloc] init];
    sixLine.backgroundColor = [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1];
    [self.scrollView addSubview:sixLine];
    
    [sixLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.top.equalTo(allBusinessHoursL.mas_bottom).offset(20+weeksVOS.count*25);
        //        make.width.mas_equalTo(kWidth);
        make.height.mas_equalTo(1.5);
    }];
    //服务设施
    UILabel *serviceFacilitiesL = [[UILabel alloc] init];
    serviceFacilitiesL.text = @"服务设施";
    serviceFacilitiesL.font = [UIFont systemFontOfSize:13];
    serviceFacilitiesL.textColor = [UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:1];
    [self.scrollView addSubview:serviceFacilitiesL];
    
    [serviceFacilitiesL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.top.equalTo(sixLine).offset(20);
        
    }];
    //宝箱
    UIImageView *boxImg = [[UIImageView alloc] init];
    boxImg.image = [UIImage imageNamed:@"ser_box"];
    [self.scrollView addSubview:boxImg];
    
    [boxImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.top.equalTo(serviceFacilitiesL).offset(30);
        make.width.mas_equalTo(18);
        make.height.mas_equalTo(18);
    }];
    
    UILabel *boxL = [[UILabel alloc] init];
    boxL.text = @"包厢";
    boxL.font = [UIFont systemFontOfSize:13];
    boxL.textColor = [UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:1];

    [self.scrollView addSubview:boxL];
    
    [boxL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(boxImg).offset(30);
        make.centerY.equalTo(boxImg);
        
    }];
    
    
    //可容纳50人
    UILabel *accommodateL = [[UILabel alloc] init];
    accommodateL.text = @"可容纳50人";
    accommodateL.textColor = [UIColor lightGrayColor];
    accommodateL.font = [UIFont systemFontOfSize:12];
    [self.scrollView addSubview:accommodateL];
    NSArray *serviceFacilities = [dict objectForKey:@"serviceFacilities"];
    NSMutableArray *larr = [NSMutableArray array];
    [serviceFacilities enumerateObjectsUsingBlock:^(NSDictionary  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([[obj objectForKey:@"name"] isEqual:@"包厢"]) {
            accommodateL.text = [obj objectForKey:@"context"];
        }else{
            accommodateL.text = @"暂无包厢";
            [larr addObject:[obj objectForKey:@"name"]];
        }
    }];

    
    
    [accommodateL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(boxImg).offset(30);
        make.top.equalTo(boxImg).offset(30);
    }];
    
    //6个图标

    
    NSArray * arr = @[@"ser_wifi",@"ser_park",@"ser_bookable",@"ser_baby_chair",@"ser_landscape",@"ser_open"];
//     = @[@"WIFI",@"停车场",@"可预订",@"宝椅",@"景观位",@"露天位"];
    for (int i=0; i<larr.count; i++) {
        UIImageView *img = [[UIImageView alloc] init];
        img.image = [UIImage imageNamed:arr[i]];
        [self.scrollView addSubview:img];
        
        UILabel *titleL = [[UILabel alloc] init];
        titleL.text = larr[i];
        titleL.font = [UIFont systemFontOfSize:13];
        titleL.textColor = [UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:1];
        [self.scrollView addSubview:titleL];
        
        [img mas_makeConstraints:^(MASConstraintMaker *make) {
            if (i<3) {
                make.top.equalTo(serviceFacilitiesL.mas_bottom).offset(80);
                make.left.equalTo(self.view).offset(20+i*((kWidth-54)/3));
            }else{
                make.top.equalTo(serviceFacilitiesL.mas_bottom).offset(80+30);
                make.left.equalTo(self.view).offset(20+(i-3)*((kWidth-54)/3));
            }
            make.width.mas_equalTo(18);
            make.height.mas_equalTo(18);
        }];
        
        [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(img);
                make.left.equalTo(img).offset(35);
                
        }];
    }
    
    //分割灰色线条
    UIView *sevenLine = [[UIView alloc] init];
    sevenLine.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    [self.scrollView addSubview:sevenLine];
    
    [sevenLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        if (larr.count<=3) {
            make.top.equalTo(serviceFacilitiesL.mas_bottom).offset(90+30);
        }else{
            make.top.equalTo(serviceFacilitiesL.mas_bottom).offset(90+60);
        }
//        make.top.equalTo(serviceFacilitiesL.mas_bottom).offset(90+(larr.count/3)*30);
        make.height.mas_equalTo(10);
    }];
    //用餐须知
    UILabel *instructionsDiningL = [[UILabel alloc] init];
    instructionsDiningL.text = @"用餐须知";
    instructionsDiningL.font = [UIFont systemFontOfSize:13];
    instructionsDiningL.textColor = [UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:1];
    [self.scrollView addSubview:instructionsDiningL];
    
    [instructionsDiningL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(sevenLine).offset(30);
    }];
    
    UIImageView *arrowfiveImg = [[UIImageView alloc] init];
    arrowfiveImg.image = [UIImage imageNamed:@"line_left"];
    [self.scrollView addSubview:arrowfiveImg];
    
    [arrowfiveImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(instructionsDiningL).offset(-60);
        make.centerY.equalTo(instructionsDiningL);
        make.width.mas_equalTo(91);
        make.height.mas_equalTo(5);
    }];
    
    UIImageView *arrowsixImg = [[UIImageView alloc] init];
    arrowsixImg.image = [UIImage imageNamed:@"line_right"];
    [self.scrollView addSubview:arrowsixImg];
    
    [arrowsixImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(instructionsDiningL.mas_right).offset(5);
        make.centerY.equalTo(instructionsDiningL);
        make.width.mas_equalTo(91);
        make.height.mas_equalTo(5);
    }];
    
    
    //两条
    
    NSArray *merchantNotices = [dict objectForKey:@"merchantNotices"];
    
    for (int i=0; i<merchantNotices.count; i++) {
        UILabel *instructionL = [[UILabel alloc] init];
        instructionL.text = [merchantNotices[i] objectForKey:@"context"];
        instructionL.textColor = [UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:1];
        instructionL.font = [UIFont systemFontOfSize:13];
        [self.scrollView addSubview:instructionL];
        
        [instructionL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(20);
            make.top.equalTo(instructionsDiningL.mas_bottom).offset(25+i*30);
        }];
        
    }
    //通知
    UILabel *informationL = [[UILabel alloc] init];
    informationL.text = @"因季节替换，部分增菜谱会有更换或者到期下架的危险！请各位及早使用哦！";
    informationL.numberOfLines = 0;
    informationL.font = [UIFont systemFontOfSize:14];
    [self.scrollView addSubview:informationL];
    
    [informationL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.top.equalTo(instructionsDiningL).offset(40+2*35);
    }];
    
    //底部图片
    UIImageView *bottomImg = [[UIImageView alloc] init];
    bottomImg.image = [UIImage imageNamed:@"ic_bottom"];
    [self.scrollView addSubview:bottomImg];
    
    [bottomImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(informationL.mas_bottom).offset(20);
        make.width.mas_equalTo(kWidth);
        make.height.mas_equalTo(kWidth*762/1078);

    }];
}

- (NSInteger )getStringHeightWithText:(NSString *)text font:(UIFont *)font viewWidth:(CGFloat)width {
    // 设置文字属性 要和label的一致
    NSDictionary *attrs = @{NSFontAttributeName :font};
    CGSize maxSize = CGSizeMake(width, MAXFLOAT);
    
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    
    // 计算文字占据的宽高
    CGSize size = [text boundingRectWithSize:maxSize options:options attributes:attrs context:nil].size;
    
    // 当你是把获得的高度来布局控件的View的高度的时候.size转化为ceilf(size.height)。
    NSInteger height = (NSInteger ) ceilf(size.height);
    
    return height;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSources.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize size = {(kWidth-25)/4,(kWidth-25)/4+10};
    return size;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    HBMenuListDetailCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HBMenuListDetailCVCellIdentifier" forIndexPath:indexPath];

    cell.dict = self.dataSources[indexPath.row];
    //cell.imgV.image = self.imgArray[indexPath.row];
//    cell.backgroundColor = [UIColor orangeColor];
    return cell;
}

- (SDCycleScrollView *)cycleScrollView {
    if (!_cycleScrollView) {
        SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero delegate:self placeholderImage:[UIImage imageNamed:@"占位图"]];
        cycleScrollView.infiniteLoop = YES;
        cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
        cycleScrollView.autoScrollTimeInterval = 1.5;
        NSArray *arr = [self.sd_dict objectForKey:@"imgPaths"];
        NSMutableArray *imgarr = [NSMutableArray array];
        [arr enumerateObjectsUsingBlock:^(NSString   *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *imgurl = [NSString stringWithFormat:@"%@%@",RYServiceAddress,obj];
            [imgarr addObject:imgurl];
        }];
        cycleScrollView.imageURLStringsGroup = imgarr;

        [self.scrollView addSubview:_cycleScrollView];
        _cycleScrollView = cycleScrollView;
    }
    
    return _cycleScrollView;
}
    

- (UIScrollView *)scrollView {
    
    if (!_scrollView) {
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, kWidth, KHeightS)];
//        scrollView.pagingEnabled = YES;
        
        scrollView.bounces = YES;
        
        scrollView.backgroundColor =[UIColor whiteColor];
        [self.view addSubview:scrollView];
        scrollView.contentSize = CGSizeMake(kWidth,KHeightS+1400);
        _scrollView = scrollView;
    }
    return _scrollView;
}

- (UICollectionView *)collectionView {
    
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        flowLayout.minimumInteritemSpacing = 5;
        //最小两行之间的间距
        flowLayout.minimumLineSpacing = 5;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        collectionView.showsHorizontalScrollIndicator = YES;
        collectionView.pagingEnabled = NO;
//        [collectionView setBackgroundColor:[UIColor cyanColor]];
        [collectionView setBackgroundColor:[UIColor whiteColor]];
        [collectionView setDelegate:self];
        [collectionView setDataSource:self];
        //_albumCollectionView.pagingEnabled = YES;
        [collectionView registerClass:[HBMenuListDetailCollectionViewCell class] forCellWithReuseIdentifier:@"HBMenuListDetailCVCellIdentifier"];
        _collectionView = collectionView;
    }
    return _collectionView;
    
    
    
    
}

//打电话
- (void)phoneClick:(UIButton *)sender{
    NSMutableString* str=[[NSMutableString alloc] initWithFormat:@"tel:%@",self.merchantPhone];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
    

}

- (void)loveClick:(UIButton *)sender{
    
}

- (NSDictionary *)getWeekData {
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *now;NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth  | NSCalendarUnitDay | NSCalendarUnitWeekday |NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    now = [NSDate date];
    comps = [calendar components:unitFlags fromDate:now];
    NSInteger week = [comps weekday];
    NSInteger month = [comps month];
    NSInteger day = [comps day];
    NSInteger hour = [comps hour];
    NSInteger min = [comps minute];
    NSInteger sec = [comps second];
    
    NSString *realWeekday;
    if (week == 1) {
        realWeekday = @"星期日";
    }else if (week == 2){
        realWeekday = @"星期一";
    }else if (week == 3){
        realWeekday = @"星期二";
    }else if (week == 4){
        realWeekday = @"星期三";
    }else if (week == 5){
        realWeekday = @"星期四";
    }else if (week == 6){
        realWeekday = @"星期五";
    }else if (week == 7){
        realWeekday = @"星期六";
    }

    NSString *ndate = realWeekday;
    NSString *str = [NSString stringWithFormat:@"%ld:%ld",(long)hour,(long)min];
    NSDictionary *di = @{@"week":ndate,@"date":str};
    return di;

}

- (NSInteger)compareDate:(NSString*)aDate withDate:(NSString*)bDate
{
    NSInteger aa = 0;
    NSDateFormatter *dateformater = [[NSDateFormatter alloc] init];
    [dateformater setDateFormat:@"HH:mm"];
    NSDate *dta = [[NSDate alloc] init];
    NSDate *dtb = [[NSDate alloc] init];
    
    dta = [dateformater dateFromString:aDate];
    dtb = [dateformater dateFromString:bDate];
    NSComparisonResult result = [dta compare:dtb];
    if (result == NSOrderedSame)
    {
        //        相等  aa=0
    }else if (result == NSOrderedAscending)
    {
        //bDate比aDate大
        aa=1;
    }else if (result == NSOrderedDescending)
    {
        //bDate比aDate小
        aa=-1;
        
    }
    
    return aa;
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

#import <UIImageView+WebCache.h>

@interface HBMenuListDetailCollectionViewCell ()


@property (nonatomic, weak) UIImageView *imgV;

@property (nonatomic, weak) UILabel *nameL;

@end

@implementation HBMenuListDetailCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        UIImageView *imgV = [[UIImageView alloc] init];
        imgV.image = [UIImage imageNamed:@"lang"];
//        imgV.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:imgV];
        _imgV = imgV;
        
        UILabel *nameL = [[UILabel alloc] init];
        nameL.text = @"菜名";
//        nameL.backgroundColor = [UIColor yellowColor];
        nameL.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:nameL];
        _nameL = nameL;
        
        
        
        __weak __typeof(&*self)weakSelf = self;
        [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView).offset(5);
            make.top.equalTo(weakSelf.contentView);
            make.width.mas_equalTo((kWidth-25)/4);
            make.height.mas_equalTo((kWidth-25)/4-10);
        }];
        
        [nameL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf.contentView);
            make.top.equalTo(imgV.mas_bottom).offset(5);
     
        }];
    }
    return self;
}

- (void)setDict:(NSDictionary *)dict {
    _dict = dict;
    if ([dict objectForKey:@"img"]) {
        NSString *imgurl = [NSString stringWithFormat:@"%@%@",RYServiceAddress,[dict objectForKey:@"img"]];
        [self.imgV sd_setImageWithURL:[NSURL URLWithString:imgurl]];
    }
    
    if ([dict objectForKey:@"name"]) {
        self.nameL.text = [dict objectForKey:@"name"];
    }
    
    
}


@end

