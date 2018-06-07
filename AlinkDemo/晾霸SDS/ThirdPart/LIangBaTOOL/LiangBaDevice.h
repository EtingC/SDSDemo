//
//  LiangBaDevice.h
//  AlinkDemo
//
//  Created by gubeidianzi on 2017/12/4.
//  Copyright © 2017年 aliyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLDNADevice.h"
@interface LiangBaDevice : NSObject
typedef void (^successBlockWithId)(id param);
typedef void (^failureBlockWithId)(id param);
@property (strong, nonatomic, readonly) NSMutableArray<BLDNADevice *> *deviceArray;
@property(strong,nonatomic) NSMutableArray * XINGHAOArr;
+ (LiangBaDevice *)sharedInstance;

- (void)addDeviceToDeviceArray:(BLDNADevice *)device;

- (BOOL)deviceHasAddedInDeviceArray:(BLDNADevice *)device;
@end
