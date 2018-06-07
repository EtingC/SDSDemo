//
//  JSCallBackDeviceModel.m
//  AlinkDemo
//
//  Created by gubeidianzi on 2017/11/14.
//  Copyright © 2017年 aliyun. All rights reserved.
//

#import "JSCallBackDeviceModel.h"
#import "AliJSBackModel.h"
#import "BlJsBackModel.h"
@implementation JSCallBackDeviceModel
+ (NSDictionary *)objectClassInArray{
    return @{
             @"params_ali" : [AliJSBackModel class],
             @"params_bl" : [BlJsBackModel class]
             };
}
@end
