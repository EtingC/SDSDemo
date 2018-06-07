//
//  LiangBaLoginViewController.m
//  AlinkDemo
//
//  Created by gubeidianzi on 2017/11/30.
//  Copyright © 2017年 aliyun. All rights reserved.
//

#import "LiangBaLoginViewController.h"
#import "FindPasswordViewController.h"
#import "ZhuceViewController.h"
#import "RootViewController.h"
#import "DeviceViewController.h"
@interface LiangBaLoginViewController ()
@property (weak, nonatomic) IBOutlet UILabel *NoAccoutntL;
@property (weak, nonatomic) IBOutlet UIButton *RightSecurityBtn;

@end

@implementation LiangBaLoginViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.LoginBtn AddLayer:10];
    self.NoAccoutntL.text = NSLocalizedString(@"还没有账号?", nil);
    self.PhoneTF.placeholder = NSLocalizedString(@"手机", nil);
    self.PasswordTF.placeholder =NSLocalizedString(@"密码", nil);
    [self.PasswordTF setValue:[CommonUtil getColor:@"#BBBBBB"] forKeyPath:@"_placeholderLabel.textColor"];
    [self.PhoneTF setValue:[CommonUtil getColor:@"#BBBBBB"] forKeyPath:@"_placeholderLabel.textColor"];
    self.PasswordTF.secureTextEntry = YES;
    [self.DismissPasswordBtn setTitle:NSLocalizedString(@"忘记密码?", nil)  forState:UIControlStateNormal];
     [self.ZhuCeBtn setTitle:NSLocalizedString(@"注册", nil)  forState:UIControlStateNormal];
    [self.LoginBtn setTitle:NSLocalizedString(@"登 录", nil)  forState:UIControlStateNormal];
    [self.RightSecurityBtn setImage:[UIImage imageNamed:@"密码不可见"] forState:UIControlStateNormal];
    // Do any additional setup after loading the view.
}
- (IBAction)passwordSecurity:(id)sender {
    
    self.PasswordTF.secureTextEntry = !self.PasswordTF.secureTextEntry;
    if (self.PasswordTF.secureTextEntry == YES) {
         [self.RightSecurityBtn setImage:[UIImage imageNamed:@"密码不可见"] forState:UIControlStateNormal];
    }else{
        [self.RightSecurityBtn setImage:[UIImage imageNamed:@"密码可见"] forState:UIControlStateNormal];
        }
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.PhoneTF resignFirstResponder];
    [self.PasswordTF resignFirstResponder];
    
}
- (IBAction)Login:(id)sender {
    [self.PhoneTF resignFirstResponder];
    [self.PasswordTF resignFirstResponder];
    [UserInfoManager  sharedTool].account = self.PhoneTF.text;
    [UserInfoManager sharedTool].password = self.PasswordTF.text;
   
 
    if(self.PhoneTF.text.length <1 ||self.PasswordTF.text.length <1 ){
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请填写账号密码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }else{
        [UsingHUD showInView:[DeviceInfoManager getCurrentVC].view];
        [[AlinkAccount sharedInstance] loginWithViewController:nil completionHandler:^(BOOL isSuccessful, NSDictionary *loginResult) {
            NSLog(@"%d--登录%@",isSuccessful,loginResult);
        } cancelationHandler:^{
          
        }];
    } 
}
- (IBAction)DisMissAction:(id)sender {
    FindPasswordViewController *vc =[[FindPasswordViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)ZhuceAction:(id)sender {
    ZhuceViewController *vc = [[ZhuceViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
   
}
- (IBAction)secrityChange:(id)sender {
    
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
