//
//  BaseViewController.h
//  AlinkDemo
//
//  Created by gubeidianzi on 2017/11/6.
//  Copyright © 2017年 aliyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKProductBriefModel.h"
#import "UIScrollView+EmptyDataSet.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
@interface BaseViewController : UIViewController<DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (nonatomic,strong) UITableView *myTable;
@property (nonatomic,strong) NSMutableArray *dataSource;

-(UIBarButtonItem* )setNavLeftRightFrame:(UINavigationController *)nav imageName:(NSString *)name selector:(NSString*)selector ;
-(void)leftBtn;
-(void)rightBtn;
@end
