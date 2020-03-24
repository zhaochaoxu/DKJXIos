//
//  AppDelegate.m
//  NewProj
//
//  Created by 胡贝 on 2019/3/6.
//  Copyright © 2019年 胡贝. All rights reserved.
//

#import "AppDelegate.h"

#import "HBSecondViewController.h"
#import "HBThirdController.h"
#import "HBFourthController.h"
#import "HBMenuListController.h"
//#import "WXApiManager.h"






@interface AppDelegate ()<WXApiDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [WXApi registerApp:@"wxefefa4067b6d2ad0"];

    
    //    [self IQKeyBoardFunc];
    [[UITabBar appearance] setTranslucent:NO];
    UITabBarController *tabbarController = [[UITabBarController alloc] init];
    
    HBMenuListController *firstVc = [[HBMenuListController alloc] init];
    firstVc.tabBarItem.title = @"招牌菜";
    firstVc.tabBarItem.image = [[UIImage imageNamed:@"ic_sign_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    firstVc.tabBarItem.selectedImage = [[UIImage imageNamed:@"ic_sign_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    firstVc.hidesBottomBarWhenPushed = NO;
    
    UINavigationController *firstNav = [[UINavigationController alloc] initWithRootViewController:firstVc];
    
    HBSecondViewController *secondVc = [[HBSecondViewController alloc] init];
    secondVc.tabBarItem.title = @"";
    
    secondVc.tabBarItem.image = [[UIImage imageNamed:@"ic_code"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    secondVc.tabBarItem.selectedImage = [[UIImage imageNamed:@"ic_code"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    secondVc.hidesBottomBarWhenPushed = NO;
    
    UINavigationController *secondNav = [[UINavigationController alloc] initWithRootViewController:secondVc];
    
    HBThirdController *thirdVc = [[HBThirdController alloc] init];
    thirdVc.tabBarItem.title = @"我的";
    thirdVc.tabBarItem.image = [[UIImage imageNamed:@"ic_me_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    thirdVc.tabBarItem.selectedImage = [[UIImage imageNamed:@"ic_me_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    thirdVc.hidesBottomBarWhenPushed = NO;
    
    UINavigationController *thirdNav = [[UINavigationController alloc] initWithRootViewController:thirdVc];

    
    
    
//    tabbarController.tabBar.tintColor = [UIColor cyanColor];
    tabbarController.tabBar.barTintColor = [UIColor whiteColor];
    tabbarController.viewControllers = @[firstNav,secondNav,thirdNav];
    self.window.rootViewController = tabbarController;
    self.window.backgroundColor = [UIColor whiteColor];
    
    

    [self.window makeKeyAndVisible];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    
    return [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {

    return  [WXApi handleOpenURL:url delegate:self];
}


- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    
   
    return  [WXApi handleOpenURL:url delegate:self];
}

#pragma mark - WXApiDelegate


//微信回调代理
- (void)onResp:(BaseResp *)resp{
    
    // =============== 获得的微信登录授权回调 ============
    if ([resp isMemberOfClass:[SendAuthResp class]])  {
        NSLog(@"******************获得的微信登录授权******************");
        
        SendAuthResp *aresp = (SendAuthResp *)resp;
        if (aresp.errCode != 0 ) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.window makeToast:@"微信授权失败"];
            });
            return;
        }
        //授权成功获取 OpenId
        NSString *code = aresp.code;
        [self getWeiXinOpenId:code];
    }
    // =============== 获得的微信支付回调 ============
    
    //微信支付的类
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        NSString *strMsg,*strTitle = [NSString stringWithFormat:@"支付结果"];
        if (resp.errCode == 0) {
            strMsg = @"支付结果：成功！";
            NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
            
            // 发通知带出支付成功结果
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ZLWXReturnSucceedPayNotification" object:resp];
            
//            PaySucceedViewController *vc = [[PaySucceedViewController alloc] init];
//            vc.backStr = @"1";
//            UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:vc];
//            AppDelegate *appDelegate =
//            (AppDelegate *)[[UIApplication sharedApplication] delegate];
//            [appDelegate.window.rootViewController presentViewController:navi animated:NO completion:nil];
        }else{
            strMsg = [NSString stringWithFormat:@"支付结果：失败！"];
            NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ZLWXReturnFailedPayNotification" object:resp];
//            PayFailedViewController *vc = [[PayFailedViewController alloc] init];
//            vc.backStr = @"1";
//            UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:vc];
//            AppDelegate *appDelegate =
//            (AppDelegate *)[[UIApplication sharedApplication] delegate];
//            [appDelegate.window.rootViewController presentViewController:navi animated:NO completion:nil];
        }
        
 
    }
    
    
}

//通过code获取access_token，openid，unionid
- (void)getWeiXinOpenId:(NSString *)code{
    /*
     appid    是    应用唯一标识，在微信开放平台提交应用审核通过后获得
     secret    是    应用密钥AppSecret，在微信开放平台提交应用审核通过后获得
     code    是    填写第一步获取的code参数
     grant_type    是    填authorization_code
     */
    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",@"wxefefa4067b6d2ad0",@"ca41252add66ba416d012fecdc3cc364",code];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data1 = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        
        if (!data1) {
            [self.window makeToast:@"微信授权失败"];
            return ;
        }
        
        // 授权成功，获取token、openID字典
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data1 options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"token、openID字典===%@",dic);
        NSString *access_token = dic[@"access_token"];
        NSString *openid= dic[@"openid"];
        
        //         获取微信用户信息
        [self getUserInfoWithAccessToken:access_token WithOpenid:openid];
        
    });
}

- (void)getUserInfoWithAccessToken:(NSString *)access_token WithOpenid:(NSString *)openid
{
    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",access_token,openid];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            // 获取用户信息失败
            if (!data) {
                [self.window makeToast:@"微信授权失败"];
                return ;
            }
            
            // 获取用户信息字典
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            //用户信息中没有access_token 我将其添加在字典中
            [dic setValue:access_token forKey:@"token"];
            NSLog(@"用户信息字典:===%@",dic);
            //保存改用户信息(我用单例保存)
            NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
            [defaults setObject:dic forKey:@"userinfo"];
//            [GLUserManager shareManager].weiXinIfon = dic;
            //微信返回信息后,会跳到登录页面,添加通知进行其他逻辑操作
            [[NSNotificationCenter defaultCenter] postNotificationName:@"weiChatOK" object:nil];
            
        });
        
    });
    
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
