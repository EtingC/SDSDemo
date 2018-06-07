//
//  FirstAddViewController.m
//  AlinkDemo
//
//  Created by gubeidianzi on 2017/11/7.
//  Copyright © 2017年 aliyun. All rights reserved.
//

#import "FirstAddViewController.h"
#import "SecondAddViewController.h"
#import "DemoAddDevNotifier.h"
#import "RightViewController.h"
@interface FirstAddViewController ()
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UIImageView *logoImage;
@property (weak, nonatomic) IBOutlet UILabel *contentL;
@property (nonatomic,strong)DemoAddDevNotifier * notifier;
@end

@implementation FirstAddViewController
-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
    if (SCREEN_HEIGHT <960) {
        
        self.contentL.font = [UIFont systemFontOfSize:12];
    }
    
}
-(void)stoptime:(NSNotification *)sender{
    //关闭定时器
    [ _notifier.myTimer setFireDate:[NSDate distantFuture]];
    [ _notifier.myTimer invalidate];
     _notifier.myTimer = nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.nextBtn AddLayer:10];
    [self.nextBtn setTitle:NSLocalizedString(@"下一步", nil) forState:UIControlStateNormal];
    self.title = self.lkmodel.brandName;
    self.view.backgroundColor = [UIColor whiteColor];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(stoptime:) name:@"STOPTIME" object:nil];
//    [self.logoImage sd_setImageWithURL:[NSURL URLWithString:self.lkmodel.icon] placeholderImage:[UIImage imageNamed:@"FY_背景图片"]];
    self.logoImage.image = [UIImage imageNamed:@"配网提示界面图片"];
//     self.contentL.text = @"1.通电后按照提示,遥控器对码成功后，使设备进入可配置状态;\n2.点击”下一步“;";
    if ([[DeviceInfoManager sharedManager].PID isEqualToString:@"000000000000000000000000d84e0000"]) {
//       self.contentL.text = @"1.初次配置时，您的设备上电后，Wi-Fi指示灯快速，设备进入可配置状态;\n2.非初次配置时，请长按开关键6秒以上直至WiFi指示灯快闪，设备即可进入可配置状态;";
    }else{
         [self getdATA];
         [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(LKPGuideCodeOnlyInputPwd) name:@"LKPGuideCodeOnlyInputPwd" object:nil];
    }
    
    self.contentL.text = @"通电后长按遥控器【照明】键5秒，直到设备蜂鸣器有响声，再按一下遥控器【风干】键，蓝色指示灯快闪，设备进入配网状态。";
    self.navigationItem.leftBarButtonItem = [self setNavLeftRightFrame:self.navigationController imageName:@"导航栏返回" selector:@"leftBtn"];
    self.navigationItem.leftBarButtonItem.target =self;
    self.navigationItem.leftBarButtonItem.style = UIBarButtonItemStylePlain;
    
    // Do any additional setup after loading the view.
}
-(void)getdATA{
    WeakSelf
    [[NetworkTool    sharedTool]requestWithURLparameters:@{@"model":self.lkmodel.model} method:@"mtop.openalink.app.product.detail.get" View:self.view sessionExpiredOption:1 needLogin:YES callBack:^(AlinkResponse *responseObject) {
        if (responseObject.successed== YES) {
            NSDictionary *dic= responseObject.dataObject;
            
            NSString * dataStr = [dic valueForKey:@"initAction"];
            NSData *jsonData = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
            NSError *err;
            
            NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData
                                 
                                                                options:NSJSONReadingMutableContainers
                                 
                                                                  error:&err];
            
            NSString * str =[jsonDic valueForKey:@"initAction"];
            
            
            NSArray * arr = [str componentsSeparatedByString:@"\\n"];
            NSMutableArray * Mutarr = [NSMutableArray arrayWithArray:arr];
            NSMutableString * contenStr = [[NSMutableString alloc]init];
            for (NSString * str  in Mutarr) {
                [contenStr appendString:str];
                [contenStr appendString:@"\n"];
            }
//            weakSelf.contentL.text = contenStr;
            
        }
    } errorBack:^(id error) {
        
    }];
}
-(void)leftBtn{
    [super leftBtn ];
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
}
-(void)LKPGuideCodeOnlyInputPwd{
    
        UIStoryboard * strory = [UIStoryboard  storyboardWithName:@"LeftMenuViewController" bundle:[NSBundle mainBundle]];
        SecondAddViewController * vc = [strory instantiateViewControllerWithIdentifier:@"secondAdd"];
        [self.navigationController  pushViewController:vc animated:YES];
    
}
- (IBAction)pushToSecondAddDevice:(UIButton *)sender {
    if ([[DeviceInfoManager sharedManager].PID isEqualToString:@"000000000000000000000000d84e0000"]) {
        UIStoryboard * strory = [UIStoryboard  storyboardWithName:@"LeftMenuViewController" bundle:[NSBundle mainBundle]];
        SecondAddViewController * vc = [strory instantiateViewControllerWithIdentifier:@"secondAdd"];
        [self.navigationController  pushViewController:vc animated:YES];
        
    }else{
        sender.userInteractionEnabled = NO;
        LKCandDeviceModel * cand = [[LKCandDeviceModel alloc]init];
        cand.model = self.lkmodel.model;//上一步拿到的产品信息中的model值
        [kLkAddDevBiz setDevice:cand];
        _notifier = [DemoAddDevNotifier new];
        [kLkAddDevBiz startAddDevice:_notifier];
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
