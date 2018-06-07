//
//  SureZhuCeViewController.m
//  AlinkDemo
//
//  Created by gubeidianzi on 2017/12/4.
//  Copyright © 2017年 aliyun. All rights reserved.
//

#import "SureZhuCeViewController.h"

@interface SureZhuCeViewController ()
@property (nonatomic,strong) UIButton * firstBtn;
@property (nonatomic,strong) UIButton * secondBtn;
@end

@implementation SureZhuCeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =NSLocalizedString( @"注册", nil);
    [self changeleftItem];
    [self.ZhuCeBtn AddLayer:10];
    [self setConfigue];
    self.TwoCodeTF.placeholder  =NSLocalizedString( @"输入短信验证码", nil);
    self.PassWordTF.placeholder  =NSLocalizedString( @"输入6-16位数字字符组合密码", nil);
    self.AgainPasswordTF.placeholder  =NSLocalizedString( @"再输入一遍密码", nil);
    [self.SendBtn setTitle:NSLocalizedString(@"再输入一遍密码", nil) forState:UIControlStateNormal];
    [self.ZhuCeBtn setTitle:NSLocalizedString(@"注册", nil) forState:UIControlStateNormal];
     self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
}
-(void)setConfigue{
    if (self.phoneStr) {
        NSString * str = [[NSString alloc]init];
        str = self.phoneStr;
        str =  [ str stringByReplacingCharactersInRange:NSMakeRange(3, 5)  withString:@"*****"];
        str = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"短信验证码已发送至", nil), str];
        self.PhoneSyr.text =  str;
    }
    self.firstBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.firstBtn.frame =CGRectMake(0, 0, 25, 18);
    [self.firstBtn setBackgroundImage:[UIImage imageNamed:@"密码可见"] forState:UIControlStateNormal];
    self.secondBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.secondBtn.frame =CGRectMake(0, 0, 25, 18);
    [self.secondBtn setBackgroundImage:[UIImage imageNamed:@"密码可见"] forState:UIControlStateNormal];
    
    
    self.PassWordTF.rightView = self.firstBtn;
    self.PassWordTF.rightViewMode = UITextFieldViewModeAlways;
    
    self.AgainPasswordTF.rightView = self.secondBtn;
    self.AgainPasswordTF.rightViewMode = UITextFieldViewModeAlways;
    
}
- (IBAction)AgainGetCode:(id)sender {
    __block NSInteger time = 59; //倒计时时间
    [self.PassWordTF resignFirstResponder];
    [self.AgainPasswordTF resignFirstResponder];
    [UsingHUD showInView:self.view];
    WeakSelf
    [BLLetAccount   sendRegVCode:weakSelf.phoneStr countryCode:@"+86" completionHandler:^(BLBaseResult * _Nonnull result) {
        dispatch_async(dispatch_get_main_queue(), ^{
              [UsingHUD hideInView:weakSelf.view];
       });
        
        if (result.error == 0) {

            __block NSInteger time = 59; //倒计时时间
            
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
            
            dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
            
            dispatch_source_set_event_handler(_timer, ^{
                
                if(time <= 0){ //倒计时结束，关闭
                    
                    dispatch_source_cancel(_timer);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        //设置按钮的样式
                        [weakSelf.SendBtn setTitle:NSLocalizedString(@"重新发送", nil) forState:UIControlStateNormal];
                        [weakSelf.SendBtn setTitleColor:[CommonUtil getColor:@"#F1AA3E"] forState:UIControlStateNormal];
                        weakSelf.SendBtn.userInteractionEnabled = YES;
                    });
                    
                }else{
                    
                    int seconds = time % 60;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        //设置按钮显示读秒效果
                        [weakSelf.SendBtn setTitle:[NSString stringWithFormat:@"%@(%.2d)",NSLocalizedString(@"重新发送", nil), seconds] forState:UIControlStateNormal];
                        [weakSelf.SendBtn setTitleColor:[CommonUtil getColor:@"#BBBBBB"] forState:UIControlStateNormal];
                        weakSelf.SendBtn.userInteractionEnabled = NO;
                    });
                    time--;
                }
            });
          
                                              
         }else{
             dispatch_async(dispatch_get_main_queue(), ^{
                  [CommonUtil  setTip:result.msg];
             });
             
         }
        
      }];
 
}
- (IBAction)ZhuceAction:(id)sender {
    WeakSelf
    [self.PassWordTF resignFirstResponder];
    [self.AgainPasswordTF resignFirstResponder];
    if (weakSelf.TwoCodeTF.text.length <1) {
        [CommonUtil setTip:NSLocalizedString(@"请填写验证码", nil)];
    }else if (weakSelf.PassWordTF.text.length<1 ||weakSelf.AgainPasswordTF.text.length <1){
        
        [CommonUtil setTip:NSLocalizedString(@"请填写密码/再次输入的密码", nil)];
    }else if (![weakSelf.PassWordTF.text isEqualToString:weakSelf.AgainPasswordTF.text]){
        
        [CommonUtil setTip:NSLocalizedString(@"两次密码输入不相同!", nil)];
    } else{
        
        [BLLetAccount regist:weakSelf.phoneStr password:weakSelf.PassWordTF.text nickname:weakSelf.phoneStr vcode:weakSelf.TwoCodeTF.text sex:BL_ACCOUNT_MALE birthday:@"" countryCode:@"86" iconPath:@"" completionHandler:^(BLLoginResult * _Nonnull result) {
           
            dispatch_async(dispatch_get_main_queue(), ^{
                [UsingHUD hideInView:self.view];
                if (result.error == 0) {
                    [weakSelf.navigationController  popToRootViewControllerAnimated:YES];
                    NSLog(@"成功%@",result);
                }else{
                    [CommonUtil  setTip:result.msg];
                }
            });
            
        }];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.TwoCodeTF endEditing:YES];
    [self.PassWordTF endEditing:YES];
    [self.AgainPasswordTF endEditing:YES];
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
