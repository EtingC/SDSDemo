//
//  LKLocalDeviceMgr.h
//  AlinkDeviceCenter
// 此类是一个单例类，用来发现mDNS本地设备以及零配设备
//  Created by ZhuYongli on 2017/7/7.
//  Copyright © 2017年 ZhuYongli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LKLANDeviceModel.h"
#import "LKErrorDefine.h"
#define kLKLocalDeviceMgr LKLocalDeviceMgr.sharedMgr

extern NSString * kLKLocalDevMgrErrorDomain;






@interface LKLocalDeviceMgr : NSObject

/**
 返回单例
 */
+(instancetype)sharedMgr;


/**
 启动发现设备流程，包括mDNS发现的本地设备以及零配设备
 @param didFoundBlock   发现设备时的回调，会调用多次
 */
-(void)startDiscovery:(void(^)(NSArray * devices, NSError * err))didFoundBlock;


/**
 停止发现设备流程
 */
-(void)stopDiscovery;


/**
 获取所有发现的设备
 @return 设备列表，参见LKLANDeviceModel
 */
-(NSArray<LKLANDeviceModel*>*)getLanDevices;


/**
 v3设备：向云端请求批量忽略某些零配设备。如果不是V3设备，会返回LKDCErrCodeCodeOperationNotPermmitted错误
 @param lanDevices 零配设备列表
 @param didIgnoreBlock 结果回调
 */
-(void)ignoreDevice:(NSArray<LKLANDeviceModel *>*)lanDevices completeBlock:(void(^)(BOOL success, NSError * err))didIgnoreBlock;


/**
 V3设备：获取被忽略的设备列表
 @param didGetBlock 结果回调,返回被忽略的列表，如果出错，view err
 */
-(void)getIgnoredDevices:(void(^)(NSArray<LKLANDeviceModel *> * devices, NSError * err))didGetBlock;


/**
 v3设备：向云端请求批量取消忽略某些零配设备。如果不是V3设备，会返回LKDCErrCodeCodeOperationNotPermmitted错误
 与 ignoreDevice:completeBlock:是逆过程
 @param lanDevices 零配设备列表
 @param didUnignoreBlock 结果回调
 */
-(void)unignoreDevice:(NSArray<LKLANDeviceModel *>*)lanDevices completeBlock:(void(^)(BOOL success, NSError * err))didUnignoreBlock;

@end
