//
//  SureZhuCeViewController.h
//  AlinkDemo
//
//  Created by gubeidianzi on 2017/12/4.
//  Copyright © 2017年 aliyun. All rights reserved.
//

#import "BaseViewController.h"

@interface SureZhuCeViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UILabel *PhoneSyr;
@property (weak, nonatomic) IBOutlet UITextField *TwoCodeTF;
@property (weak, nonatomic) IBOutlet UIButton *SendBtn;
@property (weak, nonatomic) IBOutlet UITextField *PassWordTF;
@property (weak, nonatomic) IBOutlet UITextField *AgainPasswordTF;
@property (weak, nonatomic) IBOutlet UIButton *ZhuCeBtn;
@property(nonatomic,copy) NSString *phoneStr;
@end
