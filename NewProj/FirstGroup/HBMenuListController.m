//
//  HBMenuListController.m
//  NewProj
//
//  Created by 胡贝 on 2019/4/5.
//  Copyright © 2019年 胡贝. All rights reserved.
//

#import "HBMenuListController.h"
#import "GoodsListCell.h"
#import "HBGoodsListController.h"
#import "RYHomeTopView.h"
#import "SDCycleScrollView.h"
#import "HBApiTool.h"
#import "MWPhotoBrowser.h"
#import "HBMenuListCell.h"
#import "HBLeftTableViewCell.h"
#import "HBMenuListDetailController.h"
#import <CoreLocation/CoreLocation.h>
#import "MONActivityIndicatorView.h"

@interface HBMenuListController ()<UITableViewDelegate,UITableViewDataSource,HBGoodsListControllerDeleagte,CLLocationManagerDelegate,HBMenuListCellDelegate>
{
    CLLocationManager *locationmanager;//定位服务
    NSString *currentCity;//当前城市
    NSString *strlatitude;//经度
    NSString *strlongitude;//纬度
    
    int _pageNum;
    BOOL flag;
    int _locationNum;
}
@property (nonatomic, weak) RYHomeTopView *topView;
@property (nonatomic, weak) SDCycleScrollView *cycleScrollView;
@property (nonatomic, weak)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *dataSources;
//@property (nonatomic, strong) NSMutableArray *MwPhotos;

@property (nonatomic, weak) UIView *tableBottomView;
@property (nonatomic, weak) UIView *maskView;
@property (nonatomic, weak) UITableView *leftTableView;
@property (nonatomic, weak) UITableView *rightTableView;
@property (nonatomic, strong)NSMutableArray *leftDataSources;
@property (nonatomic, strong)NSMutableArray *rightDataOneSources;
@property (nonatomic, strong)NSMutableArray *rightDataTwoSources;


@property (nonatomic, weak) UIView *bottomBarView;
@property (nonatomic, weak) UIButton *leftBtn;
@property (nonatomic, weak) UIButton *rightBtn;

@property (nonatomic, strong) NSMutableArray *selectArray;

//活动指示器
@property (nonatomic,weak) MONActivityIndicatorView *indicatorView;

@property (nonatomic, weak) UIImageView *backImg;


@end

@implementation HBMenuListController


- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    self.bottomBarView.hidden = NO;

    [self.tabBarController.tabBar setHidden:NO];

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    self.bottomBarView.hidden = YES;
//    [self.tabBarController.tabBar setHidden:YES];//隐藏tabbar

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    flag = NO;
    _locationNum = 0;
    
    self.dataSources = [NSMutableArray array];
    self.selectArray = [NSMutableArray array];
    self.leftDataSources = @[@"麻辣烫",@"烤鱼",@"东北菜"].mutableCopy;
    self.rightDataOneSources = [NSMutableArray array];
    self.rightDataTwoSources = [NSMutableArray array];

    [self getLocation];//获取经纬度
    [self setupUI];

    
    [self loadHeaderView];
    [self loadFooterView];
    [self loadRegionAndCuisineData];

    
    
    //设置到一进来就点击第一个选项
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
    if ([self.leftTableView.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
        [self.leftTableView.delegate tableView:self.leftTableView didSelectRowAtIndexPath:path];
    }
    // 设置默认选中的 cell 滚动的位置
    [self.leftTableView selectRowAtIndexPath:path animated:YES scrollPosition:UITableViewScrollPositionTop];
    
}
//区域和菜谱
- (void)loadRegionAndCuisineData {
    [HBApiTool GetRegionWithSuccess:^(NSArray *array) {
        
        if (array) {
            self.rightDataOneSources = array.mutableCopy;
        }
    } failure:^(NSError * error) {
        
    }];
    
    [HBApiTool GetCuisineWithSuccess:^(NSArray * _Nonnull array) {
        if (array) {
            self.rightDataTwoSources = array.mutableCopy;
        }
        [self.tableView.mj_header endRefreshing];
    } failure:^(NSError * _Nonnull error) {
        
    }];
    
    
}

