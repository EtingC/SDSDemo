//
//  MainViewController.m
//  AlinkDemo
//
//  Created by gubeidianzi on 2017/11/6.
//  Copyright © 2017年 aliyun. All rights reserved.
//
//首先得导入头文件
#import <AVFoundation/AVFoundation.h>
#import "UIViewController+MMDrawerController.h"
#import "MainViewController.h"
#import "RightViewController.h"
#import "MainTableViewCell.h"
#import "LeftMenuViewController.h"
#import "BanBenShengJiViewController.h"
#import "JibenSheZhiViewController.h"
#import "LoginViewController.h"
#import "BindDeviceInformationlistModel.h"
#import "BLLet.h"
#import "BLControlViewController.h"
#import "TimeManagerViewController.h"
#import <MJRefresh.h>
@interface MainViewController ()<UIPopoverPresentationControllerDelegate,AVCaptureMetadataOutputObjectsDelegate>
@property(nonatomic,strong)AVCaptureSession*session;
@property(nonatomic,strong ) UITableView *rightItemTableV;
@property(nonatomic,strong) UIPopoverPresentationController *popVC;
@property (nonatomic,strong) UIViewController *viewC;
@end

@implementation MainViewController
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    UIButton *settingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [settingButton setFrame:CGRectMake(0.0,5, 35, 35)];
    [settingButton addTarget:self action:@selector(leftBtn) forControlEvents:UIControlEventTouchUpInside];
    UIImageView * imagev =[[UIImageView alloc]init];
    
    [imagev sd_setImageWithURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults]objectForKey:@"ICONURL"]] placeholderImage:[UIImage imageNamed:@"默认头像"]];
  
    [settingButton setImage: imagev.image forState:UIControlStateNormal];
    
    //修改方法
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 44.0, 44.0)];
    [view addSubview:settingButton];
    UIBarButtonItem * left = [[UIBarButtonItem alloc]initWithCustomView:view];
    self.navigationItem.leftBarButtonItem =left;
    if(![[AlinkAccount sharedInstance] isLogin]){
        
        UIStoryboard * strory = [UIStoryboard  storyboardWithName:@"Login" bundle:[NSBundle mainBundle]];
        LoginViewController *jibenvc = [strory instantiateViewControllerWithIdentifier:@"login"];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:jibenvc];
       
        [self presentViewController:nav animated:YES completion:nil];
     
    }else{
        [self getRefresh];
    }
    //设置打开抽屉模式
    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModePanningNavigationBar];
    
}
-(void)getRefresh{
    
    //默认【下拉刷新】
     self.myTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
     [self.myTable.mj_header beginRefreshing ];
}
-(void)refresh{
   
    [self getData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getRefresh) name:@"kAKNotificationUserLoggedIn" object:nil];
    self.dataSource  = [[NSMutableArray alloc]init];
    self.title = @"BroadLink SDS";
    UIButton *settingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [settingButton setFrame:CGRectMake(0.0,5, 35, 35)];
    [settingButton addTarget:self action:@selector(leftBtn) forControlEvents:UIControlEventTouchUpInside];
    UIImageView * imagev =[[UIImageView alloc]init];
    
    [imagev sd_setImageWithURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults]objectForKey:@"ICONURL"]] placeholderImage:[UIImage imageNamed:@"默认头像"]];
    
    [settingButton setImage:imagev.image forState:UIControlStateNormal];
    
    //修改方法
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 44.0, 44.0)];
    [view addSubview:settingButton];
    UIBarButtonItem * left = [[UIBarButtonItem alloc]initWithCustomView:view];
    self.navigationItem.leftBarButtonItem =left;
   
    self.navigationItem.rightBarButtonItem = [self setNavLeftRightFrame:self.navigationController imageName:@"加号" selector:@"rightBtn"];
    self.navigationItem.rightBarButtonItem.target =self;
    self.navigationItem.rightBarButtonItem.action = @selector(rightBtn);
    self.navigationItem.rightBarButtonItem.style = UIBarButtonItemStylePlain;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(setTheConfigue:) name:@"PUSH" object:nil];
    [self MarkTheUI];
    
}
-(void)getData{
//    WeakSelf;
//    [[NetworkTool sharedTool]requestWithURLparameters:@{} method:@"mtop.openalink.app.core.devices.getbyuser" View:self.view sessionExpiredOption:AKLoginOptionAutoLoginOnly needLogin:YES callBack:^(AlinkResponse* responseObject) {
//         [weakSelf.dataSource removeAllObjects];
//        [weakSelf.myTable.mj_header endRefreshing ];
//        NSArray * data = responseObject.dataObject;
//        data = [BindDeviceInformationlistModel mj_objectArrayWithKeyValuesArray:data];
//        for (BindDeviceInformationlistModel *model in data) {
//            [weakSelf.dataSource addObject:model];
//            for (BindDeviceInformationlistModel *bindModel in [DeviceInfoManager sharedManager].deviceInfoArray) {
//                if (![bindModel.uuid isEqualToString:model.uuid]) {
//                  [[DeviceInfoManager sharedManager].deviceInfoArray addObject:model];
//                }
//            }
//        }
//        [weakSelf.myTable reloadData];
//    } errorBack:^(id error) {
//        [self.myTable.mj_header endRefreshing ];
//        NSLog(@"%@",error);
//    }];
}
-(void)setTheConfigue:(NSNotification *)notification{
    NSString * str =notification.userInfo[@"back"];
    
    if ([str isEqualToString:@"1"]) {
        [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
          
             [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
            
        }];
        UIStoryboard * strory = [UIStoryboard  storyboardWithName:@"LeftMenuViewController" bundle:[NSBundle mainBundle]];
        JibenSheZhiViewController *jibenvc = [strory instantiateViewControllerWithIdentifier:@"jiben"];
       [self.navigationController pushViewController:jibenvc animated:YES];
    }
    
    if ([str isEqualToString:@"2"]) {
        [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
            
             [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
          
        }];
        UIStoryboard * strory = [UIStoryboard  storyboardWithName:@"LeftMenuViewController" bundle:[NSBundle mainBundle]];
        BanBenShengJiViewController *jibenvc = [strory instantiateViewControllerWithIdentifier:@"version"];
          [self.navigationController pushViewController:jibenvc animated:YES];
    }
}
/**
  左侧按钮
 */
