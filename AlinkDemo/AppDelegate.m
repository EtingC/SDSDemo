//
//  AppDelegate.m
//  AlinkDemo
//
//  Created by Dong on 2016/12/28.
//  Copyright © 2016年 aliyun. All rights reserved.
//
#define LiangBaSDSLicense @"FJfuJMvyNn3sw/jt0E089EjYJCx00DfL1cozOdZqpPagfnBUwCG5lTpfgMydwwdnxzQZWgAAAAB9NpydyrFSUtnVczXPZzCKuF/g+RbQkKz6vW+j8pKatCjPGNS8vbMTL2q2DnAOfM2zQ8KDv0v9YmR5MJmQrYwFBdfyRAv01RZMW2+sVsjOhQAAAAA="
#define SDSLicense @"eXvqmOCozfEpGyAJBkl5hGmW/LCXNB7ea45CqFlfboVS3p1K6KHzSVl54tgpbw5nrHPoWQAAAACIWIhYgyIAzT36dGvsKN4bzAReGkwnmhezW5Y05374efmibKIXBssLcNEQNdjg0wvSd7CeFaOhhB3TR3ltupsAsEkbxXTfoUSQjDzWcfVjcAAAAAA="
#define LiangBaSDSAppKey @"24710846"
#define SDSAppKey @"24544065"
#import "AppDelegate.h"

#import <UserNotifications/UserNotifications.h>
#import "RootViewController.h"
#import <AlinkSDK/AlinkOpenSDK.h>
#import <CocoaLumberjack/CocoaLumberjack.h>
#import "DemoLoggingFormatter.h"
#import <AlinkSDK/AlinkOpenSDK.h>
#import <CocoaLumberjack/CocoaLumberjack.h>
#import "DemoLoggingFormatter.h"
#import "MyLoginMoudle.h"
#import <AKLog/AKLog.h>
#import <AlinkDeviceCenter/LKLogAndTrackHelper.h>
#import "FailureAddViewController.h"
#import "LiangBaLoginViewController.h"
#import "LocalLoginViewController.h"
#import "DeviceViewController.h"
#define kApplication        [UIApplication sharedApplication]
DDLogLevel ddLogLevel = DDLogLevelAll;

@interface AppDelegate () <UISplitViewControllerDelegate,UNUserNotificationCenterDelegate,BLControllerDelegate>

@property(nonatomic,strong)NSData*deviceToken;
@property(nonatomic,strong)BLLet *let;
@property(nonatomic,strong) UISegmentedControl *Boneseg,*seg;
@property(nonatomic,assign) BOOL isSearchedDev;
@end

