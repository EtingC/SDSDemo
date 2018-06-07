//
//  DemoAddDevNotifier.m
//  AlinkDemo
//
//  Created by gubeidianzi on 2017/10/30.
//  Copyright © 2017年 aliyun. All rights reserved.
//

#import "DemoAddDevNotifier.h"
#import "BLDNADevice.h"
#import "DemoLoggingFormatter.h"
#import "BLModuleInfo.h"
#import "BLFamilyInfo.h"
#import "BLFamilyDeviceInfo.h"
#import "BindDeviceInformationlistModel.h"


@interface DemoAddDevNotifier ()
@property  (nonatomic , assign) NSInteger *timeCount;
@end


@implementation DemoAddDevNotifier




#pragma mark -----------
-(void)notifyPrecheck:(BOOL)success withError:(NSError *)err {
    NSLog(@"notifyPrecheck callback err : %@", err);
}

-(void)notifyProvisionPrepare:(LKPUserGuideCode)guideCode {
    NSLog(@"notifyProvisionPrepare callback guide code : %ld", guideCode);
    //配网前期准备，UI层需要引导用户输入wifi的名字跟密码",此时，配网模块状态机会一直处于
    //等待状态，在拿到wifi名跟密码后，跳到 3.4小节继续往下执行。
    //需要配网环节且配网模式依赖用户输入路由的SSID以及密码时会收到此事件。
    if (LKPGuideCodeOnlyInputPwd == guideCode) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"LKPGuideCodeOnlyInputPwd" object:nil];
        //跳转到wifi，密码输入页面
    } else if (LKPGuideCodeHasHotSpot == guideCode){
        //手机热点配网相关界面
        //首先需要引导用户启动设备热点，热点名字，具体参见手机热点配网UI
        [[NSNotificationCenter defaultCenter]postNotificationName:@"LKPGuideCodeHasHotSpot" object:nil];
    }
}

-(void)notifyProvisioning {
//    NSLog(@"notifyProvisioning callback ");
//    for (BLDNADevice *device in [LiangBaDevice sharedInstance].deviceArray ) {
//        [[BLLet sharedLet].controller removeDevice:device];
//    }
//    [[LiangBaDevice sharedInstance].deviceArray removeAllObjects];
//    [[LiangBaDevice sharedInstance].XINGHAOArr removeAllObjects];
//
//    self.myTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(function:) userInfo:nil repeats:YES];
//    [_myTimer setFireDate:[NSDate distantPast]];
    //正在配网，这个过程会持续10-60秒不等，请耐心等待"
}
#pragma mark - 此处为在配网过程中，不断的搜索局域网设备 把相同型号的加到 [LiangBaDevice sharedInstance].XINGHAOArr 数组中 存储
-(void)function:(id)sender{
//    NSLog(@"[LiangBaDevice sharedInstance].deviceArray---%@",[LiangBaDevice sharedInstance].deviceArray);
//     NSMutableArray * xiangtongMutArr = [NSMutableArray arrayWithArray:[LiangBaDevice sharedInstance].XINGHAOArr];
    if (self.timeCount <= 0) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"notifyJoinResultError" object:nil];
    }else{
        for (BLDNADevice *device in [LiangBaDevice sharedInstance].deviceArray){
            NSLog(@"%@",device.pid);
            if ([[device.mac uppercaseString] isEqualToString:[self.mac uppercaseString]]) {
                NSLog(@"加入家庭的控制:搜索%@",device.controlKey);
                [self defvicejoinnetWith:[self.mac uppercaseString] device:device];
            }
        }
    }
    self.timeCount = self.timeCount - 3;
    NSLog(@"time****** %d",self.timeCount);
    
//        if ([device.pid isEqualToString:[DeviceInfoManager sharedManager].PID]){
//
//            if ([LiangBaDevice sharedInstance].XINGHAOArr.count<1) {
//
//                 [[LiangBaDevice sharedInstance].XINGHAOArr  addObject:device];
//
//            }else{
//                 NSMutableArray * didArr = [[NSMutableArray alloc]init];
//                 for (BLDNADevice * xinghaoDevice in xiangtongMutArr) {
//
//                 }
//                    [didArr addObject:xinghaoDevice.did];

