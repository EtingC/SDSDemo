//
//  DeviceViewController.m
//  AlinkDemo
//
//  Created by gubeidianzi on 2017/11/30.
//  Copyright © 2017年 aliyun. All rights reserved.
//

#import "DeviceViewController.h"
#import "DeviceTableViewCell.h"
#import "RightViewController.h"
#import "LoginViewController.h"
#import "LiangBaLoginViewController.h"
#import "BLFamilyDeviceInfo.h"
#import "DeviceFamilyInfo.h"
#import "BLDNADevice.h"
#import "MySelfViewController.h"
#import "BLControlViewController.h"
#import <MJRefresh.h>

@interface DeviceViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong) RightViewController * rightVC;
@end

@implementation DeviceViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated ];
//    [[BLLet sharedLet].familyManager delFamilyWithFamilyId:@"00a97edd63321c7edb1ef11a7855d44e" familyVersion:@"2018-06-06 08:33:07" completionHandler:^(BLBaseResult * _Nonnull result) {
//        if (result) {
//
//        }
//    }];
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBar.barTintColor = [CommonUtil getColor:@"#EFEFF1"];
 
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self FindSqlData];
    });
    
}
-(void)createRefresh{
    //下拉刷新
    self.myTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getData)];
    [self.myTable.mj_header beginRefreshing];
}
#pragma mark - 第一次登录先搜索本地数据库的数据
-(void)FindSqlData{
    WeakSelf
    [self.dataSource removeAllObjects];
    NSMutableArray * mutArr =  [[NSMutableArray alloc]init];
    NSMutableArray * ModuleArr =  [[NSMutableArray alloc]init];
    mutArr = [SDSsqlite FindDeviceInfoWithFamilyID:nil];
    ModuleArr = [SDSsqlite  FindMoudleInfoWithFamilyID:nil];
    for (int i = 0; i<mutArr.count; i++) {
        BLFamilyDeviceInfo * device = mutArr[i];
//        BLModuleInfo *ModuleInfo = ModuleArr[i];
        BLDNADevice * SDKDevice = [[BLDNADevice  alloc]init];
        SDKDevice.did = device.did;
        SDKDevice.password = device.password;
        SDKDevice.type = device.type;
        SDKDevice.pid = device.pid;
        SDKDevice.mac = device.mac;
        SDKDevice.name = device.name;
        SDKDevice.lock = device.lock;
        SDKDevice.controlKey = device.aesKey;
        SDKDevice.controlId = device.terminalId;
        [[BLLet sharedLet].controller  addDevice:SDKDevice];
        //////
        ////________________ 筛选moudel和家庭数据之间的关联关系
        DeviceFamilyInfo * Deviceinfo = [[DeviceFamilyInfo alloc]init];
        BLModuleInfo * moduleif = [[BLModuleInfo alloc]init];
        for (BLModuleInfo * model in ModuleArr ) {
            NSArray * BLModuleIncludeDevArr = model.moduleDevs;
            if (BLModuleIncludeDevArr) {
                BLModuleIncludeDev * devModel =BLModuleIncludeDevArr.firstObject;
                if ([devModel.did isEqualToString:device.did]) {
                    moduleif =model;
                    Deviceinfo.moduleInfo = moduleif;
                    Deviceinfo.deviceInfo = device;
                    [weakSelf.dataSource addObject:Deviceinfo];
                }
            }else{
                NSLog(@"BLModuleIncludeDevArr 数组不存在数据");
            }
        }
       
        ////________________
  
        NSMutableArray * deviceInfoArr = [DeviceInfoManager sharedManager].deviceInfoArray;
        if ([DeviceInfoManager sharedManager].deviceInfoArray.count>0) {
            
            for (int i = 0; i < deviceInfoArr.count; i++) {
//                DeviceFamilyInfo * model =deviceInfoArr[i];
                
                NSMutableArray * SqliteDeviceInfoArr = [SDSsqlite FindDeviceInfoWithFamilyID:nil ];
                NSMutableArray *devDidArr = [[NSMutableArray alloc] init];
                for (BLFamilyDeviceInfo *devModel in SqliteDeviceInfoArr) {
                    [devDidArr addObject:devModel.did];
                }
                
                if (![devDidArr containsObject:device.did]) {
                    [devDidArr addObject:device.did];
                    [[DeviceInfoManager sharedManager].deviceInfoArray addObject:Deviceinfo];
                }
            }
        }else{
            
            [[DeviceInfoManager sharedManager].deviceInfoArray addObject:Deviceinfo];
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.myTable reloadData];
    });
    
}
#pragma mark - SDS 的设备列表
-(void)getData{
    WeakSelf
    NSLog(@"11---------*************-------------***********");
    [UsingHUD showInView:self.view];
    NSMutableArray * SqliteDeviceInfoArr = [SDSsqlite FindDeviceInfoWithFamilyID:nil ];
    NSMutableArray *devDidArr = [[NSMutableArray alloc] init];
    for (BLFamilyDeviceInfo *devModel in SqliteDeviceInfoArr) {
        [devDidArr addObject:devModel.did];
//        [SDSsqlite deleteDeviceWithDeviceDid:devModel.did];
    }
    [[BLLet sharedLet].familyManager queryLoginUserFamilyIdListWithCompletionHandler:^(BLFamilyIdListGetResult * _Nonnull result) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{//查询家庭信息
            if (result.error == 0) {//查询成功
                
                 [weakSelf.dataSource removeAllObjects];
                 NSMutableArray *mutArr = [[NSMutableArray alloc]init];
                 BLFamilyIdInfo *model =result.idList.firstObject;
                 [[NSUserDefaults standardUserDefaults]setObject:model.familyVersion forKey:@"FAMILYVERSION"];
                 [[NSUserDefaults standardUserDefaults]setObject:model.familyId forKey:@"FAMILYID"];
                 [mutArr addObject:model.familyId];
                
                [[BLLet sharedLet].familyManager   queryFamilyInfoWithIds:mutArr completionHandler:^(BLAllFamilyInfoResult * _Nonnull result) {//通过获取到的家庭信息 获取设备信息
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (result.error == 0) { //成功获取设备信息
                            for (BLFamilyDeviceInfo *devModel in SqliteDeviceInfoArr) {
                                [SDSsqlite deleteDeviceWithDeviceDid:devModel.did];
                            }
                            for (BLFamilyAllInfo *info in result.allFamilyInfoArray) {
                                for (BLFamilyDeviceInfo * device in info.deviceBaseInfo) {
                                    BLDNADevice * SDKDevice = [[BLDNADevice  alloc]init];
                                    SDKDevice.did = device.did;
                                    SDKDevice.password = device.password;
                                    SDKDevice.type = device.type;
                                    SDKDevice.pid = device.pid;
                                    SDKDevice.mac = device.mac;
                                    SDKDevice.name = device.name;
                                    SDKDevice.lock = device.lock;
                                    SDKDevice.controlKey = device.aesKey;
                                    SDKDevice.controlId = device.terminalId;
                                    
                                    [[BLLet sharedLet].controller  addDevice:SDKDevice];
                                    
                                    //////
                                    DeviceFamilyInfo * Deviceinfo = [[DeviceFamilyInfo alloc]init];
                                    ////________________ 筛选moudel和家庭数据之间的关联关系
                                    //                                    Deviceinfo.moduleInfoArr =[NSArray arrayWithArray:info.moduleBaseInfo] ;
                                    Deviceinfo.deviceInfo = device;
                                    
                                    BLModuleInfo * moduleif = [[BLModuleInfo alloc]init];
                                    for (BLModuleInfo * model in info.moduleBaseInfo) {
                                        NSArray * BLModuleIncludeDevArr = model.moduleDevs;
                                        if (BLModuleIncludeDevArr) {
                                            BLModuleIncludeDev * devModel =BLModuleIncludeDevArr.firstObject;
                                            if ([devModel.did isEqualToString:device.did]) {
                                                moduleif =model;
                                                [SDSsqlite AddDeviceInfo:(BLFamilyDeviceInfo *)device];
                                                [SDSsqlite AddMoudleInfo:model];
                                            }
                                        }else{
                                            NSLog(@"BLModuleIncludeDevArr 数组不存在数据");
                                        }
                                    }
                                    Deviceinfo.moduleInfo = moduleif;
                                    ////________________
                                    [weakSelf.dataSource addObject:Deviceinfo];
                                    
                                    NSMutableArray * deviceInfoArr = [[DeviceInfoManager sharedManager].deviceInfoArray copy];
                                    if ([DeviceInfoManager sharedManager].deviceInfoArray.count>0) {
                                        BOOL   contain = NO;
                                        for (int i = 0; i < deviceInfoArr.count; i++) {
//                                            DeviceFamilyInfo * model =deviceInfoArr[i];
                                            NSLog(@"-------------------------%d",i);
                                          DeviceFamilyInfo *testinfo =  deviceInfoArr[i];
                                            if ([testinfo.deviceInfo.did  isEqualToString:device.did]){
                                                contain = YES;
                                            }
                                        }
                                        
                                        if (!contain) {
                                            NSLog(@"********========*************");
                                            [devDidArr addObject:device.did];
                                            [[DeviceInfoManager sharedManager].deviceInfoArray addObject:Deviceinfo];
                                        }
                                        
                                    }else{
                                        [[DeviceInfoManager sharedManager].deviceInfoArray addObject:Deviceinfo];
                                    }
                                }
                            }
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [weakSelf.myTable reloadData];
                                [UsingHUD hideInView:weakSelf.view];
                                //结束头部刷新
                                [weakSelf.myTable.mj_header endRefreshing];
                            });
                        }else{ //获取设备信息失败 - >刷新token - >再次获取设备信息
                            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                                 [self requestData];
                            });
                        }
                    });
                }];
            }else{ //查询失败 - >刷新token _》再次请求
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    [self requestData];
                });
            }
        });
    }];
}

