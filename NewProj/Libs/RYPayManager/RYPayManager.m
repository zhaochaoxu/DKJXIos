//
//  RYPayManager.m
//  HRRongYaoApp
//
//  Created by fabs on 2017/4/11.
//  Copyright © 2017年 fabs. All rights reserved.
//

#import "RYPayManager.h"
#import <StoreKit/StoreKit.h>
#import <AlipaySDK/AlipaySDK.h>
#import <WXApi.h>

static NSString *const APPSchemes = @"com.risenb.ryjz";

@interface RYPayManager ()<SKProductsRequestDelegate,SKPaymentTransactionObserver>

@property (copy, nonatomic) void (^paySuccessBlock)(RYPaySuccessItem *item);

@property (copy, nonatomic) void (^payFailerBlock)(NSString *erroeMessage);

@property (copy, nonatomic) void (^payCallBlock)(NSDictionary *result);

@property (assign, nonatomic) RYPayType payType;

@property (strong, nonatomic) NSURLSessionDataTask *task;

@property (copy, nonatomic) NSString *orderNo;

@end

@implementation RYPayManager

- (void)dealloc {
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    RYSafeCancleTask(self.task);
}

+ (instancetype)shareInstance {
    static RYPayManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!manager) {
            manager = [[[self class] alloc] init];
        }
    });
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        [self initNotification];
    }
    return self;
}

- (void)initNotification {
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(didReceiveXYPayResultNotification:) name:RYPaySuccessNotification object:nil];
}

- (void)didReceiveXYPayResultNotification:(NSNotification *)notification {
    NSDictionary *reslut = notification.object;
    switch (self.payType) {
        case RYPayTypeAliPay:{
            NSInteger resultStatus = [[reslut objectForKey:@"resultStatus"] integerValue];
            if (resultStatus == 9000) {
                kXYSafeBlock(self.paySuccessBlock, nil);
                kXYSafeBlock(self.payCallBlock, nil);
            } else if (resultStatus == 8000) {
                kXYSafeBlock(self.payFailerBlock, @"正在处理中，支付结果未知,请查询商户订单列表中订单的支付状态");
            } else if (resultStatus == 4000) {
                kXYSafeBlock(self.payFailerBlock, @"订单支付失败");
            } else if (resultStatus == 6001) {
                kXYSafeBlock(self.payFailerBlock, @"订单支付已取消");
            } else if (resultStatus == 6002) {
                kXYSafeBlock(self.payFailerBlock, RYNetworkError);
            } else if (resultStatus == 6004) {
                kXYSafeBlock(self.payFailerBlock, @"支付结果未知,请查询商户订单列表中订单的支付状态");
            } else {
                kXYSafeBlock(self.payFailerBlock, @"订单支付失败");
            }
        }break;
        case RYPayTypeWeiXin:{
            NSInteger resultCode = [[reslut objectForKey:@"result"] integerValue];
            switch (resultCode) {
                case WXSuccess:{
                    kXYSafeBlock(self.paySuccessBlock, nil);
                    kXYSafeBlock(self.payCallBlock, nil);
                }break;
                case WXErrCodeCommon:{
                    kXYSafeBlock(self.payFailerBlock, @"订单支付失败");
                }break;
                case WXErrCodeUserCancel:{
                    kXYSafeBlock(self.payFailerBlock, @"订单支付已取消");
                }break;
                case WXErrCodeSentFail:{
                    kXYSafeBlock(self.payFailerBlock, @"订单支付失败");
                }break;
                case WXErrCodeAuthDeny:{
                    kXYSafeBlock(self.payFailerBlock, @"订单支付授权失败");
                }break;
                case WXErrCodeUnsupport:{
                    kXYSafeBlock(self.payFailerBlock, @"不支持的订单");
                }break;
            }
        }break;
        case RYPayTypeWallet:{
        
        }break;
        case RYPayTypeApplePay:{
            NSString *diamond = [NSString stringWithFormat:@"%@",[reslut objectForKey:@"diamond"]];
            NSString *balance = [NSString stringWithFormat:@"%@",[reslut objectForKey:@"balance"]];
            [RYUserInfo addValue:diamond forKey:@"honourDiamonds"];
            [RYUserInfo addValue:balance forKey:@"honourBalance"];
            RYSafeBlock(self.payCallBlock, nil);
        }break;
        default:
            break;
    }
}

- (void)startPayWithOrderInfo:(NSDictionary *)orderInfo
                      payType:(RYPayType)payType
                      success:(void (^)(RYPaySuccessItem *))success
                       failer:(void (^)(NSString *))failer
                     callBack:(void (^)(NSDictionary *))callBack {
    self.payType = payType;
    self.paySuccessBlock = [success copy];
    self.payFailerBlock = [failer copy];
    self.payCallBlock = [callBack copy];
    switch (payType) {
        case RYPayTypeApplePay:{
            [self applePayWithOrderInfo:orderInfo];
        }break;
        case RYPayTypeAliPay:{
            [self aliPayWithOrderInfo:orderInfo];
        }break;
        case RYPayTypeWeiXin:{
            [self weixinPayWithOrderInfo:orderInfo];
        }break;
        case RYPayTypeWallet:{
        
        }break;
    }
}


