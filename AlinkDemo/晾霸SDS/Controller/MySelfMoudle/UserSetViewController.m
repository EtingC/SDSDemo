//
//  UserSetViewController.m
//  AlinkDemo
//
//  Created by gubeidianzi on 2017/12/6.
//  Copyright © 2017年 aliyun. All rights reserved.
//

#import "UserSetViewController.h"

@interface UserSetViewController ()

@end

@implementation UserSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self changeleftItem];
    [self.navigationController.navigationBar setTitleTextAttributes:
     
     @{NSFontAttributeName:[UIFont systemFontOfSize:18],
       
       NSForegroundColorAttributeName:[CommonUtil getColor:@"#333333"]}];
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
