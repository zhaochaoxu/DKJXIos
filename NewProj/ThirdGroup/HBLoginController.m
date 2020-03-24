//
//  HBLoginController.m
//  NewProj
//
//  Created by 胡贝 on 2019/5/21.
//  Copyright © 2019年 胡贝. All rights reserved.
//

#import "HBLoginController.h"
#import "SmsButtonHandle.h"
#import "HBRegisterController.h"
#import "HBApiTool.h"
#import "HTSaveCachesFile.h"
#import <WXApi.h>

@interface HBLoginController ()<UIScrollViewDelegate,UITextFieldDelegate>

@property (nonatomic, weak) UIView *line;

@property (nonatomic, weak) UIScrollView *scrollView;

@property (nonatomic, weak) UITextField *phoneTxf;

@property (nonatomic, weak) UITextField *verifyCodeTxf;

@property (nonatomic, weak) UITextField *neww_phoneTxf;

@property (nonatomic, weak) UITextField *neww_passwordTxf;

@property (nonatomic, weak) UILabel *otherWaysL;

@property (nonatomic, weak) UIButton *wxBtn;

@end

@implementation HBLoginController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]]) {
        
    }else{
        self.otherWaysL.hidden = YES;
        self.wxBtn.hidden = YES;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self addNoticeForKeyboard];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(weiChatOK) name:@"weiChatOK" object:NULL];
//    [self initNoti];
    [self setupUI];
}

- (void)setupUI {
    self.title = @"登录";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = HBRedColor;
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    UIButton *leftbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftbutton setTitle:@"返回" forState:UIControlStateNormal];
    [leftbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [leftbutton addTarget:self action:@selector(clickbutton:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftbutton];
    
    
    
    
    NSArray *titltArr = @[@"手机快速登录",@"账号密码登录"];
    //创建两个按钮
    for (int i = 0; i < 2; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];

        [button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 100 +i;
        [button.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitle:titltArr[i] forState:UIControlStateNormal];
        [self.view addSubview:button];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset((kWidth/2)*i);
            make.top.equalTo(self.view).offset(20);
            make.width.equalTo(@(kWidth/2));
            make.height.equalTo(@40);
        }];
    }
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(kWidth/7.7, 57, kWidth/4.1, 3)];
    line.backgroundColor = HBRedColor;
    [self.view addSubview:line];
    _line = line;
    
    //scrollview
    UIScrollView *scrollView = [[UIScrollView alloc] init];
