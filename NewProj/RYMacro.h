//
//  RYMacro.h
//  HRRongYaoApp
//
//  Created by fabs on 2017/4/10.
//  Copyright © 2017年 fabs. All rights reserved.
//

#ifndef RYMacro_h
#define RYMacro_h

// status bar height.
#define kStatusBarHeight    (IS_iPhoneX ? 44.f : 20.f)
// Navigation bar height.
#define kNavigationBarHeight    44.f
// Tabbar height.
#define kTabbarHeight        (IS_iPhoneX ? (49.f+34.f) : 49.f)
// Tabbar safe bottom margin.
#define kTabbarSafeBottomMargin        (IS_iPhoneX ? 34.f : 0.f)
#define kStatusBarHeight      (IS_iPhoneX ? 44.f : 20.f)
// Status bar & navigation bar height.
#define kStatusBarAndNavigationBarHeight  (IS_iPhoneX ? 88.f : 64.f)
#define IS_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)



//常用
#define kWidth  [UIScreen mainScreen].bounds.size.width
#define KHeight  [UIScreen mainScreen].bounds.size.height
#define KHeightS   ([UIScreen mainScreen].bounds.size.height-64)
#define KHeightL  ([UIScreen mainScreen].bounds.size.height-64-49)



#define RGB(r,g,b)          [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define RGBA(r,g,b,a)       [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)/255.0]
#define RGB0X(rgbValue)     [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define kWEAK_SELF      __weak typeof(self)weak_self = self
#define kSTRONG_SELF    __strong typeof(weak_self)strong_self = weak_self;\
if (!strong_self) {\
return ;\
}

#ifndef RYSafeBlock
#define RYSafeBlock(block,value)\
if (block) {\
block(value);\
}
#endif


#define RYBackgroundColor       RGB0X(0xf0f0f0) // 统一背景颜色
#define RYNavigationBarColor    RGB0X(0xea1c27) // 统一导航栏颜色
#define RYLineColor             RGB0X(0xe5e5e5) // 统一线条颜色
#define HBRedColor              HWColor(182, 34, 38)
#define HBBackColor             HWColor(222, 222, 222)

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
#define HWColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

#pragma mark - -------------------- UIScreen ------------------
#define RYBounds     [UIScreen mainScreen].bounds
#define RYWidth      [UIScreen mainScreen].bounds.size.width
#define RYHeight     [UIScreen mainScreen].bounds.size.height

#define RYScreenScale  RYWidth/375.0

#define INTERVAL_KEYBOARD  20.0

#define  KEY_USERNAME_PASSWORD @"com.company.app.usernamepassword"
#define  KEY_USERNAME @"com.company.app.username"
#define  KEY_PASSWORD @"com.company.app.password"

#endif /* RYMacro_h */
