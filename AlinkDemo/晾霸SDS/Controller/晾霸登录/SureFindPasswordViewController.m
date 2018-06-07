//
//  SureFindPasswordViewController.m
//  AlinkDemo
//
//  Created by gubeidianzi on 2017/11/30.
//  Copyright © 2017年 aliyun. All rights reserved.
//

#import "SureFindPasswordViewController.h"
#import "LastPasswordViewController.h"
@interface SureFindPasswordViewController ()
@property (nonatomic,strong) UITextField * messageTF;
@property (nonatomic,strong) UITextField * PasswordTF;
@property (nonatomic,strong) UITextField * SurePasswordTF;
@property (nonatomic,strong) UIButton * nextBtn;
@property (nonatomic,strong) UIImageView *navLine;
@end

@implementation SureFindPasswordViewController
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.barTintColor = RGB(247, 245, 244);
    _navLine.hidden = NO;
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    UIView *backgroundView = [self.navigationController.navigationBar subviews].firstObject;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationItem.leftBarButtonItem.tintColor =  [UIColor blackColor];
    _navLine = backgroundView.subviews.firstObject;
    _navLine.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
     [self changeleftItem];
     self.title =NSLocalizedString(@"找回密码", nil) ;
     self.view.backgroundColor = [UIColor whiteColor];
    [self makeUI];
    // Do any additional setup after loading the view.
}
-(void)makeUI{
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(30, 80, SCREEN_WIDTH-60, 30)];
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:label];
    NSString * str =self.phoneStr;
    str =  [str stringByReplacingCharactersInRange:NSMakeRange(3, 5)  withString:@"*****"];
    str = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"短信验证码已发送至", nil),str];
    label.text = str;
    
    self.messageTF = [[UITextField alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(label.frame)+15  , SCREEN_HEIGHT-60, 60)];
    [self.view addSubview:self.messageTF];
    self.messageTF.placeholder  =NSLocalizedString(@"输入短信验证码", nil) ;
    self.messageTF.font = [UIFont systemFontOfSize:18];
    self.messageTF.textColor = [CommonUtil getColor:@"#333333"];
      [self.messageTF setValue:[CommonUtil getColor:@"#BBBBBB"] forKeyPath:@"_placeholderLabel.textColor"];
    UIView * v = [[UIView alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(self.messageTF.frame), SCREEN_WIDTH-60, 1)];
    v.backgroundColor = Gray_Color;
    [self.view addSubview:v];
    
    self.PasswordTF = [[UITextField alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(v.frame)+5, SCREEN_HEIGHT-60, 60)];
    [self.view addSubview: self.PasswordTF];
     self.PasswordTF.placeholder  =NSLocalizedString(@"输入6-16位数字字符组合密码", nil);
     self.PasswordTF.font = [UIFont systemFontOfSize:18];
     self.PasswordTF.textColor = [CommonUtil getColor:@"#333333"];
    [self.PasswordTF setValue:[CommonUtil getColor:@"#BBBBBB"] forKeyPath:@"_placeholderLabel.textColor"];
    UIView * v1 = [[UIView alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY( self.PasswordTF.frame), SCREEN_WIDTH-60, 1)];
    v1.backgroundColor = Gray_Color;
    [self.view addSubview:v1];
    
    
    self.SurePasswordTF = [[UITextField alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(v1.frame)+5, SCREEN_HEIGHT-60, 60)];
    [self.view addSubview: self.SurePasswordTF];
     self.SurePasswordTF.placeholder  =NSLocalizedString(@"再输入一遍密码", nil) ;
     self.SurePasswordTF.font = [UIFont systemFontOfSize:18];
     self.SurePasswordTF.textColor = [CommonUtil getColor:@"#333333"];
     [self.SurePasswordTF setValue:[CommonUtil getColor:@"#BBBBBB"] forKeyPath:@"_placeholderLabel.textColor"];
    UIView * v2 = [[UIView alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(self.SurePasswordTF.frame), SCREEN_WIDTH-60, 1)];
    v2.backgroundColor = Gray_Color;
    [self.view addSubview:v2];
    
    self.nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _nextBtn.frame =  CGRectMake(30, CGRectGetMaxY(v2.frame)+50, SCREEN_WIDTH-60, 45);
    
    [self.nextBtn setTitle:NSLocalizedString(@"下一步", nil)  forState:UIControlStateNormal];
    [self.nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.nextBtn.backgroundColor = [CommonUtil getColor:@"#F1AA3E"];
    [self.nextBtn.titleLabel setFont:[UIFont systemFontOfSize:20]];
    [self.view addSubview:self.nextBtn];
    [self.nextBtn AddLayer:10];
    [self.nextBtn addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
}
-(void)next{
    LastPasswordViewController *vc = [[LastPasswordViewController alloc]init];
  
    
    [self.PasswordTF resignFirstResponder];
    [self.messageTF resignFirstResponder];
    [self.SurePasswordTF resignFirstResponder];
    if (self.SurePasswordTF.text.length<6 ||self.PasswordTF.text.length<6) {
        [CommonUtil setTip:@"请正确填写密码"];
    }else{
        if (![self.SurePasswordTF.text isEqualToString:self.PasswordTF.text]) {
            [CommonUtil setTip:@"请确保新密码输入相同！" Yposition:SCREEN_HEIGHT-150];
        }else{
            [UsingHUD showInView:self.view];
            WeakSelf
            [BLLetAccount retrivePassword:self.phoneStr vcode:self.messageTF.text newPassword:self.SurePasswordTF.text completionHandler:^(BLLoginResult * _Nonnull result) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [UsingHUD hideInView:weakSelf.view];
                    if (result) {
                        if (result.error == 0) {
                            
                            [weakSelf.navigationController pushViewController:vc animated:YES   ];
                            
                        }else{
                            [CommonUtil setTip:result.msg];
                        }
                    }
                });
                
            }];
        }

        
        
        
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