- (void)requestData
{
    WeakSelf
    NSMutableArray * SqliteDeviceInfoArr = [SDSsqlite FindDeviceInfoWithFamilyID:nil ];
    NSMutableArray *devDidArr = [[NSMutableArray alloc] init];
    for (BLFamilyDeviceInfo *devModel in SqliteDeviceInfoArr) {
        [devDidArr addObject:devModel.did];
//        [SDSsqlite deleteDeviceWithDeviceDid:devModel.did];
    }
    [[BLLet sharedLet].account refreshAccessTokenWithRefreshToken:[UserInfoManager sharedTool].RefreshToken clientId:LiangBaClientID clientSecret:CLIENT_SECRET completionHandler:^(BLOauthResult * _Nonnull result) {
        
        [[NSUserDefaults standardUserDefaults]setObject:result.refreshToken forKey:REFRESHTOKEN];
        [[NSUserDefaults standardUserDefaults]setObject:result.accessToken forKey:DEVICETOKEN];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[BLLet sharedLet].familyManager queryLoginUserFamilyIdListWithCompletionHandler:^(BLFamilyIdListGetResult * _Nonnull result) { //再次请求家庭信息
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                if (result.error == 0) { //成功
                    [weakSelf.dataSource removeAllObjects];
                    NSMutableArray *mutArr = [[NSMutableArray alloc]init];
                    BLFamilyIdInfo *model =result.idList.firstObject;
                    [[NSUserDefaults standardUserDefaults]setObject:model.familyVersion forKey:@"FAMILYVERSION"];
                    [[NSUserDefaults standardUserDefaults]setObject:model.familyId forKey:@"FAMILYID"];
                    [mutArr addObject:model.familyId];
                    
                    [[BLLet sharedLet].familyManager   queryFamilyInfoWithIds:mutArr completionHandler:^(BLAllFamilyInfoResult * _Nonnull result) {
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (result.error == 0) {
                                for (BLFamilyDeviceInfo *devModel in SqliteDeviceInfoArr) {
                                    [SDSsqlite deleteDeviceWithDeviceDid:devModel.did];
                                }
                                for (BLFamilyAllInfo *info in result.allFamilyInfoArray) {
                                    for (BLFamilyDeviceInfo * device in info.deviceBaseInfo) {
                                        BLDNADevice * SDKDevice = [[BLDNADevice  alloc]init];
                                        SDKDevice.did = device.did;
                                        SDKDevice.password = device.password;
                                        SDKDevice.type = device.type;
                                        SDKDevice.pid = device.pid;
                                        SDKDevice.mac = device.mac;
                                        SDKDevice.name = device.name;
                                        SDKDevice.lock = device.lock;
                                        SDKDevice.controlKey = device.aesKey;
                                        SDKDevice.controlId = device.terminalId;
                                        
                                        [[BLLet sharedLet].controller  addDevice:SDKDevice];
                                        
                                        //////
                                        DeviceFamilyInfo * Deviceinfo = [[DeviceFamilyInfo alloc]init];
                                        Deviceinfo.moduleInfoArr =[NSArray arrayWithArray:info.moduleBaseInfo] ;
                                        Deviceinfo.deviceInfo = device;
                                        [weakSelf.dataSource addObject:Deviceinfo];
                                        
                                        NSMutableArray * deviceInfoArr = [DeviceInfoManager sharedManager].deviceInfoArray;
                                        if ([DeviceInfoManager sharedManager].deviceInfoArray.count>0) {
                                            
                                            for (int i = 0; i < deviceInfoArr.count; i++) {
                                                //                                                                DeviceFamilyInfo * model =deviceInfoArr[i];
                                                
                                                if (![devDidArr containsObject:device.did]){
                                                    [devDidArr addObject:device.did];
                                                    [[DeviceInfoManager sharedManager].deviceInfoArray addObject:Deviceinfo];
                                                }
                                                
                                            }
                                        }else{
                                            
                                            [[DeviceInfoManager sharedManager].deviceInfoArray addObject:Deviceinfo];
                                        }
                                    }
                                }
                                [weakSelf.myTable reloadData];
                                [UsingHUD hideInView:weakSelf.view];
                                //结束头部刷新
                                [weakSelf.myTable.mj_header endRefreshing];
                            }else{
                                if ([CommonUtil isLoginExpired:result.error]) {
                                    NSLog(@"session过期了 需要重新登录");
                                }else{
                                    [CommonUtil setTip:result.msg];
                                }
                            [UsingHUD hideInView:weakSelf.view];
                            [weakSelf.myTable.mj_header endRefreshing];
                            }
                        });
                    }];
                }else{ //失败
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [UsingHUD hideInView:weakSelf.view];
                        [weakSelf.myTable.mj_header endRefreshing];
                        if ([CommonUtil isLoginExpired:result.error]) {
                            NSLog(@"session过期了 需要重新登录");
                        }else{
                            [CommonUtil setTip:result.msg];
                        }
                    });
                }
            });
        }];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
   
