//
//  LastPasswordViewController.m
//  AlinkDemo
//
//  Created by gubeidianzi on 2017/11/30.
//  Copyright © 2017年 aliyun. All rights reserved.
//

#import "LastPasswordViewController.h"

@interface LastPasswordViewController ()

@end

@implementation LastPasswordViewController
-(void)back{
    [self.navigationController   popToRootViewControllerAnimated:YES];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
     [self changeleftItem];
     self.view.backgroundColor = [UIColor whiteColor];
    self.title =NSLocalizedString(@"找回密码", nil) ;
    UIBarButtonItem * bar = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"返回"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = bar;
    
    UIImageView *imagev = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"配置完成"]];
    imagev.frame = CGRectMake(SCREEN_WIDTH/2-50, 90, 100, 100);
    [self.view addSubview:imagev];
    
    UILabel *la = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-82, CGRectGetMaxY(imagev.frame)+20, 164, 20)];
    la.text = self.title =NSLocalizedString(@"已重置密码，请返回登录", nil) ;
    la.textColor = [UIColor blackColor];
    la.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:la];
    // Do any additional setup after loading the view.
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
