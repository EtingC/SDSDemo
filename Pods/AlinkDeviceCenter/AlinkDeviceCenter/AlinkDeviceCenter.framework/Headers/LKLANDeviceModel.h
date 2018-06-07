//
//  LKLANDeviceModel.h
//  AlinkDeviceCenter
//
//  Created by ZhuYongli on 2017/7/7.
//  Copyright © 2017年 ZhuYongli. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <TBJSONModel/TBJSONModel.h>
#import "LKCandDeviceModel.h"





/**
 发现的设备信息
 */
@interface LKLANDeviceModel : NSObject

-(NSString *)getProductModel;  ///<设备model

-(NSString *)getProductIcon; ///<设备icon地址

-(NSString *)getProductName; ///<设备名称

-(LKCandDeviceModel *)toCandDeviceModel; ///<将LKLANDeviceModel-》LKCandDeviceModel， 然后调用 LKAddDeviceBiz.sharedInstance setDevice开始设备添加流程，切记发现的设备不要使用 [[LKCandDeviceModel alloc]init]来创建LKCandDeviceModel实例。
@end

