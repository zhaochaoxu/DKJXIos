//
//  HBRegisterController.m
//  NewProj
//
//  Created by 胡贝 on 2019/6/12.
//  Copyright © 2019年 胡贝. All rights reserved.
//

#import "HBRegisterController.h"
#import "SmsButtonHandle.h"
#import "HBApiTool.h"

@interface HBRegisterController ()<UITextFieldDelegate>

@property (nonatomic, weak) UITextField *nicknameTxf;
@property (nonatomic, weak) UITextField *phoneTxf;
@property (nonatomic, weak) UITextField *verifyCodeTxf;
@property (nonatomic, weak) UITextField *passwordTxf;
@property (nonatomic, weak) UITextField *rePasswordTxf;


@end

@implementation HBRegisterController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self addNoticeForKeyboard];
    [self setupUI];
    
    
}

- (void)addNoticeForKeyboard {
    
    //注册键盘出现的通知
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillShow:)
//                                                 name:UIKeyboardWillShowNotification object:nil];
    //注册键盘消失的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)setupUI {
    self.title = @"注册";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = HBRedColor;
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
//    UIButton *leftbutton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [leftbutton setTitle:@"返回" forState:UIControlStateNormal];
//    [leftbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [leftbutton addTarget:self action:@selector(clickbutton:) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftbutton];
    
    UITextField *nicknameTxf = [[UITextField alloc] init];
    nicknameTxf.borderStyle = UITextBorderStyleRoundedRect;
    nicknameTxf.clearButtonMode = UITextFieldViewModeWhileEditing;
    nicknameTxf.attributedPlaceholder = [[NSMutableAttributedString alloc] initWithString:@"请输入昵称" attributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor],NSFontAttributeName : [UIFont systemFontOfSize:15.0],NSForegroundColorAttributeName : RGB0X(0xffffff)}];
    nicknameTxf.font = [UIFont systemFontOfSize:15.0];
//    nicknameTxf.inputAccessoryView = [self addToolbar];
//    nicknameTxf.keyboardType = UIKeyboardTypeNumberPad;
    nicknameTxf.returnKeyType = UIReturnKeyDone;//变为搜索按钮
    nicknameTxf.delegate = self;//设置代理
    [self.view addSubview:nicknameTxf];
    _nicknameTxf = nicknameTxf;
    
    
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
    
    UITextField *passwordTxf = [[UITextField alloc] init];
    passwordTxf.borderStyle = UITextBorderStyleRoundedRect;
    passwordTxf.clearButtonMode = UITextFieldViewModeWhileEditing;
    passwordTxf.attributedPlaceholder = [[NSMutableAttributedString alloc] initWithString:@"请输入8-20位数字字母组合密码" attributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor],NSFontAttributeName : [UIFont systemFontOfSize:15.0],NSForegroundColorAttributeName : RGB0X(0xffffff)}];
    passwordTxf.textColor = RGB0X(0x000000);
    passwordTxf.font = [UIFont systemFontOfSize:15.0];
    passwordTxf.returnKeyType = UIReturnKeyDone;//变为搜索按钮
    passwordTxf.delegate = self;//设置代理
    [self.view addSubview:passwordTxf];
    _passwordTxf = passwordTxf;
    
    UITextField *rePasswordTxf = [[UITextField alloc] init];
    rePasswordTxf.borderStyle = UITextBorderStyleRoundedRect;
    rePasswordTxf.clearButtonMode = UITextFieldViewModeWhileEditing;
    rePasswordTxf.attributedPlaceholder = [[NSMutableAttributedString alloc] initWithString:@"请再次输入密码" attributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor],NSFontAttributeName : [UIFont systemFontOfSize:15.0],NSForegroundColorAttributeName : RGB0X(0xffffff)}];
    rePasswordTxf.textColor = RGB0X(0x000000);
    rePasswordTxf.font = [UIFont systemFontOfSize:15.0];
    rePasswordTxf.returnKeyType = UIReturnKeyDone;//变为搜索按钮
    rePasswordTxf.delegate = self;//设置代理
    [self.view addSubview:rePasswordTxf];
    _rePasswordTxf = rePasswordTxf;
    
    UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    registerBtn.layer.cornerRadius = 5.0;
    [registerBtn addTarget:self action:@selector(registerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    registerBtn.backgroundColor = HBRedColor;
    [registerBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    [self.view addSubview:registerBtn];
    
    
    [nicknameTxf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.top.equalTo(self.view).offset(20);
        make.width.mas_equalTo(kWidth-40);
        make.height.mas_equalTo(@45);
    }];
    
    [phoneTxf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.top.equalTo(nicknameTxf.mas_bottom).offset(15);
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
    
    [passwordTxf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.top.equalTo(verifyCodeTxf.mas_bottom).offset(15);
        make.width.equalTo(@(kWidth-40));
        make.height.equalTo(@45);
    }];
    
    [rePasswordTxf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.top.equalTo(passwordTxf.mas_bottom).offset(15);
        make.width.equalTo(@(kWidth-40));
        make.height.equalTo(@45);
    }];
    
    [registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.top.equalTo(rePasswordTxf.mas_bottom).offset(30);
        make.width.mas_equalTo(kWidth-40);
        make.height.equalTo(@45);
        
    }];
}

- (UIToolbar *)addToolbar
{
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

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    //将键盘弹出
    if (textField == self.passwordTxf ||textField == self.rePasswordTxf) {
        //整体上移
        //将视图上移计算好的偏移
        //    if(offset > 0) {
        [UIView animateWithDuration:0.2 animations:^{
            self.view.frame = CGRectMake(0.0f, 0, self.view.frame.size.width, self.view.frame.size.height);
        }];
    }
    
    NSLog(@"开始输入");
}



- (void) keyboardWillHide:(NSNotification *)notify {
    // 键盘动画时间
    double duration = [[notify.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    //视图下沉恢复原状
    [UIView animateWithDuration:duration animations:^{
        self.view.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height);
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [textField resignFirstResponder];
}

- (BOOL)textFieldDone {
    [self.phoneTxf resignFirstResponder];
    [self.verifyCodeTxf resignFirstResponder];
    return [self.phoneTxf resignFirstResponder];
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

//点击注册
- (void)registerBtnClick:(UIButton *)sender {
    if (self.nicknameTxf.text.length == 0) {
        [self showHint:@"昵称输入不能为空"];
        return;
    }else if (self.phoneTxf.text.length == 0){
        [self showHint:@"电话输入不能为空"];
        return;
    }else if (self.verifyCodeTxf.text.length == 0){
        [self showHint:@"验证码输入不能为空"];
        return;
    }else if (self.passwordTxf.text.length == 0){
        [self showHint:@"密码输入不能为空"];
        return;
    }else if (![self.passwordTxf.text isEqual:self.rePasswordTxf.text]){
        [self showHint:@"密码输入不一致"];
        return;
    }
    
    [HBApiTool PostRegisterWithNickname:self.nicknameTxf.text
                            phoneNumber:self.phoneTxf.text
                             verifyCode:self.verifyCodeTxf.text
                               password:self.passwordTxf.text
                                success:^(NSDictionary * _Nonnull dict) {
                                    NSNumber *boolnum = [dict objectForKey:@"success"];
                                    BOOL success = [boolnum boolValue];
                                    if (dict) {
                                        if (success == YES) {
                                            [self showHint:@"注册成功!"];
                                        }else if (success == NO){
                                            [self showHint:@"注册失败"];
                                        }
                                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                            [self.navigationController popViewControllerAnimated:YES];
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
