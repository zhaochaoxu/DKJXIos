//
//  HBWantSpecialityController.m
//  NewProj
//
//  Created by 胡贝 on 2019/6/23.
//  Copyright © 2019年 胡贝. All rights reserved.
//

#import "HBWantSpecialityController.h"
#import "HBMenuListDetailController.h"
#import "HBMenuListCell.h"
#import "HBApiTool.h"

@interface HBWantSpecialityController ()<UITableViewDelegate,UITableViewDataSource,HBMenuListCellDelegate>

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong)NSMutableArray *dataSources;



@end

@implementation HBWantSpecialityController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self loadWantSpecialityData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.dataSources = [NSMutableArray array];
    [self setupUI];
//    [self loadWantSpecialityData];
    
}

- (void)setupUI {
    
    self.title = @"我想吃的招牌菜";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = HBRedColor;
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    [self.view addSubview:self.tableView];
}

- (void)loadWantSpecialityData {
    kWEAK_SELF;
    [HBApiTool GetWantSpecialityWithSuccess:^(NSArray * _Nonnull array) {
        kSTRONG_SELF;
        if (array) {
            strong_self.dataSources = array.mutableCopy;
            [strong_self.tableView reloadData];
        }
    } failure:^(NSError * _Nonnull error) {
        
    }];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSources.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"mine";
    HBMenuListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[HBMenuListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        //        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;//cell的右边有一个小箭头，距离右边有十几像素；
         cell.delegate = self;
        
    }
    
    cell.dict = self.dataSources[indexPath.row];
    
    return cell;
    
    
    
}

- (void)HBMenuListCellDelegate:(NSString *)number boolValue:(BOOL)value indexpath:(NSString *)num {
    NSDictionary *dic = self.dataSources[[num integerValue]];
    
    
    kWEAK_SELF;
    [HBApiTool PostCancelCollectionLoveWithMerchantID:[[dic objectForKey:@"id"] stringValue]
                                           consumerID:@""
                                              success:^(NSDictionary * _Nonnull dict) {
                                                  kSTRONG_SELF;
                                                  if (dic) {
                                                      [self.view makeToast:[dict objectForKey:@"msg"]];
                                                      [strong_self loadWantSpecialityData];
                                                      
                                                  }
                                              } failure:^(NSError * _Nonnull error) {
                                                  
                                              }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *dict = self.dataSources[indexPath.row];
    HBMenuListDetailController *menuDetailVc = [[HBMenuListDetailController alloc] init];
    menuDetailVc.dict = dict;
//    [self.navigationController setNavigationBarHidden:NO animated:NO];//导航栏展示出来
//    [self.tabBarController.tabBar setHidden:YES];//隐藏标签栏
    [self.navigationController pushViewController:menuDetailVc animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 380;
    
}


- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, KHeightS) style:UITableViewStyleGrouped];
        tableView.backgroundColor = RYBackgroundColor;
        tableView.separatorStyle = UITableViewCellEditingStyleNone;
        tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
//        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLineEtched;//推荐该方法
        
        tableView.delegate = self;
        tableView.dataSource = self;
        [self.view addSubview:tableView];
        _tableView = tableView;
        
    }
    return _tableView;
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
