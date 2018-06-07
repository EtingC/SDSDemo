//
//  DrawCyclesView.m
//  AlinkDemo
//
//  Created by gubeidianzi on 2017/11/10.
//  Copyright © 2017年 aliyun. All rights reserved.
//

#import "DrawCyclesView.h"
#define kBorderWith 1
@implementation DrawCyclesView
- (void)drawRect:(CGRect)rect {
    // 获取图形上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGFloat width = rect.size.width;
    /**
     *  画空心圆
     */
    CGRect bigRect = CGRectMake(rect.origin.x + kBorderWith,
                                rect.origin.y+ kBorderWith,
                                rect.size.width - kBorderWith*2,
                                rect.size.height - kBorderWith*2);
    
    //设置空心圆的线条宽度
    CGContextSetLineWidth(ctx, kBorderWith);
    //以矩形bigRect为依据画一个圆
    CGContextAddEllipseInRect(ctx, bigRect);
    //填充当前绘画区域的颜色
    [RGB(241, 150, 28) set];
    //(如果是画圆会沿着矩形外围描画出指定宽度的（圆线）空心圆)/（根据上下文的内容渲染图层）
    CGContextStrokePath(ctx);
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

*/

@end
