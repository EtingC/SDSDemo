//
//  BianJiViewController.m
//  AlinkDemo
//
//  Created by gubeidianzi on 2017/11/6.
//  Copyright © 2017年 aliyun. All rights reserved.
//

#import "BianJiViewController.h"

@interface BianJiViewController ()
@property (nonatomic,strong) UITextField * tf;
@end

@implementation BianJiViewController
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
       self.tabBarController.tabBar.hidden = NO;
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated  ];
    self.tabBarController.tabBar.hidden = YES;
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self changeleftItem];
    self.view.backgroundColor = [CommonUtil getColor:@"#F3F3F3"];
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(10, 0, 44, 44);
    [btn setTitle:NSLocalizedString(@"保存", nil)  forState:UIControlStateNormal];
    [btn setTintColor:[UIColor blackColor  ]];
    [btn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * bar = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = bar;
    self.title= @"编辑昵称";
    self.tf = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
    self.tf.layer.borderColor = [UIColor blackColor].CGColor;
    self.tf.layer.borderWidth = 0.1;
    self.tf.text = [[NSUserDefaults standardUserDefaults]valueForKey:@"NICKNAME"];
    self.tf.placeholder = @"请输入";
    UIView * v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 30, 50)];
    v.backgroundColor = [UIColor whiteColor];
    self.tf.leftView =v;
    self.tf.leftViewMode = UITextFieldViewModeAlways;
    self.tf.backgroundColor = [UIColor whiteColor];
    self.tf.clearButtonMode = UITextFieldViewModeAlways;
    [self.view addSubview:self.tf];
    // Do any additional setup after loading the view.
}
-(void)click{
    [self.tf resignFirstResponder];
    WeakSelf
    if (self.tf.text.length<1) {
        [CommonUtil setTip:NSLocalizedString(@"亲,请填写正确的名称哦", nil) ];
    }else if ([self.tf.text isEqualToString:[[NSUserDefaults standardUserDefaults]valueForKey:@"NICKNAME"]]){
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [UsingHUD showInView:self.view];
        [BLLetAccount modifyUserNickname:self.tf.text completionHandler:^(BLBaseResult * _Nonnull result) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [UsingHUD hideInView:weakSelf.view];
                if (result) {
                    if (result.error== 0) {
                        [[NSUserDefaults standardUserDefaults]setObject:weakSelf.tf.text forKey:@"NICKNAME"];
                        [weakSelf.navigationController popViewControllerAnimated:YES];
                        if (weakSelf.callblock) {
                            weakSelf.callblock(weakSelf.tf.text);
                        }
                    }else{
                        
                        [[BLLet sharedLet].account refreshAccessTokenWithRefreshToken:[UserInfoManager sharedTool].RefreshToken clientId:LiangBaClientID clientSecret:CLIENT_SECRET completionHandler:^(BLOauthResult * _Nonnull result) {
                            
                            [[NSUserDefaults standardUserDefaults]setObject:result.refreshToken forKey:REFRESHTOKEN];
                            [[NSUserDefaults standardUserDefaults]setObject:result.accessToken forKey:DEVICETOKEN];
                            [[NSUserDefaults standardUserDefaults] synchronize];
                            
                            [BLLetAccount modifyUserNickname:self.tf.text completionHandler:^(BLBaseResult * _Nonnull result) {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [UsingHUD hideInView:weakSelf.view];
                                    if (result) {
                                        if (result.error== 0) {
                                            [[NSUserDefaults standardUserDefaults]setObject:weakSelf.tf.text forKey:@"NICKNAME"];
                                            [weakSelf.navigationController popViewControllerAnimated:YES];
                                            if (weakSelf.callblock) {
                                                weakSelf.callblock(weakSelf.tf.text);
                                            }
                                        }else{
                                            [[BLLet sharedLet].account refreshAccessTokenWithRefreshToken:[UserInfoManager sharedTool].RefreshToken clientId:LiangBaClientID clientSecret:CLIENT_SECRET completionHandler:^(BLOauthResult * _Nonnull result) {
                                                
                                                [[NSUserDefaults standardUserDefaults]setObject:result.refreshToken forKey:REFRESHTOKEN];
                                                [[NSUserDefaults standardUserDefaults]setObject:result.accessToken forKey:DEVICETOKEN];
                                                [[NSUserDefaults standardUserDefaults] synchronize];
                                            }];
                                            
                                            if ([CommonUtil isLoginExpired:result.error]) {
                                                
                                                NSLog(@"session过期了 需要重新登录");
                                                
                                            }else{
                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                    [CommonUtil setTip:result.msg];
                                                });
                                            }
                                        }
                                    }
                                });
                            }];
                        }];
                    }
                }
            });
        }];
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
