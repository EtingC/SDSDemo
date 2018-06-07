//
//  LoginViewController.m
//  AlinkDemo
//
//  Created by gubeidianzi on 2017/11/7.
//  Copyright © 2017年 aliyun. All rights reserved.
//

#import "LoginViewController.h"
#import "ChangePassWordViewController.h"
#import "ZhuCeViewController.h"
@interface LoginViewController ()
 
@property (weak, nonatomic) IBOutlet UIButton *miwenChangeBTN;

@property (weak, nonatomic) IBOutlet UIButton *LoginBtn;

@end

@implementation LoginViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

/**
 密码的显示模式的更改

 @param sender sender descriptionmimaChange
 */
- (IBAction)mimaChange:(id)sender {
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
  
    self.LoginBtn.layer.cornerRadius = 12;
    self.LoginBtn.layer.masksToBounds = YES;
   
    // Do any additional setup after loading the view.
}

/**
 登录

 @param sender login
 */
- (IBAction)login:(id)sender {
    [self.AccountTF resignFirstResponder];
    [self.PassWordTF resignFirstResponder];
    [UserInfoManager  sharedTool].account = self.AccountTF.text;
    [UserInfoManager sharedTool].password = self.PassWordTF.text;
     [UsingHUD   showInView:self.view];
    if([[AlinkAccount sharedInstance] isLogin]){
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"已经登录过" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }else{
       WeakSelf
        [[AlinkAccount sharedInstance] loginWithViewController:nil completionHandler:^(BOOL isSuccessful, NSDictionary *loginResult) {
            NSLog(@"登录成功了%@",loginResult);
          } cancelationHandler:^{
//            DDLogInfo(@"Alink login canceled!");
        }];
    }
}

/**
 忘记密码

 @param sender wangjiPassword
 */
- (IBAction)wangjiPassword:(id)sender {
    
    UIStoryboard * stroy = [UIStoryboard    storyboardWithName:@"Login" bundle:[NSBundle mainBundle]];
    ChangePassWordViewController * vc = [stroy instantiateViewControllerWithIdentifier:@"changepassword"];
    
    [self.navigationController   pushViewController:vc animated:YES];
    
}

/**
 注册界面的展示

 @param sender ZhucePerson
 */
- (IBAction)ZhucePerson:(id)sender {
    ZhuCeViewController * zhuce = [[ZhuCeViewController   alloc]init];
    [self presentViewController:zhuce animated:YES completion:nil];
    
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
