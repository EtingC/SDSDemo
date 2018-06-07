//
//  ShareTableViewCell.m
//  AlinkDemo
//
//  Created by gubeidianzi on 2017/11/23.
//  Copyright © 2017年 aliyun. All rights reserved.
//

#import "ShareTableViewCell.h"

@implementation ShareTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)layoutSubviews {
    [super layoutSubviews];
    for (UIView *subView in self.subviews){
        if([subView isKindOfClass:NSClassFromString(@"UITableViewCellDeleteConfirmationView")]) {
            CGRect cRect = subView.frame;
            cRect.size.height = self.contentView.frame.size.height - 10;
            subView.frame = cRect;
            
            UIView *confirmView=(UIView *)[subView.subviews firstObject];
            // 改背景颜色
            confirmView.backgroundColor=RGB(244, 59, 65);
            for(UIView *sub in confirmView.subviews){
                if([sub isKindOfClass:NSClassFromString(@"UIButtonLabel")]){
                    UILabel *deleteLabel=(UILabel *)sub;
                    // 改删除按钮的字体
                    deleteLabel.font=[UIFont boldSystemFontOfSize:15];
                    // 改删除按钮的文字
                    deleteLabel.text=@"解除绑定";
                }
            }
            break;
        }
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
