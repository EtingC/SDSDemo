//
//  MainTableViewCell.h
//  AlinkDemo
//
//  Created by gubeidianzi on 2017/11/6.
//  Copyright © 2017年 aliyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BindDeviceInformationlistModel.h"
@interface MainTableViewCell : UITableViewCell
typedef void(^callBackBlock)(BindDeviceInformationlistModel *  model,MainTableViewCell * cell);
@property (weak, nonatomic) IBOutlet UIView *topGrayV;
@property (weak, nonatomic) IBOutlet UISwitch *Switch;
@property (weak, nonatomic) IBOutlet UIImageView *LogoImageV;
@property (weak, nonatomic) IBOutlet UILabel *NameL;
@property (weak, nonatomic) IBOutlet UILabel *StatusL;
@property (nonatomic,strong) BindDeviceInformationlistModel *bindModel;
@property (nonatomic,copy)callBackBlock callbbackBlock;
-(void)setTheData:(BindDeviceInformationlistModel *)model;
@end
