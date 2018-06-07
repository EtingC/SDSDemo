//
//  DeviceInfoManager.m
//  AlinkDemo
//
//  Created by gubeidianzi on 2017/11/8.
//  Copyright © 2017年 aliyun. All rights reserved.
//

#import "DeviceInfoManager.h"

@implementation DeviceInfoManager
+ (DeviceInfoManager *)sharedManager
{
    static DeviceInfoManager *deviceInfoManager = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        deviceInfoManager = [[self alloc] init];
       
    });
    return deviceInfoManager;
}
-(NSString *)TheAddDevieceName{
    if (!_TheAddDevieceName) {
        _TheAddDevieceName = [[NSString alloc]init];
        
    }
    return _TheAddDevieceName;
}
-(NSString *)PID{
    if (!_PID) {
        _PID = [[NSString alloc]init];
    }
    
    return _PID;
}
-(NSMutableArray *)deviceInfoArray{
    if (_deviceInfoArray == nil) {
         _deviceInfoArray = [[NSMutableArray alloc] init];
    }
    return _deviceInfoArray;
}
+(UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    //app默认windowLevel是UIWindowLevelNormal，如果不是，找到UIWindowLevelNormal的
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    id  nextResponder = nil;
    UIViewController *appRootVC=window.rootViewController;
    //    如果是present上来的appRootVC.presentedViewController 不为nil
    if (appRootVC.presentedViewController) {
        nextResponder = appRootVC.presentedViewController;
    }else{
        
        NSLog(@"===%@",[window subviews]);
        UIView *frontView = [[window subviews] objectAtIndex:0];
        nextResponder = [frontView nextResponder];
    }
    
    if ([nextResponder isKindOfClass:[UITabBarController class]]){
        UITabBarController * tabbar = (UITabBarController *)nextResponder;
        UINavigationController * nav = (UINavigationController *)tabbar.viewControllers[tabbar.selectedIndex];
        //        UINavigationController * nav = tabbar.selectedViewController ; 上下两种写法都行
        result=nav.childViewControllers.lastObject;
        
    }else if ([nextResponder isKindOfClass:[UINavigationController class]]){
        UIViewController * nav = (UIViewController *)nextResponder;
        result = nav.childViewControllers.lastObject;
    }else{
        result = nextResponder;
    }
    return result;
}
#pragma mark - 解析获取PID
+(NSString *)getPidStringDecimal:(NSInteger)decimal {
    NSString *hex =@"";
    NSString *letter;
    NSInteger number;
    for (int i = 0; i<9; i++) {
        number = decimal % 16;
        decimal = decimal / 16;
        switch (number) {
            case 10:
                letter =@"a"; break;
            case 11:
                letter =@"b"; break;
            case 12:
                letter =@"c"; break;
            case 13:
                letter =@"d"; break;
            case 14:
                letter =@"e"; break;
            case 15:
                letter =@"f"; break;
            default:
                letter = [NSString stringWithFormat:@"%ld", (long)number];
        }
        hex = [letter stringByAppendingString:hex];
        if (decimal == 0) {
            break;
        }
    }
    if (hex.length%2 !=0) {
        hex = [NSString stringWithFormat:@"0%@",hex];
    }
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < hex.length/2; i++) {
        [array addObject:[hex substringWithRange:NSMakeRange(i*2, 2)]];
    }
    NSString *string = @"";
    for (int i = 0; i < array.count; i++) {
        string = [string stringByAppendingString:array[array.count-1-i]];
    }
    NSString *newString = [NSString stringWithFormat:@"000000000000000000000000%@",string];
    while (newString.length <32) {
        newString = [newString stringByAppendingString:@"0"];
    }
    return newString;
}
@end
