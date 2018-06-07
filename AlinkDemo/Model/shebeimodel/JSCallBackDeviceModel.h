//
//  JSCallBackDeviceModel.h
//  AlinkDemo
//
//  Created by gubeidianzi on 2017/11/14.
//  Copyright © 2017年 aliyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSCallBackDeviceModel : NSObject
//params_map.txt数据结构：
//{
//    "params_ali": [//sds参数
//                   {
//                       "key": "Switch",//参数名称
//                       "name": "开关",//参数名称
//                       "act": "1",//参数属性：1: read only 2: write only 3:read & write
//                       "type": 1,//参数类型 1表示枚举型  2表示连续型
//                       "value_range1": [//枚举型时有效
//                                        {
//                                            "value": "1",//sds枚举值
//                                            "correspond_value": "1",//bl枚举值
//                                            "name": "开"//枚举值名称
//                                        },
//                                        {
//                                            "value": "0",
//                                            "correspond_value": "0",
//                                            "name": "关"
//                                        }
//                                        ],
//                       "value_range2": {//连续型时有效
//                           "min": 1,//最小值
//                           "max": 100,//最大值
//                           "mulriple": 1,//倍数
//                           "step": 1//步长
//
//                       },
//                       "unit": ""//单位
//                   }
//                   ],
//    "params_bl": [//broadlink参数
//                  {
//                      "key": "pwr",
//                      "name": "开关"
//                  }
//              ]
//}

@property (nonatomic,strong) NSArray *params_ali;
@property (nonatomic,strong) NSArray *params_bl;
@end
