//
//  SceneViewController.m
//  AlinkDemo
//
//  Created by gubeidianzi on 2017/11/30.
//  Copyright © 2017年 aliyun. All rights reserved.
//

#import "SceneViewController.h"
#import "PropertySetViewController.h"
#import "SecondAddViewController.h"
#import "ThirdAddViewController.h"
@interface SceneViewController ()

@end

@implementation SceneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"场景", nil) ;
//     [CommonUtil adonWithImage:nil highImage:nil frame:CGRectMake(100, 200, 100, 50) title:@"click" textColor:[UIColor blackColor] textFont:[UIFont systemFontOfSize:20] backgroundColor:[UIColor redColor] addView:self.view target:self action:@selector(click)];
    // Do any additional setup after loading the view.
}
-(void)click{
   
    //    Printing description of ((__NSCFString *)0x00000001c0863300):
    //    00ffe31a901ff9b5aaa5b2dc5a7c4bd6
    //    Printing description of ((__NSCFString *)0x00000001c044d650):
    //    2017-12-23 15:01:35
//    [[BLLet sharedLet].familyManager delFamilyWithFamilyId:@"00ffe31a901ff9b5aaa5b2dc5a7c4bd6" familyVersion:@"2017-12-23 15:01:35" completionHandler:^(BLBaseResult * _Nonnull result) {
//
//
//    }];

    
    UIStoryboard * strory = [UIStoryboard  storyboardWithName:@"LeftMenuViewController" bundle:[NSBundle mainBundle]];


    ThirdAddViewController *  vc = [strory instantiateViewControllerWithIdentifier:@"thirdAdd"];
  
    [self.navigationController  pushViewController:vc animated:YES];
    
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
