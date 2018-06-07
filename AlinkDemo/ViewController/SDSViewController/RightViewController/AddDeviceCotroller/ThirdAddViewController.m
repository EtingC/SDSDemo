//
//  ThirdAddViewController.m
//  AlinkDemo
//
//  Created by gubeidianzi on 2017/11/7.
//  Copyright © 2017年 aliyun. All rights reserved.
//

#import "ThirdAddViewController.h"
#import "ProgressView.h"
#import "FourAddViewController.h"
#import "FailureAddViewController.h"
#import "RightViewController.h"
#import "DeviceSuccessViewController.h"
 
#import "FailureAddViewController.h"
@interface ThirdAddViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ProgressV;

@property (weak, nonatomic) IBOutlet UILabel *topL;
@property (weak, nonatomic) IBOutlet UIImageView *loadingV;
@property (weak, nonatomic) IBOutlet UILabel *midL;

@property (weak, nonatomic) IBOutlet UIButton *nextBtn;


@property (nonatomic,strong) NSTimer * timer;
@end

@implementation ThirdAddViewController
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated   ];
//    [self.timer setFireDate:[NSDate distantFuture]];
//    [self.timer invalidate];
//    self.timer = nil;
}
-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
-(void)tranform{
    CABasicAnimation *animation =  [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
                                    
                                    //默认是顺时针效果，若将fromValue和toValue的值互换，则为逆时针效果
                                    
     animation.fromValue = [NSNumber numberWithFloat:0.f];
                                    
     animation.toValue =  [NSNumber numberWithFloat: M_PI *2];
                                    
     animation.duration  = 3;
                                    
     animation.autoreverses = NO;
                                    
     animation.fillMode =kCAFillModeForwards;
                                    
       animation.repeatCount = MAXFLOAT; //如果这里想设置成一直自旋转，可以设置为MAXFLOAT，否则设置具体的数值则代表执行多少次
                                    
      [self.loadingV.layer addAnimation:animation forKey:nil];
    
    
   
}
-(void)viewWillAppear:(BOOL)animated{
     [super viewWillAppear:animated  ];
   
//     self.timer = [NSTimer scheduledTimerWithTimeInterval:0.4 target:self selector:@selector(cycle) userInfo:nil repeats:YES];
//     [self.timer setFireDate:[NSDate distantPast]];
    if ([[DeviceInfoManager sharedManager].PID isEqualToString:@"000000000000000000000000d84e0000"]) {
        
            [self getdata];
    }
}
 
- (void)viewDidLoad {
    [super viewDidLoad];
     [self tranform  ];
    self.topL.text = NSLocalizedString(@"正在添加设备,请耐心等待", nil);
    self.midL.text = NSLocalizedString(@"尽量使您的路由器,手机与设备相互靠近", nil);
    self.view.backgroundColor = [UIColor whiteColor];
    self.title =  [DeviceInfoManager sharedManager].TheAddDevieceName;
 //    notifyProvisonResultError
 //notifyProvisonResult
    [self.nextBtn AddLayer:10];
    [self.nextBtn setTitle:NSLocalizedString(@"正在添加", nil) forState:UIControlStateNormal];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notifyProvisonResultError) name:@"notifyProvisonResultError" object:nil];
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notifyProvisonResult) name:@"notifyProvisonResult" object:nil];
   
    self.navigationItem.leftBarButtonItem = [self setNavLeftRightFrame:self.navigationController imageName:@"导航栏返回" selector:@"leftBtn"];
    self.navigationItem.leftBarButtonItem.target =self;
    self.navigationItem.leftBarButtonItem.style = UIBarButtonItemStylePlain;
   
}
-(void)getdata{
    WeakSelf
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        BLDeviceConfigResult *result = [[BLLet sharedLet].controller deviceConfig:self.wifiname password:self.wifipassword version:3 timeout:60];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.DeviceConfigResult = result;
            if (self.DeviceConfigResult.error == 0) {
                 [CommonUtil setTip:@"局域网配网成功"];
                NSMutableArray * SqliteDeviceInfoArr = [SDSsqlite FindDeviceInfoWithFamilyID:nil ];
                for (BLFamilyDeviceInfo *devModel in SqliteDeviceInfoArr) {
                    if ([devModel.did isEqualToString:result.did]) {
                        [SDSsqlite deleteDeviceWithDeviceDid:devModel.did];
                    }
                }
                
//                for (BLDNADevice *device in [LiangBaDevice sharedInstance].deviceArray) {
//                    if ([device.did isEqualToString:result.did]) {
//                        [[BLLet sharedLet].controller removeDevice:device];
//
////                        [SDSsqlite deleteDeviceWithDeviceDid:device.did];
//                    }
//                }
                 [[BLLet sharedLet].controller removeAllDevice];
                [[LiangBaDevice sharedInstance].deviceArray removeAllObjects];
                
                // GCD定时器
                __block  int timeout =75;
                dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
                dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0); //每秒执行
                dispatch_source_set_event_handler(_timer, ^{
                    if(timeout <= 0 ){// 倒计时结束
                        // 关闭定时器
                        dispatch_source_cancel(_timer);
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [weakSelf NotifyJoinResultError];
                        });
                         [CommonUtil setTip:[NSString stringWithFormat:@"局域网未搜索到设备"]];
                    }else{// 倒计时中
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSArray * arr =[[LiangBaDevice sharedInstance].deviceArray copy];
                            for (BLDNADevice * device in arr) {
                                NSLog(@"%d",timeout);
                                if ([self.DeviceConfigResult.mac isEqualToString:device.mac]) {
                                    dispatch_source_cancel(_timer); //如果在局域网设备中找到了需要配网绑定的设备 这时候 就关闭计时器
                                     [CommonUtil setTip:@"局域网已经找到设备"];
                                    [[NSNotificationCenter defaultCenter] postNotificationName:@"isSearchedDev" object:@{@"status":@"end"}];
                                    [[BLLet sharedLet].familyManager queryLoginUserFamilyIdListWithCompletionHandler:^(BLFamilyIdListGetResult * _Nonnull result) {
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            if (result.error == 0) {
                                                NSArray * arr = result.idList;
                                                if (arr.count>0) {    //查到有家庭 --》绑定设备
                                                     [CommonUtil setTip:@"查到家庭，开始添加设备"];
                                                    NSMutableArray *mutArr = [[NSMutableArray alloc]init];
                                                    BLModuleInfo *moduleInfo = [[BLModuleInfo alloc] init];
                                                    BLFamilyIdInfo *idinfo = result.idList.firstObject;
                                                    [mutArr addObject:idinfo.familyId];
                                                    moduleInfo.familyId = idinfo.familyId;
                                                    moduleInfo.roomId = @"";
                                                    if ([device.name isEqualToString:@"晾霸晾衣架"]) {
                                                        moduleInfo.name = @"晾霸智能电动晾衣机";
                                                        device.name = @"晾霸智能电动晾衣机";
                                                    }else{
                                                        moduleInfo.name = device.name;
                                                    }
                                                    moduleInfo.iconPath = [DeviceInfoManager sharedManager].imagePath;
                                                    moduleInfo.followDev =1;
                                                    moduleInfo.order = 1;
                                                    moduleInfo.flag = 1;
                                                    moduleInfo.moduleType = 3;
                                                    //                                                    moduleInfo.extend = uuid;//这里用获取到的设备的UUID 来传给这个extend字段 是为了后面的固件升级需求要的ali的uuid入参做准备，传给服务器，下次请求家庭设备信息的时候，有个字段blmoudleinfo里面的extend就可以当做固件升级的UUID入参
                                                    BLModuleIncludeDev *moduleDevs = [[BLModuleIncludeDev alloc] initWithDictionary:@{
                                                                                                                                      @"did" : device.did,
                                                                                                                                      @"sdid" : @"",
                                                                                                                                      @"order" : @0,
                                                                                                                                      @"content" : @""
                                                                                                                                      }];
                                                    moduleInfo.moduleDevs = @[moduleDevs];
                                                    BLFamilyDeviceInfo *familyinfo = [[BLFamilyDeviceInfo alloc]init];
                                                    familyinfo.familyId = idinfo.familyId;
                                                    familyinfo.roomId = @"";
                                                    familyinfo.did = device.did;
                                                    familyinfo.password = device.password;
                                                    familyinfo.type = device.type;
                                                    familyinfo.pid = device.pid;
                                                    familyinfo.mac = device.mac;
                                                    familyinfo.name = device.name;
                                                    familyinfo.lock = device.lock;
                                                    familyinfo.aesKey = device.controlKey;
                                                    familyinfo.terminalId = device.controlId;
                                                    familyinfo.subdeviceNum = 1;
                                                    familyinfo.longitude = @"1";
                                                    familyinfo.latitude = @"1";
                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                        [[BLLet sharedLet].familyManager   queryFamilyInfoWithIds:mutArr completionHandler:^(BLAllFamilyInfoResult * _Nonnull result) {
                                                            if(result.error == 0 ){
                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                    [SDSFamliyManager sharedInstance].familyinfo = result.allFamilyInfoArray.firstObject.familyBaseInfo;
                                                                    //绑定设备
                                                                    [[BLLet sharedLet].familyManager addModule:moduleInfo toFamily:[SDSFamliyManager sharedInstance].familyinfo withDevice:familyinfo subDevice:nil completionHandler:^(BLModuleControlResult * _Nonnull result) {
                                                                        if(result.succeed ==YES){
                                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                                //把数据本地保存
                                                                                [SDSsqlite AddDeviceInfo:(BLFamilyDeviceInfo *)familyinfo];
                                                                                [SDSsqlite AddMoudleInfo:moduleInfo];
                                                                                [weakSelf NotifyJoinResult];
                                                                            });
                                                                        }else{
                                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                                [[BLLet sharedLet].account refreshAccessTokenWithRefreshToken:[UserInfoManager sharedTool].RefreshToken clientId:LiangBaClientID clientSecret:CLIENT_SECRET completionHandler:^(BLOauthResult * _Nonnull result) {
                                                                                    
                                                                                    [[NSUserDefaults standardUserDefaults]setObject:result.refreshToken forKey:REFRESHTOKEN];
                                                                                    [[NSUserDefaults standardUserDefaults]setObject:result.accessToken forKey:DEVICETOKEN];
                                                                                    [[NSUserDefaults standardUserDefaults] synchronize];
                                                                                    
                                                                                    [[BLLet sharedLet].familyManager addModule:moduleInfo toFamily:[SDSFamliyManager sharedInstance].familyinfo withDevice:familyinfo subDevice:nil completionHandler:^(BLModuleControlResult * _Nonnull result) {
                                                                                        if(result.succeed ==YES){
                                                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                                                //把数据本地保存
                                                                                                [SDSsqlite AddDeviceInfo:(BLFamilyDeviceInfo *)familyinfo];
                                                                                                [SDSsqlite AddMoudleInfo:moduleInfo];
                                                                                                [weakSelf NotifyJoinResult];
                                                                                            });
                                                                                        }else{
                                                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                                                [CommonUtil setTip:[NSString stringWithFormat:@"绑定设备失败"]];
                                                                                            });
                                                                                            if ([CommonUtil isLoginExpired:result.error]) {
                                                                                                
                                                                                                NSLog(@"session过期了 需要重新登录");
                                                                                                
                                                                                            }else{
                                                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                                                    
                                                                                                    [weakSelf NotifyJoinResultError];
                                                                                                });
                                                                                            }
                                                                                        }
                                                                                    }];
                                                                                }];
                                                                            });
                                                                        }
                                                                    }];
                                                                });
                                                            }else{
                                                                
                                                                //   }else{ //通过id 找家庭信息 - 》失败 - 》刷新token -》再次请求家庭信息
                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                    
                                                                    [[BLLet sharedLet].account refreshAccessTokenWithRefreshToken:[UserInfoManager sharedTool].RefreshToken clientId:LiangBaClientID clientSecret:CLIENT_SECRET completionHandler:^(BLOauthResult * _Nonnull result) {
                                                                        
                                                                        [[NSUserDefaults standardUserDefaults]setObject:result.refreshToken forKey:REFRESHTOKEN];
                                                                        [[NSUserDefaults standardUserDefaults]setObject:result.accessToken forKey:DEVICETOKEN];
                                                                        [[NSUserDefaults standardUserDefaults] synchronize];
                                                                        
                                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                                            
                                                                            [[BLLet sharedLet].familyManager   queryFamilyInfoWithIds:mutArr completionHandler:^(BLAllFamilyInfoResult * _Nonnull result) {
                                                                                if(result.error == 0 ){
                                                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                                                        
                                                                                        [SDSFamliyManager sharedInstance].familyinfo = result.allFamilyInfoArray.firstObject.familyBaseInfo;
                                                                                        //绑定设备
                                                                                        [[BLLet sharedLet].familyManager addModule:moduleInfo toFamily:[SDSFamliyManager sharedInstance].familyinfo withDevice:familyinfo subDevice:nil completionHandler:^(BLModuleControlResult * _Nonnull result) {
                                                                                            if(result.succeed ==YES){
                                                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                                                    //把数据本地保存
                                                                                                    [SDSsqlite AddDeviceInfo:(BLFamilyDeviceInfo *)familyinfo];
                                                                                                    [SDSsqlite AddMoudleInfo:moduleInfo];
                                                                                                    [weakSelf NotifyJoinResult];
                                                                                                    
                                                                                                });
                                                                                                
                                                                                            }else{
                                                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                                                    [CommonUtil setTip:[NSString stringWithFormat:@"绑定设备失败"]];
                                                                                                });
                                                                                                if ([CommonUtil isLoginExpired:result.error]) {
                                                                                                    
                                                                                                    NSLog(@"session过期了 需要重新登录");
                                                                                                    
                                                                                                }else{
                                                                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                                                                        
                                                                                                        [weakSelf NotifyJoinResultError];
                                                                                                    });
                                                                                                }
                                                                                            }
                                                                                        }];
                                                                                    });
                                                                                }else{
                                                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                                                        [CommonUtil setTip:[NSString stringWithFormat:@"查询家庭详细信息失败"]];
                                                                                    });
                                                                                    if ([CommonUtil isLoginExpired:result.error]) {
                                                                                        
                                                                                        NSLog(@"session过期了 需要重新登录");
                                                                                        
                                                                                    }else{
                                                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                                                            
                                                                                            
                                                                                            [weakSelf NotifyJoinResultError];
                                                                                        });
                                                                                    }
                                                                                }
                                                                            }];
                                                                        });
                                                                    }];
                                                                });
                                                                //                                                        }
                                                            }
                                                        }];
                                                    });
                                                }
                                            }else{ //查询家庭信息失败
                                                
                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                    
                                                    [[BLLet sharedLet].account refreshAccessTokenWithRefreshToken:[UserInfoManager sharedTool].RefreshToken clientId:LiangBaClientID clientSecret:CLIENT_SECRET completionHandler:^(BLOauthResult * _Nonnull result) {
                                                        if (result.succeed) {
                                                            [[NSUserDefaults standardUserDefaults]setObject:result.refreshToken forKey:REFRESHTOKEN];
                                                            [[NSUserDefaults standardUserDefaults]setObject:result.accessToken forKey:DEVICETOKEN];
                                                            [[NSUserDefaults standardUserDefaults] synchronize];
                                                            
                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                
                                                                [[BLLet sharedLet].familyManager queryLoginUserFamilyIdListWithCompletionHandler:^(BLFamilyIdListGetResult * _Nonnull result) {
                                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                                        if (result.error == 0) {
                                                                            NSArray * arr = result.idList;
                                                                            if (arr.count>0) {    //查到有家庭 --》绑定设备
                                                                                NSMutableArray *mutArr = [[NSMutableArray alloc]init];
                                                                                
                                                                                BLModuleInfo *moduleInfo = [[BLModuleInfo alloc] init];
                                                                                BLFamilyIdInfo *idinfo = result.idList.firstObject;
                                                                                [mutArr addObject:idinfo.familyId];
                                                                                moduleInfo.familyId = idinfo.familyId;
                                                                                moduleInfo.roomId = @"";
                                                                                moduleInfo.name = device.name;
                                                                                moduleInfo.iconPath = [DeviceInfoManager sharedManager].imagePath;
                                                                                moduleInfo.followDev =1;
                                                                                moduleInfo.order = 1;
                                                                                moduleInfo.flag = 1;
                                                                                moduleInfo.moduleType = 3;
                                                                                // moduleInfo.extend = uuid;//这里用获取到的设备的UUID 来传给这个extend字段 是为了后面的固件升级需求要的ali的uuid入参做准备，传给服务器，下次请求家庭设备信息的时候，有个字段blmoudleinfo里面的extend就可以当做固件升级的UUID入参
                                                                                BLModuleIncludeDev *moduleDevs = [[BLModuleIncludeDev alloc] initWithDictionary:@{
                                                                                                                                                                  @"did" : device.did,
                                                                                                                                                                  @"sdid" : @"",
                                                                                                                                                                  @"order" : @0,
                                                                                                                                                                  @"content" : @""
                                                                                                                                                                  }];
                                                                                moduleInfo.moduleDevs = @[moduleDevs];
                                                                                
                                                                                
                                                                                BLFamilyDeviceInfo *familyinfo = [[BLFamilyDeviceInfo alloc]init];
                                                                                familyinfo.familyId = idinfo.familyId;
                                                                                familyinfo.roomId = @"";
                                                                                familyinfo.did = device.did;
                                                                                familyinfo.password = device.password;
                                                                                familyinfo.type = device.type;
                                                                                familyinfo.pid = device.pid;
                                                                                familyinfo.mac = device.mac;
                                                                                familyinfo.name = device.name;
                                                                                familyinfo.lock = device.lock;
                                                                                familyinfo.aesKey = device.controlKey;
                                                                                familyinfo.terminalId = device.controlId;
                                                                                familyinfo.subdeviceNum = 1;
                                                                                familyinfo.longitude = @"1";
                                                                                familyinfo.latitude = @"1";
                                                                                
                                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                                    [[BLLet sharedLet].familyManager   queryFamilyInfoWithIds:mutArr completionHandler:^(BLAllFamilyInfoResult * _Nonnull result) {
                                                                                        if(result.error == 0 ){
                                                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                                                
                                                                                                [SDSFamliyManager sharedInstance].familyinfo = result.allFamilyInfoArray.firstObject.familyBaseInfo;
                                                                                                //绑定设备
                                                                                                [[BLLet sharedLet].familyManager addModule:moduleInfo toFamily:[SDSFamliyManager sharedInstance].familyinfo withDevice:familyinfo subDevice:nil completionHandler:^(BLModuleControlResult * _Nonnull result) {
                                                                                                    if(result.succeed ==YES){
                                                                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                                                                            //把数据本地保存
                                                                                                            [SDSsqlite AddDeviceInfo:(BLFamilyDeviceInfo *)familyinfo];
                                                                                                            [SDSsqlite AddMoudleInfo:moduleInfo];
                                                                                                            [weakSelf NotifyJoinResult];
                                                                                                            
                                                                                                        });
                                                                                                        
                                                                                                    }else{
                                                                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                                                                            [CommonUtil setTip:[NSString stringWithFormat:@"绑定设备失败"]];
                                                                                                        });
                                                                                                        if ([CommonUtil isLoginExpired:result.error]) {
                                                                                                            
                                                                                                            NSLog(@"session过期了 需要重新登录");
                                                                                                            
                                                                                                        }else{
                                                                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                                                                
                                                                                                                [weakSelf NotifyJoinResultError];
                                                                                                            });
                                                                                                        }
                                                                                                    }
                                                                                                }];
                                                                                            });
                                                                                            
                                                                                        }else{
                                                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                                                [CommonUtil setTip:[NSString stringWithFormat:@"查询家庭详细信息失败"]];
                                                                                            });
                                                                                            if ([CommonUtil isLoginExpired:result.error]) {
                                                                                                
                                                                                                NSLog(@"session过期了 需要重新登录");
                                                                                                
                                                                                            }else{
                                                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                                                    
                                                                                                    [weakSelf NotifyJoinResultError];
                                                                                                });
                                                                                            }
                                                                                        }
                                                                                    }];
                                                                                });
                                                                            }
                                                                        }else{
                                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                                [CommonUtil setTip:[NSString stringWithFormat:@"查询家庭信息失败"]];
                                                                            });
                                                                            if ([CommonUtil isLoginExpired:result.error]) {
                                                                                
                                                                                NSLog(@"session过期了 需要重新登录");
                                                                                
                                                                            }else{
                                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                                    
                                                                                    [weakSelf NotifyJoinResultError];
                                                                                });
                                                                            }
                                                                            
                                                                        }
                                                                    });
                                                                }];
                                                                
                                                            });
                                                        }
                                                        
                                                    }];
                                                });
                                            }
                                        });
                                    }];
                                    
                                    break;
                                }
                            }
                        });
                        
                        timeout--;
                    }
                });
                // 开启定时器
                dispatch_resume(_timer);
                [[NSNotificationCenter defaultCenter] postNotificationName:@"isSearchedDev" object:@{@"status":@"start"}];
            }else{
                [CommonUtil setTip:[NSString stringWithFormat:@"局域网配置失败%@",result.msg]];
                [self NotifyJoinResultError];
//                dispatch_async(dispatch_get_main_queue(), ^{
                    //                    [CommonUtil setTip:result.msg];
//                });
                
            }
        });
    });
    
}
/**
 激活失败
 */
