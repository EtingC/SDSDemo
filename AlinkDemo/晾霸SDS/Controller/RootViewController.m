//
//  RootViewController.m
//  AlinkDemo
//
//  Created by gubeidianzi on 2017/11/30.
//  Copyright © 2017年 aliyun. All rights reserved.
//

#import "RootViewController.h"
#import "MySelfViewController.h"
#import "SceneViewController.h"
#import "DeviceViewController.h"
@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createViewControllers];
    [self createTabBarItem];
    [[UITabBarItem appearance] setTitlePositionAdjustment:UIOffsetMake(0, -3)];
    [[UITabBar appearance] setBackgroundColor:[CommonUtil getColor:@"#FAFAFA"]];
    // Do any additional setup after loading the view.
}
-(void)createViewControllers
{
    //
    DeviceViewController * deviceVC = [[DeviceViewController alloc]init];
    NaviViewController * deviceNAV = [[NaviViewController alloc]initWithRootViewController:deviceVC];
   
    //
    MySelfViewController    * myselfVC = [[MySelfViewController alloc]init];
    NaviViewController * myselfNav = [[NaviViewController alloc]initWithRootViewController:myselfVC];
    
    //
    SceneViewController * SceneVC = [[SceneViewController alloc]init];
    NaviViewController * SceneNav = [[NaviViewController alloc]initWithRootViewController:SceneVC];
    
    self.viewControllers = @[deviceNAV,SceneNav,myselfNav];
}
-(void)createTabBarItem
{
    //未选中的图片
    NSArray * unselectedImageArray = @[@"设备1",@"场景1",@"我的1"];
    //选中的图片
    NSArray * selectedImageArray = @[@"设备2",@"场景2",@"我的2"];
    //标题
    NSArray * titleArray = @[NSLocalizedString(@"设备", nil),NSLocalizedString(@"场景", nil),NSLocalizedString(@"我的", nil)];
    
    for (int i= 0 ; i < self.tabBar.items.count; i ++) {
        UIImage * unselectedImage = [UIImage imageNamed:unselectedImageArray[i]];
        unselectedImage = [unselectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        UIImage * selectedImage = [UIImage imageNamed:selectedImageArray[i]];
        selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        UITabBarItem * item = self.tabBar.items[i];
        item = [item initWithTitle:titleArray[i] image:unselectedImage selectedImage:selectedImage];
    }
    
    [[UITabBarItem appearance]setTitleTextAttributes:@{NSForegroundColorAttributeName:RGB(241, 170, 64)} forState:UIControlStateSelected];
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
