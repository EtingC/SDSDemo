//
//  NetworkTool.h
//  XHH_networkTool
//
//  Created by xiaohuihui on 2017/10/10.
//  Copyright ©. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import <AlinkSDK/AlinkOpenSDK.h>

typedef void (^successBlockWithId)(id param);
typedef void (^failureBlockWithId)(id param);
@interface NetworkTool: AFHTTPSessionManager

/**
 创建网络请求工具类的单例
 */
+ (instancetype)sharedTool;

/**
 创建请求方法

 
 @param parameters 请求参数
 @param method 请求的方法类型
 @param view LOADING圈加的视图
 @param callBack 请求成功的返回
 @param errorBack 失败的返回
 */
- (void)requestWithURLparameters:(NSDictionary *)parameters
                      method: (NSString *)method
                        View:(UIView*)view
        sessionExpiredOption:(NSInteger)sessionExpiredOption
                   needLogin:(BOOL)needLogin
                    callBack: (void(^)(AlinkResponse* responseObject))callBack  errorBack: (void(^)(id error))errorBack;

- (void)getServerDeviceFirmwareVersionWithDeviceType:(NSInteger)deviceType localVersion:(NSInteger)localVersion success:(successBlockWithId)success failure:(failureBlockWithId)failure;

#pragma mark - 获取型号的详细信息
-(void)getProductDetailWithProductPid:(NSString *)productPid success:(successBlockWithId)success failure:(failureBlockWithId)failure;

#pragma mark - 获取产品型号
-(void)getProductModelWithCategoryid:(NSString *)categoryid success:(successBlockWithId)success failure:(failureBlockWithId)failure;

#pragma mark - 获取产品类型
-(void)getProductKindsuccess:(successBlockWithId)success failure:(failureBlockWithId)failure;
@end
