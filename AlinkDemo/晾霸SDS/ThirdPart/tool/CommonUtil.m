//
//  CommonUtil.m

//
//  Created by apple on 15/11/9.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "CommonUtil.h"
#import <netdb.h>
#import <CommonCrypto/CommonCrypto.h>
#import "NSData+AES256.h"
#import "AppDelegate.h"
#define GETSCREENWIDTH [[UIScreen mainScreen] bounds].size.width
#define GETSCREENHEIGHT [[UIScreen mainScreen] bounds].size.height
#define COLOR(R,G,B,A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]
@implementation CommonUtil

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    
    if (jsonString == nil) {
        
        return nil;
        
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *err;
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                         
                                                        options:NSJSONReadingMutableContainers
                         
                                                          error:&err];
    
    if(err) {
        
        NSLog(@"json解析失败：%@",err);
        
        return nil;
        
    }
    
    return dic;
    
}


+ (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}


+(UIButton *)adonWithImage:(NSString *)image highImage:(NSString *)highimage frame:(CGRect)frame title:(NSString *)title textColor:(UIColor *)color textFont:(UIFont *)font backgroundColor:(UIColor *)backgroundColor addView:(UIView *)view target:(id)target action:(SEL)action

{
    
    UIButton *btn = [[UIButton alloc] init];
    
    [btn setBackgroundImage:[UIImage imageNamed:image] forState:(UIControlStateNormal)];
    
    [btn setBackgroundImage:[UIImage imageNamed:highimage] forState:(UIControlStateSelected)];
    
    btn.frame = frame;
    
    [btn setTitle:title forState:(UIControlStateNormal)];
    
    //    btn.titleLabel.textColor = color;
    
    [btn setTitleColor:color forState:(UIControlStateNormal)];
    
    btn.titleLabel.font = font;
    
    btn.backgroundColor = backgroundColor;
    
    
    
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:btn];
    
    return btn;
    
}
// 正则判断手机号码地址格式
//邮箱地址的正则表达式
+(BOOL)isValidateEmail:(NSString *)email{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

+(BOOL)isMobileNumber:(NSString *)mobileNum {
    
    //    电信号段:133/153/180/181/189/177
    //    联通号段:130/131/132/155/156/185/186/145/176
    //    移动号段:134/135/136/137/138/139/150/151/152/157/158/159/182/183/184/187/188/147/178
    //    虚拟运营商:170
    
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[05-8])\\d{8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    
    return [regextestmobile evaluateWithObject:mobileNum];
}

+ (UIColor *)getColor:(NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}

+ (UIImage *)imageWithColor:(UIColor *)color
{
	CGRect rect;
	
	if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0)
	{
		rect = CGRectMake(0.0f, 0.0f, 10.0f, 10.0f);
	}
	else
	{
		rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
	}
	
	UIGraphicsBeginImageContext(rect.size);
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGContextSetFillColorWithColor(context, [color CGColor]);
	CGContextFillRect(context, rect);
	
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return image;
}

+ (BOOL)connectedToNetwork
{
    // Create zero addy
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    if (!didRetrieveFlags)
    {
        printf("Error. Could not recover network reachability flags\n");
        return NO;
    }
    
    BOOL isReachable = ((flags & kSCNetworkFlagsReachable) != 0);
    BOOL needsConnection = ((flags & kSCNetworkFlagsConnectionRequired) != 0);
    return (isReachable && !needsConnection) ? YES : NO;
}

+ (UIImage*)createImageWithColor:(UIColor *)color rect:(CGRect)rect alpha:(CGFloat)alpha
{
    //设置颜色
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage* pTheColorImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //设置透明度
    UIGraphicsBeginImageContextWithOptions(pTheColorImage.size, NO, 0.0f);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, pTheColorImage.size.width, pTheColorImage.size.height);
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    CGContextSetAlpha(ctx, alpha);
    CGContextDrawImage(ctx, area, pTheColorImage.CGImage);
    UIImage* pNewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return pNewImage;
}

