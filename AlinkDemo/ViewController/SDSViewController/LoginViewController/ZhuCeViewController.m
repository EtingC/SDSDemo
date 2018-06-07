//
//  ZhuCeViewController.m
//  AlinkDemo
//
//  Created by gubeidianzi on 2017/11/7.
//  Copyright © 2017年 aliyun. All rights reserved.
//

#import "ZhuCeViewController.h"
#import "PhoneRegisterView.h"
#import "MailRegisterView.h"
#import "SureTheRegisterPasswordView.h"
#define SELECT_COLOR RGB(39, 39, 39)
#define NORMAL_COLOR RGB(173, 172, 173)
#define ORANGE_COLOR RGB(236, 154, 49)
 @interface ZhuCeViewController ()
@property (nonatomic,strong) PhoneRegisterView * phoneV;
@property (nonatomic,strong) MailRegisterView * mailV;
@property (nonatomic,strong) SureTheRegisterPasswordView * sureV;
@property (nonatomic,strong) UIButton * phoneBtn;
@property (nonatomic,strong) UIButton * mailBtn;
@property (nonatomic,strong) UIButton * NextBtn;
@property (nonatomic,strong) UIView *phoneLineV;
@property (nonatomic,strong) UIView *mailLineV;
@property (nonatomic,strong) UIButton * loginBtn;
@property (nonatomic,strong) UIView *midV;
@property (nonatomic,assign) BOOL phoneOrMail;
@property (nonatomic,assign) BOOL twoAction;
@property (nonatomic,copy)  NSString * phoneCode;
@property (nonatomic,copy)  NSString * mailCode;
@end

@implementation ZhuCeViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden = YES;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeUI];
    self.phoneOrMail = YES;  //YES ->pHONE  no - >mAIL
    self.twoAction = NO;
    // Do any additional setup after loading the view.
}
-(void)makeUI{
    
    self.phoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.phoneBtn.frame = CGRectMake(30, 84, (SCREEN_WIDTH-60)/2, 38);
    [self.phoneBtn setTitle:@"手机注册" forState:UIControlStateNormal];
    [self.phoneBtn setTitleColor:SELECT_COLOR forState:(UIControlState)UIControlStateNormal];
    [self.phoneBtn.titleLabel setFont:[UIFont systemFontOfSize:21]];
    [self.view addSubview:self.phoneBtn];
    [self.phoneBtn addTarget:self action:@selector(phonebtn) forControlEvents:UIControlEventTouchUpInside];
    self.phoneLineV.frame =CGRectMake(30, CGRectGetMaxY(self.phoneBtn.frame), self.phoneBtn.frame.size.width, 1);
    self.phoneLineV.backgroundColor = SELECT_COLOR;//39 39 39  173  172  173
    [self.view addSubview:self.phoneLineV];
    
    self.mailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.mailBtn.frame = CGRectMake(CGRectGetMaxX(self.phoneBtn.frame), 84, (SCREEN_WIDTH-60)/2, 38);
    [self.view addSubview:self.mailBtn];
    [self.mailBtn setTitle:@"邮箱注册" forState:UIControlStateNormal];
    [self.mailBtn setTitleColor:NORMAL_COLOR forState:(UIControlState)UIControlStateNormal];
    [self.mailBtn.titleLabel setFont:[UIFont systemFontOfSize:21]];
    [self.mailBtn addTarget:self action:@selector(mailbtn) forControlEvents:UIControlEventTouchUpInside];
    self.mailLineV.frame =CGRectMake(CGRectGetMaxX(self.phoneLineV.frame), CGRectGetMaxY(self.mailBtn.frame), self.mailBtn.frame.size.width, 1);
    self.mailLineV.backgroundColor = NORMAL_COLOR;//39 39 39  173  172  173
    [self.view addSubview:self.mailLineV];
#pragma mark - 登录
    UILabel * label  = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-60, SCREEN_HEIGHT-70, 80, 40)];
    label.font= [UIFont systemFontOfSize:14];
    label.backgroundColor = [UIColor clearColor];
    [self.view addSubview:label];
    label.text = @"已有账号?";
    label.textColor = NORMAL_COLOR;
    self.loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.loginBtn.frame = CGRectMake(CGRectGetMaxX(label.frame), label.frame.origin.y, 30, 40);
    [self.view addSubview:self.loginBtn];
    [self.loginBtn setTitleColor:ORANGE_COLOR forState:UIControlStateNormal];
    self.loginBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [self.loginBtn addTarget:self action:@selector(gotologin) forControlEvents:UIControlEventTouchUpInside];
