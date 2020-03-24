//
//  HBSettingController.m
//  NewProj
//
//  Created by 胡贝 on 2019/5/23.
//  Copyright © 2019年 胡贝. All rights reserved.
//

#import "HBSettingController.h"
#import "HBPersonalDataSetController.h"
#import "HBAboutUsController.h"

@interface HBSettingController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak)UITableView *tableView;

@property (nonatomic, strong)NSMutableArray *dataSources;

@end

@implementation HBSettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.dataSources = @[@"个人资料设置",@"关于我们",@"清空缓存"].mutableCopy;
    
    [self setupUI];
}

- (void)setupUI{
    self.title = @"设置";
    self.view.backgroundColor = [UIColor whiteColor];
//    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
//    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTranslucent:NO];
    
    

    self.navigationController.navigationBar.barTintColor = HBRedColor;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [self.view addSubview:self.tableView];
    
    
//    removeFile
    UIButton *logoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    logoutBtn.layer.cornerRadius = 4.0;
    [logoutBtn addTarget:self action:@selector(clickLogoutBtn:) forControlEvents:UIControlEventTouchUpInside];
    logoutBtn.backgroundColor = HBRedColor;
    [logoutBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [logoutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [logoutBtn setTitle:@"退出" forState:UIControlStateNormal];
    [self.view addSubview:logoutBtn];
    
    [logoutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).offset(-50);
        make.width.mas_equalTo(kWidth-40);
        make.height.mas_equalTo(50);
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSources.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"setting";
    HBSetCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[HBSetCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;//cell的右边有一个小箭头，距离右边有十几像素；

    }
    
    
    cell.textLabel.text = self.dataSources[indexPath.row];
        
    if (indexPath.row == 2) {
        
        NSUInteger bytesCache = [[SDImageCache sharedImageCache] getSize];
        //换算成 MB (注意iOS中的字节之间的换算是1000不是1024)
        float MBCache = bytesCache/1000/1000;
        NSString *stringFloat = [NSString stringWithFormat:@"%.2fM",MBCache];
        cell.subL.text = stringFloat;
        
    }
    
    return cell;
    
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    

    HBPersonalDataSetController *personDataSetVc = [[HBPersonalDataSetController alloc] init];

    
    if (indexPath.row == 0) {
        //个人资料
        [self.navigationController pushViewController:personDataSetVc animated:YES];
        
    }else if (indexPath.row == 1){
        HBAboutUsController *aboutUsVc = [[HBAboutUsController alloc] init];
        [self.navigationController pushViewController:aboutUsVc animated:YES];

    }else if (indexPath.row == 2){
        
//        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [[SDImageCache sharedImageCache] clearDisk];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"清理缓存成功" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
            [alert show];
        
//        });
            [self.tableView reloadData];

    }
    
    
    
    
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

//退出
- (void)clickLogoutBtn:(UIButton *)sender {
    
    BOOL isSuccess = [HTSaveCachesFile removeFile:@"HBUSER"];
    if (isSuccess) {
        [self showHint:@"退出登录"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    }
}



- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, KHeightS-170) style:UITableViewStyleGrouped];
        tableView.backgroundColor = RYBackgroundColor;
        tableView.separatorStyle = UITableViewCellEditingStyleNone;
        tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
        tableView.scrollEnabled = NO;
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLineEtched;//推荐该方法
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

@interface HBSetCell ()

@end

@implementation HBSetCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UILabel *subL = [[UILabel alloc] init];
        subL.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:subL];
        _subL = subL;
        
        [subL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).offset(-10);
            make.centerY.equalTo(self.contentView);
            
        }];
        
    }
    return self;
}


@end
