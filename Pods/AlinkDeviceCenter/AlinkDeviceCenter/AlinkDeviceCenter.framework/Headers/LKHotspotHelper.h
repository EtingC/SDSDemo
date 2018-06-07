//
//  LKHotspotHelper.h
//  AlinkDeviceCenter
//  热点配网工具类
//  Created by ZhuYongli on 2017/8/1.
//  Copyright © 2017年 ZhuYongli. All rights reserved.
//

#import <Foundation/Foundation.h>


#define kLKHotspotHelper LKHotspotHelper.sharedHelper

/**
 * 可访问的设备节点
 */
@interface LKHotAccessibleItem : NSObject

@property (nonatomic, copy) NSString *model;    ///< 设备model
@property (nonatomic, copy) NSString *sn;       ///< 设备唯一标示

@property (nonatomic, copy) NSString *host;     ///< host
@property (nonatomic, copy) NSString *port;     ///< 端口

@property (nonatomic, copy) NSString *security; ///< 支持的安全等级

@end


/**
 * 热点信息
 */
@interface LKAccessibleAccessPoint : NSObject

@property (nonatomic, copy) NSString *ssid;         ///< 热点SSID
@property (nonatomic, copy) NSString *xssid;        ///< 非UTF-8编码的SSID，通过`ssid`字段获取转译成UTF-8编码后的ssid


@end

@interface LKHotspotHelper : NSObject
/**
 返回单例
 */
+(instancetype)sharedHelper;

/**
 获取当前所连路由器名称
 */
+(NSString *)getCurrentSsid;



/**
 是否支持起热点，检测是否为iPhone
 
 @return YES则支持起热点
 */
+ (BOOL)isSupportedHotspot;


/**
 发现（搜索）支持手机热点配网服务的设备列表，每隔2s发送一次发现请求，有新增会有多次回调
 
 @param completionHandler 回调（发现的设备列表）
 */
- (void)discoverAccessibleItems:(void (^)(NSArray<LKHotAccessibleItem *> *devices, NSError *error))completionHandler;

/**
 停止发现
 */
- (void)stopDiscover;



/**
 发送单播 并 开启监听，搜索设备周边 Wi-Fi 列表，可能有多次回调
 
 @param completionHandler 回调（WiFi列表）
 */
- (void)searchWifiList:(LKHotAccessibleItem*)access completeBlock:(void (^)(NSArray<LKAccessibleAccessPoint *> *wifiList, NSError *error))completionHandler;

/**
 停止搜索设备周边 Wi-Fi 列表
 */
- (void)stopSearchWifiList;
@end
