//
//  BLDeviceWebControlPlugin.m
//  Let
//
//  Created by junjie.zhu on 2016/10/31.
//  Copyright © 2016年 BroadLink Co., Ltd. All rights reserved.
//

#import "BLDeviceWebControlPlugin.h"
#import "BLDeviceService.h"
#import "BLLet.h"
#import "JsCallBackModelManager.h"
#import "JSCallBackDeviceModel.h"
#import "BlJsBackModel.h"
#import "AliJSBackModel.h"
#define kDevice_Is_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
@implementation BLDeviceWebControlPlugin
-(void)dealloc{
   
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (id)init {
    if (self = [super init]) {
         
    }
    return self;
}
-(void)getToolBarHeight:(CDVInvokedUrlCommand *)command{
    [self.commandDelegate runInBackground:^{
        
        NSString * height = @"44";
        
        NSDictionary *dic = @{
                              @"toolbar_height":height
                              };
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:[CommonUtil dictionaryToJson:dic]];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
    
}
-(void)getStatusBarHeight:(CDVInvokedUrlCommand *)command{
    [self.commandDelegate runInBackground:^{
        
        NSString * height = @"0";
        if (kDevice_Is_iPhoneX) {
            height = @"40";
        }else{
            height = @"20";
        }
        NSDictionary *dic = @{
            @"statusbar_height":height
        };
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:[CommonUtil dictionaryToJson:dic]];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
}
-(void)defalut:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.viewController.navigationController popViewControllerAnimated:YES];
        });
    }];
}
- (void)openDevicePropertyPage:(CDVInvokedUrlCommand *)command {
    [[NSNotificationCenter defaultCenter ]postNotificationName:@"openDevicePropertyPage" object:nil];
}
-(void)closeWebView:(CDVInvokedUrlCommand *)command {
     [[NSNotificationCenter defaultCenter ]postNotificationName:@"closeWebView" object:nil];
}

//自定义导航栏
- (void)custom:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (command.arguments != nil) {
                NSNotification * notice = [NSNotification notificationWithName:BL_H5_NAVI object:nil userInfo:@{@"hander":command.arguments}];
                [[NSNotificationCenter defaultCenter]postNotification:notice];
            }
            CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_NO_RESULT messageAsString:@"error"];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        });
    }];
}
- (void)saveSceneCmds:(CDVInvokedUrlCommand *)command {
//    [self.commandDelegate runInBackground:^{
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (command.arguments != nil) {
//                NSDictionary *dic = command.arguments.firstObject;
//                NSString *name = dic[@"name"];
//                NSArray *cmds = dic[@"cmds"];
//                NSMutableArray *params = [NSMutableArray array];
//                NSMutableArray *values = [NSMutableArray array];
//                for (NSDictionary *cmd in cmds) {
//                    NSArray *paramArray = cmd[@"params"];
//                    NSArray *vals = cmd[@"vals"];
//                    [params addObjectsFromArray:paramArray];
//                    NSMutableArray *vval = [NSMutableArray arrayWithCapacity:0];
//                    for (NSNumber *val in vals) {
//                        NSDictionary *tempDic = @{
//                                                  @"idx":@"0",
//                                                  @"val":val,
//                                                  };
//                        [vval addObject:tempDic];
//                    }
//                    [values addObjectsFromArray:vval];
//                }
//                NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
//                userInfo[@"dataArr"] = values;
//                userInfo[@"paramArr"] = params;
//                userInfo[@"name"] = name;
//                BLDeviceService *deviceService = [BLDeviceService sharedDeviceService];
//                BLDNADevice *selectDevice = deviceService.selectDevice;
//                userInfo[@"did"] = selectDevice.did;
//                userInfo[@"pid"] = selectDevice.pid;
//
//                for (BLModuleInfo *moudel in [CustomFamilyInfoManager sharedInstance].currentFamilyAllInfo.moduleBaseInfo) {
//                    if (moudel.followDev == 1) {
//                        if ((NSNull *)moudel.moduleDevs  == [NSNull null]) {
//                        }else {
//                            if ([moudel.moduleDevs.firstObject[@"did"] isEqualToString:selectDevice.did]) {
//                                userInfo[@"modelName"] = moudel.name;
//                            }
//                        }
//
//                    }
//                }
//                [[NSNotificationCenter defaultCenter]postNotificationName:kCordovaInfoNotification object:nil userInfo:userInfo];
//            }
//            CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_NO_RESULT messageAsString:@"error"];
//            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
//        });
//    }];
}
- (void)deviceinfo:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{
        BLDeviceService *deviceService = [BLDeviceService sharedDeviceService];
        BLController *selectControl = deviceService.blController;
        BLDNADevice *selectDevice = deviceService.selectDevice;
        NSString *accountName = deviceService.accountName;
        
        NSString *deviceinfoJsonString = [NSString stringWithFormat:@"{\"deviceID\":\"%@\",\"deviceName\":\"%@\", \"deviceStatus\":%ld,\"networkStatus\":{\"status\":\"available\"},\"user\":{\"name\":\"%@\"}}", [selectDevice getDid], [selectDevice getName], BL_DEVICE_STATE_LAN, accountName];  //(long)[selectControl queryDeviceState:[selectDevice getDid]]
        
        NSLog(@"%@", deviceinfoJsonString);
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:deviceinfoJsonString];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
}

