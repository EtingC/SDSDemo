//
//  DevieceMoudleManager.m
//  AlinkDemo
//
//  Created by gubeidianzi on 2017/11/13.
//  Copyright © 2017年 aliyun. All rights reserved.
//

#import "DevieceMoudleManager.h"

@implementation DevieceMoudleManager
+(DevieceMoudleManager *)shareManager{
    
    static DevieceMoudleManager * manger  =nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manger = [[self alloc]init];
    });
    return manger;
}
-(BindDeviceInformationlistModel *)listModel{
    
    if (_listModel == nil) {
        _listModel = [[BindDeviceInformationlistModel alloc]init];
    }
    return _listModel;
}
@end
