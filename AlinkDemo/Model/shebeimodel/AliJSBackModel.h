//
//  AliJSBackModel.h
//  AlinkDemo
//
//  Created by gubeidianzi on 2017/11/14.
//  Copyright © 2017年 aliyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "value_range2Model.h"
@interface AliJSBackModel : NSObject
@property (nonatomic,copy) NSString *key;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *act;
@property (nonatomic,copy) NSString *type;
@property (nonatomic,copy) NSString *unit;
@property (nonatomic,copy) NSArray  *value_range1;
@property (nonatomic,copy) value_range2Model *value_range2;

@end