- (void)devicecontrol:(CDVInvokedUrlCommand*)command {
    [self.commandDelegate runInBackground:^{
        [self actWithControlParam:command.arguments andBlock:^(BOOL ret, NSDictionary *dic) {
            CDVPluginResult* pluginResult;
            if (ret) {
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:[self p_toJsonString:dic]];
            }
            else {
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[self p_toJsonString:dic]];
            }
            
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }];
    }];
}
- (void)actWithControlParam:(NSArray *)info andBlock:(void(^)(BOOL ret, NSDictionary *dic))mainBlock {

    BLDeviceService *deviceService = [BLDeviceService sharedDeviceService];
    BLController *selectControl = deviceService.blController;
    BLDNADevice *selectDevice = deviceService.selectDevice;

    NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithCapacity:0];
    [dataDic setObject:[selectDevice getDid] forKey:@"did"];
    [dataDic setDictionary:[info objectAtIndex:2]];
    NSString *dataStr = [self p_toJsonString:dataDic];
    NSString *controlResult = [[BLLet sharedLet].controller dnaControl:[selectDevice getDid] subDevDid:nil
                       dataStr:dataStr command:info[3] scriptPath:nil];
    
      mainBlock(YES, [self p_toDictory:controlResult]);
////    INFO ----》的格式
//    //   (
////    (null),
////    <null>,
////    {
////        act = set;
////        params =     (
////                      pwr
////                      );
////        srv = "4.1.50";
////        vals =     (
////                    (
////                     {
////                         idx = 1;
////                         val = 0;
////                     }
////                     )
////                    );
////    },
////    dev_ctrl
////    )
//
//
//     NSString * status = [dataDic valueForKey:@"act"] ;
//
//    if ([status isEqualToString:@"set"]) {
//                //设置设备的状态
//
//        NSMutableArray * AliparamsArr = [[NSMutableArray alloc]init];
//        NSMutableArray * BlparamsArr = [[NSMutableArray alloc]init];
//                for (AliJSBackModel *model in [JsCallBackModelManager sharedManager].model.params_ali)
//                  {
//                      [AliparamsArr addObject:model.key];
//
//                      }
//              for (BlJsBackModel *model in [JsCallBackModelManager sharedManager].model.params_bl)
//                    {
//                        [BlparamsArr addObject:model.key];
//
//                    }
//              NSArray  * valArr = [dataDic valueForKey:@"vals"];
//              NSMutableDictionary * paramsDic = [[NSMutableDictionary  alloc]init];
//              NSMutableArray * blArr = [dataDic valueForKey:@"params"];
//                    for (int i= 0; i<blArr.count; i++) {
//                        for (int j = 0; j<BlparamsArr.count; j++) {
//                            if (blArr[i]==BlparamsArr[j]) {
//
//                                NSString *key =AliparamsArr[j];
//                                NSArray *varr = valArr[i];
//                                NSDictionary * valDic = varr.firstObject;
//                                NSString *value = [NSString stringWithFormat:@"%@",[valDic objectForKey:@"val"]];
//                                [paramsDic setObject:@{@"value":value} forKey:key];
//
//                            }
//                        }
//                    }
//
//            AlinkRequest *request1 = [[AlinkRequest alloc] init];
//            request1.method = @"mtop.openalink.app.core.device.set.status";
//            request1.params = @{@"uuid":DEVICEMoudleManger.listModel.uuid,@"setParams":[self dictionaryToJson:paramsDic/*@{@"Switch":@{@"value":val}}*/]};
//            request1.needLogin = YES; //YES or NO
//            request1.sessionExpiredOption = AKLoginOptionAutoLoginOnly;
//            [AlinkSDK.sharedManager invokeWithRequest:request1 completionHandler:^(AlinkResponse * _Nonnull response) {
//                NSError *outError = nil;
//                if (response.successed) {
//                    NSDictionary * Backdic =@{
//                                              @"data" : @{
//                                                      @"did": @"00000F205E005C00000034EA34B5D909",
//                                                      @"params" :[dataDic valueForKey:@"params"],
//                                                      @"vals"   : [dataDic valueForKey:@"vals"]
//                                                      },
//                                              @"msg":@"",
//                                              @"status" : @(0)
//                                              };
//
//
//                    mainBlock(YES, Backdic);
//
//                    NSLog(@"--------------------------------------%@",response);
//
//                }
//                else {
//                    NSDictionary * Backdic =@{
//                                              @"msg":@"请求失败",
//                                              @"status" : @"1000"
//                                              };
//                    mainBlock(YES, Backdic);
//                    outError = response.responseError;
//                    NSLog(@"outErroroutErroroutErroroutErroroutError=======%@",outError);
//                }
//            }];
//    }else if([status isEqualToString:@"get"]){
//
//            // 获取设备最新状态
//            AlinkRequest *request = [[AlinkRequest alloc] init];
//            request.method = @"mtop.openalink.app.core.device.get.status";
//            request.params = @{@"uuid": DEVICEMoudleManger.listModel.uuid};
//            request.needLogin = YES; //YES or NO
//            request.sessionExpiredOption = AKLoginOptionAutoLoginOnly;
//            [AlinkSDK.sharedManager invokeWithRequest:request completionHandler:^(AlinkResponse * _Nonnull response) {
//                NSError *outError = nil;
//                if (response.successed) {
//                    NSMutableArray * AliparamsArr = [[NSMutableArray alloc]init];
//                    NSMutableArray * BlparamsArr = [[NSMutableArray alloc]init];
//                    NSMutableArray * valsArr = [[NSMutableArray alloc]init];//valueArr
//                    NSMutableArray * paramArr = [[NSMutableArray alloc]init];//paramsArr
//                    for (AliJSBackModel *model in [JsCallBackModelManager sharedManager].model.params_ali) {
//                        [AliparamsArr addObject:model.key];
//                    }
//                    for (BlJsBackModel *model in [JsCallBackModelManager sharedManager].model.params_bl) {
//                        [BlparamsArr addObject:model.key];
//                    }
//                    NSDictionary *dic = response.dataObject;
//                    NSArray *allKeyS = dic.allKeys;
//                    for ( int i =0; i<AliparamsArr.count; i++) {
//                        for (int j = 0; j<allKeyS.count; j++) {
//                            if (AliparamsArr[i]==allKeyS[j]) {
//                                [paramArr addObject:BlparamsArr[i]];  //paramsArr
//
//                                NSDictionary * valueDic = nil; //valueArr
//                                valueDic = [dic objectForKey:allKeyS[j]];
//                                NSString * val1= [valueDic objectForKey:@"value"];
//                                NSMutableArray * subArr = [[NSMutableArray alloc]init];
//                                NSDictionary *subDic = @{
//                                                         @"idx":@(1),
//                                                         @"val" : @([val1 intValue])
//                                                         };
//
//                                [subArr addObject:subDic];
//                                [valsArr addObject:subArr];
//                            }
//                        }
//
//                    }
//                    NSLog(@"-------------------------------------99999-%@",response);
//                    NSDictionary * Backdic =@{
//                                              @"data" : @{
//                                                      @"did": @"00000F205E005C00000034EA34B5D909",
//                                                      @"params" : paramArr,
//                                                      @"vals": valsArr/*@[
//                                                              @[
//                                                                  @{
//                                                                      @"idx":@(1),
//                                                                      @"val" : @([val1 intValue])
//                                                                      }
//                                                                  ]
//                                                              ]*/
//                                                      },
//                                              @"msg":@"",
//                                              @"status" : @(0)
//                                              };
//
//
//                    mainBlock(YES, Backdic);
//                }
//                else {
//                    outError = response.responseError;
//                    NSDictionary * Backdic =@{
//                                              @"msg":@"请求失败",
//                                              @"status" : @"1000"
//                                              };
//                    mainBlock(YES, Backdic);
//                    NSLog(@"outErroroutErroroutErroroutErroroutError=======%@",outError);
//                }
//            }];
//
//    }
}
- (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}
- (void)notification:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{
        BLDeviceService *deviceService = [BLDeviceService sharedDeviceService];
        BLDNADevice *selectDevice = deviceService.selectDevice;
        
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[selectDevice getDid], @"did", nil];
        NSString *echo = [self p_toJsonString:dic];
        
        CDVPluginResult* pluginResult;
        if (echo && [echo length] > 0) {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:echo];
        }
        else {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
        }
        
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
}

#pragma mark - private
- (NSString *)p_toJsonString:(NSDictionary *)dic {
    NSError *error;
    NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:0 error:&error];
    if (error) {
        NSLog(@"%@", error.localizedDescription);
        return nil;
    }
    
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

- (NSDictionary *)p_toDictory:(NSString *)jsonString {
    NSError *error;
    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (error) {
        NSLog(@"%@", error.localizedDescription);
        return nil;
    }
    
    return dic;
}

@end