- (void)setDataSources:(NSMutableArray *)dataSources {
    _dataSources = dataSources;
    
 
    [self.selectArray removeAllObjects];
    //将datasouces数据collect 放到selecArray
    [dataSources enumerateObjectsUsingBlock:^(NSDictionary  *dict, NSUInteger idx, BOOL * _Nonnull stop) {
        NSNumber *collectNum = [dict objectForKey:@"collect"];
        BOOL collect = [collectNum boolValue];
        if (collect == YES) {
            NSString *num = [NSString stringWithFormat:@"%lu",(unsigned long)idx];
            [self.selectArray addObject:num];
        }
        
    }];
    
    [self.tableView reloadData];
}

- (void)setRightDataOneSources:(NSMutableArray *)rightDataOneSources {
    _rightDataOneSources = rightDataOneSources;
    [self.rightTableView reloadData];
}



- (void)loadHeaderView {
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadGroupListData)];
}

- (void)loadFooterView {
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}


- (void)setupUI {
//    self.title = @"招牌菜";
//    self.tabBarController.tabBar.tintColor = [UIColor colorWithRed:252/255.0 green:13/255.0 blue:27/255.0 alpha:1.0f];
    if (self.navigationController) {
        self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
        [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    }
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.tabBarController.tabBar.tintColor = HBRedColor;
    self.view.backgroundColor = RYBackgroundColor;
    self.navigationController.navigationBar.barTintColor = HBRedColor;
    
    [self.navigationController.navigationBar addSubview:self.bottomBarView];
    [self.bottomBarView addSubview:self.leftBtn];
    [self.bottomBarView addSubview:self.rightBtn];
   
    [self.view addSubview:self.tableView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.tableBottomView];

    [self.tableBottomView addSubview:self.leftTableView];
    [self.tableBottomView addSubview:self.rightTableView];
    [self.view addSubview:self.indicatorView];



    
}


//获得首页列表
- (void)loadGroupListData {
    

    _pageNum = 1;
    kWEAK_SELF;
    [HBApiTool GetMenuListWithLongitude:strlongitude
                               latitude:strlatitude
                              bussHubId:nil
                          cuisineTypeID:nil
                                 pageNO:[NSString stringWithFormat:@"%@",@(_pageNum)]
                                success:^(NSDictionary *dict) {
                                    kSTRONG_SELF;
                                 
//
                                    NSNumber *success = [dict objectForKey:@"success"];
                                    boolean_t isS = [success boolValue];
                                    if (isS) {
                                        //说明有数据
                                        [self.backImg removeFromSuperview];
                                        NSArray *array =  [dict objectForKey:@"data"];
                                        strong_self.dataSources = array.mutableCopy;
                                    }else{
                                         [self.tableView addSubview:self.backImg];
                                    }
                                    
                                    [self.tableView.mj_header endRefreshing];
                                    [self.tableView.mj_footer endRefreshing];
                                } failure:^(NSError * _Nonnull error) {

                                }];
    
}

- (void)loadMoreData
{
    
    _pageNum = _pageNum +1;
    
    NSString *allPageNum = [NSString stringWithFormat:@"%@",@(_pageNum)];
    kWEAK_SELF;
    [HBApiTool GetMenuListWithLongitude:strlongitude
                               latitude:strlatitude
                              bussHubId:nil
                          cuisineTypeID:nil
                                 pageNO:allPageNum
                                success:^(NSDictionary * _Nonnull dict) {
                                    kSTRONG_SELF;
                                    
                                    NSNumber *success = [dict objectForKey:@"success"];
                                    boolean_t isS = [success boolValue];
                                    if (isS) {
                                        NSArray *array = [dict objectForKey:@"data"];
                                        [strong_self.dataSources addObjectsFromArray:array];
                                        //添加了新的item 同时selecarray 也得添加新的item
                                        [array enumerateObjectsUsingBlock:^(NSDictionary  *dict, NSUInteger idx, BOOL * _Nonnull stop) {
                                           NSNumber *collectNum = [dict objectForKey:@"collect"];
                                           BOOL collect = [collectNum boolValue];
                                           if (collect == YES) {
                                        
                                               NSString *num = [NSString stringWithFormat:@"%lu",(unsigned long)idx];
                                               NSInteger allnum = ([allPageNum integerValue]-1)*10 + [num integerValue];
                                               NSString *allnum1 = [NSString stringWithFormat:@"%ld",allnum];
                                               [self.selectArray addObject:allnum1];
                                           }
                                        }];
                                        
                                        [self.tableView reloadData];
                                        
                                    }else{
                                        
                                    }

                                    
                                    [self.tableView.mj_header endRefreshing];
                                    [self.tableView.mj_footer endRefreshing];
                                    
                                } failure:^(NSError * _Nonnull error) {
                                    
                                }];
}

- (void)getLocation
{
    //判断定位功能是否打开
    if ([CLLocationManager locationServicesEnabled]) {
        locationmanager = [[CLLocationManager alloc]init];
        locationmanager.delegate = self;
        [locationmanager requestAlwaysAuthorization];
        currentCity = [NSString new];
        [locationmanager requestWhenInUseAuthorization];
        
        //设置寻址精度
        locationmanager.desiredAccuracy = kCLLocationAccuracyBest;
        locationmanager.distanceFilter = 5.0;
        [locationmanager startUpdatingLocation];
    }
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.leftTableView) {
        return self.leftDataSources.count;
    }else if (tableView == self.rightTableView){
        return self.rightDataOneSources.count;
    }
    return self.dataSources.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.leftTableView) {
        static NSString *cellIdentifier = @"left";
        HBLeftTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[HBLeftTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.titleL.text = @"热门商圈";
        cell.titleL.font = [UIFont systemFontOfSize:13];
        return cell;
    }else if (tableView == self.rightTableView){
        static NSString *cellidentidier = @"right";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellidentidier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellidentidier];
            
        }
        if (flag == NO) {
            NSDictionary *dict = self.rightDataOneSources[indexPath.row];
            cell.textLabel.text =[dict objectForKey:@"name"];
            cell.textLabel.font = [UIFont systemFontOfSize:13];
        }else if(flag == YES){
            NSDictionary *dict = self.rightDataTwoSources[indexPath.row];
            cell.textLabel.text =[dict objectForKey:@"name"];
            cell.textLabel.font = [UIFont systemFontOfSize:13];
        }
        

        return cell;
    }
    
    static NSString *cellIdentifier = @"goodslist";
    HBMenuListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[HBMenuListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.delegate = self;
        
    }
    
    NSString *num = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    
    
    