-(void)NotifyJoinResultError{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIStoryboard * strory = [UIStoryboard  storyboardWithName:@"LeftMenuViewController" bundle:[NSBundle mainBundle]];
        FailureAddViewController *  vc = [strory instantiateViewControllerWithIdentifier:@"failureAdd"];
        
        [self.navigationController  pushViewController:vc animated:YES];
        
    });
    
}

/**
 成功激活
 */
-(void)NotifyJoinResult{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIStoryboard * strory = [UIStoryboard  storyboardWithName:@"LeftMenuViewController" bundle:[NSBundle mainBundle]];
        DeviceSuccessViewController *  vc = [strory instantiateViewControllerWithIdentifier:@"devicesuccess"];
        
        [self.navigationController  pushViewController:vc animated:YES];
    });
    
}


-(void)leftBtn{
    [super leftBtn ];
    [kLkAddDevBiz stopAddDevice];
    if ([self isKindOfClass:[RightViewController class]]) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[RightViewController class]]) {
                RightViewController *A =(RightViewController *)controller;
                [self.navigationController popToViewController:A animated:YES];
            }
        }
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:@"STOPTIME" object:nil];
}
-(void)notifyProvisonResult{
    UIStoryboard * strory = [UIStoryboard  storyboardWithName:@"LeftMenuViewController" bundle:[NSBundle mainBundle]];
    FourAddViewController *  vc = [strory instantiateViewControllerWithIdentifier:@"fourAdd"];
    
    [self.navigationController  pushViewController:vc animated:YES];
    
}

-(void)notifyProvisonResultError{
    
        UIStoryboard * strory = [UIStoryboard  storyboardWithName:@"LeftMenuViewController" bundle:[NSBundle mainBundle]];
        FailureAddViewController *  vc = [strory instantiateViewControllerWithIdentifier:@"failureAdd"];
    
        [self.navigationController  pushViewController:vc animated:YES];
    
}
- (IBAction)push:(id)sender {
  
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
