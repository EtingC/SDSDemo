//
//  LXKDatePickerView.h
//  DatePickerDemo
//
//  Created by LXK on 2016/11/16.
//  Copyright © 2016年 lxkboy. All rights reserved.
////年月datepickage封装

#import <UIKit/UIKit.h>
@protocol LXKDatePickerViewDelegate<NSObject>
 
//获取日期改变的代理方法
@optional
-(void)getdatepickerForYearAndMonthChangeValues:(NSString *)values indexpath:(NSIndexPath *)indexpath;
@end
@interface LXKDatePickerView : UIView
//委托变量
@property(nonatomic,weak) id<LXKDatePickerViewDelegate>delegate;
@property (nonatomic,strong) NSIndexPath * indexpath;
-(instancetype)initWithFrame:(CGRect)frame;
+(instancetype)makeViewWithMaskDatePicker:(CGRect)frame setTitle:(NSString *)title indexpath:(NSIndexPath *)indexpath;
@end
