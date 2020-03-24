//
//  RYUtils.h
//  HRRongYaoApp
//
//  Created by fabs on 2017/4/10.
//  Copyright © 2017年 fabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface RYUtils : NSObject

#pragma mark - UIDevice Methods
/**
 *  @brief  获取屏幕比例.以4.7寸屏为准.
 */
+ (CGFloat)screenScale;

/**
 *  @brief  获取当前版本.
 */
+ (NSString *)version;

/**
 *  @brief  获取手机型号
 */
+ (NSString *)platformString;

/**
 *  @brief  获取手机剩余空间
 */
+ (int64_t)freeDiskspaceSize;
#pragma mark -

#pragma mark - NSString Methods

/**
 *  @brief  创建支付Toast标题
 */
+ (NSString *)creatPayTitleWithPrice:(NSString *)price
                                type:(NSString *)type;

/**
 *  @brief  md5
 */
+ (NSString *)md5StringWithData:(NSData *)data;

/**
 *  @brief  过滤敏感词汇
 */
+ (NSString *)filteringSensitiveWords:(NSString *)string;

/**
 *  @brief  判断是否是空字符传
 */
+ (BOOL)isEmptyString:(NSString *)string;

/**
 *  @brief  验证是否是手机号码
 */
+ (BOOL)isTelPhoneWithString:(NSString *)string;

/**
 *  @brief  验证是否是密码
 */
+ (BOOL)isPasswordWithString:(NSString *)string;

/**
 *  @brief  验证是否是邮箱
 */
+ (BOOL)isEmallWithString:(NSString *)string;

/**
 *  @brief  计算文字大小
 */
+ (CGSize)boundingRectWithString:(NSString *)string
                            size:(CGSize)size
                      attributes:(NSDictionary *)attributes;
#pragma mark -

#pragma mark - NSAttributedString Methods
+ (NSMutableParagraphStyle *)paragraphStyleWithLineSpacing:(CGFloat)lineSpacing lineBreakModel:(NSLineBreakMode)lineBreakModel;

+ (NSMutableAttributedString *)attributedString:(NSString *)string
                                    font:(UIFont *)font;

+ (NSMutableAttributedString *)attributedString:(NSString *)string
                              attributes:(NSDictionary *)attributes;
#pragma mark -

#pragma mark - UIImage Methods
/**
 *  @brief  默认展位图
 */
+ (UIImage *)placeholderImage;

/**
 *  @brief  截屏
 */
+ (UIImage *)captureScreenImage;

/**
 *  @brief  修改图片颜色
 */
+ (UIImage *)replaceImageColor:(UIColor *)color image:(UIImage *)image;

/**
 *  @brief  修正图片方向
 */
+ (UIImage *)fixedImageOrientation:(UIImage *)image;

/**
 *  @brief  修改上传的图片
 */
+ (void)fixedUploadImages:(UIImage *)image
               completion:(void(^)(NSData *data, NSString *fileName, NSString *mimeType))completion;

/**
 *  @brief  16进制转RGB
 */
+ (UIColor *)colorWithHexString:(NSString *)color;
#pragma mark -

#pragma mark - NSDate Methods
/**
 *  @brief  获取NSDateFormatter
 */
+ (NSDateFormatter *)formatterWithFormat:(NSString *)format;
/**
 *  @brief  获取本地UTC时间
 */
+ (NSDate *)UTCDate:(NSDate *)date;

/**
 *  @brief  时间撮转日期字符串. yyyy-MM-dd HH:mm:ss.
 */
+ (NSString *)dateStringFormUnix:(NSTimeInterval)unix;

/**
 *  @brief  时间撮转指定日期字符串.
 */
+ (NSString *)dateStringFormUnix:(NSTimeInterval)unix format:(NSString *)format;

/**
 *  @brief  把YYYY-MM-dd HH:mm:ss 转换成YYYY-MM-dd HH:mm
 */
+ (NSString *)missingSecondsFromString:(NSString *)string;

/**
 *  @brief  秒数转换成mm:ss
 */
+ (NSString *)dateStringFormSeconds:(NSString *)seconds;

/**
 *  @brief  mm:ss字符串转换成时间
 */
+ (NSInteger)seekTimeFormString:(NSString *)string;
#pragma mark -

+ (void)isCanEnterLiveOrVideoWithFreeType:(NSInteger)freeType
                                    isBuy:(BOOL)isBuy
                                    enter:(void(^)(BOOL isCanEnter))enter
                                    error:(void(^)(NSString *message))error;

/**
 *  @brief  转换关注数量
 */
+ (NSString *)conversionFansNumWithString:(NSString *)string;

/**
 *  @brief  验证输入的文字是否有效.字母/数字/中文.
 */
+ (BOOL)stringIsEffective:(NSString *)string length:(NSInteger)length;

/**
 *  @brief  生成分享二维码String
 */
+ (NSString *)shareQrCodeString;

@end


@interface UIView (NSIndexPath_Category)

@property (copy, nonatomic) NSIndexPath *indexPath;

@end
