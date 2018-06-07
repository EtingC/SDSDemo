//
//  SureTheRegisterPasswordView.m
//  AlinkDemo
//
//  Created by gubeidianzi on 2017/11/20.
//  Copyright © 2017年 aliyun. All rights reserved.
//

#import "SureTheRegisterPasswordView.h"

@implementation SureTheRegisterPasswordView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    self = [[[NSBundle mainBundle] loadNibNamed:@"SureTheRegisterPasswordView" owner:self options:nil] lastObject];
    if (self) {
        self.frame = frame;
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
