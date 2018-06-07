//
//  BianJiViewController.h
//  AlinkDemo
//
//  Created by gubeidianzi on 2017/11/6.
//  Copyright © 2017年 aliyun. All rights reserved.
//
typedef void(^callBackBlock)(NSString *  progress);
#import "BaseViewController.h"

@interface BianJiViewController : BaseViewController
@property (copy,nonatomic) callBackBlock callblock;
@end
