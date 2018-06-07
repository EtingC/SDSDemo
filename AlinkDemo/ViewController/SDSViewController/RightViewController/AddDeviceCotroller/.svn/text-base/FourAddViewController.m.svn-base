//
//  FourAddViewController.m
//  AlinkDemo
//
//  Created by gubeidianzi on 2017/11/7.
//  Copyright © 2017年 aliyun. All rights reserved.
//

#import "FourAddViewController.h"
 
#import "DeviceSuccessViewController.h"
#import "RightViewController.h"
#import "FailureAddViewController.h"
@interface FourAddViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *loading;
@property (nonatomic,strong) NSTimer * timer;
@end

@implementation FourAddViewController
-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
   
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated  ];
    
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
    
    [self.loading.layer addAnimation:animation forKey:nil];
   
}
- (void)viewDidLoad {
    
      self.title =  [DeviceInfoManager sharedManager].TheAddDevieceName;
      [super viewDidLoad];
      self.view.backgroundColor = [UIColor whiteColor];
      [self tranform  ];
    self.navigationItem.leftBarButtonItem = [self setNavLeftRightFrame:self.navigationController imageName:@"导航栏返回" selector:@"leftBtn"];
    self.navigationItem.leftBarButtonItem.target =self;
    self.navigationItem.leftBarButtonItem.style = UIBarButtonItemStylePlain;
   
    
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notifyJoinResultError) name:@"notifyJoinResultError" object:nil];
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notifyJoinResult) name:@"notifyJoinResult" object:nil];
   
    // Do any additional setup after loading the view.
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
/**
 激活失败
 */
-(void)notifyJoinResultError{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIStoryboard * strory = [UIStoryboard  storyboardWithName:@"LeftMenuViewController" bundle:[NSBundle mainBundle]];
        FailureAddViewController *  vc = [strory instantiateViewControllerWithIdentifier:@"failureAdd"];
        
        [self.navigationController  pushViewController:vc animated:YES];
    });
}

/**
 成功激活
 */
-(void)notifyJoinResult{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIStoryboard * strory = [UIStoryboard  storyboardWithName:@"LeftMenuViewController" bundle:[NSBundle mainBundle]];
        DeviceSuccessViewController *  vc = [strory instantiateViewControllerWithIdentifier:@"devicesuccess"];
        
        [self.navigationController  pushViewController:vc animated:YES];
    });
   
    
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
