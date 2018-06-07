//
//  ControllSetTableViewCell.h
//  AlinkDemo
//
//  Created by gubeidianzi on 2017/11/14.
//  Copyright © 2017年 aliyun. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^callBackBlock)(NSString * index,UIButton *btn);
@interface ControllSetTableViewCell : UITableViewCell
@property (nonatomic,assign) NSInteger num;
@property (weak, nonatomic) IBOutlet UILabel *ActionL;
@property (weak, nonatomic) IBOutlet UIButton *ActionBnt;
@property (nonatomic,copy) callBackBlock callbackblock;
-(void)setTheData:(NSString *)arr;
@end
