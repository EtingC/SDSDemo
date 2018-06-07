//
//  SetTimeActionViewController.h
//  AlinkDemo
//
//  Created by gubeidianzi on 2017/11/14.
//  Copyright © 2017年 aliyun. All rights reserved.
//

#import "BaseViewController.h"
typedef void(^backBlock) (NSString *content);
@interface SetTimeActionViewController : BaseViewController
@property (nonatomic,copy) backBlock backblock;
@property (nonatomic,assign) NSInteger Sign;
@property (nonatomic,copy)NSString * WhoPushMe;
@end
