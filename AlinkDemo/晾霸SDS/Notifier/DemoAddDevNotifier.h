//
//  DemoAddDevNotifier.h
//  AlinkDemo
//
//  Created by gubeidianzi on 2017/10/30.
//  Copyright © 2017年 aliyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AlinkDeviceCenter/LKAddDeviceBiz.h>
@interface DemoAddDevNotifier : NSObject<ILKAddDeviceNotifier>
{
    __block BOOL jian;
    NSString * uuid;
}
@property (nonatomic,strong) NSTimer * myTimer;

@property (nonatomic,strong)NSString *mac;


@end
