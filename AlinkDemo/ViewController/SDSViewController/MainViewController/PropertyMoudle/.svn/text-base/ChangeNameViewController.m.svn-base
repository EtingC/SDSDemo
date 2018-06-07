//
//  ChangeNameViewController.m
//  AlinkDemo
//
//  Created by gubeidianzi on 2017/11/23.
//  Copyright © 2017年 aliyun. All rights reserved.
//

#import "ChangeNameViewController.h"
#import "BLModuleInfo.h"
@interface ChangeNameViewController ()
@property (nonatomic,strong) UITextField * tf;
@end

@implementation ChangeNameViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated  ];
    self.tabBarController.tabBar.hidden = YES;
  
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO; 
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [CommonUtil getColor:@"#F3F3F3"];
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(0, 0, 44, 44);
    [btn setTitle:NSLocalizedString(@"保存", nil) forState:UIControlStateNormal];
    [btn setTintColor:[UIColor blackColor ]];
    [btn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * bar = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = bar;
    self.title= self.name;
    self.tf = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
    self.tf.layer.borderColor = [UIColor blackColor].CGColor;
    self.tf.layer.borderWidth = 0.1;
    self.tf.text =self.name;
    self.tf.placeholder =NSLocalizedString(@"请输入", nil) ;
    UIView * v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 30, 50)];
    v.backgroundColor = [UIColor whiteColor];
    self.tf.leftView =v;
    self.tf.leftViewMode = UITextFieldViewModeAlways;
    self.tf.backgroundColor = [UIColor whiteColor];
    self.tf.clearButtonMode = UITextFieldViewModeAlways;
    [self.view addSubview:self.tf];
    
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"导航栏返回"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(back1)];    self.navigationItem.leftBarButtonItem = left;

    // Do any additional setup after loading the view.
}
-(void)back1{
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)click{
      [self.tf resignFirstResponder];
    
    WeakSelf
    if (self.tf.text.length<1) {
        [CommonUtil setTip:@"亲,请填写正确的名称哦！"];
    }else if ([self.tf.text isEqualToString:self.name]){
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        /**
         Modify module info from family
         
         @param moduleInfo          Modify module info
         @param familyId            Family ID
         @param version             Family current version
         @param completionHandler   Callback with modify result
         */
//        - (void)modifyModule:(nonnull BLModuleInfo*)moduleInfo fromFamilyId:(nonnull NSString *)familyId familyVersion:(nullable NSString *)version completionHandler:(nullable void (^)(BLModuleControlResult * __nonnull result))completionHandler;
        BLModuleInfo * info = [[BLModuleInfo alloc]init];
        info = [SDSFamliyManager sharedInstance].deFaInfoData.moduleInfo;
        info.name = self.tf.text;
        [UsingHUD showInView:self.view];
        [[BLLet sharedLet].familyManager modifyModule:info fromFamilyId:[SDSFamliyManager sharedInstance].famliyID familyVersion:[SDSFamliyManager sharedInstance].familyVer completionHandler:^(BLModuleControlResult * _Nonnull result) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [UsingHUD hideInView:weakSelf.view];
                if (result.error == 0) {
                    weakSelf.back(weakSelf.tf.text);
                    
                    [SDSsqlite UpdateDeviceName:weakSelf.tf.text WithDid:[SDSFamliyManager sharedInstance].deFaInfoData.deviceInfo.did];
                    
                    [[NSUserDefaults standardUserDefaults]setObject:result.version forKey:@"FAMILYVERSION"];
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                    
                }else{
                    
                    [[BLLet sharedLet].account refreshAccessTokenWithRefreshToken:[UserInfoManager sharedTool].RefreshToken clientId:LiangBaClientID clientSecret:CLIENT_SECRET completionHandler:^(BLOauthResult * _Nonnull result) {
                        
                        [[NSUserDefaults standardUserDefaults]setObject:result.refreshToken forKey:REFRESHTOKEN];
                        [[NSUserDefaults standardUserDefaults]setObject:result.accessToken forKey:DEVICETOKEN];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        
                        [[BLLet sharedLet].familyManager modifyModule:info fromFamilyId:[SDSFamliyManager sharedInstance].famliyID familyVersion:[SDSFamliyManager sharedInstance].familyVer completionHandler:^(BLModuleControlResult * _Nonnull result) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [UsingHUD hideInView:weakSelf.view];
                                if (result.error == 0) {
                                    weakSelf.back(weakSelf.tf.text);
                                    [SDSsqlite UpdateDeviceName:weakSelf.tf.text WithDid:[SDSFamliyManager sharedInstance].deFaInfoData.deviceInfo.did];
                                    [[NSUserDefaults standardUserDefaults]setObject:result.version forKey:@"FAMILYVERSION"];
                                    [weakSelf.navigationController popViewControllerAnimated:YES];
                                    
                                }else{
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        [UsingHUD hideInView:weakSelf.view];
                                        if ([CommonUtil isLoginExpired:result.error]) {
                                            
                                            NSLog(@"session过期了 需要重新登录");
                                            
                                        }else{
                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                [CommonUtil setTip:result.msg];
                                            });
                                        }
                                    });
                                }
                            });
                        }];
                    }];
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