//                 if (![didArr containsObject:device.did]) {
//                     [[LiangBaDevice sharedInstance].XINGHAOArr addObject:device];
//                    }
//                 }
//             }
//        }
}
-(void)notifyShouldSwitchBackToRouter:(NSString * )routerAp {
    NSLog(@"notifyShouldSwitchBackToRouter callback routeAp: %@", routerAp);
    //手机热点配网，设备拿到家庭wifi网络密码后，需要将手机切换回家庭wifi网络,
    //此处需要给用户提示
}
-(void)notifyProvisonResult:(id)result withError:(NSError *)err {
    
    if (err != nil) {
        NSLog(@"设备配网 失败，err :%@", err);
        //关闭定时器
        [_myTimer setFireDate:[NSDate distantFuture]];
        [_myTimer invalidate];
        _myTimer = nil;
        [[NSNotificationCenter defaultCenter]postNotificationName:@"notifyProvisonResultError" object:nil];
    } else {
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"notifyProvisonResult" object:nil];
        NSString * result1 = [result valueForKey:@"result"];
        NSLog(@"设备配网 成功，result :%@", result);
    }
}
//设备注册、绑定、授权、激活等入网状态
-(void)notifyJoining:(NSDictionary*)step {
    NSLog(@"设备正在入网，此过程会持续10-60s不等");
    NSString * step1 = step[@"step"];
    if ([step1 isEqualToString:@"enrolleeActive"]) {
        //提示用户激活设备,V3设备需要在设备上触控某个按钮来完成激活流程
        //由具体的产品来定义
    } else if ([step1 isEqualToString:@"enrolleeAdd"]) {
        //零配添加
    } else {
    }
}

-(void)defvicejoinnetWith:(NSString *)sn device:(BLDNADevice *)device {
    
    
    jian  = YES;
    //关闭定时器
    [_myTimer setFireDate:[NSDate distantFuture]];
    [_myTimer invalidate];
    _myTimer = nil;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"isSearchedDev" object:@{@"status":@"end"}];
    NSMutableArray * SqliteDeviceInfoArr = [SDSsqlite FindDeviceInfoWithFamilyID:nil ];
    NSMutableArray *devDidArr = [[NSMutableArray alloc] init];
    for (BLFamilyDeviceInfo *devModel in SqliteDeviceInfoArr) {
        [devDidArr addObject:devModel.did];
    }