- (void)aliPayWithOrderInfo:(NSDictionary *)orderInfo {
    NSString *order = [orderInfo objectForKey:@"sign"];
    [[AlipaySDK defaultService] payOrder:order fromScheme:APPSchemes callback:^(NSDictionary *resultDic) {
        NSNotification *notification = [NSNotification notificationWithName:RYPaySuccessNotification object:resultDic];
        [self didReceiveXYPayResultNotification:notification];
    }];
}

- (void)weixinPayWithOrderInfo:(NSDictionary *)orderInfo {
    if (![WXApi isWXAppInstalled]) {
        kXYSafeBlock(self.payFailerBlock, @"未安装微信");
        return;
    }
    NSDictionary *params = [orderInfo objectForKey:@"sign"];
    NSString *timestamp = [NSString stringWithFormat:@"%@",[params objectForKey:@"timestamp"]];
    
    PayReq* req             = [[PayReq alloc] init];
    req.partnerId           = [params objectForKey:@"partnerid"];
    req.prepayId            = [params objectForKey:@"prepayid"];
    req.nonceStr            = [params objectForKey:@"noncestr"];
    req.timeStamp           = timestamp.intValue;
    req.package             = [params objectForKey:@"package"];
    req.sign                = [params objectForKey:@"sign"];
    [WXApi sendReq:req];
}

- (void)applePayWithOrderInfo:(NSDictionary *)orderInfo {
    if ([SKPaymentQueue canMakePayments]) {
        RYSVProgressHUDShow();
        self.orderNo = [orderInfo objectForKey:@"orderno"];
        NSString *productId = [orderInfo objectForKey:@"goodid"];
        NSSet *set = [NSSet setWithArray:@[productId]];
        SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:set];
        request.delegate = self;
        [request start];
    } else {
        RYSafeBlock(self.payFailerBlock,@"不支持苹果支付");
    }
}


#pragma mark - SKProductsRequestDelegate Methods
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    RYSVProgressHUDDismiss();
    if (response.products.count <= 0) {
        RYSafeBlock(self.payFailerBlock, @"商品不存在");
        return;
    }
    [[SKPaymentQueue defaultQueue] addPayment:[SKPayment paymentWithProduct:response.products.firstObject]];
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"SKProductsRequest error = %@",error);
    RYSafeBlock(self.payFailerBlock, error.localizedFailureReason);
}
#pragma mark -

#pragma mark - SKPaymentTransactionObserver Methods
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions {
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchased:{
                // 购买成功
                [self completeTransaction:transaction];
            }break;
            case SKPaymentTransactionStateRestored:{
                // 已经购买
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                RYSafeBlock(self.payFailerBlock, @"您已经购买过该商品");
            }break;
            case SKPaymentTransactionStatePurchasing:{
                // 商品添加进列表  继续锁定屏幕
            }break;
            case SKPaymentTransactionStateFailed:{
                // 购买失败
                [self failedTransaction:transaction];
            }break;
            default:
                break;
        }
    }
}
#pragma mark - 


- (void)completeTransaction:(SKPaymentTransaction *)transaction {
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    NSString * productIdentifier = transaction.payment.productIdentifier;
    //    NSString * receipt = [transaction.transactionReceipt base64EncodedString];
    if ([productIdentifier length] > 0) {
        // 向自己的服务器验证购买凭证
        [self sendAppleHandlerRequestWithOrderNo:self.orderNo];
    }
    RYSafeBlock(self.paySuccessBlock, nil);
}

- (void)failedTransaction:(SKPaymentTransaction *)transaction {
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    if(transaction.error.code != SKErrorPaymentCancelled) {
        RYSafeBlock(self.payFailerBlock, @"购买失败");
    } else {
        RYSafeBlock(self.payFailerBlock, @"取消购买");
    }
}
#pragma mark - 

- (void)sendAppleHandlerRequestWithOrderNo:(NSString *)orderNo {
    RYSafeCancleTask(self.task);
    NSDictionary *params = @{@"orderno":orderNo};
    kWEWK_SELF;
    self.task = [[XYHTTPRequestManager shareInstance] POST:API_Order_ApplePay_CallBack parameters:params progress:nil success:^(XYResponseObject *responseObject) {
        kSTRONG_SELF;
        if (responseObject.status == XYRequestStatusSuccessed) {
            NSNotification *notification = [NSNotification notificationWithName:RYPaySuccessNotification object:responseObject.data];
            [strong_self didReceiveXYPayResultNotification:notification];
        }else{
            RYSafeBlock(strong_self.payFailerBlock, responseObject.errorMsg);
        }
    } failure:^(NSError *error) {
        kSTRONG_SELF;
        if (error.code != NSURLErrorCancelled) {
            RYSafeBlock(strong_self.payFailerBlock, error.localizedFailureReason);
        }
    }];
}

@end


@implementation RYPaySuccessItem


@end