+ (UIImage *)changeImageContentWithColor:(UIColor *)color orignImage:(UIImage*)img
{
    UIGraphicsBeginImageContextWithOptions(img.size, NO, img.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, img.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGRect rect = CGRectMake(0, 0, img.size.width, img.size.height);
    CGContextClipToMask(context, rect, img.CGImage);
    [color setFill];
    CGContextFillRect(context, rect);
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


+ (CGSize)getTextSize:(NSString*)text font:(UIFont*)font width:(CGFloat)width height:(CGFloat)height
{
    CGSize size = CGSizeMake(width, height);
    NSDictionary *pDic = @{NSFontAttributeName: font};
        
    size = [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:pDic context:nil].size;
    
    return size;
}

+ (UIImage*)transformViewIntoImage:(UIView*)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
+ (void)setTip:(NSString*)pStrTip
{
	[CommonUtil setTip:pStrTip Yposition:(GETSCREENHEIGHT-100)];
}
+ (void)setTip:(NSString*)pStrTip Yposition:(CGFloat)fY
{
    if (!pStrTip || pStrTip.length == 0) {
        return;
    }
    
    CGSize tipSize = [self getTextSize:pStrTip font:[UIFont systemFontOfSize:13] width:GETSCREENWIDTH-35 height:200];
    
    UILabel* tipLabel = [[UILabel alloc] initWithFrame:CGRectMake((GETSCREENWIDTH-tipSize.width-15)/2, fY, tipSize.width+15, tipSize.height+10)];
    tipLabel.text = pStrTip;
    tipLabel.font = [UIFont systemFontOfSize:13];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.textColor = [UIColor whiteColor];
    tipLabel.backgroundColor = COLOR(68, 68, 68, 0.8);
    tipLabel.layer.masksToBounds = YES;
    tipLabel.layer.cornerRadius = 5.0f;
    tipLabel.alpha = 0;
    tipLabel.numberOfLines = 0;
    
    if (CGRectGetMaxY(tipLabel.frame) > GETSCREENHEIGHT-20) {
        [tipLabel setY:GETSCREENHEIGHT-20-tipLabel.frame.size.height];
    }
    
    AppDelegate* app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [app.window addSubview:tipLabel];
    [app.window bringSubviewToFront:tipLabel];
    
    [UIView animateWithDuration:0.5 animations:^{
        tipLabel.alpha = 1;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 delay:1.5 options:UIViewAnimationOptionCurveLinear animations:^{
            tipLabel.alpha = 0;
        } completion:^(BOOL finished) {
            [tipLabel removeFromSuperview];
        }];
    }];
}

+(void)showNoNetworkTip
{
	NSString *string = @"没有网络，请检查网络";
	[CommonUtil setTip:string Yposition:GETSCREENHEIGHT-100];
}
+(void)showFailedTip
{
	NSString *string = @"获取失败，请检查网络";
	[CommonUtil setTip:string Yposition:GETSCREENHEIGHT-100];
}

 

+ (NSString*)encryption:(NSString*)string
{
    NSString* key = @"1222A1908D024080";
    NSData* plain = [string dataUsingEncoding:NSUTF8StringEncoding];
    
    NSData* eData = [plain AES256EncryptWithKey:key];
 
    NSString* encodeStr = [self hexStringFromData:eData];
    return encodeStr;
}

+ (NSString*)decryption:(NSString*)string
{
    NSString* key = @"1222A1908D024080";
    
    NSData* eData = [self dataFromHexString:string];
    NSData* origData = [eData AES256DecryptWithKey:key];
    
    NSString* origStr = [[NSString alloc] initWithData:origData encoding:NSUTF8StringEncoding];
    return origStr;

}

//data转换为十六进制的。
+ (NSString*)hexStringFromData:(NSData*)myD
{
    Byte* bytes = (Byte*)[myD bytes];
    //下面是Byte 转换为16进制。
    NSString* hexStr=@"";
    for(int i=0;i<[myD length];i++)
        
    {
        NSString* newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        
        if([newHexStr length]==1)
            
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        
        else
            
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
    }
 
    
    return hexStr;
}

+ (NSData*)dataFromHexString:(NSString*)hexString
{
    int j=0;
    Byte bytes[1024]; ///3ds key的Byte 数组， 1024位
    for(int i=0;i<[hexString length];i++)
    {
        int int_ch; /// 两位16进制数转化后的10进制数
        unichar hex_char1 = [hexString characterAtIndex:i]; ////两位16进制数中的第一位(高位*16)
        int int_ch1;
        if(hex_char1 >= '0' && hex_char1 <='9')
            int_ch1 = (hex_char1-48)*16;   //// 0 的Ascll - 48
        else if(hex_char1 >= 'A' && hex_char1 <='F')
            int_ch1 = (hex_char1-55)*16; //// A 的Ascll - 65
        else
            int_ch1 = (hex_char1-87)*16; //// a 的Ascll - 97
        i++;
        unichar hex_char2 = [hexString characterAtIndex:i]; ///两位16进制数中的第二位(低位)
        int int_ch2;
        if(hex_char2 >= '0' && hex_char2 <='9')
            int_ch2 = (hex_char2-48); //// 0 的Ascll - 48
        else if(hex_char1 >= 'A' && hex_char1 <='F')
            int_ch2 = hex_char2-55; //// A 的Ascll - 65
        else
            int_ch2 = hex_char2-87; //// a 的Ascll - 97
        int_ch = int_ch1+int_ch2;
//        NSLog(@"int_ch=%d",int_ch);
        bytes[j] = int_ch;  ///将转化后的数放入Byte数组里
        j++;
    }
    NSData* newData = [[NSData alloc] initWithBytes:bytes length:j];
    return newData;
}

+ (CGSize)compressionImageWithBase:(CGSize)base ImageSize:(CGSize)imageSize
{
    //缩放图片
    CGFloat w = base.width;//基准,根据这个长宽来缩放
    CGFloat h = base.height;
    
    CGFloat scale = 1;
    if (imageSize.width > 0 && imageSize.height > 0) {
        scale = imageSize.width/imageSize.height;
    }
    
    
    CGFloat width = imageSize.width;
    CGFloat het = imageSize.height;
    
    
    if (width > w) {//长大于基准
        width = w;
        het = width/scale;
        
        if (het > h) {//压缩后的宽大于基准
            het = h;
            width = het*scale;
        }
    }else{//长小于基准
        if (het > h) {//如果宽大于基准
            het = h;
            width = het*scale;
        }else{//如果长和宽都小于基准,已长度长的为基准
            
            if (width>het) {//如果长>宽,已长为准
                width = w;
                het = width/scale;
                if (het > h) {//放大后的宽大于基准
                    het = h;
                    width = het*scale;
                }
            }else{
                het = h;
                width = het*scale;
                if (width > w) {
                    width = w;
                    het = width/scale;
                }
            }
            
        }
    }
    return CGSizeMake(width, het);
}

//ensure image is less than 500k
+ (NSData*)imageCompressedData:(UIImage*)img
{
//    NSLog(@"primal img x=%f, y=%f", img.size.width, img.size.height);
//    UIImage* screenImage = [CommonUtil imageScaleToSize:img inSize:CGSizeMake(640, 1136)];
//    NSLog(@"small img x=%f, y=%f", screenImage.size.width, screenImage.size.height);
    UIImage* screenImage = img;
    NSData* data = nil;
    data = [[NSData alloc] initWithData:UIImageJPEGRepresentation(screenImage, 1.0)];
    //to fit the size on phone
    NSLog(@"primal SIZE OF compressed IMAGE: %d", (int)data.length);
    if ([CommonUtil isDataOverKbtyes:data standard:500]) {
        data = [[NSData alloc] initWithData:UIImageJPEGRepresentation((screenImage), 0.3)]; //to fit the size on phone
        if ([CommonUtil isDataOverKbtyes:data standard:250]) {
            data = [[NSData alloc] initWithData:UIImageJPEGRepresentation((screenImage), 0.15)];
        }
    }
    NSLog(@"SIZE OF compressed IMAGE: %d", (int)data.length);
    return data;
}

+ (BOOL)isDataOverKbtyes:(NSData*)data standard:(NSInteger)byte
{
    if ([data length]/1024.f > byte) {
        return YES;
    }
    return NO;
}

+ (UIImage*)fixOrientation:(UIImage *)aImage
{
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

+ (NSString*)dataToJsonString:(id)object
{
    NSString* jsonString = nil;
    NSError* error;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:&error];
    if (!jsonData) {
        NSLog(@"Got an error: %@", error);
    }else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

+ (NSString *)dateAdd:(NSString *)dateString addtime:(NSString*)addstr{
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
     [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSDate *date =[dateFormat dateFromString:dateString];
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents* dc1 = [[NSDateComponents alloc] init] ;
    [dc1 setMonth:[addstr intValue]];
    NSDate *nextYearDate = [ gregorian dateByAddingComponents:dc1 toDate:date options:0];
    NSString *str =[dateFormat stringFromDate:nextYearDate];
    return str;
}
+(void)setTipValue:(NSString *)value{
    
    if ([value isEqualToString:@"201"]) {
        [CommonUtil setTip:@"参数错误"];
    }
    if ([value isEqualToString:@"100 "]) {
        [CommonUtil setTip:@"未登录"];
    }
    if ([value isEqualToString:@"101"]) {
        [CommonUtil setTip:@"用户不存在"];
    }
    if ([value isEqualToString:@"102 "]) {
        [CommonUtil setTip:@"用户名或密码错误"];
    }
    if ([value isEqualToString:@"103"]) {
        [CommonUtil setTip:@"账号已禁用"];
    }
    if ([value isEqualToString:@"104"]) {
        [CommonUtil setTip:@"账号已存在"];
    }
    if ([value isEqualToString:@"105"]) {
        [CommonUtil setTip:@"密码错误"];
    }
    if ([value isEqualToString:@"106"]) {
        [CommonUtil setTip:@"无效token"];
    }
    if ([value isEqualToString:@"107"]) {
        [CommonUtil setTip:@"无权限"];
    }
    if ([value isEqualToString:@"108"]) {
        [CommonUtil setTip:@" 原密码不正确"];
    }
    if ([value isEqualToString:@"109"]) {
        [CommonUtil setTip:@"身份证号和手机号不一致"];
    }
    if ([value isEqualToString:@"300"]) {
        [CommonUtil setTip:@" 数据不存在"];
    }
    if ([value isEqualToString:@"301"]) {
        [CommonUtil setTip:@"验证码错误"];
    }
    if ([value isEqualToString:@"500"]) {
        [CommonUtil setTip:@"操作失败"];
    }
    if ([value isEqualToString:@"501"]) {
        [CommonUtil setTip:@"短信发送失败"];
    }
    if ([value isEqualToString:@"601"]) {
        [CommonUtil setTip:@"提现金额超过最大可提现金额"];
    }
    if ([value isEqualToString:@"602"]) {
        [CommonUtil setTip:@"已申请过退单，请勿重复申请"];
    }
    if ([value isEqualToString:@"603"]) {
        [CommonUtil setTip:@"今日已申请过提现"];
    }
    
    
}
/**
 2  * @method
 3  *
 4  * @brief 获取两个日期之间的天数
 5  * @param fromDate       起始日期
 6  * @param toDate         终止日期
 7  * @return    总天数
 8  */
+ (NSInteger)numberOfDaysWithFromDate:(NSString *)fromDate toDate:(NSString *)toDate{
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    dateFormatter.dateFormat=@"yyyy-MM-dd hh:mm:ss";
    NSDate *fromdate = [dateFormatter dateFromString:fromDate];
    NSDate *todate = [dateFormatter dateFromString:toDate];
    NSDateComponents * comp = [calendar components:NSCalendarUnitDay   fromDate:fromdate toDate:todate options:NSCalendarWrapComponents];
         NSLog(@" -- >>  comp : %@  << --",comp);
      return comp.day;
}

/**
 时间字符串与当前时间的天数差

 @param date date
 @return date
 */
+(NSInteger)getDifferenceByDate:(NSString *)date {
    //获得当前时间
    NSDate *now = [NSDate date];
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *oldDate = [dateFormatter dateFromString:date];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    unsigned int unitFlags = NSDayCalendarUnit;
    NSDateComponents *comps = [gregorian components:unitFlags fromDate:oldDate  toDate:now  options:0];
    return [comps day];
}


/**
 算时间字符串与时间0.00时候的时间差

 @param time date
 */
+(double)intervalSinceZeroTime:(NSString *)time{
    
    double timeNumber = 0.0000;
    time= [time substringWithRange:NSMakeRange(11, 8)];
    
    NSMutableString * mutStr = [NSMutableString stringWithString:time];
    
    NSArray * timeArr = [mutStr componentsSeparatedByString:@":"];
    
    timeNumber = [(NSString*)timeArr[0] doubleValue]/24 + [(NSString*)timeArr[1] doubleValue]/1440+[(NSString*)timeArr[2] doubleValue]/86400;
    return timeNumber;
    
}
+ (int)intervalSinceNow1: (NSString *) theDate {
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd"];//设置时间格式//很重要
    NSDate *d=[date dateFromString:theDate];
    
    NSTimeInterval late=[d timeIntervalSince1970]*1;
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now=[dat timeIntervalSince1970]*1;
    NSString *timeString=@"";
    NSTimeInterval cha=now-late;
    if (cha/86400>1) {
        timeString = [NSString stringWithFormat:@"%f", cha/86400];
        timeString = [timeString substringToIndex:timeString.length-7];
        return [timeString intValue];
    }
    return -1;
}
//BROADLINK_LIVING_OUTLET_SPMINI_3_1_0_10001
+(NSArray *)GetTheDeviceModel:(NSString *)MODEL{
    
    
    NSMutableArray * mutArr= [[NSMutableArray alloc]init];
    
    NSArray * arr1 = [MODEL componentsSeparatedByString:@"_"];
    
        [mutArr addObject:arr1[arr1.count-3]];
        [mutArr addObject:arr1[arr1.count-2]];
        [mutArr addObject:arr1[arr1.count-1]];
    arr1 =  [mutArr copy];
    
    return arr1;
}
+(BOOL)isLoginExpired:(NSInteger)status {
    if (status == -1012 || status == -1009 || status == -1000 || status == 10011||status == -3003) {
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"RELOGIN_NOTIFICATION" object:nil];
        return YES;
    } else {
        return NO;
    }
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
}
@end
