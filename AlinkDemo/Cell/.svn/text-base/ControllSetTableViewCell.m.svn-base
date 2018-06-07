//
//  ControllSetTableViewCell.m
//  AlinkDemo
//
//  Created by gubeidianzi on 2017/11/14.
//  Copyright © 2017年 aliyun. All rights reserved.
//

#import "ControllSetTableViewCell.h"

@implementation ControllSetTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization code
}
-(void)setTheData:(NSString *)arr{
    self.ActionL.text = arr;
    
}
- (IBAction)click:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    if (sender.selected == YES) {
        [sender setImage:[UIImage imageNamed:@"已选"] forState:UIControlStateNormal];
    }else{
        [sender setImage:[UIImage imageNamed:@"未选"] forState:UIControlStateNormal];
    }
    self.callbackblock(self.ActionL.text,sender);
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
