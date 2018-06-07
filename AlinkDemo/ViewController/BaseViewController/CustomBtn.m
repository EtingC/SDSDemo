//
//  CustomBtn.m
//  AlinkDemo
//
//  Created by gubeidianzi on 2017/12/13.
//  Copyright © 2017年 aliyun. All rights reserved.
//

#import "CustomBtn.h"

@implementation CustomBtn
- (void)drawRect:(CGRect)rect {
    
    
    self.layer.cornerRadius = 10;
    self.layer.masksToBounds = YES;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

*/

@end