//    scrollView.frame= CGRectMake(0, 150, kWidth, 220);
//    scrollView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:scrollView];
    //设置scrollview属性
    scrollView.contentSize = CGSizeMake(2*kWidth, 180);
    scrollView.contentOffset = CGPointMake(kWidth, 0);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.delegate = self;
    scrollView.contentOffset = CGPointMake(0, 0); //赋值属性
    _scrollView = scrollView;
    
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line).offset(30);
        make.left.equalTo(self.view);
        make.width.mas_equalTo(kWidth);
        make.height.mas_equalTo(240);
    }];
    
    //第一页
    //创建label
    
    UITextField *phoneTxf = [[UITextField alloc] init];
    phoneTxf.borderStyle = UITextBorderStyleRoundedRect;
    phoneTxf.clearButtonMode = UITextFieldViewModeWhileEditing;
    phoneTxf.attributedPlaceholder = [[NSMutableAttributedString alloc] initWithString:@"请输入手机号" attributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor],NSFontAttributeName : [UIFont systemFontOfSize:15.0],NSForegroundColorAttributeName : RGB0X(0xffffff)}];
    phoneTxf.font = [UIFont systemFontOfSize:15.0];
    phoneTxf.inputAccessoryView = [self addToolbar];
    phoneTxf.keyboardType = UIKeyboardTypeNumberPad;
    phoneTxf.returnKeyType = UIReturnKeyDone;//变为搜索按钮
    phoneTxf.delegate = self;//设置代理
    [scrollView addSubview:phoneTxf];
    _phoneTxf = phoneTxf;
    
    UITextField *verifyCodeTxf = [[UITextField alloc] init];
    verifyCodeTxf.borderStyle = UITextBorderStyleRoundedRect;
    verifyCodeTxf.clearButtonMode = UITextFieldViewModeWhileEditing;
    verifyCodeTxf.attributedPlaceholder = [[NSMutableAttributedString alloc] initWithString:@"请输入验证码" attributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor],NSFontAttributeName : [UIFont systemFontOfSize:15.0],NSForegroundColorAttributeName : RGB0X(0xffffff)}];
    verifyCodeTxf.textColor = RGB0X(0x000000);
    verifyCodeTxf.font = [UIFont systemFontOfSize:15.0];
    verifyCodeTxf.returnKeyType = UIReturnKeyDone;//变为搜索按钮
    verifyCodeTxf.delegate = self;//设置代理
    [scrollView addSubview:verifyCodeTxf];
    _verifyCodeTxf = verifyCodeTxf;

    UIButton *verifyBtn = [[SmsButtonHandle sharedSmsBHandle] buttonWithFrame:CGRectZero title:@"获取中" action:@selector(clickVerifyBtn:) superVC:self];
    verifyBtn.layer.cornerRadius = 4.0;
    [verifyBtn addTarget:self action:@selector(clickVerifyBtn:) forControlEvents:UIControlEventTouchUpInside];
    verifyBtn.backgroundColor = HBRedColor;
    [verifyBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [verifyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [verifyBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [scrollView addSubview:verifyBtn];
    

    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.layer.cornerRadius = 4.0;
    [loginBtn addTarget:self action:@selector(clickLoginBtn:) forControlEvents:UIControlEventTouchUpInside];
    loginBtn.backgroundColor = HBRedColor;
    [loginBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [scrollView addSubview:loginBtn];
    
    UILabel *otherWaysL = [[UILabel alloc] init];
    otherWaysL.text = @"其他登录方式";
    otherWaysL.textColor = [UIColor grayColor];
    otherWaysL.numberOfLines = 0;
    otherWaysL.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:otherWaysL];
    _otherWaysL = otherWaysL;
    
    UIButton *wxBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    wxBtn.layer.cornerRadius = 25.0;
    [wxBtn addTarget:self action:@selector(wxLoginBtn:) forControlEvents:UIControlEventTouchUpInside];
    wxBtn.backgroundColor = HBRedColor;
    [wxBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [wxBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [wxBtn setTitle:@"wechat" forState:UIControlStateNormal];
    [wxBtn setImage:[UIImage imageNamed:@"weichat_normal"] forState:UIControlStateNormal];
    [self.view addSubview:wxBtn];
    _wxBtn = wxBtn;
    
    [phoneTxf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(scrollView).offset(20);
        make.top.equalTo(scrollView).offset(15);
        make.width.equalTo(@(kWidth-40));
        make.height.equalTo(@45);
    }];
    
    [verifyCodeTxf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(scrollView).offset(20);
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
    
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(scrollView).offset(20);
        make.top.equalTo(verifyCodeTxf.mas_bottom).offset(30);
        make.width.equalTo(@(kWidth-40));
        make.height.equalTo(@47);
    }];
    
    [otherWaysL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).offset(-110);
        //        make.width.equalTo(@(50));
        make.height.equalTo(@(50));
    }];
    
    
    [wxBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(otherWaysL).offset(50);
        make.width.equalTo(@(50));
        make.height.equalTo(@(50));
    }];
    
    //第二页
    UITextField *neww_phoneTxf = [[UITextField alloc] init];
    neww_phoneTxf.borderStyle = UITextBorderStyleRoundedRect;
    neww_phoneTxf.clearButtonMode = UITextFieldViewModeWhileEditing;
    neww_phoneTxf.attributedPlaceholder = [[NSMutableAttributedString alloc] initWithString:@"请输入手机号" attributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor],NSFontAttributeName : [UIFont systemFontOfSize:15.0],NSForegroundColorAttributeName : RGB0X(0xffffff)}];
    neww_phoneTxf.font = [UIFont systemFontOfSize:15.0];
    neww_phoneTxf.keyboardType = UIKeyboardTypeNumberPad;

    neww_phoneTxf.inputAccessoryView = [self addToolbar];
    neww_phoneTxf.returnKeyType = UIReturnKeyDone;//变为搜索按钮
    neww_phoneTxf.delegate = self;//设置代理
    [scrollView addSubview:neww_phoneTxf];
    _neww_phoneTxf = neww_phoneTxf;
    
    
    UITextField *neww_passwordTxf = [[UITextField alloc] init];
    neww_passwordTxf.borderStyle = UITextBorderStyleRoundedRect;
    neww_passwordTxf.secureTextEntry = YES;
    neww_passwordTxf.clearButtonMode = UITextFieldViewModeWhileEditing;
    neww_passwordTxf.attributedPlaceholder = [[NSMutableAttributedString alloc] initWithString:@"请输入密码" attributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor],NSFontAttributeName : [UIFont systemFontOfSize:15.0],NSForegroundColorAttributeName : RGB0X(0xffffff)}];
    neww_passwordTxf.font = [UIFont systemFontOfSize:15.0];
    neww_passwordTxf.returnKeyType = UIReturnKeyDone;//变为搜索按钮
    neww_passwordTxf.delegate = self;//设置代理
    [scrollView addSubview:neww_passwordTxf];
    _neww_passwordTxf = neww_passwordTxf;
    
    UIButton *new_loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    new_loginBtn.layer.cornerRadius = 4.0;
    [new_loginBtn addTarget:self action:@selector(new_clickLoginBtn:) forControlEvents:UIControlEventTouchUpInside];
    new_loginBtn.backgroundColor = HBRedColor;
    [new_loginBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [new_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [new_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [scrollView addSubview:new_loginBtn];
    
    UIButton *newUserRegisterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [newUserRegisterBtn addTarget:self action:@selector(newUserRegisterClick) forControlEvents:UIControlEventTouchUpInside];
//    newUserRegisterBtn.backgroundColor = HBRedColor;
    [newUserRegisterBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [newUserRegisterBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [newUserRegisterBtn setTitle:@"新用户注册" forState:UIControlStateNormal];
    [scrollView addSubview:newUserRegisterBtn];
    
    
    [neww_phoneTxf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(scrollView).offset(kWidth+20);
        make.top.equalTo(scrollView).offset(15);
        make.width.equalTo(@(kWidth-40));
        make.height.equalTo(@45);
    }];
    
    [neww_passwordTxf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(scrollView).offset(kWidth+20);
        make.top.equalTo(neww_phoneTxf.mas_bottom).offset(20);
        make.width.equalTo(@(kWidth-40));
        make.height.equalTo(@45);
    }];
    
    [new_loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(scrollView).offset(kWidth+ 20);
        make.top.equalTo(neww_passwordTxf.mas_bottom).offset(30);
        make.width.equalTo(@(kWidth-40));
        make.height.equalTo(@47);
    }];
    
    [newUserRegisterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(new_loginBtn.mas_right).offset(0);
        make.top.equalTo(new_loginBtn.mas_bottom).offset(10);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(30);
    }];
}

