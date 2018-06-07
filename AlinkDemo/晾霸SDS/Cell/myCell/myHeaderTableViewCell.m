//
//  myHeaderTableViewCell.m
//  AlinkDemo
//
//  Created by gubeidianzi on 2017/11/30.
//  Copyright © 2017年 aliyun. All rights reserved.
//

#import "myHeaderTableViewCell.h"

@implementation myHeaderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.headerIMG.layer.cornerRadius = self.headerIMG.frame.size.width/2;
    self.headerIMG.layer.masksToBounds = YES;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
