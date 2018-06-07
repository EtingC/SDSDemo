//
//  LKCandDeviceModel.h
//  AlinkDeviceCenter
//
//  Created by ZhuYongli on 2017/7/7.
//  Copyright © 2017年 ZhuYongli. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "TBJSONModel.h"



/**
 * 候选设备类型
 */
typedef NS_ENUM(NSInteger, LKDeviceType) {
    LKDeviceTypeWifi = 1,       ///< WIFI 设备
    LKDeviceTypeBle = 2,   ///< 蓝牙
    LKDeviceType433 = 3,   ///< RF433设备
    LKDeviceTypeZigbee = 4,   ///< Zigbee设备
};



/**
 * 候选设备数据模型
 */
@interface LKCandDeviceModel : NSObject
@property (nonatomic, copy) NSString * model; ///<等待添加设备的model,必选
@property (nonatomic, copy) NSString * mac; ///<等待添加设备mac地址，可选
@property (nonatomic, copy) NSString * sn; ///<等待添加设备mac地址，可选
@property (nonatomic, copy) NSString * uuid; ///<等待添加设备mac地址，可选，（如果mac、sn、uuid同时为空，则认为此设备需要先配网）
@property (nonatomic, copy) NSString * connectMode; ///<可选，为空时默认为"alibaba_smartconfig_v3"，此值可以通过, "mtop.openlink.app.product.detail.get" 请求从云端拿到,UI层透传给SDK
@property (nonatomic, assign) BOOL supportRouterProvision; ///<设备是否支持路由器配网，默认为不支持，即 "NO"
//@property (nonatomic, copy) NSString *  productName;
@property (nonatomic, assign) LKDeviceType devType;  ///<设备类型，默认为 LKDeviceTypeWifi
@property (nonatomic, copy) NSString * gatewayUuid; ///<子设备时必选，如Zigbee子设备，则需要填写zigbee网关uuid

@property (nonatomic, copy) NSString * xModel;///<公版设备的型号

@property (nonatomic, assign, readonly) BOOL deviceAdded;///<设备添加成功与否,YES表示成功 
/**
 判断当前设备是否支持设备热点配网
 */
-(BOOL)supportSoftAp;


/**
 判断当前设备是否支持手机热点配网
 */
-(BOOL)supportHotspot;
@end