//    if ([[device.mac uppercaseString] isEqualToString:sn]){
        jian =NO;
        dispatch_async(dispatch_get_main_queue(), ^{
            [[BLLet sharedLet].familyManager queryLoginUserFamilyIdListWithCompletionHandler:^(BLFamilyIdListGetResult * _Nonnull result) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (result.error == 0) {
                        NSArray * arr = result.idList;
                        if (arr.count>0) {    //查到有家庭 --》绑定设备
                            NSMutableArray *mutArr = [[NSMutableArray alloc]init];
                            
                            BLModuleInfo *moduleInfo = [[BLModuleInfo alloc] init];
                            BLFamilyIdInfo *idinfo = result.idList.firstObject;
                            [mutArr addObject:idinfo.familyId];
                            moduleInfo.familyId = idinfo.familyId;
                            moduleInfo.roomId = @"";
                            moduleInfo.name = device.name;
                            moduleInfo.iconPath = [DeviceInfoManager sharedManager].imagePath;
                            moduleInfo.followDev =1;
                            moduleInfo.order = 1;
                            moduleInfo.flag = 1;
                            moduleInfo.moduleType = 3;
                            moduleInfo.extend = uuid;//这里用获取到的设备的UUID 来传给这个extend字段 是为了后面的固件升级需求要的ali的uuid入参做准备，传给服务器，下次请求家庭设备信息的时候，有个字段blmoudleinfo里面的extend就可以当做固件升级的UUID入参
                            BLModuleIncludeDev *moduleDevs = [[BLModuleIncludeDev alloc] initWithDictionary:@{
                                                                                                              @"did" : device.did,
                                                                                                              @"sdid" : @"",
                                                                                                              @"order" : @0,
                                                                                                              @"content" : @""
                                                                                                              }];
                            moduleInfo.moduleDevs = @[moduleDevs];
                            
                            
                            BLFamilyDeviceInfo *familyinfo = [[BLFamilyDeviceInfo alloc]init];
                            familyinfo.familyId = idinfo.familyId;
                            familyinfo.roomId = @"";
                            familyinfo.did = device.did;
                            familyinfo.password = device.password;
                            familyinfo.type = device.type;
                            familyinfo.pid = device.pid;
                            familyinfo.mac = device.mac;
                            familyinfo.name = device.name;
                            familyinfo.lock = device.lock;
                            familyinfo.aesKey = device.controlKey;
                            NSLog(@" 加入家庭的控制1111:%@",device.controlKey);
                            familyinfo.terminalId = device.controlId;
                            familyinfo.subdeviceNum = 1;
                            familyinfo.longitude = @"1";
                            familyinfo.latitude = @"1";
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [[BLLet sharedLet].familyManager   queryFamilyInfoWithIds:mutArr completionHandler:^(BLAllFamilyInfoResult * _Nonnull result) {
                                    if(result.error == 0 ){
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            
                                            [SDSFamliyManager sharedInstance].familyinfo = result.allFamilyInfoArray.firstObject.familyBaseInfo;
                                            //绑定设备
                                            
                                            [[BLLet sharedLet].familyManager addModule:moduleInfo toFamily:[SDSFamliyManager sharedInstance].familyinfo withDevice:familyinfo subDevice:nil completionHandler:^(BLModuleControlResult * _Nonnull result) {
                                                if(result.succeed ==YES){
                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                        //把数据本地保存
                                                        if (![devDidArr containsObject:device.did]) {
                                                            [SDSsqlite AddDeviceInfo:(BLFamilyDeviceInfo *)familyinfo];
                                                            [SDSsqlite AddMoudleInfo:moduleInfo];
                                                            
                                                        }
                                                        [[NSNotificationCenter defaultCenter]postNotificationName:@"notifyJoinResult" object:nil];
                                                    });
                                                }else{
                                                    //                                                                    if ([CommonUtil isLoginExpired:result.error]) {
                                                    //
                                                    //                                                                        NSLog(@"session过期了 需要重新登录");
                                                    //
                                                    //                                                                    }else{
                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                        [[BLLet sharedLet].account refreshAccessTokenWithRefreshToken:[UserInfoManager sharedTool].RefreshToken clientId:LiangBaClientID clientSecret:CLIENT_SECRET completionHandler:^(BLOauthResult * _Nonnull result) {
                                                            
                                                            [[NSUserDefaults standardUserDefaults]setObject:result.refreshToken forKey:REFRESHTOKEN];
                                                            [[NSUserDefaults standardUserDefaults]setObject:result.accessToken forKey:DEVICETOKEN];
                                                            [[NSUserDefaults standardUserDefaults] synchronize];
                                                            
                                                            [[BLLet sharedLet].familyManager addModule:moduleInfo toFamily:[SDSFamliyManager sharedInstance].familyinfo withDevice:familyinfo subDevice:nil completionHandler:^(BLModuleControlResult * _Nonnull result) {
                                                                if(result.succeed ==YES){
                                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                                        //把数据本地保存
                                                                        if (![devDidArr containsObject:device.did]) {
                                                                            [SDSsqlite AddDeviceInfo:(BLFamilyDeviceInfo *)familyinfo];
                                                                            [SDSsqlite AddMoudleInfo:moduleInfo];
                                                                            
                                                                        }
                                                                        [[NSNotificationCenter defaultCenter]postNotificationName:@"notifyJoinResult" object:nil];
                                                                    });
                                                                    
                                                                }else{
                                                                    if ([CommonUtil isLoginExpired:result.error]) {
                                                                        
                                                                        NSLog(@"session过期了 需要重新登录");
                                                                        
                                                                    }else{
                                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                                            
                                                                            [[NSNotificationCenter defaultCenter]postNotificationName:@"notifyJoinResultError" object:nil];
                                                                        });
                                                                    }
                                                                }
                                                            }];
                                                        }];
                                                    });
                                                    //                                                                    }
                                                }
                                            }];
                                        });
                                    }else{
                                        //                                                        }else{ //通过id 找家庭信息 - 》失败 - 》刷新token -》再次请求家庭信息
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            
                                            [[BLLet sharedLet].account refreshAccessTokenWithRefreshToken:[UserInfoManager sharedTool].RefreshToken clientId:LiangBaClientID clientSecret:CLIENT_SECRET completionHandler:^(BLOauthResult * _Nonnull result) {
                                                
                                                [[NSUserDefaults standardUserDefaults]setObject:result.refreshToken forKey:REFRESHTOKEN];
                                                [[NSUserDefaults standardUserDefaults]setObject:result.accessToken forKey:DEVICETOKEN];
                                                [[NSUserDefaults standardUserDefaults] synchronize];
                                                
                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                    
                                                    [[BLLet sharedLet].familyManager   queryFamilyInfoWithIds:mutArr completionHandler:^(BLAllFamilyInfoResult * _Nonnull result) {
                                                        if(result.error == 0 ){
                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                
                                                                [SDSFamliyManager sharedInstance].familyinfo = result.allFamilyInfoArray.firstObject.familyBaseInfo;
                                                                //绑定设备
                                                                [[BLLet sharedLet].familyManager addModule:moduleInfo toFamily:[SDSFamliyManager sharedInstance].familyinfo withDevice:familyinfo subDevice:nil completionHandler:^(BLModuleControlResult * _Nonnull result) {
                                                                    if(result.succeed ==YES){
                                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                                            //把数据本地保存
                                                                            if (![devDidArr containsObject:device.did]) {
                                                                                [SDSsqlite AddDeviceInfo:(BLFamilyDeviceInfo *)familyinfo];
                                                                                [SDSsqlite AddMoudleInfo:moduleInfo];
                                                                                
                                                                            }
                                                                            [[NSNotificationCenter defaultCenter]postNotificationName:@"notifyJoinResult" object:nil];
                                                                        });
                                                                        
                                                                    }else{
                                                                        if ([CommonUtil isLoginExpired:result.error]) {
                                                                            
                                                                            NSLog(@"session过期了 需要重新登录");
                                                                            
                                                                        }else{
                                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                                [[NSNotificationCenter defaultCenter]postNotificationName:@"notifyJoinResultError" object:nil];
                                                                            });
                                                                        }
                                                                    }
                                                                }];
                                                            });
                                                        }else{
                                                            if ([CommonUtil isLoginExpired:result.error]) {
                                                                
                                                                NSLog(@"session过期了 需要重新登录");
                                                                
                                                            }else{
                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                    
                                                                    [[NSNotificationCenter defaultCenter]postNotificationName:@"notifyJoinResultError" object:nil];
                                                                });
                                                            }
                                                        }
                                                    }];
                                                });
                                            }];
                                        });
                                    }
                                }];
                            });
                        }
                    }else{
                        //                                        if ([CommonUtil isLoginExpired:result.error]) {
                        //
                        //                                            NSLog(@"session过期了 需要重新登录");
                        //
                        //                                        }else{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            [[BLLet sharedLet].account refreshAccessTokenWithRefreshToken:[UserInfoManager sharedTool].RefreshToken clientId:LiangBaClientID clientSecret:CLIENT_SECRET completionHandler:^(BLOauthResult * _Nonnull result) {
                                
                                [[NSUserDefaults standardUserDefaults]setObject:result.refreshToken forKey:REFRESHTOKEN];
                                [[NSUserDefaults standardUserDefaults]setObject:result.accessToken forKey:DEVICETOKEN];
                                [[NSUserDefaults standardUserDefaults] synchronize];
                                
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    
                                    [[BLLet sharedLet].familyManager queryLoginUserFamilyIdListWithCompletionHandler:^(BLFamilyIdListGetResult * _Nonnull result) {
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            if (result.error == 0) {
                                                NSArray * arr = result.idList;
                                                if (arr.count>0) {    //查到有家庭 --》绑定设备
                                                    NSMutableArray *mutArr = [[NSMutableArray alloc]init];
                                                    
                                                    BLModuleInfo *moduleInfo = [[BLModuleInfo alloc] init];
                                                    BLFamilyIdInfo *idinfo = result.idList.firstObject;
                                                    [mutArr addObject:idinfo.familyId];
                                                    moduleInfo.familyId = idinfo.familyId;
                                                    moduleInfo.roomId = @"";
                                                    moduleInfo.name = device.name;
                                                    moduleInfo.iconPath = [DeviceInfoManager sharedManager].imagePath;
                                                    moduleInfo.followDev =1;
                                                    moduleInfo.order = 1;
                                                    moduleInfo.flag = 1;
                                                    moduleInfo.moduleType = 3;
                                                    moduleInfo.extend = uuid;//这里用获取到的设备的UUID 来传给这个extend字段 是为了后面的固件升级需求要的ali的uuid入参做准备，传给服务器，下次请求家庭设备信息的时候，有个字段blmoudleinfo里面的extend就可以当做固件升级的UUID入参
                                                    BLModuleIncludeDev *moduleDevs = [[BLModuleIncludeDev alloc] initWithDictionary:@{
                                                                                                                                      @"did" : device.did,
                                                                                                                                      @"sdid" : @"",
                                                                                                                                      @"order" : @0,
                                                                                                                                      @"content" : @""
                                                                                                                                      }];
                                                    moduleInfo.moduleDevs = @[moduleDevs];
                                                    BLFamilyDeviceInfo *familyinfo = [[BLFamilyDeviceInfo alloc]init];
                                                    familyinfo.familyId = idinfo.familyId;
                                                    familyinfo.roomId = @"";
                                                    familyinfo.did = device.did;
                                                    familyinfo.password = device.password;
                                                    familyinfo.type = device.type;
                                                    familyinfo.pid = device.pid;
                                                    familyinfo.mac = device.mac;
                                                    familyinfo.name = device.name;
                                                    familyinfo.lock = device.lock;
                                                    familyinfo.aesKey = device.controlKey;
                                                     NSLog(@" 加入家庭的控制333:%@",device.controlKey);
                                                    familyinfo.terminalId = device.controlId;
                                                    familyinfo.subdeviceNum = 1;
                                                    familyinfo.longitude = @"1";
                                                    familyinfo.latitude = @"1";
                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                        [[BLLet sharedLet].familyManager   queryFamilyInfoWithIds:mutArr completionHandler:^(BLAllFamilyInfoResult * _Nonnull result) {
                                                            if(result.error == 0 ){
                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                    
                                                                    [SDSFamliyManager sharedInstance].familyinfo = result.allFamilyInfoArray.firstObject.familyBaseInfo;
                                                                    //绑定设备
                                                                    [[BLLet sharedLet].familyManager addModule:moduleInfo toFamily:[SDSFamliyManager sharedInstance].familyinfo withDevice:familyinfo subDevice:nil completionHandler:^(BLModuleControlResult * _Nonnull result) {
                                                                        if(result.succeed ==YES){
                                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                                
                                                                                //把数据本地保存
                                                                                if (![devDidArr containsObject:device.did]) {
                                                                                    [SDSsqlite AddDeviceInfo:(BLFamilyDeviceInfo *)familyinfo];
                                                                                    [SDSsqlite AddMoudleInfo:moduleInfo];
                                                                                    
                                                                                }
                                                                                [[NSNotificationCenter defaultCenter]postNotificationName:@"notifyJoinResult" object:nil];
                                                                            });
                                                                            
                                                                        }else{
                                                                            if ([CommonUtil isLoginExpired:result.error]) {
                                                                                
                                                                                NSLog(@"session过期了 需要重新登录");
                                                                                
                                                                            }else{
                                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                                    [[NSNotificationCenter defaultCenter]postNotificationName:@"notifyJoinResultError" object:nil];
                                                                                });
                                                                            }
                                                                        }
                                                                    }];
                                                                });
                                                                
                                                            }else{
                                                                if ([CommonUtil isLoginExpired:result.error]) {
                                                                    
                                                                    NSLog(@"session过期了 需要重新登录");
                                                                    
                                                                }else{
                                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                                        [[NSNotificationCenter defaultCenter]postNotificationName:@"notifyJoinResultError" object:nil];
                                                                    });
                                                                }
                                                            }
                                                        }];
                                                    });
                                                }
                                            }else{
                                                if ([CommonUtil isLoginExpired:result.error]) {
                                                    
                                                    NSLog(@"session过期了 需要重新登录");
                                                    
                                                }else{
                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                        [[NSNotificationCenter defaultCenter]postNotificationName:@"notifyJoinResultError" object:nil];
                                                    });
                                                }
                                                
                                            }
                                        });
                                    }];
                                });
                            }];
                        });
                        //
                    }
                });
            }];
        });
