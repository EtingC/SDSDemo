//
//  CommonUtil.h
// 
//
//  Created by apple on 15/11/9.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <SystemConfiguration/SystemConfiguration.h>

@interface CommonUtil : NSObject

// 根据十六进制获得颜色
+ (UIColor *)getColor:(NSString *)color;

+ (UIImage *)imageWithColor:(UIColor *)color;

// 判断是否有网
+ (BOOL)connectedToNetwork;

//根据颜色,透明度转换成图片
+ (UIImage*)createImageWithColor:(UIColor *)color rect:(CGRect)rect alpha:(CGFloat)alpha;

//改变图片填充颜色
+ (UIImage *)changeImageContentWithColor:(UIColor *)color orignImage:(UIImage*)img;

//获取文本长度
+ (CGSize)getTextSize:(NSString*)text font:(UIFont*)font width:(CGFloat)width height:(CGFloat)height;

//根据视图得到视图的一张图片
+ (UIImage*)transformViewIntoImage:(UIView*)view;

//文本提示
+ (void)setTip:(NSString*)pStrTip;
+ (void)setTip:(NSString*)pStrTip Yposition:(CGFloat)fY;
+ (void)showNoNetworkTip;//显示通用的没有网络的提示
+ (void)showFailedTip;//显示通用的请求失败的提示

//加密
+ (NSString*)encryption:(NSString*)string;

//解密
+ (NSString*)decryption:(NSString*)string;

//data转换为十六进制的。
+ (NSString*)hexStringFromData:(NSData*)myD;
+ (NSData*)dataFromHexString:(NSString*)hexString;

//根据基准压缩图片
+ (CGSize)compressionImageWithBase:(CGSize)base ImageSize:(CGSize)imageSize;

+ (NSData*)imageCompressedData:(UIImage*)img;

//拍照后旋转
+ (UIImage*)fixOrientation:(UIImage *)aImage;
// 正则判断手机号码地址格式
+ (BOOL)isMobileNumber:(NSString *)mobileNum;

+(BOOL)isValidateEmail:(NSString *)email;
//转成json字符串
+ (NSString*)dataToJsonString:(id)object;



+(void)setTipValue:(NSString *)value;

+ (int)intervalSinceNow1: (NSString *) theDate;

+ (NSInteger)numberOfDaysWithFromDate:(NSString *)fromDate toDate:(NSString *)toDate;

+(double)intervalSinceZeroTime:(NSString *)time;

+(NSInteger)getDifferenceByDate:(NSString *)date;

#pragma mark - 拆pID
//BROADLINK_LIVING_OUTLET_SPMINI_3_1_0_10001   处理设备Model拆分为厂商代码和设备等级和DevieceType
+(NSArray *)GetTheDeviceModel:(NSString *)MODEL;

// 添加button

+(UIButton *)adonWithImage:(NSString *)image highImage:(NSString *)highimage frame:(CGRect)frame title:(NSString *)title textColor:(UIColor *)color textFont:(UIFont *)font backgroundColor:(UIColor *)backgroundColor addView:(UIView *)view target:(id)target action:(SEL)action;
//字典转json格式字符串：
+ (NSString*)dictionaryToJson:(NSDictionary *)dic;
/*!
 
 * @brief 把格式化的JSON格式的字符串转换成字典
 
 * @param jsonString JSON格式的字符串
 
 * @return 返回字典
 
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;


/**
 通过传过来的 status 判断当前的设备是否需要重新登录

 @param status status
 @return status
 */
+(BOOL)isLoginExpired:(NSInteger)status;

@end
