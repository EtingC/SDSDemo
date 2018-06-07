//
//  BaseViewController.m
//  AlinkDemo
//
//  Created by gubeidianzi on 2017/11/6.
//  Copyright © 2017年 aliyun. All rights reserved.
//

#import "BaseViewController.h"
#import "UIControl+Custom.h"
@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setTitleTextAttributes:
     
     @{NSFontAttributeName:[UIFont systemFontOfSize:18],
       
       NSForegroundColorAttributeName:[CommonUtil getColor:@"#333333"]}];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationController.navigationBar.barTintColor = [CommonUtil getColor:@"#EFEFF1"];
    self.navigationItem.backBarButtonItem = item;
    self.view.backgroundColor =Gray_Color;
    
    self.dataSource  = [[NSMutableArray alloc]init];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    // Do any additional setup after loading the view.
}
-(UIBarButtonItem *)setNavLeftRightFrame:(UINavigationController *)nav imageName:(NSString *)name selector:(NSString *)selector{
    
    UIButton *settingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    settingButton.custom_acceptEventInterval = 2;
    if ([selector isEqualToString:@"leftBtn"]) {
        [settingButton setFrame:CGRectMake(-5, 7, 32.0, 32.0)];
        if ([name isEqualToString:@"导航栏返回"]){
            
          [settingButton setFrame:CGRectMake(-15, 0, 44, 44.0)];
        }
      
          [settingButton addTarget:self action:@selector(leftBtn) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [settingButton setFrame:CGRectMake(9.0, 9.0, 25.0, 25.0)];
        [settingButton addTarget:self action:@selector(rightBtn) forControlEvents:UIControlEventTouchUpInside];
    }
  
    [settingButton setImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
    
    
    //修改方法
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 44.0, 44.0)];
    [view addSubview:settingButton];
    
    return  [[UIBarButtonItem alloc] initWithCustomView:view];
}
-(void)leftBtn{
   //子类集成
}
-(void)rightBtn{
  //子类继承
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
