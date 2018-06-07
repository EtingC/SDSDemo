//
//  LKLogAndTrackHelper.h
//  AlinkDeviceCenter
// 日志工具类
//  Created by ZhuYongli on 2017/8/2.
//  Copyright © 2017年 ZhuYongli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AKLog/AKLog.h>

// log level define
/*
 typedef NS_ENUM(NSInteger, LKDCLogLevel) {
    LKDCLogLevelVerbose = 0,
    LKDCLogLevelDebug,
    LKDCLogLevelInfo,
    LKDCLogLevelWarn,
    LKDCLogLevelError
};


@protocol LKDCLogDelegate <NSObject>

@optional

- (void)log:(LKDCLogLevel)flag file:(const char *)file func:(const char *)func line:(int)line fmt:(NSString *)fmt args:(va_list)args;

@end
*/
@interface LKLogAndTrackHelper : NSObject

/**
 设置 log delegate，否则会用NSLog输出log
 @param delegate 代理
 */
+ (void)setDelegate:(id<AKLogDelegate>)delegate;


/**
 log 开关
 @param on 开关
 */
+ (void)turnLogOn:(BOOL)on;

@end

