//
//  LocalLoginViewController.m
//  AlinkDemo
//
//  Created by gubeidianzi on 2018/4/16.
//  Copyright © 2018年 aliyun. All rights reserved.
//

#import "LocalLoginViewController.h"
#import "DeviceViewController.h"
@interface LocalLoginViewController ()

@end

@implementation LocalLoginViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView * backImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"晾霸启动页"]];
    backImage.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [self.view addSubview:backImage];
    
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
