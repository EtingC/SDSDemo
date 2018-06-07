//
//  UIViewController+changeleftItem.m
//  AlinkDemo
//
//  Created by gubeidianzi on 2018/1/11.
//  Copyright © 2018年 aliyun. All rights reserved.
//

#import "UIViewController+changeleftItem.h"

@implementation UIViewController (changeleftItem)
-(void)changeleftItem{
   
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"导航栏返回"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = left;
    
}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
