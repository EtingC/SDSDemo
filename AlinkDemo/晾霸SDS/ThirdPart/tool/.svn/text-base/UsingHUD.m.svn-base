//
//  UsingHUD.m
//  JiShiTang
//
//  Created by apple on 16/1/6.
//  Copyright © 2016年 xiexu. All rights reserved.
//

#import "UsingHUD.h"

@implementation UsingHUD

+ (void)blackStyle:(MBProgressHUD*)hud
{
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    hud.contentColor = [UIColor whiteColor];
}

+ (MBProgressHUD*)showInView:(UIView*)view
{
    MBProgressHUD* hud = (MBProgressHUD*)[view viewWithTag:12021];
    if (hud == nil) {
        hud = [[MBProgressHUD alloc] initWithView:view];
        [UsingHUD blackStyle:hud];
        hud.tag = 12021;
        [view addSubview:hud];
    }
    [view bringSubviewToFront:hud];
    [hud showAnimated:NO];
    
    return hud;
}

+ (void)hideInView:(UIView*)view
{
    MBProgressHUD* hud = (MBProgressHUD*)[view viewWithTag:12021];
    if (hud) {
        [hud hideAnimated:NO];
    }
}


+ (MBProgressHUD*)showProgressInView:(UIView*)view
{
    MBProgressHUD* hud = (MBProgressHUD*)[view viewWithTag:12021];
    hud = [[MBProgressHUD alloc] initWithView:view];
    [UsingHUD blackStyle:hud];
    [view addSubview:hud];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.detailsLabel.text = @"上传中...";
    hud.removeFromSuperViewOnHide = YES;
    [hud showAnimated:NO];
    [view addSubview:hud];

    return hud;
}

@end
