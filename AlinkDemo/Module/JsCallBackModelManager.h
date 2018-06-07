//
//  JsCallBackModelManager.h
//  AlinkDemo
//
//  Created by gubeidianzi on 2017/11/14.
//  Copyright © 2017年 aliyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSCallBackDeviceModel.h"
@interface JsCallBackModelManager : NSObject

@property (nonatomic,strong) JSCallBackDeviceModel * model;
@property(nonatomic,copy) NSString * UIPath;
+(JsCallBackModelManager *)sharedManager;

@end
