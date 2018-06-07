//
//  NoTimeView.m
//  AlinkDemo
//
//  Created by gubeidianzi on 2017/11/17.
//  Copyright © 2017年 aliyun. All rights reserved.
//

#import "NoTimeView.h"

@implementation NoTimeView
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    self = [[[NSBundle mainBundle] loadNibNamed:@"NOTimeView" owner:self options:nil] lastObject];
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