- (void)initNoti {
//    [[NSNotificationCenter defaultCenter] addObserver: self
//                                             selector: @selector(wechatLoginUserCancelled)
//                                                 name: @"NOTI_WXLOGIN_USERCANCELLED"
//                                               object: nil];
//
//    [[NSNotificationCenter defaultCenter] addObserver: self
//                                             selector: @selector(wechatLoginAuthorized:)
//                                                 name: @"NOTI_WXLOGIN_AUTHORIZED"
//                                               object: nil];
}

- (void)dealloc {

    [self removeNoti];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"weiChatOK" object:self];
}

- (void)removeNoti {
    [[NSNotificationCenter defaultCenter] removeObserver: self
                                                    name: @"NOTI_WXLOGIN_USERCANCELLED"
                                                  object: nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver: self
                                                    name: @"NOTI_WXLOGIN_AUTHORIZED"
                                                  object: nil];
}


#pragma mark - 键盘通知
- (void)addNoticeForKeyboard {
    
    //注册键盘出现的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    //注册键盘消失的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"滑动时执行的方法");
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    NSLog(@"手指离开scrollView时执行的方法");
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSLog(@"scrollView滑动结束后执行的方法");
}

//手机快速 --登录
- (void)clickLoginBtn:(UIButton *)sender {
    //首先是收起键盘
    [self.neww_phoneTxf resignFirstResponder];
    if (self.phoneTxf.text.length !=11) {
        [self showHint:@"手机号码不正确"];
        return;
    }else if (self.verifyCodeTxf.text.length == 0){
        [self showHint:@"验证码不能为空"];
        return;
    }
    
//    NSString *verifyCodet = self.verifyCodeTxf.text;
    [HBApiTool GetUserInfoWithTel:self.phoneTxf.text
                         password:@""
                        weChatUID:@""
                         weChatNO:@""
                              sex:@""
                          imgpath:@""
                         nickname:@""
                          msgCode:self.verifyCodeTxf.text
                          success:^(NSDictionary * _Nonnull dict) {
                              if (dict) {
                                  NSNumber *num = [dict objectForKey:@"success"];
                                  BOOL isS = [num boolValue];
                                  if (isS) {
                                      //保存到本地
                                      NSMutableDictionary * myHeader = [[NSMutableDictionary alloc] init];
                                      [myHeader setValue:[dict objectForKey:@"company"] forKey:@"company"];
                                      
                                      NSDictionary *dataDict = [dict objectForKey:@"data"];
                                      [myHeader addEntriesFromDictionary:dataDict];
                                      [HTSaveCachesFile saveDataList:myHeader fileName:@"HBUSER"];
                                      [self.view makeToast:@"登录成功"];
                                      
                                      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                          [self dismissViewControllerAnimated:YES completion:nil];
                                      });
                                  }else{
                                      [self.view makeToast:[dict objectForKey:@"msg"]];
                                  }
                                  
                                  
                              }
                          } failure:^(NSError * _Nonnull error) {
                              
                          }];
}

