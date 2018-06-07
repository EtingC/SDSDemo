//
//  TimeManagerTableViewCell.m
//  AlinkDemo
//
//  Created by gubeidianzi on 2017/11/13.
//  Copyright © 2017年 aliyun. All rights reserved.
//

#import "TimeManagerTableViewCell.h"

@implementation TimeManagerTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}
- (IBAction)ChangeTimeState:(UISwitch *)sender {
    if (self.vackvalue) {
        self.vackvalue(sender,self.timeModel);
    }
}

-(void)setTheData:(SetTimeSceneList *)model{
    if (model) {
      self.timeModel =model;
    }
    NSString * templateID = nil;
    if ([model.templateId isEqualToString:@"1000201"]) {
        templateID = @"开启";
         self.TimeL.text = [NSString stringWithFormat:@"%@:%@",model.jsonValues.hour,model.jsonValues.minute];
    }
    if ([model.templateId isEqualToString:@"1000202"]) {
        templateID = @"关闭";
         self.TimeL.text = [NSString stringWithFormat:@"%@:%@",model.jsonValues.hour,model.jsonValues.minute];
    }
    if ([model.templateId isEqualToString:@"1000203"]) {
        templateID = @"开启关闭";
        self.TimeL.text = [NSString stringWithFormat:@"%@:%@、%@:%@",model.jsonValues.firstHour,model.jsonValues.firstMinute,model.jsonValues.secondHour,model.jsonValues.secondMinute];
    }
    NSString *weekStr = nil;
    if ([model.jsonValues.week isEqualToString:@""]) {
        weekStr = @"仅一次";
    }else{
        NSMutableString * mutstr = [[NSMutableString alloc]init];;
        weekStr = model.jsonValues.week;
        NSArray * arr = [weekStr componentsSeparatedByString:@","];
        NSMutableArray * mutarr = [NSMutableArray arrayWithArray:arr];
        [mutarr removeLastObject];
        for (NSString * str  in mutarr) {
            [mutstr appendString:[self backCycelSetTime:str]];
            [mutstr appendString:@","];
        }
        weekStr = [mutstr copy];
        weekStr = [weekStr substringToIndex:weekStr.length-1];
    }
    self.timecycleL.text = [NSString stringWithFormat:@"%@,%@",templateID,weekStr];
    if ([model.state isEqualToString:@"1"]) {
        self.timeSwitchBtn.on =YES;
    }else{
        self.timeSwitchBtn.on = NO;
    }
}
-(NSString *)backCycelSetTime:(NSString *)time{
    if ([time isEqualToString:@""]) {
        return @"";
    }
    if ([time isEqualToString:@"2"]) {
        return @"周一";
    }
    if ([time isEqualToString:@"3"]) {
        return @"周二";
    }
    if ([time isEqualToString:@"4"]) {
        return @"周三";
    }
    if ([time isEqualToString:@"5"]) {
        return @"周四";
    }
    if ([time isEqualToString:@"6"]) {
        return @"周五";
    }
    if ([time isEqualToString:@"7"]) {
        return @"周六";
    }
    if ([time isEqualToString:@"1"]) {
        return @"周日";
    }
    return @"";
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
