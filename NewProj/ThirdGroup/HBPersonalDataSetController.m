//
//  HBPersonalDataSetController.m
//  NewProj
//
//  Created by 胡贝 on 2019/5/24.
//  Copyright © 2019年 胡贝. All rights reserved.
//

#import "HBPersonalDataSetController.h"
#import "HBPersonInfoCell.h"
#import "SelectPhotoManager.h"
#import "HMDatePickView.h"
#import "HBBindCellphoneController.h"
#import "HTSaveCachesFile.h"
#import <UIImageView+WebCache.h>
#import <UIButton+WebCache.h>
#import "HBApiTool.h"


@interface HBPersonalDataSetController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak)UITableView *tableView;

@property (nonatomic, strong)NSMutableArray *dataSources;

@property (nonatomic, strong)SelectPhotoManager *photoManager;


@end

@implementation HBPersonalDataSetController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSString *we;
    NSDictionary *userinfo = [HTSaveCachesFile loadDataList:@"HBUSER"];
    if ([userinfo objectForKey:@"company"]) {
        we = [userinfo objectForKey:@"company"];
    }
    
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
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    _dataSources = @[@"头像",@"昵称",@"性别",@"生日",@"绑定手机号"].mutableCopy;
    
    
    
    [self setupUI];
}

- (void)setupUI {
    self.title = @"个人信息设置";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.dataSources.count-1;
    }
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"personalInfo";
    HBPersonInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[HBPersonInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
       //cell的右边有一个小箭头，距离右边有十几像素；
    }
    
    NSDictionary *dict = [HTSaveCachesFile loadDataList:@"HBUSER"];

    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.subTitleL.hidden = YES;
            cell.imgBtn.hidden = NO;
            
            
        }else{
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.subTitleL.hidden = NO;
            cell.imgBtn.hidden = YES;
            
            if (indexPath.row == 1) {
                cell.subTitleL.text = [dict objectForKey:@"nickname"];
            }else if (indexPath.row == 2){
                if ([[[dict objectForKey:@"sex"] stringValue] isEqualToString:@"1"]) {
                    cell.subTitleL.text = @"男";
                }else if ([[[dict objectForKey:@"sex"] stringValue] isEqualToString:@"0"]){
                    cell.subTitleL.text = @"女";
                }
              
            }else if (indexPath.row == 3){
                NSString *str1 = [[dict objectForKey:@"birth"] substringToIndex:11];//截取掉下标11之前的字符串
                cell.subTitleL.text =  str1;
                
            }
        }
        cell.titleL.text = self.dataSources[indexPath.row];
    }else{
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.subTitleL.hidden = NO;
        cell.imgBtn.hidden = YES;
        cell.titleL.text = self.dataSources[indexPath.row+4];
        cell.subTitleL.text = [dict objectForKey:@"tel"];
    }

    
    return cell;
    
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];


    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
//            if (!_photoManager) {
//                _photoManager =[[SelectPhotoManager alloc]init];
//            }
//            [_photoManager startSelectPhotoWithImageName:@"选择头像"];
////            __weak typeof(self)mySelf=self;
//            //选取照片成功
//            _photoManager.successHandle=^(SelectPhotoManager *manager,UIImage *image){
//                HBPersonInfoCell *cell = (HBPersonInfoCell *)[tableView cellForRowAtIndexPath:indexPath];
//                [cell.imgBtn setImage:image forState:UIControlStateNormal];
//                cell.imgBtn.layer.cornerRadius = 30;
//                //保存到本地
//                NSData *data = UIImagePNGRepresentation(image);
//                [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"headerImage"];
//            };
        }else if (indexPath.row == 1){
            HBPersonInfoCell *cell = (HBPersonInfoCell *)[tableView cellForRowAtIndexPath:indexPath];
            [self nickNameClick:cell];//修改昵称
            
        }else if (indexPath.row == 2){
            HBPersonInfoCell *cell = (HBPersonInfoCell *)[tableView cellForRowAtIndexPath:indexPath];
            [self alterSexPortrait:cell];//修改性别
            
        }else if (indexPath.row == 3){
            //修改日期
            HBPersonInfoCell *cell = (HBPersonInfoCell *)[tableView cellForRowAtIndexPath:indexPath];
            [self dateBtnClick:cell];
        }
    }else{
        HBBindCellphoneController *bindCellVc = [[HBBindCellphoneController alloc] init];
        [self.navigationController pushViewController:bindCellVc animated:YES];
        
    }
    