- (void)new_clickLoginBtn:(UIButton *)sender {
    
    //首先是收起键盘
    [self.neww_phoneTxf resignFirstResponder];
    //账号密码登录
    if (self.neww_phoneTxf.text.length == 0) {
        [self showHint:@"手机号不能为空"];
        return;
    }else if (self.neww_passwordTxf.text.length == 0){
        [self showHint:@"密码不能为空"];
        return;
    }
    
    [HBApiTool GetUserInfoWithTel:self.neww_phoneTxf.text
                         password:self.neww_passwordTxf.text
                        weChatUID:@""
                         weChatNO:@""
                              sex:@""
                          imgpath:@""
                         nickname:@""
                          msgCode:@""
                          success:^(NSDictionary * _Nonnull dict) {
                              if (dict) {
                                  NSNumber *num = [dict objectForKey:@"success"];
                                  BOOL isS = [num boolValue];
                                  if (isS) {
                                      //保存到本地
                                      NSMutableDictionary * myHeader = [[NSMutableDictionary alloc] init];
                                      [myHeader setValue:[dict objectForKey:@"company"] forKey:@"company"];
                                      
                                      NSDictionary *dataDict = [dict objectForKey:@"data"];
                                      [myHeader addEntriesFromDictionary:dataDict];
                                      [HTSaveCachesFile saveDataList:myHeader fileName:@"HBUSER"];
                                      [self.view makeToast:@"登录成功"];
                                      
                                      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                          [self dismissViewControllerAnimated:YES completion:nil];
                                      });
                                  }else{
                                      [self.view makeToast:[dict objectForKey:@"msg"]];
                                  }

                                  
                              }
                          } failure:^(NSError * _Nonnull error) {
                              
                          }];
}


