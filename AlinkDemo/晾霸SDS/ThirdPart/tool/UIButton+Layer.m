//
//  UIButton+Layer.m
//  AlinkDemo
//
//  Created by gubeidianzi on 2017/11/30.
//  Copyright © 2017年 aliyun. All rights reserved.
//

#import "UIButton+Layer.h"

@implementation UIButton (Layer)
-(void)AddLayer:(CGFloat)number{
    
    self.layer.cornerRadius =  number;
    self.layer.masksToBounds = YES;
}
@end
