//
//  TheFirmwareUpdateViewController.m
//  AlinkDemo
//
//  Created by gubeidianzi on 2017/12/12.
//  Copyright © 2017年 aliyun. All rights reserved.
//

#import "TheFirmwareUpdateViewController.h"
#import "VersionTableViewCell.h"
@interface TheFirmwareUpdateViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) NSMutableDictionary * dataDIC;
@property (nonatomic,strong) UIButton * btn;
@end

@implementation TheFirmwareUpdateViewController
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    WeakSelf
     self.btn.userInteractionEnabled = NO;
    [self.btn setTitleColor: [UIColor grayColor] forState:UIControlStateNormal];
    self.dataDIC = [[NSMutableDictionary alloc]init];
    //queryFirmwareVersion ---》数据放回
    //        {
    //            versions =     (
    //                            {
    //                                changelog =             {
    //                                    cn = "\U66f4\U65b0\U5185\U5bb9\Uff1a\n\U89e3\U51b3\U79bb\U7ebf\U95ee\U9898";
    //                                    en = "updating:\nSolving offline  problems ";
    //                                };
    //                                date = "2017-11-02";
    //                                url = "http://fwversions.ibroadlink.com/firmware/download/20379/ELECTROLUX-45016-7682-BL-255-compatible.bin";
    //                                version = 16;
    //                            }
    //                            );
    //        }
    BLFirmwareVersionResult *Result = [[BLLet sharedLet].controller queryFirmwareVersion:[BLDeviceService sharedDeviceService].selectDevice.did];
    if (Result.error == 0) {
     [[NetworkTool sharedTool]getServerDeviceFirmwareVersionWithDeviceType:  [BLDeviceService sharedDeviceService].selectDevice.type  localVersion: [Result.version integerValue]  success:^(id param) {
          NSMutableDictionary * paramD = param;
           weakSelf.dataDIC = [paramD copy];
         NSIndexPath *path= [NSIndexPath indexPathForRow:0 inSection:0];
         NSIndexPath *path1= [NSIndexPath indexPathForRow:1 inSection:0];
         VersionTableViewCell *cell = [weakSelf.myTable cellForRowAtIndexPath:path];
         VersionTableViewCell *cell1 = [weakSelf.myTable cellForRowAtIndexPath:path1];
         cell.versionNum.text =Result.version;
         cell1.versionNum.text =[paramD valueForKey:@"version"];
           [weakSelf.myTable reloadData];
         
         if ([[NSString stringWithFormat:@"%@",[paramD valueForKey:@"version"]] isEqualToString: Result.version ] ) {
              weakSelf.btn.userInteractionEnabled = NO;
              [weakSelf.btn setTitle:NSLocalizedString(@"已经是最新版本", nil)  forState:UIControlStateNormal];
              [weakSelf.btn setTitleColor: [UIColor grayColor] forState:UIControlStateNormal];
         }else{
              weakSelf.btn.userInteractionEnabled = YES;
              [weakSelf.btn setTitleColor: [UIColor orangeColor] forState:UIControlStateNormal];
              [weakSelf.btn setTitle:NSLocalizedString(@"升级至最新版本", nil) forState:UIControlStateNormal];
         }
        } failure:^(id param) {
            
            
            [[BLLet sharedLet].account refreshAccessTokenWithRefreshToken:[UserInfoManager sharedTool].RefreshToken clientId:LiangBaClientID clientSecret:CLIENT_SECRET completionHandler:^(BLOauthResult * _Nonnull result) {
                
                [[NSUserDefaults standardUserDefaults]setObject:result.refreshToken forKey:REFRESHTOKEN];
                [[NSUserDefaults standardUserDefaults]setObject:result.accessToken forKey:DEVICETOKEN];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                [[NetworkTool sharedTool]getServerDeviceFirmwareVersionWithDeviceType:  [BLDeviceService sharedDeviceService].selectDevice.type  localVersion: [Result.version integerValue]  success:^(id param) {
                    NSMutableDictionary * paramD = param;
                    weakSelf.dataDIC = [paramD copy];
                    NSIndexPath *path= [NSIndexPath indexPathForRow:0 inSection:0];
                    NSIndexPath *path1= [NSIndexPath indexPathForRow:1 inSection:0];
                    VersionTableViewCell *cell = [weakSelf.myTable cellForRowAtIndexPath:path];
                    VersionTableViewCell *cell1 = [weakSelf.myTable cellForRowAtIndexPath:path1];
                    cell.versionNum.text =Result.version;
                    cell1.versionNum.text =[paramD valueForKey:@"version"];
                    [weakSelf.myTable reloadData];
                    
                    if ([[NSString stringWithFormat:@"%@",[paramD valueForKey:@"version"]] isEqualToString: Result.version ] ) {
                        weakSelf.btn.userInteractionEnabled = NO;
                        [weakSelf.btn setTitle:NSLocalizedString(@"已经是最新版本", nil) forState:UIControlStateNormal];
                        [weakSelf.btn setTitleColor: [UIColor grayColor] forState:UIControlStateNormal];
                    }else{
                        weakSelf.btn.userInteractionEnabled = YES;
                        [weakSelf.btn setTitleColor: [UIColor orangeColor] forState:UIControlStateNormal];
                        [weakSelf.btn setTitle:NSLocalizedString(@"升级至最新版本", nil) forState:UIControlStateNormal];
                    }
                } failure:^(id param) {
                    
                    NSError *err = param;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if ([CommonUtil isLoginExpired:err.code]) {
                            
                            NSLog(@"session过期了 需要重新登录");
                            
                        }else{
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [CommonUtil setTip:err.userInfo[ERROR_MESSAGE]];
                            });
                        }
                        
                    });
                    
                }];
            }];
        }];
    }else{
        
        [[BLLet sharedLet].account refreshAccessTokenWithRefreshToken:[UserInfoManager sharedTool].RefreshToken clientId:LiangBaClientID clientSecret:CLIENT_SECRET completionHandler:^(BLOauthResult * _Nonnull result) {
            
            [[NSUserDefaults standardUserDefaults]setObject:result.refreshToken forKey:REFRESHTOKEN];
            [[NSUserDefaults standardUserDefaults]setObject:result.accessToken forKey:DEVICETOKEN];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            BLFirmwareVersionResult *result1 = [[BLLet sharedLet].controller queryFirmwareVersion:[BLDeviceService sharedDeviceService].selectDevice.did];
            if (result.error == 0) {
                [[NetworkTool sharedTool]getServerDeviceFirmwareVersionWithDeviceType:  [BLDeviceService sharedDeviceService].selectDevice.type  localVersion: [result1.version integerValue]  success:^(id param) {
                    NSMutableDictionary * paramD = param;
                    weakSelf.dataDIC = [paramD copy];
                    NSIndexPath *path= [NSIndexPath indexPathForRow:0 inSection:0];
                    NSIndexPath *path1= [NSIndexPath indexPathForRow:1 inSection:0];
                    VersionTableViewCell *cell = [weakSelf.myTable cellForRowAtIndexPath:path];
                    VersionTableViewCell *cell1 = [weakSelf.myTable cellForRowAtIndexPath:path1];
                    cell.versionNum.text =result1.version;
                    cell1.versionNum.text =[paramD valueForKey:@"version"];
                    [weakSelf.myTable reloadData];
                    
                    if ([[NSString stringWithFormat:@"%@",[paramD valueForKey:@"version"]] isEqualToString: result1.version ] ) {
                        weakSelf.btn.userInteractionEnabled = NO;
                        [weakSelf.btn setTitle:NSLocalizedString(@"已经是最新版本", nil) forState:UIControlStateNormal];
                        [weakSelf.btn setTitleColor: [UIColor grayColor] forState:UIControlStateNormal];
                    }else{
                        weakSelf.btn.userInteractionEnabled = YES;
                        [weakSelf.btn setTitleColor: [UIColor orangeColor] forState:UIControlStateNormal];
                        [weakSelf.btn setTitle:NSLocalizedString(@"升级至最新版本", nil) forState:UIControlStateNormal];
                    }
                } failure:^(id param) {
                    NSError *err = param;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if ([CommonUtil isLoginExpired:err.code]) {
                            
                            NSLog(@"session过期了 需要重新登录");
                            
                        }else{
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [CommonUtil setTip:err.userInfo[ERROR_MESSAGE]];
                            });
                        }
                    });
                }];
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([CommonUtil isLoginExpired:result.error]) {
                        
                        NSLog(@"session过期了 需要重新登录");
                        
                    }else{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [CommonUtil setTip:result.msg];
                        });
                    }
                    
                });
            }
        }];
     }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self changeleftItem];
    self.title =NSLocalizedString(@"固件升级", nil) ;
    [self settheUI];
    self.navigationController.navigationBar.translucent = NO;
    // Do any additional setup after loading the view.
}
-(void)settheUI{
    self.myTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 120) style:UITableViewStylePlain];
    self.myTable.delegate = self;
    self.myTable.dataSource = self;
    self.myTable.userInteractionEnabled = NO;
    [self.myTable   registerNib:[UINib nibWithNibName:@"VersionTableViewCell" bundle:nil] forCellReuseIdentifier:@"VersionTableViewCell"];
    [self.view addSubview:self.myTable];
    
     _btn = [UIButton  buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:_btn];
    _btn.layer.borderWidth = 0.2;
    [_btn setTitle:NSLocalizedString(@"升级至最新版本", nil) forState:UIControlStateNormal];
    [_btn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    _btn.backgroundColor = [UIColor whiteColor];
    [_btn  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-50);
        make.height.mas_equalTo(@60);
        
    }];
    [self.btn addTarget:self action:@selector(shengji:) forControlEvents:UIControlEventTouchUpInside];
}
-(void)shengji:(id)sender{
    WeakSelf
    BLBaseResult *result = [[BLLet sharedLet].controller upgradeFirmware:[BLDeviceService sharedDeviceService].selectDevice.did url:[self.dataDIC valueForKey:@"url"]];
    if (result.succeed == YES) {
        
         weakSelf.btn.userInteractionEnabled = NO;
        [weakSelf.btn setTitleColor: [UIColor grayColor] forState:UIControlStateNormal];
        [weakSelf.btn setTitle:NSLocalizedString(@"已经是最新版本", nil) forState:UIControlStateNormal];
        [weakSelf.dataDIC setObject:[weakSelf.dataDIC valueForKey:@"version"] forKey:@"localver"];
        [weakSelf.myTable reloadData];
    }else{
        [CommonUtil setTip:result.msg];
    }
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return 2;/*self.dataSource.count*/;
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    VersionTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"VersionTableViewCell"];
    if (cell == nil) {
        cell = [[VersionTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"VersionTableViewCell"];
    }
   
      
        if (indexPath.row == 0) {
            cell.vername.text =NSLocalizedString(@"当前版本", nil) ;
           
        }
        if (indexPath.row == 1) {
            cell.vername.text = NSLocalizedString(@"最新版本", nil) ;
           
        }
        

    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
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
