//
//  SDSsqlite.h
//  AlinkDemo
//
//  Created by gubeidianzi on 2017/11/27.
//  Copyright © 2017年 aliyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB.h>
@class BLFamilyDeviceInfo;
@class sdsUIVersion;
@class BLModuleInfo;
@class BLModuleIncludeDev;
@interface SDSsqlite : NSObject

+ (void)createDatabase;
// 添加
+ (BOOL)addSdsUIVersion:(sdsUIVersion *)version;
// 查询  如果 传空 默认会查询表中所有数据
+ (NSArray <sdsUIVersion *> *)queryversion:(NSString *)queryVersion;
// 修改
+ (BOOL)updateSdsUIVersion:(NSString *)updateSql;


+(BOOL)AddDeviceInfo:(BLFamilyDeviceInfo *)deviceInfo;

//加入modle信息
+(BOOL)AddMoudleInfo:(BLModuleInfo *)deviceInfo;

//查询设备信息
+(NSMutableArray<BLFamilyDeviceInfo*> *)FindDeviceInfoWithFamilyID:(NSString *)familyid;

//查询moudle信息
+(NSMutableArray<BLModuleInfo *> *)FindMoudleInfoWithFamilyID:(NSString *)familyid;


//删除设备
+(BOOL)deleteDeviceWithDeviceDid:(NSString *)did;

//更新设备名称
+(void)UpdateDeviceName:(NSString *)DeviceName WithDid:(NSString *)did;

//更新设备图片
+(void)UpdateDeviceImage:(NSString *)Deviceimage WithDid:(NSString *)did;
@end
