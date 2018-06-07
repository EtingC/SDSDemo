//
//  ChangeNameViewController.h
//  AlinkDemo
//
//  Created by gubeidianzi on 2017/11/23.
//  Copyright © 2017年 aliyun. All rights reserved.
//
typedef void(^backBlock)(NSString * text);
#import "BaseViewController.h"
#import "BindDeviceInformationlistModel.h"

@interface ChangeNameViewController : BaseViewController
@property (nonatomic,copy) NSString * name;
@property (nonatomic,copy) backBlock back;
@property (nonatomic,strong) BindDeviceInformationlistModel * bindModel;
@end