//    if ([self.selectArray containsObject:num]) {
//        [cell setImageViewRed];
//    }else{
//        [cell setImageViewGray];
//    }
    
    cell.num = num;
    cell.array = self.selectArray;
    cell.dict = self.dataSources[indexPath.row];
    if ([self.selectArray containsObject:num]) {
        [cell setImageViewRed];
    }else{
        [cell setImageViewGray];
    }
    

    return cell;

    
}

- (void)HBMenuListCellDelegate:(NSString *)number boolValue:(BOOL)value indexpath:(NSString *)num {
    NSDictionary *dic = self.dataSources[[num integerValue]];
    if ([self.selectArray containsObject:num]) {
        [self.selectArray removeObject:num];
        [HBApiTool PostCancelCollectionLoveWithMerchantID:[[dic objectForKey:@"id"] stringValue]
                                               consumerID:@""
                                                  success:^(NSDictionary * _Nonnull dict) {
                                                      if (dic) {
                                                          [self.view makeToast:[dict objectForKey:@"msg"]];
                                                      }
                                                  } failure:^(NSError * _Nonnull error) {
                                                      
                                                  }];
    }else{
        [self.selectArray addObject:num];
        
        [HBApiTool PostCollectionLoveWithMerchantID:[[dic objectForKey:@"id"] stringValue]
                                         consumerID:@""
                                            success:^(NSDictionary * _Nonnull dict) {
                                                if (dict) {
                                                    [self.view makeToast:[dict objectForKey:@"msg"]];
                                                }
                                            } failure:^(NSError * _Nonnull error) {
                                                
                                            }];
    }
    



    
    
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

    if (tableView == self.leftTableView) {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        
        NSLog(@"left");
    }else if (tableView == self.rightTableView){
        NSLog(@"right");
        NSString *name = nil;
        NSString *cuisine = nil;
        if (flag == 0) {
            //区域
            name = [[self.rightDataOneSources[indexPath.row] objectForKey:@"id"] stringValue];
            NSString *realName = [self.rightDataOneSources[indexPath.row] objectForKey:@"name"];
            [self.leftBtn setTitle:realName forState:UIControlStateNormal];
            
        }else if (flag == 1){
            //菜品
            cuisine = [[self.rightDataTwoSources[indexPath.row] objectForKey:@"id"] stringValue];
            NSString *cuisineName = [self.rightDataTwoSources[indexPath.row] objectForKey:@"name"];
            [self.rightBtn setTitle:cuisineName forState:UIControlStateNormal];
        }
        
        //
        
        _pageNum = 1;
        kWEAK_SELF;
        //点击就收回下拉
        [self removeMask];
      

        [HBApiTool GetMenuListWithLongitude:strlongitude
                                    latitude:strlatitude
                                   bussHubId:name
                               cuisineTypeID:cuisine
                                      pageNO:[NSString stringWithFormat:@"%@",@(_pageNum)]
                                     success:^(NSDictionary *dict) {
                                         kSTRONG_SELF;

                                         NSNumber *success = [dict objectForKey:@"success"];
                                         boolean_t isS = [success boolValue];
                                         if (isS) {
                                             //从tableview上面移除
                                             
                                             [self.backImg removeFromSuperview];
                                             NSArray *array = [dict objectForKey:@"data"];
                                             strong_self.dataSources = array.mutableCopy;
                                             
                                         }else{
                                             //说明没数据
                                             [self.dataSources removeAllObjects];
                                             [self.tableView addSubview:self.backImg];
                                             [self.backImg mas_makeConstraints:^(MASConstraintMaker *make) {
                                                 make.center.equalTo(self.tableView);
                                                 make.width.mas_equalTo(150);
                                                 make.height.mas_equalTo(150);
                                             }];
                                             [self.tableView reloadData];
                                         }
                                    
                                     } failure:^(NSError * _Nonnull error) {

                                     }];
        
        
        
    }else if (tableView == self.tableView){

        NSDictionary *dict = self.dataSources[indexPath.row];
        HBMenuListDetailController *menuDetailVc = [[HBMenuListDetailController alloc] init];
        menuDetailVc.dict = dict;
        [self.navigationController setNavigationBarHidden:NO animated:NO];//导航栏展示出来
        [self.tabBarController.tabBar setHidden:YES];//隐藏标签栏
        [self.navigationController pushViewController:menuDetailVc animated:YES];
        
        NSLog(@"tableView");
    }


    
    
}



