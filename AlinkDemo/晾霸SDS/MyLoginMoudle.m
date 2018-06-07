//
//  MyLoginMoudle.m
//  AlinkDemo
//
//  Created by gubeidianzi on 2017/10/27.
//  Copyright © 2017年 aliyun. All rights reserved.
//

#import "MyLoginMoudle.h"

#import <AlinkSDK/AlinkOpenSDK.h>
#import "BLFamilyIdListGetResult.h"

#import "BLGetUserInfoResult.h"
#import "LiangBaLoginViewController.h"
#import "RootViewController.h"

//使用DDLog打印日志
#import <CocoaLumberjack/CocoaLumberjack.h>
#import "BLFamilyInfo.h"
static DDLogLevel ddLogLevel = DDLogLevelAll;
@interface MyLoginMoudle()

@property (nonatomic,strong) LiangBaLoginViewController *logovc;
@property (nonatomic,strong) NSLock *lock;
@property (nonatomic,copy) NSString *nick;
@property (nonatomic,copy) NSString *iconUrl;
@property (nonatomic,copy) NSString *userid;
@property (nonatomic, assign) BOOL isPresenting; //登录框是否已弹出
@property (nonatomic, copy) void (^completionHandler)(BOOL isSuccessful, NSDictionary *loginResult);
@property (atomic, assign, getter=isInited) BOOL inited; //OpenAccount是否已初始化完成

@end
@implementation MyLoginMoudle

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    
    return self;
}
/**
 刷新登录态Token
 
 @param option 登录选项
 @param completionHandler 刷新结果回调，刷新成功loginResult为currentSession，刷新失败loginResult的key为msg，value为错误详情字符串
 */
- (void)refreshToken:(AKLoginOption)option completion:(void (^)(BOOL isSuccessful, NSDictionary *loginResult))completionHandler{
     
    //自动刷新token成功
    if (completionHandler) {
        completionHandler(YES, [self currentSession]);
    }
}
-(void)setUserInfo{
    
    
}
/**
 当前登录账号的session信息
 
 @return session信息
 */
- (NSDictionary *)currentSession {
    
    
    //以下几个协议字段必须实现
    return @{
             kAKSessionKeyAccount : [[NSUserDefaults standardUserDefaults]objectForKey:ACCOUNT] ?: @"",
             kAKSessionKeyToken :/*[[ALBBOpenAccountSession sharedInstance] sessionID]*/[[NSUserDefaults standardUserDefaults]objectForKey:DEVICETOKEN] ?: @"",
             kAKSessionKeyNick : [[NSUserDefaults standardUserDefaults]objectForKey:NICKNAME]?: @"",
             kAKSessionKeyAvatarUrl : [[NSUserDefaults standardUserDefaults]objectForKey:ICONURL] ?: @""
             };
}
/**
 登出
 
 @param completionHandler 完成回调
 */
- (void)logout:(void (^)(NSError *error))completionHandler{
    
    //发送登出通知
    [[NSNotificationCenter defaultCenter] postNotificationName:kAKNotificationUserLoggedOut object:nil];
    if (completionHandler){
        completionHandler(nil);
    }
}
#pragma mark - Helper

-(UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    //app默认windowLevel是UIWindowLevelNormal，如果不是，找到UIWindowLevelNormal的
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    id  nextResponder = nil;
    UIViewController *appRootVC=window.rootViewController;
    //    如果是present上来的appRootVC.presentedViewController 不为nil
    if (appRootVC.presentedViewController) {
        nextResponder = appRootVC.presentedViewController;
    }else{
        
        NSLog(@"===%@",[window subviews]);
        UIView *frontView = [[window subviews] objectAtIndex:0];
        nextResponder = [frontView nextResponder];
    }
    
    if ([nextResponder isKindOfClass:[UITabBarController class]]){
        UITabBarController * tabbar = (UITabBarController *)nextResponder;
        UINavigationController * nav = (UINavigationController *)tabbar.viewControllers[tabbar.selectedIndex];
        //        UINavigationController * nav = tabbar.selectedViewController ; 上下两种写法都行
        result=nav.childViewControllers.lastObject;
        
    }else if ([nextResponder isKindOfClass:[UINavigationController class]]){
        UIViewController * nav = (UIViewController *)nextResponder;
        result = nav.childViewControllers.lastObject;
    }else{
        result = nextResponder;
    }
    return result;
}
/**
 登录
 
 @param viewController      从该viewController上弹出登录框，如果viewController为nil，从keyWindow的rootViewController弹出
 @param completionHandler   登录结果回调
 @param cancelationHandler  用户取消回调
 */
