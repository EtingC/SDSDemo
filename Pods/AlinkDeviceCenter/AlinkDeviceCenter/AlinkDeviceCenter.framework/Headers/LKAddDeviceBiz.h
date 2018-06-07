//
//  AddDeviceBiz.h
//  AlinkDeviceCenter
//
//  Created by ZhuYongli on 2017/7/6.
//  Copyright © 2017年 ZhuYongli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LKCandDeviceModel.h"
#import "LKErrorDefine.h"

#define kLkAddDevBiz LKAddDeviceBiz.sharedInstance



/**
 * 准备配网指导码
guideCode=1,对应页面流转：直接进入输入密码页
guideCode=2,对应页面流转：用户引导页-》输入密码页
guideCode=3,对应页面流转：用户引导页（智能路由配网）
guideCode=4,对应页面流转：用户引导页-》切换到设备热点页-》输入密码页
guideCode=5,对应页面流转：启动手机热点页-》发现设备列表页-》获取设备周边热点列表页-》输入密码页
 */
typedef NS_ENUM(NSInteger, LKPUserGuideCode) {
    LKPGuideCodeOnlyInputPwd = 1,
    LKPGuideCodeWithUserGuide = 2,
    LKPGuideCodeRouterGuide = 3,
    LKPGuideCodeHasSoftAp = 4,
    LKPGuideCodeHasHotSpot = 5,
};



/**
 添加设备过程中状态流转码
 */
typedef NS_ENUM(NSInteger, LKAddState) {
    LKAddStatePrechecking = 0, ///< 前期检查入参
    LKAddStateProvisionPreparing = 1, ///<真正配网前的准备阶段，如等待用户输入ssid+pwd
    LKAddStateProvisioning = 2, ///<进入配网状态
    LKAddStateProvisionOver = 3, ///<配网结束
    LKAddStateWaitReconnectRouter = 4, ///<等待用户重新连接路由器，在手机热点配网或设备热点配网时会有此中转状态
    LKAddStateJoining = 5, ///<设备注册、绑定/认证/激活 时都处于此状态
    LKAddStateJoinOver = 6, ///<设备注册、绑定/认证/激活 结果
};


/**
 * 强制选择配网类型枚举值
 */
typedef NS_ENUM(NSUInteger, ForceAliLinkType) {
    ForceAliLinkTypeNone, ///< 由native SDK自行决定在广播配网，P2P，路由器配网中选择最优的配网方案；
    ForceAliLinkTypeSoftAP, ///< 设备热点配网方案,在一般配网方案失败后，可切换到设备热点方案
    ForceAliLinkTypeHotspot, ///< 手机热点配网方案，在一般配网方案失败后，可切换到手机热点方案
};


/**
 * UI层通知者，向UI层发送事件，同步当前添加设备流转状态
 */
@protocol ILKAddDeviceNotifier <NSObject>
-(void)notifyPrecheck:(BOOL)success withError:(NSError *)err; ///<通知UI层，precheck结果。可以没有
-(void)notifyProvisionPrepare:(LKPUserGuideCode)guideCode; ///<通知UI层，进入配网准备页面，如进入输入密码页面。密码输入后，调用toggleProvision开始配网
-(void)notifyProvisioning; ///<通知UI层，当前正在配网中
-(void)notifyShouldSwitchBackToRouter:(NSString * )routerAp; ///<通知UI层，需要切换回路由器。在softAP配网方案中，手机会连上设备热点，在配网完成后，需要重新连上路由器才能完成下边的入网过程
-(void)notifyProvisonResult:(NSDictionary*)result withError:(NSError *)err; ///<通知UI层配网结果，err!=nil标识配网失败了
-(void)notifyJoining:(NSDictionary*)step; ///<通知UI层，进入设备注册、绑定、授权、激活等入网状态
-(void)notifyJoinResult:(NSDictionary*)result withError:(NSError *)err; ///<通知UI层，入网结果，err!=nil标识配网失败了
@end

@interface LKAddDeviceBiz : NSObject
/**
 * 单例
 */
+(instancetype)sharedInstance;

/**
 设置待添加的设备属性，在startAddDevice调用前传入相关信息,在同一时刻只能有一个待添加设备存在
 @param dev 设备相关信息，如model，connectMode，参见LKCandDeviceModel
 */
-(LKDCErrCode)setDevice:(LKCandDeviceModel*)dev;

/**
 * 开始添加设备流程，在setDevice后即可调用此API
 @param notifier UI层通知者，向UI层同步当前流程的状态，参见ILKAddDeviceNotifier
 */
-(void)startAddDevice:(id<ILKAddDeviceNotifier>) notifier;


/**
 中止添加设备流程，
 */
-(void)stopAddDevice;

/**
 传入配网所需参数，UI层在收到ILKAddDeviceNotifier::notifyProvisionPrepare事件，引导用户输入
 wifi密码后，调用此API正式进入配网流程.
 @param ssid 路由器wifi名称
 @param pwd  路由器wifi密码
 @param timeout 配网过程超时时间，以秒为单位，默认是60s
 */
-(void)toggleProvision:(NSString *)ssid pwd:(NSString *)pwd timeout:(int)timeout;

/**
 获取当前添加设备流程的状态
 @return 参见LKAddState
 */
-(LKAddState)getProcedureState;

/**
 切换配网模式，一般配网SDK会根据LKCandDeviceModel传入的属性来选择一个默认的
 配网模式，但是在默认配网模式失败后，提供此API可以切换到SoftAP配网或者手机热点配网（HotSpot）
 所以该API的provisionMode入参只允许传入LKPAliModeDefault\LKPAliModeAlinkSoftAP\LKPAliModeAlinkSoftAP
 三个值
 @param linkType 参见ForceAliLinkType
 */
-(void)setAliProvisionMode:(ForceAliLinkType)linkType;


/**
 获取当前正在添加的设备model
 @return 参见LKCandDeviceModel
 */
-(LKCandDeviceModel*)getCurrentDevice;
@end
