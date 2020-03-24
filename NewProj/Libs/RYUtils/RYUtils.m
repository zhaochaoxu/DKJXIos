//
//  RYUtils.m
//  HRRongYaoApp
//
//  Created by fabs on 2017/4/10.
//  Copyright © 2017年 fabs. All rights reserved.
//

#import "RYUtils.h"
#import <sys/sysctl.h>
#import <objc/runtime.h>
#import <CommonCrypto/CommonCrypto.h>

@implementation RYUtils

+ (CGFloat)screenScale {
    return CGRectGetWidth([UIScreen mainScreen].bounds) / 375.0;
}

+ (NSString *)version {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

+ (NSString *)platformString {
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    return platform;
}

+ (int64_t)freeDiskspaceSize {
    NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[paths lastObject] error: &error];
    if (!error && dictionary) {
//        NSNumber *fileSystemSizeInBytes = [dictionary objectForKey: NSFileSystemSize];
        NSNumber *freeFileSystemSizeInBytes = [dictionary objectForKey:NSFileSystemFreeSize];
        return freeFileSystemSizeInBytes.longLongValue;
    }
    return 0.0;
}

+ (NSString *)creatPayTitleWithPrice:(NSString *)price
                                type:(NSString *)type {
    return [NSString stringWithFormat:@"抱歉,您需支付%@元才可%@\n请您选择以下方式支付",price,type];
}

+ (NSString *)md5StringWithData:(NSData *)data {
    const char *cstr = [data bytes];
    unsigned char result[CC_MD2_DIGEST_LENGTH];
    CC_MD5(cstr, (CC_LONG)[data length], result);
    NSString *md5 = @"";
    for (NSInteger i = 0; i < CC_MD2_DIGEST_LENGTH; i++) {
        md5 = [md5 stringByAppendingString:[NSString stringWithFormat:@"%02X",result[i]]];
    }
    return [md5 uppercaseString];
}

+ (NSString *)filteringSensitiveWords:(NSString *)string {
    __block NSString *resultString = [string copy];
    NSArray *keyWorlds = [[NSUserDefaults standardUserDefaults] objectForKey:RYSensitiveWordsKey];
    [keyWorlds enumerateObjectsUsingBlock:^(NSString *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([resultString rangeOfString:obj].length != NSNotFound) {
            NSString *cString = @"";
            for (NSInteger i = 0; i < obj.length; i++) {
                cString = [cString stringByAppendingString:@"*"];
            }
            resultString = [resultString stringByReplacingOccurrencesOfString:obj withString:cString];
        }
    }];
    return resultString;
}

+ (BOOL)isEmptyString:(NSString *)string {
    if ([string isEqualToString:@"(null)"] || [string isKindOfClass:[NSNull class]] || !string) {
        return YES;
    }
    if ([string isKindOfClass:[NSString class]]) {
        return (string.length == 0);
    }
    return NO;
}

+ (BOOL)isTelPhoneWithString:(NSString *)string {
    NSString *MOBILE = @"^1(3[0-9]|4[579]|5[0-35-9]|7[0135-8]|8[0-9])\\d{8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    return [regextestmobile evaluateWithObject:string];
}

+ (BOOL)isPasswordWithString:(NSString *)string {
    NSString *      regex = @"(^[A-Za-z0-9]{6,20}$)";
    NSPredicate *   pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:string];
}

+ (BOOL)isEmallWithString:(NSString *)string {
    NSString *      regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *   pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:string];
}

+ (CGSize)boundingRectWithString:(NSString *)string size:(CGSize)size attributes:(NSDictionary *)attributes {
    return [string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:NULL].size;
}

+ (NSMutableParagraphStyle *)paragraphStyleWithLineSpacing:(CGFloat)lineSpacing lineBreakModel:(NSLineBreakMode)lineBreakModel {
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineBreakMode = lineBreakModel;
    style.lineSpacing = lineSpacing;
    return style;
}

+ (NSMutableAttributedString *)attributedString:(NSString *)string
                                    font:(UIFont *)font {
    return [RYUtils attributedString:string attributes:@{NSFontAttributeName:font}];
}

+ (NSMutableAttributedString *)attributedString:(NSString *)string
                              attributes:(NSDictionary *)attributes {
    if ([RYUtils isEmptyString:string]) {
        return [[NSMutableAttributedString alloc] initWithString:@""];
    }
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string attributes:attributes];
    return attributedString;
}

+ (UIImage *)placeholderImage {
    return RYNormalImage();
}