- (void)HBGoodsListControllerDeleagteWithValue:(NSString *)value {
    NSLog(@"---%@",value);
}

#pragma mark CoreLocation delegate (定位失败)
//定位失败后调用此代理方法
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    //设置提示提醒用户打开定位服务
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"允许定位提示" message:@"请在设置中打开定位" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"打开定位" style:UIAlertActionStyleDefault handler:nil];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:okAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}


#pragma mark 定位成功后则执行此代理方法
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    //每次一进来就+1
    _locationNum = _locationNum + 1;
    [locationmanager stopUpdatingHeading];
    //旧址
    CLLocation *currentLocation = [locations lastObject];
    CLGeocoder *geoCoder = [[CLGeocoder alloc]init];
    //打印当前的经度与纬度
    NSLog(@"%f,%f",currentLocation.coordinate.latitude,currentLocation.coordinate.longitude);
    strlatitude = [NSString stringWithFormat:@"%.6f",currentLocation.coordinate.latitude];
    strlongitude = [NSString stringWithFormat:@"%.6f",currentLocation.coordinate.longitude];
    
    [self loadGroupListData];
    manager.delegate = nil;
    
//    if (_locationNum == 2) {
//        [self loadGroupListData];
//        _locationNum = 0;
//    }
    

    if (strlatitude != nil) {
        [locationmanager stopUpdatingLocation];
    }
    
    //反地理编码
    [geoCoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count > 0) {
            CLPlacemark *placeMark = placemarks[0];
            currentCity = placeMark.locality;
            if (!currentCity) {
                currentCity = @"无法定位当前城市";
            }
            
            /*看需求定义一个全局变量来接收赋值*/
            NSLog(@"----%@",placeMark.country);//当前国家
            NSLog(@"%@",currentCity);//当前的城市
            //            NSLog(@"%@",placeMark.subLocality);//当前的位置
            //            NSLog(@"%@",placeMark.thoroughfare);//当前街道
            //            NSLog(@"%@",placeMark.name);//具体地址
            
        }
    }];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.leftTableView) {
        return 50;
    }else if (tableView == self.rightTableView){
        return 50;
    }
    return 380;
}





- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 68, kWidth, KHeightL) style:UITableViewStyleGrouped];
        tableView.backgroundColor = RYBackgroundColor;
        tableView.separatorStyle = UITableViewCellEditingStyleNone;
        tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
//        ableView.separatorStyle = UITableViewCellSeparatorStyleSingleLineEtched;//推荐该方法
        tableView.estimatedRowHeight = 0;
        tableView.estimatedSectionHeaderHeight = 0;
        tableView.estimatedSectionFooterHeight = 0;
        tableView.delegate = self;
        tableView.dataSource = self;
        [self.view addSubview:tableView];
        _tableView = tableView;

    }
    return _tableView;
}

- (UIView *)tableBottomView {
    if (!_tableBottomView) {
        UIView *tableBottomView = [[UIView alloc] initWithFrame:CGRectMake(0, -300, kWidth, 300)];
        tableBottomView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
      
        [self.view addSubview:tableBottomView];
        _tableBottomView = tableBottomView;
    }
    return _tableBottomView;
}

- (UITableView *)leftTableView {
    if (!_leftTableView) {
        UITableView *leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth/2.1, 50) style:UITableViewStylePlain];
//        leftTableView.bounces = NO;
        leftTableView.backgroundColor = RYBackgroundColor;
        leftTableView.separatorStyle = UITableViewCellEditingStyleNone;
//        leftTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLineEtched;//推荐该方法
        leftTableView.delegate = self;
        leftTableView.dataSource = self;
        [self.tableBottomView addSubview:leftTableView];
        _leftTableView = leftTableView;
        
    }
    return _leftTableView;
}

- (UITableView *)rightTableView {
    if (!_rightTableView) {
        UITableView *rightTableView = [[UITableView alloc] initWithFrame:CGRectMake(kWidth/2.1, 0, kWidth*1.1/2.1, 300) style:UITableViewStylePlain];
        rightTableView.backgroundColor = RYBackgroundColor;
        rightTableView.bounces = NO;
        rightTableView.separatorStyle = UITableViewCellEditingStyleNone;
//        rightTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLineEtched;//推荐该方法
        
        rightTableView.delegate = self;
        rightTableView.dataSource = self;
        [self.tableBottomView addSubview:rightTableView];
        _rightTableView = rightTableView;
        
    }
    return _rightTableView;
}

- (UIView *)bottomBarView {
    if (!_bottomBarView) {
        UIView *bottomBarView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, kWidth, 64)];
        bottomBarView.backgroundColor = [UIColor whiteColor];
        [self.navigationController.navigationBar addSubview:bottomBarView];
//        [self.view addSubview:bottomBarView];
        _bottomBarView = bottomBarView;
    }
    return _bottomBarView;
}