- (void)click:(UIButton *)sender {

    if (sender.tag == 100) {
        [UIView animateWithDuration:0.2 animations:^{
            self.line.frame = CGRectMake(kWidth/7.7, 57, kWidth/4.1, 3);
            self.scrollView.contentOffset = CGPointMake(0, 0);
        }];
    }else if (sender.tag == 101){
        [UIView animateWithDuration:0.2 animations:^{
            self.line.frame = CGRectMake(kWidth/7.7+kWidth/2, 57, kWidth/4.1, 3);
            self.scrollView.contentOffset = CGPointMake(kWidth, 0);

        }];

    }
}

- (void)clickVerifyBtn:(UIButton *)sender {
    [self.phoneTxf resignFirstResponder];
    
    if (self.phoneTxf.text.length != 11) {
        [self showHint:@"手机号不正确"];
        return;
    }
    [[SmsButtonHandle sharedSmsBHandle] startTimer];
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

- (void)clickbutton:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)newUserRegisterClick {
    HBRegisterController *registerVc = [[HBRegisterController alloc] init];
    [self.navigationController pushViewController:registerVc animated:YES];
}

//微信登录
- (void)wxLoginBtn:(UIButton *)sender {
    if ([WXApi isWXAppInstalled]) {

        
        

        SendAuthReq *req = [[SendAuthReq alloc] init];
        req.state = @"wx_oauth_authorization_state";//用于保持请求和回调的状态，授权请求或原样带回
        req.scope = @"snsapi_userinfo";//授权作用域：获取用户个人信息
        req.openID = @"wxefefa4067b6d2ad0";
        //唤起微信
        
        BOOL isSuccess = [WXApi sendReq:req];
        
    }
}

///键盘显示事件
- (void) keyboardWillShow:(NSNotification *)notification {
    //获取键盘高度，在不同设备上，以及中英文下是不同的
    CGFloat kbHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    //计算出键盘顶端到inputTextView panel底端的距离(加上自定义的缓冲距离INTERVAL_KEYBOARD)
    CGFloat offset = (self.verifyCodeTxf.frame.origin.y+self.verifyCodeTxf.frame.size.height+INTERVAL_KEYBOARD) - (self.view.frame.size.height - kbHeight);
    
    
    // 取得键盘的动画时间，这样可以在视图上移的时候更连贯
    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    //将视图上移计算好的偏移
//    if(offset > 0) {
        [UIView animateWithDuration:duration animations:^{
            self.view.frame = CGRectMake(0.0f, 0, self.view.frame.size.width, self.view.frame.size.height);
        }];
//    }
}

///键盘消失事件
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

- (BOOL)textFieldDone{
    [self.neww_phoneTxf resignFirstResponder];
    return [self.phoneTxf resignFirstResponder];
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

- (void)weiChatOK{//第三方登录
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSDictionary *weChatDic = [defaults objectForKey:@"userinfo"];
    

    
    //判断三方登录是否手机认证接口(这里就按照需求走了)
//    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:3];
//    [parameters setValue:@"3" forKey:@"type"];
//    [parameters setValue:weChatDic[@"openid"] forKey:@"id"];
//    [parameters setValue:weChatDic[@"token"] forKey:@"token"];
    
    
    

    [HBApiTool GetUserInfoWithTel:@""
                         password:@""
                        weChatUID:weChatDic[@"unionid"]
                         weChatNO:@""
                              sex:[weChatDic[@"sex"] stringValue]
                          imgpath:weChatDic[@"headimgurl"]
                         nickname:weChatDic[@"nickname"]
                          msgCode:@""
                          success:^(NSDictionary * _Nonnull dict) {
                              if (dict) {
                                  //保存到本地
                                  NSMutableDictionary * myHeader = [[NSMutableDictionary alloc] init];
                                  [myHeader setValue:[dict objectForKey:@"company"] forKey:@"company"];
                                  
                                  NSDictionary *dataDict = [dict objectForKey:@"data"];
                                  [myHeader addEntriesFromDictionary:dataDict];
                                  [HTSaveCachesFile saveDataList:myHeader fileName:@"HBUSER"];
                                  [self.view makeToast:@"登录成功"];
                                  
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
