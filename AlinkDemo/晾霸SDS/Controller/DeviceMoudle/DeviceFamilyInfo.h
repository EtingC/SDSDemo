//
//  DeviceFamilyInfo.h
//  AlinkDemo
//
//  Created by gubeidianzi on 2017/12/8.
//  Copyright © 2017年 aliyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLFamilyDeviceInfo.h"
#import "BLModuleInfo.h"
@interface DeviceFamilyInfo : NSObject    //这是模型 是从首页列表 获取的数据模型 又重新整合的模型，因为原来的首页模型获取过来以后是 moudlebaseinfo  和  devicebaseinfo 然后  Moudle和device 又都在各自的数组里面 取值的时候很不方便 ，现在把他们对应的整合在一个模型里面

@property (nonatomic,strong) NSArray * moduleInfoArr;

@property (nonatomic,strong) BLFamilyDeviceInfo * deviceInfo;

@property (nonatomic,strong) BLModuleInfo * moduleInfo;
@end
