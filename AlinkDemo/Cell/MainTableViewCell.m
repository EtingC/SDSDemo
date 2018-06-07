//
//  MainTableViewCell.m
//  AlinkDemo
//
//  Created by gubeidianzi on 2017/11/6.
//  Copyright © 2017年 aliyun. All rights reserved.
//

#import "MainTableViewCell.h"
#import "sdsUIVersion.h"
@implementation MainTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor= [UIColor whiteColor];
    self.topGrayV.backgroundColor = RGB(236, 234, 243);
    self.layer.cornerRadius = 10;
    self.layer.masksToBounds = YES;
    // Initialization code
}
-(void)setTheData:(BindDeviceInformationlistModel *)model{

    self.bindModel = model;
    if (model.nickName) {
         self.NameL.text = model.nickName;
    }else{
        
         self.NameL.text = model.displayName;
    }
   
   
    if ([model.onlineState.value isEqualToString:@"on"]) {
         self.StatusL.text = @"在线";
         self.Switch.hidden = NO;
    }else{
        self.Switch.hidden = YES;
        self.StatusL.text = @"离线";
    }
  
    for (BindDeviceInformationlistModel*bindmodel in [DeviceInfoManager sharedManager].deviceInfoArray){
        [UsingHUD showInView:[DeviceInfoManager getCurrentVC].view];
        if ([self.bindModel.uuid isEqualToString:bindmodel.uuid]){
        
            AlinkRequest *request1 = [[AlinkRequest alloc] init];
            request1.method = @"mtop.openalink.app.core.device.get.status";
            request1.params = @{@"uuid":bindmodel.uuid};
            request1.needLogin = YES; //YES or NO
            request1.sessionExpiredOption = AKLoginOptionAutoLoginOnly;
            
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [AlinkSDK.sharedManager invokeWithRequest:request1 completionHandler:^(AlinkResponse * _Nonnull response) {
                    NSError *outError = nil;
                    if (response.successed){
                        NSLog(@"--------------------------------------%@",response);
                    
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [UsingHUD hideInView:[DeviceInfoManager getCurrentVC].view];
                            NSDictionary *dic = response.dataObject;
                            dic = [dic objectForKey:@"Switch"];
                            if ([[dic objectForKey:@"value"] isEqualToString:@"1"]) {
                                self.Switch.on = YES;
                            }else{
                                self.Switch.on = NO;
                            }
                         });
                    }
                    else {
                          [UsingHUD hideInView:[DeviceInfoManager getCurrentVC].view];
                        outError = response.responseError;
                        NSLog(@"outErroroutErroroutErroroutErroroutError=======%@",outError);
                    }
                }];
            });
        }else{
            
        }
    }
      
     [self.LogoImageV sd_setImageWithURL:[NSURL URLWithString:model.thumbnail] placeholderImage:[UIImage imageNamed:@"FY_背景图片"]];
    
     [self.Switch addTarget:self action:@selector(changeValue:) forControlEvents:UIControlEventValueChanged];
     NSString *pid =[DeviceInfoManager getPidStringDecimal:[[CommonUtil GetTheDeviceModel:model.model][2] integerValue]];
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
                        }
                        NSLog(@"我是在MainCell中下载更新UI包的！%@",result.savePath);
                    }];
                });
            }
        }
    }else{  //文件不存在时 下载UI包 同时 向数据库 插入 PID 和当前UI包的版本号
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
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
                    } else {
                        NSLog(@"插入失败");
                    }
                }else{
                    NSLog(@"解压失败");
                }
                NSLog(@"我是在MainCell中下载UI包的！%@",result.savePath);
            }];
        });
    }
}
- (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}
-(void)changeValue:(UISwitch *)swit{
    if (self.callbbackBlock) {
        self.callbbackBlock(self.bindModel,self);
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