+ (UIImage *)captureScreenImage {
    UIView *view = [[UIApplication sharedApplication] topViewController].view;
    UIGraphicsBeginImageContextWithOptions([UIScreen mainScreen].bounds.size, view.opaque, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)replaceImageColor:(UIColor *)color image:(UIImage *)image {
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, image.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    CGContextClipToMask(context, rect, image.CGImage);
    [color setFill];
    CGContextFillRect(context, rect);
    UIImage*newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (UIImage *)fixedImageOrientation:(UIImage *)image {
    if (image.imageOrientation == UIImageOrientationUp) return image;
    
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    [image drawInRect:(CGRect){0, 0, image.size}];
    UIImage *normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return normalizedImage;
}

+ (void)fixedUploadImages:(UIImage *)image
               completion:(void(^)(NSData *data, NSString *fileName, NSString *mimeType))completion {
    image = [RYUtils fixedImageOrientation:image];
    NSData *data = UIImagePNGRepresentation(image);
    NSString *fileName = [NSString stringWithFormat:@"%@.png",[RYUtils md5StringWithData:data]];
    NSString *mimetype = @"image/png";
    if (!data) {
        data = UIImageJPEGRepresentation(image, 1.0);
        fileName = [NSString stringWithFormat:@"%@.jpg",[data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength]];
        mimetype = @"image/jpg";
    }
    if (completion) {
        completion(data, fileName, mimetype);
    }
}

+ (UIColor *)colorWithHexString:(NSString *)color {
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    // 判断前缀
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    // 从六位数值中找到RGB对应的位数并转换
    NSRange range;
    range.location = 0;
    range.length = 2;
    //R、G、B
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}

+ (NSDateFormatter *)formatterWithFormat:(NSString *)format {
    static NSDateFormatter *dateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!dateFormatter) {
            dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
            [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
        }
    });
    [dateFormatter setDateFormat:format];
    return dateFormatter;
}

+ (NSDate *)UTCDate:(NSDate *)date {
    NSTimeZone *sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    NSTimeZone *destinationTimeZone = [NSTimeZone localTimeZone];
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:date];
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:date];
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    return [[NSDate alloc] initWithTimeInterval:interval sinceDate:date];
}

+ (NSString *)dateStringFormUnix:(NSTimeInterval)unix {
    return [RYUtils dateStringFormUnix:unix format:@"yyyy-MM-dd HH:mm:ss"];
}

+ (NSString *)dateStringFormUnix:(NSTimeInterval)unix format:(NSString *)format {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:unix];
    NSDateFormatter *dateFormatter = [RYUtils formatterWithFormat:format];
    return [dateFormatter stringFromDate:date];
}

+ (NSString *)dateStringFormSeconds:(NSString *)seconds {
    NSInteger timeInterval = seconds.integerValue;
    NSString *minutes = [NSString stringWithFormat:@"%02zd",timeInterval/60];
    NSString *sec = @"00";
    if (timeInterval%60) {
        sec = [NSString stringWithFormat:@"%02zd",timeInterval%60];
    }
    return [NSString stringWithFormat:@"%@:%@",minutes,sec];
}

+ (NSInteger)seekTimeFormString:(NSString *)string {
    if ([RYUtils isEmptyString:string]) {
        return 0;
    }
    NSArray *times = [string componentsSeparatedByString:@":"];
    if (times.count != 2) {
        return 0;
    }
    NSInteger minutes = [times.firstObject integerValue];
    NSInteger sec = [times.lastObject integerValue];
    return minutes * 60 + sec;
}

+ (NSString *)missingSecondsFromString:(NSString *)string {
    return [string substringToIndex:string.length - 3];
}

+ (void)isCanEnterLiveOrVideoWithFreeType:(NSInteger)freeType
                                    isBuy:(BOOL)isBuy
                                    enter:(void(^)(BOOL isCanEnter))enter
                                    error:(void(^)(NSString *message))error {
    switch (freeType) {
        case 0: // 免费
        case 3:{ // 名师
            RYSafeBlock(enter, YES);
        }break;
        case 1:{
            // 收费
            RYSafeBlock(enter, isBuy);
        }break;
        case 2:{
            // VIP
            if ([RYUserInfo vip].integerValue != 0) {
                RYSafeBlock(enter, YES);
            }else{
                RYSafeBlock(error, @"VIP用户才能观看");
            }
        }break;
    }
}

+ (NSString *)conversionFansNumWithString:(NSString *)string {
    if ([RYUtils isEmptyString:string]) {
        return @"0";
    }
    NSInteger number = string.integerValue;
    if (number < 10000) {
        return string;
    }
    return [NSString stringWithFormat:@"%.1f万",ceilf(number/10000)];
}

+ (BOOL)stringIsEffective:(NSString *)string length:(NSInteger)length {
    NSString *c = length > 0 ? @(length).stringValue : @(10000).stringValue;
    NSString *predicate = [NSString stringWithFormat:@"^[➋➌➍➎➏➐➑➒\a-zA-Z0-9\u4E00-\u9FA5]{0,%@}",c];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", predicate];
    return [pred evaluateWithObject:string];
}

+ (NSString *)shareQrCodeString {
    return [NSString stringWithFormat:@"http://ryjz.4pole.cn/shareQrcode/%@",[RYUserInfo uid]];
}

@end


// *********************************************
@implementation UIView (NSIndexPath_Category)

static NSString const* UIView_NSIndexPath_Category = @"UIView_NSIndexPath_Category";

- (void)setIndexPath:(NSIndexPath *)indexPath {
    objc_setAssociatedObject(self, [UIView_NSIndexPath_Category UTF8String], indexPath, OBJC_ASSOCIATION_COPY);
}

- (NSIndexPath *)indexPath {
    return objc_getAssociatedObject(self, [UIView_NSIndexPath_Category UTF8String]);
}

@end

