//
//  BLControlViewController.h
//  NewElectrolux
//
//  Created by gubeidianzi on 2017/6/2.
//  Copyright © 2017年 gubeidianzi. All rights reserved.
//

#import <Cordova/CDVViewController.h>
#import <Cordova/CDVCommandDelegateImpl.h>
#import <Cordova/CDVCommandQueue.h>

@class BLDNADevice;
@class BLFamilyDeviceInfo;

@interface BLControlViewController : CDVViewController

+ (BLControlViewController *)controlVCWithDevice:(BLDNADevice *)device;

@property (strong, nonatomic) UIImageView *naviBackgroundView;

@property (strong, nonatomic) NSMutableArray *rightButtons;

@property (strong, nonatomic) NSString *myJsFuncName;//如果只存在一个菜单项，就不使用弹出菜单的形式

@property (strong, nonatomic) NSString *myLeftJsFuncName;//left button method click

@end

@interface DeviceControlIndexCommandDelegate : CDVCommandDelegateImpl

@end


@interface DeviceControlIndexCommandQueue : CDVCommandQueue

@end