//        break;  //找到了 就跳出
//    }
}


-(void)notifyJoinResult:(id)result withError:(NSError *)err {
   
    self.timeCount = 69;
    
    if (err != nil) {
        
        NSLog(@"notifyJoinResult 入网失败，err :%@", err);
        if (err.code == LKDCErrCodeIllegalToken) {
            //账号登录超过一个时期，账号token失效，此时需要调起登录页面重新登录一下账号。这个错误必须处理。否则重试还会失败
            if ([CommonUtil isLoginExpired:err.code]) {
                
                NSLog(@"session过期了 需要重新登录");
            }
        }else{
            [[NSNotificationCenter defaultCenter]postNotificationName:@"notifyJoinResultError" object:nil];
        }
    } else {   // aliSDK 的入网成功 分支 --》 进行晾霸的 入网成功的判断
        
        NSLog(@"notifyJoinResult 入网成功，result :%@", result);
        NSString * sn =  [kLkAddDevBiz getCurrentDevice].sn;//获取当前配网设备的sn
        sn = [sn uppercaseString ];
        [[NetworkTool sharedTool]requestWithURLparameters:@{} method:@"mtop.openalink.app.core.devices.getbyuser" View:nil sessionExpiredOption:AKLoginOptionAutoLoginOnly needLogin:YES callBack:^(AlinkResponse* responseObject) {
             uuid = nil;
            NSDictionary * dataDic = responseObject.dataObject[0];
//            data = [BindDeviceInformationlistModel mj_objectArrayWithKeyValuesArray:data];
//            for (BindDeviceInformationlistModel *model in data) {
                if ([[dataDic[@"sn"] uppercaseString] isEqualToString:sn]) {
                    uuid = dataDic[@"uuid"];
                }
            self.mac = sn;
            
//            for (BLDNADevice *device in [LiangBaDevice sharedInstance].deviceArray ) {
//                [[BLLet sharedLet].controller removeDevice:device];
//            }
            NSMutableArray * SqliteDeviceInfoArr = [SDSsqlite FindDeviceInfoWithFamilyID:nil ];
            for (BLFamilyDeviceInfo *devModel in SqliteDeviceInfoArr) {
                if ([[devModel.mac uppercaseString] isEqualToString:[sn uppercaseString]]) {
                    [SDSsqlite deleteDeviceWithDeviceDid:devModel.did];
                }
            }
            [[BLLet sharedLet].controller removeAllDevice];
            
            
            [[LiangBaDevice sharedInstance].deviceArray removeAllObjects];
            [[LiangBaDevice sharedInstance].XINGHAOArr removeAllObjects];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"isSearchedDev" object:@{@"status":@"start"}];
            self.myTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(function:) userInfo:nil repeats:YES];
            [_myTimer setFireDate:[NSDate distantPast]];
            
//            }
//            if([LiangBaDevice sharedInstance].XINGHAOArr.count<1){
//                dispatch_async(dispatch_get_main_queue(), ^{
//
//                    [[NSNotificationCenter defaultCenter]postNotificationName:@"notifyJoinResultError" object:nil];
//                });
//
//                NSLog(@"[LiangBaDevice sharedInstance].XINGHAOArr的个数是0");
//            }else{
//                NSUInteger findTime =[LiangBaDevice sharedInstance].XINGHAOArr.count;
//                for (BLDNADevice *device in [LiangBaDevice sharedInstance].XINGHAOArr){
//                    if (jian == YES) {
//                         findTime--; //查一次就让他减一
//                    }else{ //没有找到 这一次
//                        if (jian == YES) {
//                            if (findTime ==0) { //最后一次查不到  就设备绑定失败
//                                dispatch_async(dispatch_get_main_queue(), ^{
//
//                                    [[NSNotificationCenter defaultCenter]postNotificationName:@"notifyJoinResultError" object:nil];
//                                });
//                            }
//                        }
//                    }
//                }
//            }
        } errorBack:^(id error) {
            NSError *err = error;
            if (err.code != LKDCErrCodeIllegalToken) {
                //账号登录超过一个时期，账号token失效，此时需要调起登录页面重新登录一下账号。这个错误必须处理。否则重试还会失败
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"notifyJoinResultError" object:nil];
                });
            } 
        }];
        
    }
}

@end
