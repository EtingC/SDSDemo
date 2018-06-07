//
//  SheBeiDetailModel.m
//  AlinkDemo
//
//  Created by gubeidianzi on 2017/11/23.
//  Copyright © 2017年 aliyun. All rights reserved.
//

#import "SheBeiDetailModel.h"
#import "relAccountsModel.h"
@implementation SheBeiDetailModel
+(NSDictionary *)mj_objectClassInArray{
    
    return @{
             @"relAccounts":[relAccountsModel class]
             
             };
    
}
@end