#pragma mark - 中间部位
    self.midV = [[UIView alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(self.phoneLineV.frame)+30, SCREEN_WIDTH-60, 120)];
    [self.view addSubview:self.midV];
    self.midV.backgroundColor = [UIColor whiteColor];
    [self.midV addSubview:self.phoneV];
    
    [self.phoneV.GetCodeBtn addTarget:self action:@selector(getPhoneCode) forControlEvents:UIControlEventTouchUpInside];
    [self.mailV.GetCodeMailBtn addTarget:self action:@selector(getMailCode) forControlEvents:UIControlEventTouchUpInside];
#pragma mark - 下一步
    self.NextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.NextBtn.frame =CGRectMake(30, CGRectGetMaxY(self.midV.frame)+55, SCREEN_WIDTH-60, 60  );
    [self.view addSubview:self.NextBtn];
    self.NextBtn.backgroundColor = ORANGE_COLOR;
    self.NextBtn.layer.cornerRadius = 12;
    self.NextBtn.layer.masksToBounds = YES;
    [self.NextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [self.NextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.NextBtn addTarget:self action:@selector(goNext) forControlEvents:UIControlEventTouchUpInside];
    self.NextBtn.titleLabel.font = [UIFont systemFontOfSize:20];
}

/**
 下一步
 */
-(void)goNext{
    [self.sureV.FirstPassword   resignFirstResponder];
    [self.sureV.SecondPasswordTF resignFirstResponder];
    if (self.twoAction == NO) {
        self.twoAction = YES;
        if (self.phoneOrMail == YES) {
            if (self.phoneV.PhoneTF.text.length<1) {
                [CommonUtil setTip:@"请填写验证码"];
            }else{
                [self.phoneV removeFromSuperview];
                [self.midV addSubview:self.sureV];
                self.phoneCode = self.phoneV.yanzhengCodeTF.text;
            }
        }else{
            if (self.mailV.mailTF.text.length<1) {
                [CommonUtil setTip:@"请填写验证码"];
            }else{
                self.mailCode = self.mailV.mailCode.text;
                [self.mailV removeFromSuperview];
                [self.midV addSubview:self.sureV];
            }
        }
    }else{
        self.twoAction = NO;
        NSString *username = nil;
        NSString * code = nil;
        if (self.phoneOrMail == YES) {
            username  = self.phoneV.PhoneTF.text;
            code = _phoneCode;
        }else{
            username  = self.mailV.mailTF.text;
            code = _mailCode;
        }
        if ([self.sureV.SecondPasswordTF.text isEqualToString:self.sureV.FirstPassword.text]) {
            [UsingHUD showInView:self.view];
            [BLLetAccount regist:username password:self.sureV.SecondPasswordTF.text nickname:username vcode:code sex:BL_ACCOUNT_MALE birthday:@"" countryCode:@"86" iconPath:@"" completionHandler:^(BLLoginResult * _Nonnull result) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [UsingHUD hideInView:self.view];
                    if (result.error == 0) {
                        [CommonUtil  setTip:@"注册成功"];
                        [self.navigationController  popViewControllerAnimated:YES];
                        NSLog(@"成功%@",result);
                    }else{
                        
                        [CommonUtil  setTip:result.msg];
                    }
                });
               
            }];
        }else{
            [CommonUtil setTip:@"请确认两次密码相同"];
            
        }
    }
       
}
/**
 获取邮箱码
 */
-(void)getMailCode{
    [self.mailV.mailTF resignFirstResponder];
    [self.mailV.mailCode resignFirstResponder   ];
    if ([CommonUtil isValidateEmail:self.mailV.mailTF.text]) {
        [UsingHUD showInView:self.view];
        [BLLetAccount sendRegVCode:self.mailV.mailTF.text completionHandler:^(BLBaseResult * _Nonnull result) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [UsingHUD hideInView:self.view];
                if (result.error == 0) {
                    [CommonUtil  setTip:@"获取验证码成功，请稍后"];
                    NSLog(@"成功%@",result);
                }else{
                    
                    [CommonUtil  setTip:result.msg];
                }
            });
           
        }];
    }else{
             [CommonUtil setTip:@"请正确填写邮箱"];
    }
  
}
/**
 获取手机验证码
 */
