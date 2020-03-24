//
//  HBBindCellphoneController.m
//  NewProj
//
//  Created by 胡贝 on 2019/5/27.
//  Copyright © 2019年 胡贝. All rights reserved.
//

#import "HBBindCellphoneController.h"
#import "SmsButtonHandle.h"
#import "HBApiTool.h"

@interface HBBindCellphoneController ()<UITextFieldDelegate>

@property (nonatomic, weak)UITextField *phoneTxf;

@property (nonatomic, weak)UITextField *verifyCodeTxf;

//@property (nonatomic, weak)UITextField *CombinationPSDTxf;

@end

@implementation HBBindCellphoneController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self setupUI];
}

- (void)setupUI {
    self.title = @"绑定手机号";
    self.view.backgroundColor = [UIColor whiteColor];

    
    
    
    UITextField *phoneTxf = [[UITextField alloc] init];
    phoneTxf.borderStyle = UITextBorderStyleRoundedRect;
    phoneTxf.clearButtonMode = UITextFieldViewModeWhileEditing;
    phoneTxf.attributedPlaceholder = [[NSMutableAttributedString alloc] initWithString:@"请输入手机号" attributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor],NSFontAttributeName : [UIFont systemFontOfSize:15.0],NSForegroundColorAttributeName : RGB0X(0xffffff)}];
    phoneTxf.font = [UIFont systemFontOfSize:15.0];
    phoneTxf.inputAccessoryView = [self addToolbar];
    phoneTxf.keyboardType = UIKeyboardTypeNumberPad;
    phoneTxf.returnKeyType = UIReturnKeyDone;//变为搜索按钮
    phoneTxf.delegate = self;//设置代理
    [self.view addSubview:phoneTxf];
    _phoneTxf = phoneTxf;
    
    
    UITextField *verifyCodeTxf = [[UITextField alloc] init];
    verifyCodeTxf.borderStyle = UITextBorderStyleRoundedRect;
    verifyCodeTxf.clearButtonMode = UITextFieldViewModeWhileEditing;
    verifyCodeTxf.attributedPlaceholder = [[NSMutableAttributedString alloc] initWithString:@"请输入验证码" attributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor],NSFontAttributeName : [UIFont systemFontOfSize:15.0],NSForegroundColorAttributeName : RGB0X(0xffffff)}];
    verifyCodeTxf.textColor = RGB0X(0x000000);
    verifyCodeTxf.font = [UIFont systemFontOfSize:15.0];
    verifyCodeTxf.inputAccessoryView = [self addToolbar];
    verifyCodeTxf.keyboardType = UIKeyboardTypeNumberPad;
    verifyCodeTxf.font = [UIFont systemFontOfSize:15.0];
    verifyCodeTxf.returnKeyType = UIReturnKeyDone;//变为搜索按钮
    verifyCodeTxf.delegate = self;//设置代理
    [self.view addSubview:verifyCodeTxf];
    _verifyCodeTxf = verifyCodeTxf;
    
    UIButton *verifyBtn = [[SmsButtonHandle sharedSmsBHandle] buttonWithFrame:CGRectZero title:@"获取中" action:@selector(clickVerifyBtn:) superVC:self];
    verifyBtn.layer.cornerRadius = 4.0;
    [verifyBtn addTarget:self action:@selector(clickVerifyBtn:) forControlEvents:UIControlEventTouchUpInside];
    verifyBtn.backgroundColor = HBRedColor;
    [verifyBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [verifyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [verifyBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self.view addSubview:verifyBtn];
    
    
//    UITextField *CombinationPSDTxf = [[UITextField alloc] init];
//    CombinationPSDTxf.borderStyle = UITextBorderStyleRoundedRect;
//    CombinationPSDTxf.clearButtonMode = UITextFieldViewModeWhileEditing;
//    CombinationPSDTxf.attributedPlaceholder = [[NSMutableAttributedString alloc] initWithString:@"请输入8-20字母数字组合密码" attributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor],NSFontAttributeName : [UIFont systemFontOfSize:15.0],NSForegroundColorAttributeName : RGB0X(0xffffff)}];
//    CombinationPSDTxf.textColor = RGB0X(0x000000);
//    CombinationPSDTxf.font = [UIFont systemFontOfSize:15.0];
//    CombinationPSDTxf.returnKeyType = UIReturnKeyDone;//变为搜索按钮
//    CombinationPSDTxf.delegate = self;//设置代理
//    [self.view addSubview:CombinationPSDTxf];
//    _CombinationPSDTxf = CombinationPSDTxf;
    
    
    
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.layer.cornerRadius = 4.0;
    [loginBtn addTarget:self action:@selector(clickLoginBtn:) forControlEvents:UIControlEventTouchUpInside];
    loginBtn.backgroundColor = HBRedColor;
    [loginBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginBtn setTitle:@"确认" forState:UIControlStateNormal];
    [self.view addSubview:loginBtn];
    
    
    [phoneTxf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.top.equalTo(self.view).offset(15);
        make.width.equalTo(@(kWidth-40));
        make.height.equalTo(@45);
    }];
    
    [verifyCodeTxf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.top.equalTo(phoneTxf.mas_bottom).offset(20);
        make.width.equalTo(@(kWidth-160));
        make.height.equalTo(@45);
    }];
    
    [verifyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(verifyCodeTxf.mas_right).offset(10);
        make.top.equalTo(phoneTxf.mas_bottom).offset(20);
        make.width.equalTo(@(110));
        make.height.equalTo(@45);
    }];
    
