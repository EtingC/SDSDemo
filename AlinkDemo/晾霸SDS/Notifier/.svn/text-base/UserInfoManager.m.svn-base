//
//  UserInfoManager.m
//  AlinkDemo
//
//  Created by gubeidianzi on 2017/11/17.
//  Copyright © 2017年 aliyun. All rights reserved.
//

#import "UserInfoManager.h"

@implementation UserInfoManager
+(instancetype)sharedTool{
    static id instance =nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self  alloc] init];
        
    });
    return instance;
}
-(NSString *)account{
    if (!_account){
        _account = [[NSString alloc]init];
    }
    return _account;
}
-(NSString *)password{
    if (!_password) {
        _password = [[NSString alloc]init];
    }
    return _password;
}

-(NSString *)AccessToken{
   
    if ([[NSUserDefaults standardUserDefaults]objectForKey:DEVICETOKEN]==nil) {
        return @"";
    }
    return [[NSUserDefaults standardUserDefaults]objectForKey:DEVICETOKEN];
}
-(NSString *)RefreshToken{
    if ([[NSUserDefaults standardUserDefaults]objectForKey:REFRESHTOKEN]==nil) {
        return @"";
    }
    return [[NSUserDefaults standardUserDefaults]objectForKey:REFRESHTOKEN];
}
@end