- (UIButton *)leftBtn {
    if (!_leftBtn) {
        UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        leftBtn.frame = CGRectMake(40, 20, 80, 35);
        [leftBtn setImage:[UIImage imageNamed:@"下三角"] forState:UIControlStateNormal];
        leftBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [leftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        leftBtn.backgroundColor = [UIColor cyanColor];
        
        [leftBtn setTitle:@"全城" forState:UIControlStateNormal];
        [leftBtn addTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomBarView addSubview:leftBtn];
        _leftBtn = leftBtn;
        
    }
    return _leftBtn;
}

- (UIButton *)rightBtn {
    if (!_rightBtn) {
        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        rightBtn.frame = CGRectMake(170, 20, 80, 35);
        rightBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        rightBtn.backgroundColor = [UIColor cyanColor];
        [rightBtn setImage:[UIImage imageNamed:@"下三角"] forState:UIControlStateNormal];
        [rightBtn setTitle:@"全部" forState:UIControlStateNormal];
        [rightBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomBarView addSubview:rightBtn];
        _rightBtn = rightBtn;
        
    }
    return _rightBtn;
}

-(UIView *)maskView {
    if (!_maskView) {
        UIView *maskView = [[UIView alloc] initWithFrame:CGRectMake(0, KHeight, kWidth, KHeight)];
        maskView.backgroundColor = [UIColor blackColor];
        maskView.alpha = 0.7;
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeMask)];
        //        recognizer.delegate = self;
        [maskView addGestureRecognizer:recognizer];
        [[UIApplication sharedApplication].keyWindow addSubview:maskView];
        _maskView = maskView;
    }
    return _maskView;
}

//点击全城按钮 弹出下来区域框
- (void)leftBtnClick:(UIButton *)sender {
    
    flag = NO;
    [self.rightTableView reloadData];
    
    kWEAK_SELF;
    [UIView animateWithDuration:0.3 animations:^{
        kSTRONG_SELF;
        strong_self.maskView.frame = CGRectMake(0, 0, kWidth, KHeight);
    }];
    [UIView animateWithDuration:0.3 animations:^{
        kSTRONG_SELF;
        strong_self.tableBottomView.frame = CGRectMake(0, 20, kWidth, 300);
    }];
    
}

- (void)rightBtnClick:(UIButton *)sender {
    
    flag = YES;
    [self.rightTableView reloadData];
    kWEAK_SELF;
    [UIView animateWithDuration:0.3 animations:^{
        kSTRONG_SELF;
        strong_self.maskView.frame = CGRectMake(0, 0, kWidth, KHeight);
    }];
    [UIView animateWithDuration:0.3 animations:^{
        kSTRONG_SELF;
        strong_self.tableBottomView.frame = CGRectMake(0, 20, kWidth, 300);
    }];
}

- (void)removeMask {
    kWEAK_SELF;
    
    [UIView animateWithDuration:0.3 animations:^{
        kSTRONG_SELF;
        strong_self.maskView.frame = CGRectMake(0, KHeight, kWidth, KHeight);
    }];
    [UIView animateWithDuration:0.3 animations:^{
        kSTRONG_SELF;
        strong_self.tableBottomView.frame = CGRectMake(0, -300, kWidth, 300);
    }];
}

- (MONActivityIndicatorView *)indicatorView
{
    if (_indicatorView == nil) {
        MONActivityIndicatorView *indicatorView = [[MONActivityIndicatorView alloc] init];
        indicatorView.numberOfCircles = 5;
        indicatorView.radius = 10;
        indicatorView.internalSpacing = 6;
        indicatorView.duration = 0.5;
        indicatorView.delay = 0.2;
        indicatorView.center = self.view.center;
        [self.view addSubview:indicatorView];
        _indicatorView = indicatorView;
    }
    return _indicatorView;
}

- (UIImageView *)backImg {
    if (_backImg == nil) {
        UIImageView *backImg = [[UIImageView alloc] init];
        backImg.image = [UIImage imageNamed:@"kong"];
        [self.tableView addSubview:backImg];
        _backImg = backImg;
    }
    return _backImg;
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

