//
//  DeviceTableViewCell.m
//  AlinkDemo
//
//  Created by gubeidianzi on 2017/11/30.
//  Copyright © 2017年 aliyun. All rights reserved.
//

#import "DeviceTableViewCell.h"
#import "sdsUIVersion.h"
#import "UsingHUD.h"
#import "SDSFamliyManager.h"
@implementation DeviceTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)make:(DeviceFamilyInfo *)model1{
    for (DeviceFamilyInfo*Infomodel in [DeviceInfoManager sharedManager].deviceInfoArray){
        if ([self.deviceFamilyModel.deviceInfo.did isEqualToString:Infomodel.deviceInfo.did]) {
            
            NSDictionary * dic = @{
                                   @"act" : @"get",
                                   @"did" : Infomodel.deviceInfo.did, //0000000000000000000034ea345553fe
                                   @"params" : @[],
                                   @"vals" :   @[]
                                   };
            NSString * json = [CommonUtil dictionaryToJson:dic];
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                
//                BLDeviceStatusEnum  result =    [[BLLet sharedLet].controller queryDeviceRemoteState:Infomodel.deviceInfo.did];
//                NSLog(@"%ld",(long)result);
                NSString * content = [[BLLet sharedLet].controller  dnaControl:Infomodel.deviceInfo.did subDevDid:nil dataStr:json command:@"dev_ctrl" scriptPath:nil];
                NSLog(@"contentcontentcontentcontentcontentv%@",content);
                NSDictionary * dic = [CommonUtil dictionaryWithJsonString:content];
                NSString * status = [dic valueForKey:@"status"];
                if ([status integerValue]==0) {
                    dic = [dic valueForKey:@"data"];
                    NSMutableArray * valsArr = [dic valueForKey:@"vals"];
                    NSMutableArray * paramArr = [dic valueForKey:@"params"];
                    NSMutableDictionary * contentDic = [[NSMutableDictionary alloc]init];
                    for (int i = 0; i < paramArr.count; i++) { //遍历当前的状态类型  风干 烘干 优先（这俩互斥） 没有 就 杀菌 再没有 就显示无工作
                        NSString * status = paramArr[i];
                        NSString * valsStr = [[NSString alloc]init];
                        NSArray * valarr =valsArr[i];
                        NSDictionary*valsdic = valarr[0];
                        valsStr = [valsdic valueForKey:@"val"];
                        [contentDic setObject:valsStr forKey:status];
                    }
                    NSNumber * fenggan = [contentDic valueForKey:@"rack_airdrying"];
                    NSNumber * honggan = [contentDic valueForKey:@"rack_drying"];
                    NSNumber *shajun = [contentDic valueForKey:@"rack_disinfect"];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if ([fenggan intValue] == 1||[honggan intValue]==1) {
                            if ([fenggan intValue] ==1 ) {
                                self.StatusL.text = [NSString stringWithFormat:@"风干剩余时间 %@ min", [contentDic valueForKey:@"rack_airdryremtime"]] ;
                            }else if([honggan intValue]==1){
                                self.StatusL.text = [NSString stringWithFormat:@"烘干剩余时间 %@ min", [contentDic valueForKey:@"rack_dryremtime"]] ;
                            }
                        }else if([shajun intValue]==1){
                            self.StatusL.text = [NSString stringWithFormat:@"杀菌剩余时间 %@ min", [contentDic valueForKey:@"rack_disinremtime"]] ;
                        }else{
                            if (model1.deviceInfo.type != 20184) { //老设备无"无工作概念"
                                self.StatusL.text = @"无工作";
                            }else{
                                self.StatusL.text = @"";
                            }
                        }
                    });
                }
//                    else if ([status integerValue] == -7) {
//                    for (BLDNADevice *device in [LiangBaDevice sharedInstance].deviceArray) {
//                        if ([device.did isEqualToString:Infomodel.deviceInfo.did]) {
//
//                            BLFamilyDeviceInfo *familyinfo = [[BLFamilyDeviceInfo alloc]init];
//                            familyinfo.familyId = self.deviceFamilyModel.deviceInfo.familyId;
//                            familyinfo.roomId = @"";
//                            familyinfo.did = device.did;
//                            familyinfo.password = device.password;
//                            familyinfo.type = device.type;
//                            familyinfo.pid = device.pid;
//                            familyinfo.mac = device.mac;
//                            familyinfo.name = device.name;
//                            familyinfo.lock = device.lock;
//                            familyinfo.aesKey = device.controlKey;
//                            NSLog(@" 加入家庭的控制1111:%@",device.controlKey);
//                            familyinfo.terminalId = device.controlId;
//                            familyinfo.subdeviceNum = 1;
//                            familyinfo.longitude = @"1";
//                            familyinfo.latitude = @"1";
////                            UIAlertView *aler = [[UIAlertView alloc] initWithTitle:@"" message:@"aaa" delegate:sender cancelButtonTitle:@"qqqq" otherButtonTitles:nil, nil];
////                            [aler show];
//
//
//                            BLModuleInfo *moduleInfo = [[BLModuleInfo alloc] init];
////                            BLFamilyIdInfo *idinfo = [SDSFamliyManager sharedInstance].famliyID;
////                            [mutArr addObject:idinfo.familyId];
//                            moduleInfo.familyId = [SDSFamliyManager sharedInstance].famliyID;
//                            moduleInfo.roomId = @"";
//                            moduleInfo.name = device.name;
//                            moduleInfo.iconPath = [DeviceInfoManager sharedManager].imagePath;
//                            moduleInfo.followDev =1;
//                            moduleInfo.order = 1;
//                            moduleInfo.flag = 1;
//                            moduleInfo.moduleType = 3;
//                            //                            moduleInfo.extend = uuid;//这里用获取到的设备的UUID 来传给这个extend字段 是为了后面的固件升级需求要的ali的uuid入参做准备，传给服务器，下次请求家庭设备信息的时候，有个字段blmoudleinfo里面的extend就可以当做固件升级的UUID入参
//                            BLModuleIncludeDev *moduleDevs = [[BLModuleIncludeDev alloc] initWithDictionary:@{
//                                                                                                              @"did" : device.did,
//                                                                                                              @"sdid" : @"",
//                                                                                                              @"order" : @0,
//                                                                                                              @"content" : @""
//                                                                                                              }];
//                            moduleInfo.moduleDevs = @[moduleDevs];
//
//                            [[BLLet sharedLet].familyManager addModule:moduleInfo toFamily:[SDSFamliyManager sharedInstance].familyinfo withDevice: familyinfo subDevice:nil completionHandler:^(BLModuleControlResult * _Nonnull result) {
//
//                            }];
//                        }
//
//                    }
//
//                }
               
            });
        }
    }
    
}
-(void)setTheConfigue:(DeviceFamilyInfo *)model{
    if (model) {
        self.deviceFamilyModel = model;
        if (model.moduleInfo.iconPath) {
            NSString *str = model.moduleInfo.iconPath;
            if ([str isEqualToString:@"X23-X30"] || [str isEqualToString:@"X90"]) {
                self.LogoImage.image = [UIImage imageNamed:str];
            }else if ([str hasPrefix:@"file"]){
                self.LogoImage.image = [UIImage imageNamed:@"X23-X30"];
            }else{
                if (model.deviceInfo.type == 20445) {
//                    self.LogoImage.image = [UIImage imageNamed:@"X90"];
                    
                    NSString *file_name = [self.LogoImage.image accessibilityIdentifier];
                    if (file_name) {
                        if (![file_name isEqualToString:str]) {
                            [self.LogoImage sd_setImageWithURL:[NSURL URLWithString:model.moduleInfo.iconPath] placeholderImage:nil];
                        }
                    }else{
                        [self.LogoImage.image setAccessibilityIdentifier:str] ;
                        [self.LogoImage sd_setImageWithURL:[NSURL URLWithString:model.moduleInfo.iconPath] placeholderImage:nil];
                    }
                    
                }else{
                    [self.LogoImage sd_setImageWithURL:[NSURL URLWithString:model.moduleInfo.iconPath] placeholderImage:[UIImage imageNamed:@"X23-X30"]];
                }
                
            }
        }else{
            NSLog(@"model.moduleInfo.iconPath 出问题了");
        }
        self.NameL.text = model.moduleInfo.name;
        [self make:model];
//        [self performSelector:@selector(make:) withObject:nil afterDelay:0 inModes:@[NSRunLoopCommonModes]];
        
        for (DeviceFamilyInfo*Infomodel in [DeviceInfoManager sharedManager].deviceInfoArray){
            if ([self.deviceFamilyModel.deviceInfo.did isEqualToString:Infomodel.deviceInfo.did]) {
                
                NSString *pid =Infomodel.deviceInfo.pid;
               
                NSString * SDKUIpath = [[BLLet sharedLet].controller queryUIPath:pid];
                NSLog(@"UI文件包===============%@",SDKUIpath);
                if ([[NSFileManager defaultManager] fileExistsAtPath:SDKUIpath]) {  //当文件存在时
                    NSString *sql = [NSString stringWithFormat:@"select * from UIVERSION_TABLE Where PID ='%@'",pid];
                    NSArray * sdsVersionArr = [SDSsqlite queryversion:sql];//查询数据库中版本号数据
                    NSString * SDKUIVersion=nil;
                    NSArray* UIversionArr = [[BLLet sharedLet].controller queryUIVersion:pid].versions;
                    for (BLResourceVersion * version in UIversionArr) {
                        SDKUIVersion = version.version;    //获取SDK的最新版本
                    }
                    if (sdsVersionArr) {
                        sdsUIVersion* version = sdsVersionArr.firstObject;
                        NSString * ver = version.version; //数据库中版本号
                        
                        if ([SDKUIVersion isEqualToString:ver]) {   //如果文件存在同时版本号是最新的 就打印下面语句
                            NSLog(@"%@的UI文件包已经存在了,版本是最新",SDKUIpath);
                        }else{//如果查询到当前版本 与 SDK的版本不相同，就下载最新的，SDK会覆盖掉本地的老版本UI包 同时 更新数据库 PID对应的UI包版本
                            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                                [[BLLet sharedLet].controller downloadUI:pid completionHandler:^(BLDownloadResult * _Nonnull result) {
                                    BOOL isUnzip = [SSZipArchive unzipFileAtPath:result.savePath toDestination:SDKUIpath];
                                    if (isUnzip) {
                                        NSLog(@"解压成功");
                                        NSString *updateSql = [NSString stringWithFormat:@"update UIVERSION_TABLE set Version = '%@' where PID = '%@'",SDKUIVersion,pid];
                                        BOOL ret = [SDSsqlite updateSdsUIVersion:updateSql];
                                        if (ret) {
                                            NSLog(@"更新版本号成功");
                                        }else{
                                            NSLog(@"更新版本号失败");
                                        }
                                    }else{
                                        NSLog(@"解压失败");
                                        [SSZipArchive unzipFileAtPath:result.savePath toDestination:SDKUIpath];
                                    }
                                    NSLog(@"我是在MainCell中下载更新UI包的！%@",result.savePath);
                                }];
                            });
                        }
                    }
                }else{  //文件不存在时 下载UI包 同时 向数据库 插入 PID 和当前UI包的版本号
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [UsingHUD showInView:self.superview];
                        [[BLLet sharedLet].controller downloadUI:pid completionHandler:^(BLDownloadResult * _Nonnull result) {
                            
                            BOOL isUnzip = [SSZipArchive unzipFileAtPath:result.savePath toDestination:SDKUIpath];
                            if (isUnzip) {
                                NSLog(@"解压成功");
                                NSString * SDKUIVersion=nil;
                                NSArray* UIversionArr = [[BLLet sharedLet].controller queryUIVersion:pid].versions;
                                for (BLResourceVersion * version in UIversionArr) {
                                    SDKUIVersion = version.version;
                                }
                                sdsUIVersion * versionModel = [sdsUIVersion sdsUIVersiontWith:SDKUIVersion pid:pid];
                                BOOL isInsert = [SDSsqlite addSdsUIVersion:versionModel];
                                if (isInsert) {
                                    NSLog(@"插入成功");
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        [UsingHUD hideInView:self.superview];
                                    });
                                } else {
                                    NSLog(@"插入失败");
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        [UsingHUD hideInView:self.superview];
                                        [CommonUtil setTip:@"下载设备界面失败，请重新刷新设备列表"];
                                     });
                                }
                            }else{
                                NSLog(@"解压失败");
                                [SSZipArchive unzipFileAtPath:result.savePath toDestination:SDKUIpath];
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [UsingHUD hideInView:self.superview];
                                    [CommonUtil setTip:result.msg];
                                 });
                            }
                            NSLog(@"我是在MainCell中下载UI包的！%@",result.savePath);
                        }];
                    });
                }
            }
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
