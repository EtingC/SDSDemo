//
//  LeftMenuViewController.m
//  AlinkDemo
//
//  Created by gubeidianzi on 2017/11/6.
//  Copyright © 2017年 aliyun. All rights reserved.
//

#import "LeftMenuViewController.h"
#import "UIViewController+MMDrawerController.h"
@interface LeftMenuViewController ()<UIGestureRecognizerDelegate>
@property (nonatomic,strong) UITapGestureRecognizer *tap;
@property (nonatomic,strong) UITapGestureRecognizer *tap1;
@end

@implementation LeftMenuViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    self.UserNameL.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"NICKNAME"];
    [self.IconImage sd_setImageWithURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults]objectForKey:@"ICONURL"]] placeholderImage:[UIImage imageNamed:@"默认头像"]];
    
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.navigationController.navigationBarHidden  = NO;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(click:)];
    self.tap1 .delegate= self;
    self.tap.delegate = self;
    self.tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(click1:)];
    self.JibenShezhiBtn.userInteractionEnabled = YES;
    self.BanBenshengjiBtn.userInteractionEnabled= YES;
    [self.JibenShezhiBtn addGestureRecognizer: self.tap];
    [self.BanBenshengjiBtn addGestureRecognizer: self.tap1];
    
    
    // Do any additional setup after loading the view.
}
-(void)click:(UITapGestureRecognizer*)tap{
    
     
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"PUSH" object:nil userInfo:@{@"back":@"1"}];
  
    
}
-(void)click1:(UITapGestureRecognizer*)tap{
    
  
      [[NSNotificationCenter defaultCenter]postNotificationName:@"PUSH" object:nil userInfo:@{@"back":@"2"}];
    
    
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