@implementation AppDelegate
{
    // iOS 10通知中心
    UNUserNotificationCenter *_notificationCenter;
}
-(void)CheckTheNetChange{
    AFNetworkReachabilityManager *afNetworkReachabilityManager = [AFNetworkReachabilityManager sharedManager];
   
    [afNetworkReachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:{
                NSLog(@"网络不通：%@",@(status) );
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWiFi:{
                NSLog(@"网络通过WIFI连接：%@",@(status));
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWWAN:{
                NSLog(@"网络通过无线连接：%@",@(status) );
                break;
            }
            default:
                break;
        }
        
        NSLog(@"网络状态数字返回：%@",@(status));
        NSLog(@"网络状态返回: %@", AFStringFromNetworkReachabilityStatus(status));
        
        NSLog(@"isReachable: %@",@([AFNetworkReachabilityManager sharedManager].isReachable));
        NSLog(@"isReachableViaWWAN: %@",@([AFNetworkReachabilityManager sharedManager].isReachableViaWWAN));
        NSLog(@"isReachableViaWiFi: %@",@([AFNetworkReachabilityManager sharedManager].isReachableViaWiFi));
    }];
    [afNetworkReachabilityManager startMonitoring];  //开启网络监视器；
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.isSearchedDev = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeISearchDec:) name:@"isSearchedDev" object:nil];
    [self CheckTheNetChange];
    [self loadAppSdk];
    [self loadAlliSDK];
    /*SDS项目 开发代码内容  基础框架 如下/上*/
    sleep(1);
    
    //6、初始化窗口、设置根控制器、显示窗口
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    NSString * Autologin =[DATACache objectForKey:ISLOGIN];
    if ([Autologin isEqualToString:@"YES"]) {
        LocalLoginViewController * vc = [[LocalLoginViewController alloc]init];
        [self.window setRootViewController: vc];
        [self.window makeKeyAndVisible];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[BLLet sharedLet].account localLoginWithUsrid:[DATACache objectForKey:ACCOUNT] session:[DATACache objectForKey:SESSION] completionHandler:^(BLLoginResult * _Nonnull result) {
                if (result.error==0) {
                    [SDSsqlite createDatabase];
                    dispatch_async(dispatch_get_main_queue(), ^{
//                        DeviceViewController *vc = [[DeviceViewController alloc]init];
//                        NaviViewController *nav = [[NaviViewController alloc] initWithRootViewController:vc];
                        RootViewController * nav = [[RootViewController alloc]init];
                        nav.selectedIndex = 0;
                        [[AppDelegate shareAppDelegate].window setRootViewController:nav];
                        [self.window makeKeyAndVisible];
                    });
                }else{
                    
                    if ([CommonUtil isLoginExpired:result.error]) {
                        
                        NSLog(@"session过期了 需要重新登录");
                        
                    }else{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [CommonUtil setTip:result.msg];
                        });
                    }
                }
            }];
        });
    }else{
        UIStoryboard * strory = [UIStoryboard  storyboardWithName:@"LliangBaStoryBoard" bundle:[NSBundle mainBundle]];
        LiangBaLoginViewController *jibenvc = [strory instantiateViewControllerWithIdentifier:@"LiangBaLoginViewController"];
        NaviViewController *nav = [[NaviViewController alloc] initWithRootViewController:jibenvc];
        [self.window setRootViewController: nav];
        [self.window makeKeyAndVisible];
    }
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reLogin) name:@"RELOGIN_NOTIFICATION" object:nil];
       [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(setHomeVC) name:kAKNotificationUserLoggedIn object:nil];
    return YES;
}
-(void)setHomeVC{
 
//    DeviceViewController *vc = [[DeviceViewController alloc]init];
//    NaviViewController *nav = [[NaviViewController alloc] initWithRootViewController:vc];
//    [[AppDelegate shareAppDelegate].window setRootViewController:nav];
//    [self.window makeKeyAndVisible];
    [SDSsqlite createDatabase];
    RootViewController * nav = [[RootViewController alloc]init];
    nav.selectedIndex = 0;
    [[AppDelegate shareAppDelegate].window setRootViewController:nav];
    [self.window makeKeyAndVisible];
}
-(void)loadAlliSDK{
    
#warning  请先配置好 Bundle ID 和 安全图片(yw_1222.jpg)!!!
   
    //设置AlinkSDK环境，指定appKey
    AlinkEnvConfig *envConfig = [AlinkEnvConfig sharedInstance];
    envConfig.appKey = LiangBaSDSAppKey;
    //    //打开日志模块，Release版本请记得关闭
    [envConfig openDebugLog:NO];
    [AKLog setDelegate:[AKDDLog sharedInstance]];
    [AKLog turnLogOn:NO];
    [LKLogAndTrackHelper setDelegate:(id<AKLogDelegate>)[AKDDLog sharedInstance]];
    [LKLogAndTrackHelper turnLogOn:NO];
    //安装自定义登录协议，默认实现是OpenAccount，自定义登录协议请参照实现
    
    MyLoginMoudle *module = [[MyLoginMoudle alloc]init];
    [[AlinkAccount sharedInstance] installCustomLoginModule:module];
    
    //初始化AlinkSDK
    [kAlinkSDK asyncInit:^(NSError * _Nullable error) {
        if (!error) {
            NSLog(@"aliSDK初始化成功");
            //初始化完成，设置应用内下行通知回调（如：设备状态变更），也可通过监听kAKNotificationDownStream通知
            [kAlinkSDK setDownStreamCallback:^(NSDictionary * _Nonnull dict) {
                NSString *str = [NSString stringWithFormat:@"收到downStream: %@", dict];
                //                 NSLog(@"aliSDK初始化-------%@",str);
                //                DDLogInfo(@"%@", str);
            }];
            return;
        }
        DDLogError(@"AlinkSDK 初始化错误：%@", error);
    }];
}
+ (AppDelegate*) shareAppDelegate {
    return (AppDelegate*)[kApplication delegate];
}
-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
-(void)reLogin{
    
    UIStoryboard * strory = [UIStoryboard  storyboardWithName:@"LliangBaStoryBoard" bundle:[NSBundle mainBundle]];
    LiangBaLoginViewController *jibenvc = [strory instantiateViewControllerWithIdentifier:@"LiangBaLoginViewController"];
    NaviViewController *nav = [[NaviViewController alloc] initWithRootViewController:jibenvc];
    [[AppDelegate shareAppDelegate].window setRootViewController:nav];
}
- (void)loadAppSdk {
    
    self.let = [BLLet sharedLetWithLicense:LiangBaSDSLicense];        // Init APPSDK
    self.let.debugLog = BL_LEVEL_NONE;                           // Set APPSDK debug log level
    [self.let.controller setSDKRawDebugLevel:BL_LEVEL_NONE];     // Set DNASDK debug log level
    [self.let.controller startProbe];                           // Start probe device
    self.let.controller.delegate = self;
    
    self.let.configParam.controllerSendCount = 2;
//    self.let.configParam.controllerRepeatCount = 3;
    
   // BLPicker *pick = [BLPicker sharedPickerWithConfigParam:self.let.configParam];
   // [pick startPick];
 
}
- (void)changeISearchDec:(NSNotification *)info
{
    NSDictionary *dic = [info object];
    if ([dic[@"status"] isEqualToString:@"start"]) {
        self.isSearchedDev = NO;
    }else{
        self.isSearchedDev = YES;
    }
}

