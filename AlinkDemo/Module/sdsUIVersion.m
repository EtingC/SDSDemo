//
//  sdsUIVersion.m
//  AlinkDemo
//
//  Created by gubeidianzi on 2017/11/27.
//  Copyright © 2017年 aliyun. All rights reserved.
//

#import "sdsUIVersion.h"

@implementation sdsUIVersion
+ (instancetype)sdsUIVersiontWith: (NSString *)VERSION pid:(NSString *)PID{
    
    sdsUIVersion * sds = [[sdsUIVersion alloc]init];
    sds.version = VERSION;
    sds.pid = PID;
    return sds;
    
}
@end