//    HBLoginController *loginVc = [[HBLoginController alloc] init];
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVc];
//
//    if (indexPath.row == 0) {
//        [self presentViewController:nav animated:YES completion:nil];
//
//    }else if (indexPath.row == 1){
//        [self presentViewController:nav animated:YES completion:nil];

}

- (void)dateBtnClick:(HBPersonInfoCell *)cell {
    
    /** 自定义日期选择器 */
    HMDatePickView *datePickVC = [[HMDatePickView alloc] initWithFrame:CGRectMake(0, 0, kWidth, KHeightS)];
    //距离当前日期的年份差（设置最大可选日期）
    datePickVC.maxYear = -1;
    //设置最小可选日期(年分差)
    //    _datePickVC.minYear = 10;
    datePickVC.date = [NSDate date];
    //设置字体颜色
    datePickVC.fontColor = [UIColor redColor];
    //日期回调
    datePickVC.completeBlock = ^(NSString *selectDate) {
        cell.subTitleL.text = selectDate;
        
        [HBApiTool PostModifyUserInfoWithNickname:NULL
                                              sex:NULL
                                            birth:selectDate
                                          success:^(NSDictionary * _Nonnull dict) {
                                              if (dict) {
                                                  [self showHint:[dict objectForKey:@"msg"]];
                                              }
                                              
                                          } failure:^(NSError * _Nonnull error) {
                                              
                                          }];
    };
    //配置属性
    [datePickVC configuration];
    
    [self.view addSubview:datePickVC];
}


#pragma mark----- 选择性别弹出框
- (void)alterSexPortrait:(HBPersonInfoCell *)cell {
    /*  弹出提示框
     */
    //初始化提示框
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    //按钮：男
    [alert addAction:[UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        cell.subTitleL.text=@"男";
        cell.subTitleL.textColor = [UIColor blackColor];
        [HBApiTool PostModifyUserInfoWithNickname:NULL
                                              sex:@"1"
                                            birth:NULL
                                          success:^(NSDictionary * _Nonnull dict) {
                                              if (dict) {
                                                  [self showHint:[dict objectForKey:@"msg"]];
                                              }
                                              
                                          } failure:^(NSError * _Nonnull error) {
                                              
                                          }];
    }]];
    //按钮：女
    [alert addAction:[UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        cell.subTitleL.text=@"女";
        cell.subTitleL.textColor = [UIColor blackColor];
        [HBApiTool PostModifyUserInfoWithNickname:NULL
                                              sex:@"0"
                                            birth:NULL
                                          success:^(NSDictionary * _Nonnull dict) {
                                              if (dict) {
                                                  [self showHint:[dict objectForKey:@"msg"]];
                                              }
                                              
                                          } failure:^(NSError * _Nonnull error) {
                                              
                                          }];
    }]];
    //按钮：取消，类型：UIAlertActionStyleCancel
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)nickNameClick:(HBPersonInfoCell *)cell {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"请输入昵称" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UITextField *userNameTextField = alertController.textFields.firstObject;
            userNameTextField.secureTextEntry = NO;
            NSLog(@"昵称：%@",userNameTextField.text);
            cell.subTitleL.text = userNameTextField.text;
            
            [HBApiTool PostModifyUserInfoWithNickname:userNameTextField.text
                                                  sex:NULL
                                                birth:NULL
                                              success:^(NSDictionary * _Nonnull dict) {
                                                 if (dict) {
                                                     
                                                     [self showHint:[dict objectForKey:@"msg"]];
                                                 }
                                            } failure:^(NSError * _Nonnull error) {
                                                 
                                            }];
        }]];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField*_Nonnull textField) {
//        NSDictionary *dic = [HTSaveCachesFile loadDataList:@"HBUSER"];
    
        textField.placeholder =@"请输入昵称";
        
        textField.secureTextEntry=NO;
        
    }];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 85;
        }
    }
    return 55;
}


- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, KHeightS) style:UITableViewStyleGrouped];
        tableView.backgroundColor = RYBackgroundColor;
        tableView.separatorStyle = UITableViewCellEditingStyleNone;
        tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
//        tableView.scrollEnabled = NO;
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
