//
//  FailureAddViewController.m
//  AlinkDemo
//
//  Created by gubeidianzi on 2017/11/7.
//  Copyright © 2017年 aliyun. All rights reserved.
//

#import "FailureAddViewController.h"
#import "RightViewController.h"
@interface FailureAddViewController ()
@property (weak, nonatomic) IBOutlet UILabel *failureContenL;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UILabel *sdsdL;

@end

@implementation FailureAddViewController
-(void)LabelAttributedString:(UILabel*)label firstW:(NSString *)oneW toSecondW:(NSString *)twoW color:(UIColor *)color size:(CGFloat)size{
    // 创建Attributed
    NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:label.text];
    // 需要改变的第一个文字的位置
    NSUInteger firstLoc = [[noteStr string] rangeOfString:oneW].location;
    // 需要改变的最后一个文字的位置
    NSUInteger secondLoc = [[noteStr string] rangeOfString:twoW].location+1;
    // 需要改变的区间
    NSRange range = NSMakeRange(firstLoc, secondLoc - firstLoc);
    // 改变颜色
    [noteStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:range];
    // 改变字体大小及类型
    [noteStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:size] range:range];
    // 为label添加Attributed
    [label setAttributedText:noteStr];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.nextBtn AddLayer:10];
    self.sdsdL.text = NSLocalizedString(@"设备配网失败", nil);
    [self.nextBtn setTitle:NSLocalizedString(@"再试一次", nil) forState:UIControlStateNormal];
    self.view.backgroundColor = [UIColor whiteColor];
     self.title =  [DeviceInfoManager sharedManager].TheAddDevieceName;
    self.navigationItem.leftBarButtonItem = [self setNavLeftRightFrame:self.navigationController imageName:@"导航栏返回" selector:@"leftBtn"];
    self.navigationItem.leftBarButtonItem.target =self;
    self.navigationItem.leftBarButtonItem.style = UIBarButtonItemStylePlain;
    self.failureContenL.text =NSLocalizedString(@"请按以下步骤排查可能的问题\n\n1.确保您的设备已经按照开始时的提示,设置到配网状态;\n2.确保之前输入的WIFI账号密码无误;\n3.确保设备与家庭路由器的距离不要太远;\n4.您的路由器是否是指到了5GHz，可以进入路由器管理设置检查,确保是2.4HZ", nil) ;
   
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.failureContenL.text];
    
    //设置颜色
    NSRange range = [self.failureContenL.text rangeOfString:@"请按以下步骤排查可能的问题"];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:range];
    self.failureContenL.attributedText =attributedString;
    
    self.failureContenL.textColor = [CommonUtil getColor:@"#BBBBBB"];
    // Do any additional setup after loading the view.
}
-(void)leftBtn{
    [super leftBtn ];
    [[LiangBaDevice sharedInstance].XINGHAOArr removeAllObjects];
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
- (IBAction)failureAdd:(id)sender {
    [[LiangBaDevice sharedInstance].XINGHAOArr   removeAllObjects];
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
