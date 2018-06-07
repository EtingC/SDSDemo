//
//  LXKDatePickerView.m
//  DatePickerDemo
//
//  Created by LXK on 2016/11/16.
//  Copyright © 2016年 lxkboy. All rights reserved.
//

#import "LXKDatePickerView.h"
#import "AppDelegate.h"

@interface LXKDatePickerView ()<UIPickerViewDataSource,UIPickerViewDelegate>
@property(nonatomic,strong)UIView *bottomView;//底部view
@property (strong,nonatomic) UIPickerView *datePicker;
@property (strong,nonatomic) UIView*timeSelectView;//时间选择view
@property (strong,nonatomic) NSMutableArray *minuteData;//月数据
@property (strong,nonatomic) NSMutableArray *hourData;//年数据

@property (strong,nonatomic) NSString  *timeSelectedString;//选择时间结果
@property (strong,nonatomic)NSString  *minuteStr;//月
@property (strong,nonatomic)NSString  *hourStr;//年
@end

@implementation LXKDatePickerView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.frame = frame;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        self.userInteractionEnabled = YES;
    }
    return self;
}
+(instancetype)makeViewWithMaskDatePicker:(CGRect)frame setTitle:(NSString *)title indexpath:(NSIndexPath *)indexpath
{
    
    
    LXKDatePickerView *mview = [[self alloc]initWithFrame:frame];
    mview.indexpath = indexpath;
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.window addSubview:mview];
    //添加底部view添加的window上
    mview.bottomView = [[UIView alloc]initWithFrame:CGRectMake(5, SCREEN_HEIGHT *3/5, SCREEN_WIDTH-10, SCREEN_HEIGHT *2/5)];
    mview.bottomView.backgroundColor = [UIColor clearColor];
    [delegate.window addSubview:mview.bottomView];
//    //横屏
//    if ([[UIApplication sharedApplication] statusBarOrientation] == UIDeviceOrientationLandscapeLeft) {
//        mview.bottomView.frame = CGRectMake(0, SCREEN_HEIGHT *2/5, SCREEN_WIDTH, SCREEN_HEIGHT *3/5);
//    }
    
    
    //添加自定义一个时间选择器
    mview.datePicker = [[UIPickerView alloc]initWithFrame:CGRectMake(2,0,SCREEN_WIDTH-14,mview.bottomView.frame.size.height  - 70)];
    mview.datePicker.backgroundColor = [UIColor whiteColor];
    mview.datePicker.dataSource = mview;
    mview.datePicker.delegate = mview;
    mview.datePicker.layer.cornerRadius = 12;
    mview.datePicker.layer.masksToBounds = YES;
    //初始时间选择文字
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"mm"];
    mview.minuteStr = [formatter stringFromDate:[NSDate date]];
    
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setDateFormat:@"HH"];
    mview.hourStr = [formatter1 stringFromDate:[NSDate date]];
    mview.timeSelectedString = [NSString stringWithFormat:@"%@:%@",mview.hourStr,mview.minuteStr];
    [mview.datePicker selectRow:mview.minuteStr.integerValue  inComponent:1 animated:NO];
    [mview.datePicker selectRow:mview.hourStr.integerValue inComponent:0 animated:NO];
    
    [mview.bottomView addSubview:mview.datePicker];
   
    //添加底部button
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(0, 0,40, 40);
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelBtn setTitle:@"X" forState:UIControlStateNormal];
    [cancelBtn addTarget:mview action:@selector(cancelBtn:) forControlEvents:UIControlEventTouchUpInside];
    [mview.bottomView  addSubview:cancelBtn];
    //确定按钮
    UIButton *makeSureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    makeSureBtn.frame = CGRectMake(0 , CGRectGetMaxY(mview.datePicker.frame)+5, SCREEN_WIDTH-10, 65);
    makeSureBtn.backgroundColor = [UIColor whiteColor];
    [makeSureBtn setTitle:@"确定" forState: UIControlStateNormal];
    [makeSureBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [makeSureBtn addTarget:mview action:@selector(makeSureBtn:) forControlEvents:UIControlEventTouchUpInside];
    [mview.bottomView addSubview:makeSureBtn];
    makeSureBtn.layer.cornerRadius = 12;
    makeSureBtn.layer.masksToBounds = YES;
    return mview;
}
//取消
-(void)cancelBtn:(UIButton *)cancelBtn
{
    [self removeView];
}

-(void)makeSureBtn:(UIButton *)makeSureBtn
{
    //代理传值
    if ([_delegate respondsToSelector:@selector(getdatepickerForYearAndMonthChangeValues:indexpath:)]) {
        if (!self.timeSelectedString) {
            NSDate *currentDate = [NSDate date];//获取当前时间，日期
            [self getdate:currentDate];
        }
        [_delegate getdatepickerForYearAndMonthChangeValues:self.timeSelectedString indexpath:self.indexpath];
    }
    [self removeView];
}
//获取日期
-(void)getdate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    self.timeSelectedString = [dateFormatter stringFromDate:date];
}
//单击蒙层取消蒙层
-(void)removeView{
    [self.bottomView removeFromSuperview];
    [self removeFromSuperview];
}
#pragma mark pickDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    //年，月
    return 2;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        self.hourStr = self.hourData[row];
    }else{
        self.minuteStr = self.minuteData[row];
    }
//    NSDateFormatter *formatterMonth = [[NSDateFormatter alloc] init];
//    [formatterMonth setDateFormat:@"mm"];
//    NSString *nowMonthStr = [formatterMonth stringFromDate:[NSDate date]];
//    NSDateFormatter *formatterYear= [[NSDateFormatter alloc] init];
//    [formatterYear setDateFormat:@"HH"];
//    NSString *nowYearStr = [formatterYear stringFromDate:[NSDate date]];
//    int a = [nowMonthStr intValue];
//    int b = [nowYearStr intValue];
//    int c = [self.minuteStr intValue];
//    int d = [self.hourStr intValue];
//    //当时间大于当前时间时，返回到当前时间
//    if (d>b||(d==b&&c>a)) {
//        [self.datePicker selectRow:a-1 inComponent:1 animated:YES];
//        [self.datePicker selectRow:b-1900 inComponent:0 animated:YES];
//        self.hourStr = nowYearStr;
//        self.minuteStr = nowMonthStr;
//    }
    self.timeSelectedString = [NSString stringWithFormat:@"%@:%@",self.hourStr,self.minuteStr];
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        
        return self.hourData.count;
    }else {
      
        return self.minuteData.count;
    }
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component == 0) {
        return  [NSString stringWithFormat:@"%@ 时",self.hourData[row]];
    }else {
        return  [NSString stringWithFormat:@"%@ 分",self.minuteData[row]];
    }
}

-(NSMutableArray *)minuteData{
    if (!_minuteData) {
        _minuteData = [[NSMutableArray alloc]init];
        for (int i = 00; i<=59; i++) {
            NSString *str = nil;
            if (i<10) {
                str = [NSString stringWithFormat:@"0%d",i];
            }else{
                str = [NSString stringWithFormat:@"%d",i];
            }
            
            [self.minuteData addObject:str];
        }
    }
    return _minuteData;
}
-(NSMutableArray *)hourData{
    if (!_hourData) {
        _hourData = [[NSMutableArray alloc]init];
        for (int i = 0; i<24; i++) {
            NSString *str = [NSString stringWithFormat:@"%d",i];
            [self.hourData addObject:str];
        }
    }
    return _hourData;
}
@end
