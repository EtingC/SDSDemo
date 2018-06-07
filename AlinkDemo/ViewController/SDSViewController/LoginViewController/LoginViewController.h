//
//  LoginViewController.h
//  AlinkDemo
//
//  Created by gubeidianzi on 2017/11/7.
//  Copyright © 2017年 aliyun. All rights reserved.
//

#import "BaseViewController.h"
typedef void(^PUSHValueBlock)(NSString *deviceToken);

@interface LoginViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITextField *PassWordTF;
@property (nonatomic,copy) PUSHValueBlock deviceBlock;
@property (weak, nonatomic) IBOutlet UITextField *AccountTF;
@end
