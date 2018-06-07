//
//  DeviceInfoManager.h
//  AlinkDemo
//
//  Created by gubeidianzi on 2017/11/8.
//  Copyright © 2017年 aliyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceInfoManager : NSObject

@property (nonatomic,strong) NSMutableArray * deviceInfoArray;
@property (nonatomic,copy) NSString *PID;
@property (nonatomic,copy) NSString *imagePath;
@property (nonatomic,copy) NSString *TheAddDevieceName;
+(DeviceInfoManager *)sharedManager;
+(UIViewController *)getCurrentVC;
#pragma mark - 解析获取PID
+(NSString *)getPidStringDecimal:(NSInteger)decimal;
@end
