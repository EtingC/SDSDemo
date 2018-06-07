//
//  LKErrorDefine.h
//  AlinkDeviceCenter
//
//  Created by ZhuYongli on 2017/8/29.
//  Copyright © 2017年 ZhuYongli. All rights reserved.
//

#ifndef LKErrorDefine_h
#define LKErrorDefine_h



/**
 对外错误码定义
 */
typedef NS_ENUM(NSInteger, LKDCErrCode) {
    LKDCErrCodeNoError = 0,  ///<没有错误
    LKDCErrCodeSystemErr = 600, ///<系统错误
    LKDCErrCodeParamErr = 601, ///< 参数错误
    LKDCErrCodeRedoAddWhileAdding = 602, ///<添加设备正在进行，不允许重复操作
    
    LKDCErrCodeProvisionTimeout = 603, ///<配网超时
    LKDCErrCodeProvisionCommonErr = 604, ///<配网通用错误，如socket 错误
    
    LKDCErrCodeIllegalToken = 605, ///<账号token失效，遇到此错误时，需要账号重新登录
    LKDCErrCodeRegOrBindErr = 606, ///<1.0设备在注册或者绑定过程中失败了
    LKDCErrCodeAuthDevErr = 607, ///<1.1设备在做认证时过程中失败了
    LKDCErrCodeEnrolleeAddErr = 608, ///<v3设备在向服务端做add 请求时失败
    LKDCErrCodeEnrolleeActiveErr = 609, ///<v3设备在向服务端做active 请求时失败
    LKDCErrCodeBindNeedAuthorized = 610,///<设备已经有人绑定，需要管理员授权，管理员可以通过分享二维码授权绑定
    
    LKDCErrCodeMtopRequestFailed = 620,  ///<mtop请求失败
    LKDCErrCodeOperationNotPermmitted = 621,  ///<此操作不被允许
    LKDCErrCodeMtopRequestBadResp = 622,  ///<mtop请求返回数据格式不对
};


#endif /* LKErrorDefine_h */