-(void)leftBtn{
    
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}
/**
 右侧按钮
 */
-(void)rightBtn{
    [super rightBtn];
    
    self.viewC = [[UIViewController alloc]init];
    self.viewC.view.backgroundColor = [UIColor whiteColor];
    // 设定大小(此处也可不做设置,不做设置的效果如下图)
    self.viewC.preferredContentSize = CGSizeMake(SCREEN_WIDTH/3, 121);
    // 初始化
    self.viewC.modalPresentationStyle = UIModalPresentationPopover;
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 61, SCREEN_WIDTH/3, 1)];
    view.backgroundColor = Gray_Color;
    [_viewC.view addSubview:view];
    for (int i = 1; i<=2; i++) {
        UIButton * btn  = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 61*(i-1), SCREEN_WIDTH/3, 60);
        [_viewC.view addSubview:btn];
        btn.tag = 1000+i;
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        if (i== 1) {
            [btn setTitle:@"添加设备" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }else{
            [btn setTitle:@"扫一扫" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
        }
    }
    _popVC = self.viewC.popoverPresentationController;
    // 设置代理(iPhone必须设置代理才能显示)
    _popVC.delegate = self;
    _popVC.backgroundColor = [UIColor whiteColor];
    // 获取按钮
    _popVC.barButtonItem = self.navigationItem.rightBarButtonItem;
    // 退出视图
    [self presentViewController:self.viewC animated:YES completion:nil];
}
-(void)clickBtn:(UIButton *)btn{
    
    if (btn.tag == 1001) {
            RightViewController * rightVC= [[RightViewController alloc]init];
            [self.navigationController  pushViewController:rightVC animated:YES];
    }else{
//        LBXScanViewController *vc = [LBXScanViewController new];
//        vc.style = [StyleDIY SDSScan];
//        vc.isOpenInterestRect = YES;
//
//        self.navigationController.navigationBarHidden=NO;
//        [self.navigationController pushViewController:vc animated:YES];
        
    }
    [self.viewC dismissViewControllerAnimated:YES completion:^{
        
    }];
}
/**
 mark the ui
 */
-(void)MarkTheUI{
    
    self.myTable = [[UITableView alloc]initWithFrame:CGRectMake(8, 64, SCREEN_WIDTH-16, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    [self.myTable registerNib:[UINib nibWithNibName:@"MainTableViewCell" bundle:nil] forCellReuseIdentifier:@"MainTableViewCell"];
    self.myTable.backgroundColor =RGB(236, 234, 243);
    self.myTable.delegate = self;
    self.myTable.dataSource = self;
    self.myTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.myTable];

}
#pragma mark - UIPopoverPresentationControllerDelegate
- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller{
    //此处为不适配(如果选择其他,会自动视频屏幕,上面设置的大小就毫无意义了)
    return UIModalPresentationNone;
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
    
  
   
    MainTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MainTableViewCell"];
    if (cell == nil) {
        cell = [[MainTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MainTableViewCell"];
    }
    
     [cell setTheData:self.dataSource[indexPath.row]];
     cell.callbbackBlock = ^(BindDeviceInformationlistModel *model, MainTableViewCell *cell) {
         BOOL Currentvalue = !cell.Switch.isOn;
         BOOL rulevalue = cell.Switch.isOn;
         cell.Switch.userInteractionEnabled = NO;
         NSString * valueStr = [NSString stringWithFormat:@"%d",rulevalue];
         [[NetworkTool sharedTool]requestWithURLparameters:@{@"uuid":model.uuid,@"setParams":[self dictionaryToJson:@{@"Switch":@{@"value":valueStr}}]} method:@"mtop.openalink.app.core.device.set.status" View:self.view  sessionExpiredOption:AKLoginOptionAutoLoginOnly needLogin:YES callBack:^(AlinkResponse *responseObject) {
             
             if (responseObject.successed == YES) {
                  cell.Switch.on = rulevalue;
                  cell.Switch.userInteractionEnabled = YES;
             }
             
         } errorBack:^(id error) {
                 cell.Switch.on =Currentvalue;
             cell.Switch.userInteractionEnabled = YES;
         }];
    };
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
  
    [self.navigationController pushViewController:[BLControlViewController controlVCWithDevice:self.dataSource[indexPath.row]]  animated:YES];
 
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