//    self.navigationItem.leftBarButtonItem = [self setNavLeftRightFrame:self.navigationController imageName:@"我的" selector:@"leftBtn"];
//    self.navigationItem.leftBarButtonItem.target =self;
//    self.navigationItem.leftBarButtonItem.style = UIBarButtonItemStylePlain;
//
    
    self.navigationItem.title = NSLocalizedString(@"设备列表", nil );
    self.navigationItem.rightBarButtonItem = [self setNavLeftRightFrame:self.navigationController imageName:@"添加" selector:@"rightBtn"];
    self.navigationItem.rightBarButtonItem.target =self;
    self.navigationItem.rightBarButtonItem.action = @selector(rightBtn);
    self.navigationItem.rightBarButtonItem.style = UIBarButtonItemStylePlain;
    self.dataSource= [[NSMutableArray alloc]init];
    [self SetTheUI];
   
    [self createRefresh];
     [self FindSqlData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(createRefresh) name:@"addDevSUC" object:nil];
    // Do any additional setup after loading the view.
}
//-(void)leftBtn{
//    [super leftBtn ];
//    MySelfViewController * vc = [[MySelfViewController alloc]init];
//    [self.navigationController pushViewController:vc animated:YES];
//
//}
-(void)SetTheUI{
    
    self.myTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    [self.myTable registerNib:[UINib nibWithNibName:@"DeviceTableViewCell" bundle:nil] forCellReuseIdentifier:@"DeviceTableViewCell"];
    self.myTable.backgroundColor =[UIColor whiteColor];
    self.myTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.myTable.delegate = self;
    self.myTable.dataSource = self;
    self.myTable.emptyDataSetSource = self;
    self.myTable.emptyDataSetDelegate = self;
  
    [self.view addSubview:self.myTable];
}
-(void)rightBtn{
    [super rightBtn];
//    RightViewController * vc = [[RightViewController alloc]init];
    [self.navigationController pushViewController:self.rightVC animated:YES];
}
#pragma mark - tableview的代理方法实现
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return self.dataSource.count;
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"---------*************-------------***********");
    DeviceTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DeviceTableViewCell"];
    if (cell == nil) {
        cell = [[DeviceTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DeviceTableViewCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    DeviceFamilyInfo * model = self.dataSource[indexPath.row];
    if (model.deviceInfo.type == 20184) {
        cell.StatusL.hidden = YES;
    }else{
        cell.StatusL.hidden = NO;
    }
    [cell setTheConfigue:model];
    
    return cell;
}
- (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 80;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
//        DeviceTableViewCell * cell = [self.myTable cellForRowAtIndexPath:indexPath];
 
        DeviceFamilyInfo * model = self.dataSource[indexPath.row];
        BLModuleInfo *modeIF = model.moduleInfo;
        model.moduleInfo = modeIF;
        [SDSFamliyManager sharedInstance].deFaInfoData = model;
        
        BLFamilyDeviceInfo * device = model.deviceInfo;
        
        
        BLDNADevice * SDKDevice = [[BLDNADevice  alloc]init];
        SDKDevice.did = device.did;
        SDKDevice.password = device.password;
        SDKDevice.type = device.type;
        SDKDevice.pid = device.pid;
        SDKDevice.mac = device.mac;
        SDKDevice.name = device.name;
        SDKDevice.lock = device.lock;
        SDKDevice.controlKey = device.aesKey;
        SDKDevice.controlId = device.terminalId;
        
        [self.navigationController pushViewController:[BLControlViewController controlVCWithDevice:SDKDevice] animated:YES];
  
}
#pragma mark - DZNEmptyDataSetSource ——实现该协议
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"1"];
}
-(BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView{
    
    return YES;
} 
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *title =NSLocalizedString(@"暂无设备,去添加", nil) ;
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont boldSystemFontOfSize:15.0f],
                                 NSForegroundColorAttributeName:[CommonUtil getColor:@"#999999"]
                                 };
    return [[NSAttributedString alloc] initWithString:title attributes:attributes];
}
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return -50;
}
- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView{
    
    return 10;
}
- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView {
    UIColor *appleGreenColor = [UIColor whiteColor];
    return appleGreenColor;
}

- (RightViewController *)rightVC
{
    if (!_rightVC) {
        _rightVC = [[RightViewController alloc] init];
    }
    return _rightVC;
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