-(void)getPhoneCode{
    [self.phoneV.PhoneTF resignFirstResponder];
    [self.phoneV.yanzhengCodeTF resignFirstResponder];
    if ([CommonUtil isMobileNumber:self.phoneV.PhoneTF.text]) {
        [UsingHUD showInView:self.view];
        [BLLetAccount   sendRegVCode:self.phoneV.PhoneTF.text countryCode:@"+86" completionHandler:^(BLBaseResult * _Nonnull result) {
           
            dispatch_async(dispatch_get_main_queue(), ^{
                [UsingHUD hideInView:self.view];
                if (result.error == 0) {
                    [CommonUtil  setTip:@"获取验证码成功，请稍后"];
                    NSLog(@"成功%@",result);
                }else{
                    
                    [CommonUtil  setTip:result.msg];
                }
                
            });
        }];
    }else{
        
        [CommonUtil  setTip:@"请正确填写手机号码"];
    };
   
}
-(void)phonebtn{
    if (self.phoneOrMail!= YES) {
        self.mailV = nil;
        self.sureV = nil;
        [self.phoneBtn setTitleColor:SELECT_COLOR forState:UIControlStateNormal];
        self.phoneLineV.backgroundColor =SELECT_COLOR;
        self.mailLineV.backgroundColor = NORMAL_COLOR;
        [self.mailBtn setTitleColor:NORMAL_COLOR forState:UIControlStateNormal];
        if (self.mailV) {
              [self.mailV removeFromSuperview];
        }
        [self.midV addSubview:self.phoneV];
        self.phoneOrMail = YES;
    }
}
-(void)mailbtn{
    if (self.phoneOrMail!= NO ) {
        self.phoneV = nil;
        self.sureV = nil;
        [self.phoneBtn setTitleColor:NORMAL_COLOR forState:UIControlStateNormal];
        [self.mailBtn setTitleColor:SELECT_COLOR forState:UIControlStateNormal];
        self.phoneLineV.backgroundColor =NORMAL_COLOR;
        self.mailLineV.backgroundColor = SELECT_COLOR;
        if (self.phoneV) {
            [self.phoneV removeFromSuperview];
        }
        [self.midV addSubview:self.mailV];
        self.phoneOrMail = NO;
    }
    
}
-(void)gotologin{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - LazyLoad
-(UIView *)phoneLineV{
    if (!_phoneLineV) {
        _phoneLineV = [[UIView alloc]init];
    }
    return _phoneLineV;
}
-(UIView *)mailLineV{
    if (!_mailLineV) {
        _mailLineV = [[UIView alloc]init];
    }
    return _mailLineV;
}
-(PhoneRegisterView *)phoneV{
    if (!_phoneV) {
        _phoneV = [[PhoneRegisterView alloc]initWithFrame: CGRectMake(0, 0, self.midV.frame.size.width,  self.midV.frame.size.height) ];
        
    }
    return _phoneV;
    
}
-(MailRegisterView *)mailV{
    if (!_mailV) {
        _mailV = [[MailRegisterView alloc]initWithFrame:CGRectMake(0, 0, self.midV.frame.size.width,  self.midV.frame.size.height)];
        
    }
    return  _mailV;
}
-(SureTheRegisterPasswordView *)sureV{
    if (!_sureV) {
        _sureV = [[SureTheRegisterPasswordView alloc]initWithFrame:CGRectMake(0, 0, self.midV.frame.size.width,  self.midV.frame.size.height)];
        
    }
    return _sureV;
}
-(NSString *)phoneCode{
    if (!_phoneCode) {
        _phoneCode = [[NSString alloc]init];
    }
    return _phoneCode;
}
-(NSString *)mailCode{
    if (!_mailCode) {
        _mailCode = [[NSString alloc]init];
    }
    return _mailCode    ;
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