- (void)loginWithViewController:(nullable UIViewController *)viewController completionHandler:(void (^)(BOOL isSuccessful, NSDictionary *loginResult))completionHandler cancelationHandler:(void (^)())cancelationHandler{
    UIViewController *vc = viewController;
    if (!vc) {
        vc = [self getCurrentVC];
    }
    self.logovc = [[LiangBaLoginViewController alloc]init];

    [[BLLet sharedLet].account queryIhcAccessTokenWithUserName:[UserInfoManager sharedTool].account  password:[UserInfoManager sharedTool].password cliendId:LiangBaClientID redirectUri:LiangBaredirectUri completionHandler:^(BLOauthResult * _Nonnull result) {// 获取accessToken

        if (result.succeed ==YES&&result.accessToken) {// 获取accessToken 和 refreshtoken->成功
            [[NSUserDefaults standardUserDefaults]setObject:result.refreshToken forKey:REFRESHTOKEN];
            [[NSUserDefaults standardUserDefaults]setObject:result.accessToken forKey:DEVICETOKEN];
            [[NSUserDefaults standardUserDefaults] synchronize];
            WeakSelf
            [BLLetAccount loginWithIhcAccessToken:[[NSUserDefaults standardUserDefaults]objectForKey:DEVICETOKEN] completionHandler:^(BLLoginResult * _Nonnull result) { //通过accessToken 获取 userid
                
                dispatch_async(dispatch_get_main_queue(), ^{
                  
                    if (result.error == 0) { //通过accessToken 获取 userid-->成功
                        [[NSUserDefaults standardUserDefaults]setObject:result.loginsession forKey:SESSION];
                        [[NSUserDefaults standardUserDefaults]setObject:[UserInfoManager sharedTool].password forKey:@"PASSWORD"];
                        [[NSUserDefaults standardUserDefaults] setObject:@[result.userid] forKey:@"thisIsUserID"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        [BLLetAccount getUserInfo:@[result.userid] completionHandler:^(BLGetUserInfoResult * _Nonnull result) { //通过userid-->获取用户的 nickname  userid  iconUrl
                            if (result.error == 0){ ////通过userid-->获取用户的 nickname  userid  iconUrl -->成功
                                NSArray * userInfo = result.info;
                                BLUserInfo * userIf = userInfo.firstObject;
                                [[NSUserDefaults standardUserDefaults]setObject:userIf.nickname forKey:NICKNAME];
                                [[NSUserDefaults standardUserDefaults]setObject:userIf.userid forKey:ACCOUNT];
                                [[NSUserDefaults standardUserDefaults]setObject:userIf.iconUrl forKey:ICONURL];
                                [[NSUserDefaults standardUserDefaults] synchronize];
                                
                                [[BLLet sharedLet].familyManager queryLoginUserFamilyIdListWithCompletionHandler:^(BLFamilyIdListGetResult * _Nonnull result) { //查询账号下的家庭
                                    if (result.error==0) { //查询账号下的家庭 -->成功
                                        
                                        NSArray * arr = result.idList;
                                        if (arr.count>0) { //账号下有家庭
                                            if (completionHandler) {
                                                completionHandler(YES, [weakSelf currentSession]);
                                            }
                                            BLFamilyIdInfo * model = arr[0];
                                            [[NSUserDefaults standardUserDefaults]setObject:model.familyId forKey:FAMILYID];
                                            [[NSUserDefaults standardUserDefaults]setObject:model.familyVersion forKey:FAMILYVERSION];
                                            [[NSUserDefaults standardUserDefaults]setObject:@"YES" forKey:ISLOGIN];
                                            [[NSUserDefaults standardUserDefaults] synchronize];
                                            
                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                [UsingHUD hideInView:[DeviceInfoManager getCurrentVC].view];
                                                [[NSNotificationCenter defaultCenter] postNotificationName:kAKNotificationUserLoggedIn object:nil];
                                            });
                                            
                                        }else{ //账号下没有家庭--》创建家庭   名称为  "*#com_lbest_rm_sfgxh#*"
                                            BLFamilyInfo * info = [[BLFamilyInfo alloc]init];
                                            info.familyName = FamliyNAME;
                                            [ [BLLet sharedLet].familyManager createNewFamilyWithInfo:info iconImage:[UIImage imageNamed:@""] completionHandler:^(BLFamilyInfoResult * _Nonnull result) { //创建家庭
                                                if (result.error == 0) { //创建家庭 --》成功
                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                        [[NSUserDefaults standardUserDefaults]setObject:result.familyInfo.familyId forKey:FAMILYID];
                                                        [[NSUserDefaults standardUserDefaults]setObject:result.familyInfo.familyVersion forKey:FAMILYVERSION];
                                                         [[NSUserDefaults standardUserDefaults]setObject:@"YES" forKey:ISLOGIN];
                                                         [[NSUserDefaults standardUserDefaults] synchronize];
                                                        
                                                        [UsingHUD hideInView:[DeviceInfoManager getCurrentVC].view];
                                                        [SDSFamliyManager sharedInstance].familyinfo =result.familyInfo;
                                                        if (completionHandler) {
                                                            completionHandler(YES, [weakSelf currentSession]);
                                                        }
                                                        [[NSNotificationCenter defaultCenter] postNotificationName:kAKNotificationUserLoggedIn object:nil];
                                                    });
                                                }else{//创建家庭 --》失败 - 》刷新token - >再次创建家庭
                                                    
                                                    [[BLLet sharedLet].account refreshAccessTokenWithRefreshToken:[UserInfoManager sharedTool].RefreshToken clientId:LiangBaClientID clientSecret:CLIENT_SECRET completionHandler:^(BLOauthResult * _Nonnull result) {
                                                        
                                                        [[NSUserDefaults standardUserDefaults]setObject:result.refreshToken forKey:REFRESHTOKEN];
                                                        [[NSUserDefaults standardUserDefaults]setObject:result.accessToken forKey:DEVICETOKEN];
                                                        [[NSUserDefaults standardUserDefaults] synchronize];
                                                        
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            
                                                            [ [BLLet sharedLet].familyManager createNewFamilyWithInfo:info iconImage:[UIImage imageNamed:@""] completionHandler:^(BLFamilyInfoResult * _Nonnull result) { //创建家庭
                                                                if (result.error == 0) { //创建家庭 --》成功
                                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                                        [[NSUserDefaults standardUserDefaults]setObject:result.familyInfo.familyId forKey:FAMILYID];
                                                                        [[NSUserDefaults standardUserDefaults]setObject:result.familyInfo.familyVersion forKey:FAMILYVERSION];
                                                                        [[NSUserDefaults standardUserDefaults]setObject:@"YES" forKey:ISLOGIN];
                                                                        [[NSUserDefaults standardUserDefaults] synchronize];
                                                                        
                                                                        [UsingHUD hideInView:[DeviceInfoManager getCurrentVC].view];
                                                                        [SDSFamliyManager sharedInstance].familyinfo =result.familyInfo;
                                                                        if (completionHandler) {
                                                                            completionHandler(YES, [weakSelf currentSession]);
                                                                        }
                                                                        [[NSNotificationCenter defaultCenter] postNotificationName:kAKNotificationUserLoggedIn object:nil];
                                                                    });
                                                                }else{//创建家庭 --》失败
                                                                    
                                                                    [[NSUserDefaults standardUserDefaults]setObject:@"NO" forKey:ISLOGIN];
                                                                    [UsingHUD hideInView:[DeviceInfoManager getCurrentVC].view];
                                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                                        if (completionHandler) {
                                                                            completionHandler(NO, nil);
                                                                        }
                                                                        [CommonUtil setTip:result.msg];
                                                                    });
                                                                }
                                                            }];
                                                        });
                                                    }];
                                                 }
                                            }];
                                        }
                                    }else{ //查询账号下的家庭 -->失败---》刷新accesstoken - >再次查询家庭信息
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                           
                                            [[BLLet sharedLet].account refreshAccessTokenWithRefreshToken:[UserInfoManager sharedTool].RefreshToken clientId:LiangBaClientID clientSecret:CLIENT_SECRET completionHandler:^(BLOauthResult * _Nonnull result) {
                                                
                                                [[NSUserDefaults standardUserDefaults]setObject:result.refreshToken forKey:REFRESHTOKEN];
                                                [[NSUserDefaults standardUserDefaults]setObject:result.accessToken forKey:DEVICETOKEN];
                                                [[NSUserDefaults standardUserDefaults] synchronize];
                                                
                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                   
                                                    [[BLLet sharedLet].familyManager queryLoginUserFamilyIdListWithCompletionHandler:^(BLFamilyIdListGetResult * _Nonnull result) { //查询账号下的家庭
                                                        if (result.error==0) { //查询账号下的家庭 -->成功
                                                            
                                                            NSArray * arr = result.idList;
                                                            if (arr.count>0) { //账号下有家庭
                                                                if (completionHandler) {
                                                                    completionHandler(YES, [weakSelf currentSession]);
                                                                }
                                                                BLFamilyIdInfo * model = arr[0];
                                                                [[NSUserDefaults standardUserDefaults]setObject:model.familyId forKey:FAMILYID];
                                                                [[NSUserDefaults standardUserDefaults]setObject:model.familyVersion forKey:FAMILYVERSION];
                                                                [[NSUserDefaults standardUserDefaults]setObject:@"YES" forKey:ISLOGIN];
                                                                [[NSUserDefaults standardUserDefaults] synchronize];
                                                                
                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                    [UsingHUD hideInView:[DeviceInfoManager getCurrentVC].view];
                                                                    [[NSNotificationCenter defaultCenter] postNotificationName:kAKNotificationUserLoggedIn object:nil];
                                                                });
                                                                
                                                            }else{ //账号下没有家庭--》创建家庭   名称为  "*#com_lbest_rm_sfgxh#*"
                                                                BLFamilyInfo * info = [[BLFamilyInfo alloc]init];
                                                                info.familyName = FamliyNAME;
                                                                [ [BLLet sharedLet].familyManager createNewFamilyWithInfo:info iconImage:[UIImage imageNamed:@""] completionHandler:^(BLFamilyInfoResult * _Nonnull result) { //创建家庭
                                                                    if (result.error == 0) { //创建家庭 --》成功
                                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                                            [[NSUserDefaults standardUserDefaults]setObject:result.familyInfo.familyId forKey:FAMILYID];
                                                                            [[NSUserDefaults standardUserDefaults]setObject:result.familyInfo.familyVersion forKey:FAMILYVERSION];
                                                                            [[NSUserDefaults standardUserDefaults]setObject:@"YES" forKey:ISLOGIN];
                                                                            [[NSUserDefaults standardUserDefaults] synchronize];
                                                                            
                                                                            [UsingHUD hideInView:[DeviceInfoManager getCurrentVC].view];
                                                                            [SDSFamliyManager sharedInstance].familyinfo =result.familyInfo;
                                                                            if (completionHandler) {
                                                                                completionHandler(YES, [weakSelf currentSession]);
                                                                            }
                                                                            [[NSNotificationCenter defaultCenter] postNotificationName:kAKNotificationUserLoggedIn object:nil];
                                                                        });
                                                                    }else{//创建家庭 --》失败
                                                                        [[NSUserDefaults standardUserDefaults]setObject:@"NO" forKey:ISLOGIN];
                                                                        [UsingHUD hideInView:[DeviceInfoManager getCurrentVC].view];
                                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                                            if (completionHandler) {
                                                                                completionHandler(NO, nil);
                                                                            }
                                                                            [CommonUtil setTip:result.msg];
                                                                        });
                                                                    }
                                                                }];
                                                            }
                                                            
                                                        }else{ //查询账号下的家庭 -->失败
                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                
                                                                [[NSUserDefaults standardUserDefaults]setObject:@"NO" forKey:ISLOGIN];
                                                                [UsingHUD hideInView:[DeviceInfoManager getCurrentVC].view];
                                                                [CommonUtil setTip:result.msg];
                                                                if (completionHandler) {
                                                    
                                                                    completionHandler(NO, nil);
                                                    
                                                                }
                                                                NSLog(@"%@",result.msg);
                                                                });
                                                            }
                                                        }];
                                                    });
                                                }];
                                            });
                                        }
                                }];
                            }else{ ////通过userid-->获取用户的 nickname  userid  iconUrl -->失败
                                dispatch_async(dispatch_get_main_queue(), ^{
                                     [[NSUserDefaults standardUserDefaults]setObject:@"NO" forKey:ISLOGIN];
                                    [UsingHUD hideInView:[DeviceInfoManager getCurrentVC].view];
                                    [CommonUtil setTip:result.msg];
                                    if (completionHandler) {
                                        completionHandler(NO, nil);
                                    }
                                    NSLog(@"%@",result.msg);
                                });
                            }
                        }];
                    }else{ //通过accessToken 获取 userid-->失败
                        [[NSUserDefaults standardUserDefaults]setObject:@"NO" forKey:ISLOGIN];
                        dispatch_async(dispatch_get_main_queue(), ^{
                        [UsingHUD hideInView:[DeviceInfoManager getCurrentVC].view];
                            [CommonUtil setTip:result.msg];
                            if (completionHandler) {
                                completionHandler(NO, nil);
                            }
                            NSLog(@"%@",result.msg);
                        });
                     }
                });
            }];
        }else{// 获取accessToken ->失败
            [[NSUserDefaults standardUserDefaults]setObject:@"NO" forKey:ISLOGIN];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completionHandler) {
                    completionHandler(NO, nil);
                }
                [UsingHUD hideInView:[DeviceInfoManager getCurrentVC].view];
                [UserInfoManager sharedTool].account = nil;
                [UserInfoManager sharedTool].password=nil;
                if (result.msg  ) {
                      [CommonUtil setTip:result.msg];

                }else{
                    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"" message:@"登录失败，账号或密码错误\n请重新输入" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alert show];
                } 
            });
        }
    }];
}
- (BOOL)isLogin {
    
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"ISLOGIN"] isEqualToString:@"YES"]) {
        return YES;
    }
    else
    return NO;
}
- (nonnull NSString *)accountType {
    //实现你的自定义账号类型
    return @"qweroot";
}

@end