//    [CombinationPSDTxf mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(verifyBtn.mas_bottom).offset(20);
//        make.left.equalTo(self.view).offset(20);
//        make.right.equalTo(self.view.mas_right).offset(-20);
//        make.height.equalTo(@45);
//    }];
    
    
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.top.equalTo(self.verifyCodeTxf.mas_bottom).offset(30);
        make.width.equalTo(@(kWidth-40));
        make.height.equalTo(@47);
    }];
}


- (void)clickVerifyBtn:(UIButton *)sender {
    [[SmsButtonHandle sharedSmsBHandle] startTimer];
    
    if (self.phoneTxf.text.length == 0) {
        [self showHint:@"手机号不能为空"];
        return;
    }
    //发送验证码
    [HBApiTool GetVerifyCodeWithPhoneNumber:self.phoneTxf.text
                                    success:^(BOOL data) {
                                        if (data == YES) {
                                            [self showHint:@"验证码发送成功"];
                                        }
                                    }
                                    failure:^(NSError * _Nonnull error) {
                                        
                                    }];
}

- (void)clickLoginBtn:(UIButton *)sender {
    
    
    if (self.phoneTxf.text.length == 0){
        [self showHint:@"电话输入不能为空"];
        return;
    }else if (self.verifyCodeTxf.text.length == 0){
        [self showHint:@"验证码输入不能为空"];
        return;
    }
//    else if (self.CombinationPSDTxf.text.length == 0){
//        [self showHint:@"密码输入不能为空"];
//        return;
//    }
    [HBApiTool PostBindCellPhoneWithPhoneNum:self.phoneTxf.text
                                     msgCode:self.verifyCodeTxf.text
                                     success:^(NSDictionary * _Nonnull dict) {
                                         if (dict) {
                                             [self showHint:[dict objectForKey:@"msg"]];
                                             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                 [self.navigationController popViewControllerAnimated:YES];
                                             });
                                           
                                         }
                                     } failure:^(NSError * _Nonnull error) {
                                         
                                     }];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [textField resignFirstResponder];
}

- (id)addToolbar {
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 35)];
    toolbar.tintColor = [UIColor blueColor];
    toolbar.backgroundColor = [UIColor lightGrayColor];
    //    UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(nextTextField)];
    //    UIBarButtonItem *prevButton = [[UIBarButtonItem alloc] initWithTitle:@"上一步" style:UIBarButtonItemStylePlain target:self action:@selector(prevTextField)];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(textFieldDone)];
    [bar setTintColor:[UIColor blackColor]];
    toolbar.items = @[space, bar];
    return toolbar;
}

- (BOOL)textFieldDone {
    [self.phoneTxf resignFirstResponder];
    [self.verifyCodeTxf resignFirstResponder];
    return [self.phoneTxf resignFirstResponder];
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
