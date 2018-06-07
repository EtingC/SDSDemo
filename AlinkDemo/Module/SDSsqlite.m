//
//  SDSsqlite.m
//  AlinkDemo
//
//  Created by gubeidianzi on 2017/11/27.
//  Copyright © 2017年 aliyun. All rights reserved.
//

#import "SDSsqlite.h"
#import "sdsUIVersion.h"
#import "BLFamilyDeviceInfo.h"
#import "BLModuleInfo.h"
#import "BLModuleIncludeDev.h"
#define  UIVERSION_TABLE @"UIVersion_TABLE.sqlite"
@implementation SDSsqlite
static FMDatabase *_fmdb;
+ (void)initialize {
    [SDSsqlite createDatabase];
}
+ (void)createDatabase{
    //拼接路径
    NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(
                                                               NSDocumentDirectory,
                                                               NSUserDomainMask,
                                                               YES);
    NSString *documentFolderPath = [searchPaths objectAtIndex:0];
    //        NSLog(@"docoumentFolderPath=%@",documentFolderPath);
    NSString* dbFilePath = [documentFolderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite",[[NSUserDefaults standardUserDefaults] objectForKey:ACCOUNT]]];
    //初始化FMDB
    _fmdb = [FMDatabase databaseWithPath:dbFilePath];
    
    //打开数据库
    [_fmdb open];
    
    BOOL isSucc = [_fmdb executeUpdate:@"create table if not exists UIVERSION_TABLE(id integer primary key, Version text,PID text)"];
    NSLog(@"%d", isSucc);
    BOOL isSucc1 = [_fmdb executeUpdate:@"create table if not exists DEVICE_INFO_TABLE(familyId text not null, roomId text not null ,did text not null ,  password integer not null,  type integer not null,  pid text not null,  mac text not null,  name text not null,  lock integer not null,  aesKey text not null,  terminalId integer not null,  subdeviceNum integer not null,  longitude text not null,  latitude text not null)"];
    NSLog(@"%d", isSucc1);
    
    BOOL isSucc2 = [_fmdb executeUpdate:@"create table if not exists MOUDLE_INFO_TABLE(familyId text not null, roomId text not null ,name text not null ,  iconPath text not null,  followDev integer not null,  Infoorder integer not null,  flag integer not null,  moduleType integer not null,  extend text not null,  did text not null,  sdid text not null,  moduleorder integer not null,  content text not null,moduleId text not null)"];
    NSLog(@"%d", isSucc2);
    
}
//加入modle信息
+(BOOL)AddMoudleInfo:(BLModuleInfo *)deviceInfo{
    
    NSString *addSql = [NSString stringWithFormat:@"insert into MOUDLE_INFO_TABLE(familyId,roomId,name,iconPath,followDev,Infoorder,flag,moduleType,extend,did,sdid,moduleorder,content,moduleId) values ('%@','%@','%@','%@','%ld','%ld','%ld','%ld','%@','%@','%@','%ld','%@','%@');", deviceInfo.familyId, deviceInfo.roomId, deviceInfo.name, deviceInfo.iconPath , deviceInfo.followDev,deviceInfo.order, deviceInfo.flag, deviceInfo.moduleType, deviceInfo.extend, deviceInfo.moduleDevs.firstObject.did, deviceInfo.moduleDevs.firstObject.sdid, deviceInfo.moduleDevs.firstObject.order, deviceInfo.moduleDevs.firstObject.content,deviceInfo.moduleId];
    BOOL isSuccess = [_fmdb executeUpdate:addSql];
    
    return isSuccess;
    
}
//加入设备信息
+(BOOL)AddDeviceInfo:(BLFamilyDeviceInfo *)deviceInfo{
    
    NSString *addSql = [NSString stringWithFormat:@"insert into DEVICE_INFO_TABLE(familyId,roomId,did,password,type,pid,mac,name,lock,aesKey,terminalId,subdeviceNum,longitude,latitude) values ('%@','%@','%@','%ld','%ld','%@','%@','%@','%d','%@','%ld','%ld','%@','%@');", deviceInfo.familyId, deviceInfo.roomId, deviceInfo.did, deviceInfo.password , deviceInfo.type, deviceInfo.pid, deviceInfo.mac, deviceInfo.name, deviceInfo.lock, deviceInfo.aesKey, deviceInfo.terminalId, deviceInfo.subdeviceNum, deviceInfo.longitude, deviceInfo.latitude];
    BOOL isSuccess = [_fmdb executeUpdate:addSql];
    return isSuccess;
}
//更新设备名称
+(void)UpdateDeviceName:(NSString *)DeviceName WithDid:(NSString *)did{
    
//     NSString *sql = [NSString stringWithFormat:@"SELECT *from DEVICE_INFO_TABLE"];
//     FMResultSet *set = [_fmdb executeQuery:sql];
//     while ([set next]) {
//        NSString *Devicedid = [set stringForColumn:@"did"];
//         if ([Devicedid isEqualToString:did]){
//             NSString *sql = [NSString stringWithFormat:@"UPDATE DEVICE_INFO_TABLE SET name = '%@' WHERE did = '%@'",DeviceName,did];
//         BOOL isSuccess =  [_fmdb executeUpdate:sql];
//             if (isSuccess) {
//                   NSLog(@"更新设备名称DEVICE_INFO_TABLE成功");
//             }
//         }
//     }
     NSString *sql1 = [NSString stringWithFormat:@"SELECT *from MOUDLE_INFO_TABLE"];
     FMResultSet *set1 = [_fmdb executeQuery:sql1];
     while ([set1 next]) {
         NSString *Devicedid = [set1 stringForColumn:@"did"];
         if ([Devicedid isEqualToString:did]){
             NSString *sql = [NSString stringWithFormat:@"UPDATE MOUDLE_INFO_TABLE SET name = '%@' WHERE did = '%@'",DeviceName,did];
             BOOL isSuccess =  [_fmdb executeUpdate:sql];
             if (isSuccess) {
                 NSLog(@"更新设备名称DEVICE_INFO_TABLE成功");
             }
         }
    }
}
//更新设备图片
+(void)UpdateDeviceImage:(NSString *)Deviceimage WithDid:(NSString *)did{
    
    NSString *sql1 = [NSString stringWithFormat:@"SELECT *from MOUDLE_INFO_TABLE"];
    FMResultSet *set = [_fmdb executeQuery:sql1];
    while ([set next]) {
        NSString *Devicedid = [set stringForColumn:@"did"];
        if ([Devicedid isEqualToString:did]){
            NSString *sql = [NSString stringWithFormat:@"UPDATE MOUDLE_INFO_TABLE SET iconPath = '%@' WHERE did = '%@'",Deviceimage,did];
            BOOL isSuccess =  [_fmdb executeUpdate:sql];
            if (isSuccess) {
                NSLog(@"更新设备名称DEVICE_INFO_TABLE成功");
            }
        }
    }
}
//查询设备信息
+(NSMutableArray *)FindDeviceInfoWithFamilyID:(NSString *)familyid{
    
    NSString *sql = nil;
    if (familyid) {
        sql = [NSString stringWithFormat:@"SELECT * from DEVICE_INFO_TABLE where familyId = '%@'",familyid];
    }else{
        sql =@"SELECT * from DEVICE_INFO_TABLE";
    }
    
    NSMutableArray <BLFamilyDeviceInfo *> *DeviceInfoArr = [[NSMutableArray alloc] init];
    FMResultSet *set = [_fmdb executeQuery:sql];
    
    while ([set next]) {
        BLFamilyDeviceInfo * model = [[BLFamilyDeviceInfo alloc]init];
        model.familyId = [set stringForColumn:@"familyId"];
        model.roomId =     [set stringForColumn:@"roomId"];
        model.did =        [set stringForColumn:@"did"];
        model.password = [set intForColumn:@"password"];
        model.type =     [set intForColumn:@"type"];
        model.pid = [set stringForColumn:@"pid"];
        model.mac = [set stringForColumn:@"mac"];
        model.name = [set stringForColumn:@"name"];
        model.lock = [set intForColumn:@"lock"];
        model.aesKey = [set stringForColumn:@"aesKey"];
        model.terminalId = [set intForColumn:@"terminalId"];
        model.subdeviceNum = [set intForColumn:@"subdeviceNum"];
        model.longitude = [set stringForColumn:@"longitude"];
        model.latitude = [set stringForColumn:@"latitude"];
        [DeviceInfoArr addObject:model];
    }
    return DeviceInfoArr;
}
//查询moudle信息
+(NSMutableArray *)FindMoudleInfoWithFamilyID:(NSString *)familyid{
    
    NSString *sql = nil;
    if (familyid) {
        sql = [NSString stringWithFormat:@"SELECT * from MOUDLE_INFO_TABLE where familyId = '%@'",familyid];
    }else{
        
        sql =@"SELECT * from MOUDLE_INFO_TABLE";
    }
    NSMutableArray <BLModuleInfo *> *DeviceInfoArr = [[NSMutableArray alloc] init];
    FMResultSet *set = [_fmdb executeQuery:sql];
    while ([set next]) {
        
        BLModuleInfo * model = [[BLModuleInfo alloc]init];
        model.familyId = [set stringForColumn:@"familyId"];
        model.roomId =     [set stringForColumn:@"roomId"];
        model.name =        [set stringForColumn:@"name"];
        model.iconPath = [set stringForColumn:@"iconPath"];
        model.followDev =     [set intForColumn:@"followDev"];
        model.order = [set intForColumn:@"Infoorder"];
        model.flag = [set intForColumn:@"flag"];
        model.moduleType = [set intForColumn:@"moduleType"];
        model.extend = [set stringForColumn:@"extend"];
        model.moduleId = [set stringForColumn:@"moduleId"];
        NSString *did = [set stringForColumn:@"did"];
        
        BLModuleIncludeDev *moduleDevs = [[BLModuleIncludeDev alloc] initWithDictionary:@{
                                                                                          @"did" : did,
                                                                                          @"sdid" : @"",
                                                                                          @"order" : @0,
                                                                                          @"content" : @""
                                                                                          }];
        model.moduleDevs = @[moduleDevs];
        [DeviceInfoArr addObject:model];
    }
    return DeviceInfoArr;
}
+(BOOL)addSdsUIVersion:(sdsUIVersion *)version{
    
    NSString *addSql = [NSString stringWithFormat:@"insert into UIVERSION_TABLE(Version, PID) values ('%@','%@');", version.version, version.pid];
    
    BOOL isSuccess = [_fmdb executeUpdate:addSql];
    
    return isSuccess;
}
//删除设备
+(BOOL)deleteDeviceWithDeviceDid:(NSString *)did{
    
     NSString *DeviceSql = [NSString stringWithFormat:@"delete from DEVICE_INFO_TABLE where did = '%@'",did];
     BOOL isSuccess = [_fmdb executeUpdate:DeviceSql];
    
    
     NSString *MoudleSql = [NSString stringWithFormat:@"delete from MOUDLE_INFO_TABLE where did = '%@'",did];
     BOOL isSuccess1 = [_fmdb executeUpdate:MoudleSql];
    
    if (isSuccess==YES&&isSuccess1==YES) {
        
        return YES;
    }else
    
    return NO;
}
//查询
+ (NSArray <sdsUIVersion *> *)queryversion:(NSString *)queryVersion {
    
    if (queryVersion == nil) {
        queryVersion = @"select * from UIVERSION_TABLE;";
    }
    
    NSMutableArray <sdsUIVersion *> *versionArr = [NSMutableArray array];
    FMResultSet *set = [_fmdb executeQuery:queryVersion];
    
    while ([set next]) {
        
        NSString *version = [set stringForColumn:@"Version"];
        NSString *pid = [set stringForColumn:@"PID"];
        
        
        sdsUIVersion *sds = [sdsUIVersion sdsUIVersiontWith:version pid:pid];
        [versionArr addObject:sds];
    }
    return versionArr;
}
+ (BOOL)updateSdsUIVersion:(NSString *)updateSql {
    
    if (updateSql == nil) {
        return NO;
    }
    
    BOOL isSuccess = [_fmdb executeUpdate:updateSql];
    
    return isSuccess;
}
@end