#pragma mark - BLControllerDelegate
- (Boolean)filterDevice:(BLDNADevice *)device {
    return NO;
}
- (Boolean)shouldAdd:(BLDNADevice *)device {
    return YES;
}
- (void)onDeviceUpdate:(BLDNADevice *)device isNewDevice:(Boolean)isNewDevice {
    
//    if (!self.isSearchedDev) {
    
        if (device.type == 20445 || device.type == 20184) {
            NSLog(@"devicedevicedevicedevicedevicedevicedevicedevicev%@--%@",device.name,device.did);
            if ([[LiangBaDevice sharedInstance]deviceHasAddedInDeviceArray:device] == NO) {
                NSLog(@"加入家庭的控制key000：%@",device.controlKey);
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:device.controlKey delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [alert show];
//                });
                [[LiangBaDevice sharedInstance] addDeviceToDeviceArray:device];
            }
        }
        
//    }else{
//
//    }
   
   
}
-(NSInteger)currentBoneENV{
    NSNumber*BoneENV=[[NSUserDefaults standardUserDefaults] objectForKey:@"BoneENV"];
    return BoneENV?[BoneENV integerValue]:2;
}
-(void)confirm{
    DDLogInfo(@"%ld",self.seg.selectedSegmentIndex);
    [[NSUserDefaults standardUserDefaults] setInteger:self.Boneseg.selectedSegmentIndex forKey:@"BoneENV"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[AlinkAccount sharedInstance] logout:^(NSError * _Nonnull error) {
        
    }];
    [self performSelector:@selector(reboot) withObject:nil afterDelay:1];
}

-(void)reboot{
     exit(0);
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    self.deviceToken=deviceToken;
    //上传deviceToken
    
}
- (void)registerAPNS:(UIApplication *)application {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        // iOS 8 Notifications
        [application registerUserNotificationSettings:
         [UIUserNotificationSettings settingsForTypes:
          (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge)
                                           categories:nil]];
        [application registerForRemoteNotifications];
    }
    else {
        // iOS < 8 Notifications
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
    }
}
/*
 id<IOpenStaticDataStoreComponent> component = [[OpenSecurityGuardManager getInstance] getStaticDataStoreComp];
 NSInteger keyType = [component getKeyType: @"myKey" authCode: @"myAuthCode"];
 NSLog(@"my key type is:%@",[NSString stringWithFormat: @"%d", keyType]);
 
 
 NSString* extraData = [component getExtraData: @"myKey" authCode: @"myAuthCode"];
 if(extraData)
 NSLog(@"my extradata:%@", extraData);
 
 NSString* appKey0 = [component getAppKey: [NSNumber numberWithInt: 0] authCode: @"myAuthCode];
 if(appKey0)
 NSLog(@"my appKey 0:%@", appKey0);
 */




- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"applicationWillEnterForeground" object:nil];
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"CHONGFUSHEZHI"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ZHIXINGCAOZUO"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ZHIXINGSHIJING"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"CLOSEZHIXINGSHIJING"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
