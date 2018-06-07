//
//  JsCallBackModelManager.m
//  AlinkDemo
//
//  Created by gubeidianzi on 2017/11/14.
//  Copyright © 2017年 aliyun. All rights reserved.
//

#import "JsCallBackModelManager.h"

@implementation JsCallBackModelManager
+ (JsCallBackModelManager *)sharedManager
{
    static JsCallBackModelManager *deviceInfoManager = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        deviceInfoManager = [[self alloc] init];
        
    });
    return deviceInfoManager;
}
-(JSCallBackDeviceModel *)model{
//    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"params_map" ofType:@"json"];
    NSData *data=[NSData dataWithContentsOfFile:self.UIPath];
    NSError *error;
    id jsonObject=[NSJSONSerialization JSONObjectWithData:data
                                                  options:NSJSONReadingAllowFragments
                                                    error:&error];
    
    JSCallBackDeviceModel * model = [JSCallBackDeviceModel mj_objectWithKeyValues:jsonObject];
    return model;
}
@end
