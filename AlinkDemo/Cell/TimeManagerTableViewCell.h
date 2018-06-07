//
//  TimeManagerTableViewCell.h
//  AlinkDemo
//
//  Created by gubeidianzi on 2017/11/13.
//  Copyright © 2017年 aliyun. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "SetTimeSceneList.h"
typedef void (^backValue) (UISwitch * timeSwitchBtn,SetTimeSceneList *model);
@interface TimeManagerTableViewCell : BaseTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *TimeL;
@property (weak, nonatomic) IBOutlet UILabel *timecycleL;
@property (weak, nonatomic) IBOutlet UISwitch *timeSwitchBtn;
-(void)setTheData:(SetTimeSceneList *)model;
@property(nonatomic,strong  ) SetTimeSceneList * timeModel;
@property (nonatomic,copy) backValue vackvalue;
@end
