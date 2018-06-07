//
//  MainTImeSelectedPushViewController.m
//  AlinkDemo
//
//  Created by gubeidianzi on 2017/11/16.
//  Copyright © 2017年 aliyun. All rights reserved.
//

#import "MainTImeSelectedPushViewController.h"
#import "CommonTimeTableViewCell.h"
#import "JSCallBackDeviceModel.h"
#import "AliJSBackModel.h"
#import "SetTimeActionViewController.h"
#import "LXKDatePickerView.h"
#import "CycleSetTimeViewController.h"
@interface MainTImeSelectedPushViewController ()<UITableViewDelegate,UITableViewDataSource,LXKDatePickerViewDelegate,UIGestureRecognizerDelegate >
@property (nonatomic,strong)NSMutableArray * configueArr;
@property(nonatomic,strong)LXKDatePickerView * DatePickerView;
@property (nonatomic,copy) NSString * cycleTimeStr;
@property (nonatomic,strong) UIButton * btn;
@end

@implementation MainTImeSelectedPushViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"定时设置";
    self.navigationItem.leftBarButtonItem = [self setNavLeftRightFrame:self.navigationController imageName:@"Back Chevron" selector:@"leftBtn"];
    self.navigationItem.leftBarButtonItem.target =self;
    self.navigationItem.leftBarButtonItem.style = UIBarButtonItemStylePlain;
    UIButton * label =  [UIButton buttonWithType:UIButtonTypeCustom];
    [label setTitle:@"保存" forState:UIControlStateNormal];
    [label setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [label.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [label addTarget:self action:@selector(baocun) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * right = [[UIBarButtonItem alloc]initWithCustomView:label];
    self.navigationItem.rightBarButtonItem = right;
    
     self.configueArr = [[NSMutableArray alloc]init];
     [self setTheUI];
    NSString * templateID = nil;
    if ([self.model.templateId isEqualToString:@"1000201"]) {
        templateID = @"开启";
       
    }
    if ([self.model.templateId isEqualToString:@"1000202"]) {
        templateID = @"关闭";
       
    }
    if ([self.model.templateId isEqualToString:@"1000203"]) {
        templateID = @"开启关闭";
    }
    [self setTheConfigue:templateID];
    // Do any additional setup after loading the view.
}
-(void)setTheConfigue:(NSString *)str {
    
    NSArray * dic  = @[ /*1*/@[
                                 @{
                                     @"SectionName":@"模块",
                                     @"Status":@"开启"
                                     }
                                 ],
                             /*2*/ @[
                                 @{
                                      @"SectionName":@"执行操作",
                                      @"Status":[self backAnalysisFirstActionParams:self.model.jsonValues.firstActionParams]?:@""
                                     
                                     },
                                 @{
                                     @"SectionName":@"执行时间",
                                     @"Status":self.model.jsonValues.hour?[NSString stringWithFormat:@"%@:%@",self.model.jsonValues.hour,self.model.jsonValues.minute]:@""
                                     
                                     },
                                 @{
                                     @"SectionName":@"重复设置",
                                     @"Status": [self backWeek:self.model.jsonValues.week]?:@"仅一次"
                                     
                                     }
                                 ]
                             ];
    
    NSArray * dic1  = @[
                        /*1*/@[
                                 @{
                                     @"SectionName":@"模块",
                                     @"Status":@"关闭"
                                     }
                                 ],
                             /*2*/  /*2*/ @[
                                 @{
                                     @"SectionName":@"执行操作",
                                     @"Status":[self backAnalysisFirstActionParams:self.model.jsonValues.firstActionParams]?:@""
                                     
                                     },
                                 @{
                                     @"SectionName":@"执行时间",
                                     @"Status":self.model.jsonValues.hour?[NSString stringWithFormat:@"%@:%@",self.model.jsonValues.hour,self.model.jsonValues.minute]:@""
                                     
                                     },
                                 @{
                                     @"SectionName":@"重复设置",
                                     @"Status": [self backWeek:self.model.jsonValues.week]?:@"仅一次"
                                     
                                     }
                                 ]
                             ];
    
    NSArray * dic2  =    @[
                           /*1*/@[
                                    @{
                                        @"SectionName":@"模块",
                                        @"Status":@"开启关闭"
                                        }
                                    ],
                                /*2*/ @[
                                    @{
                                        @"SectionName":@"执行操作",
                                        @"Status":[self backAnalysisFirstActionParams:self.model.jsonValues.firstActionParams]?:@""
                                        
                                        },
                                    @{
                                        @"SectionName":@"执行时间",
                                        @"Status":self.model.jsonValues.firstHour?[NSString stringWithFormat:@"%@:%@",self.model.jsonValues.firstHour,self.model.jsonValues.firstMinute]:@""
                                        
                                        }
                                    ],
                                /*3*/ @[@{
                                            @"SectionName":@"执行操作",
                                            @"Status":[self backAnalysisSecondActionParams:self.model.jsonValues.secondActionParams]?:@""
                                            
                                            },
                                        @{
                                            @"SectionName":@"执行时间",
                                            @"Status":self.model.jsonValues.secondHour?[NSString stringWithFormat:@"%@:%@",self.model.jsonValues.secondHour,self.model.jsonValues.secondMinute]:@""
                                            
                                            }
                                        ],
                                /*4*/@[
                                    @{
                                        @"SectionName":@"重复设置",
                                        @"Status":[self backWeek:self.model.jsonValues.week]?:@"仅一次"
                                        
                                        }
                                    ]
                                ];
    
    if ([str isEqualToString:@"开启"]) {
        self.configueArr =[NSMutableArray arrayWithArray:dic];
    }else if ([str isEqualToString:@"关闭"]){
        
        self.configueArr = [NSMutableArray arrayWithArray:dic1];
    }else{
        self.configueArr = [NSMutableArray arrayWithArray:dic2];
    }
    [self.myTable reloadData];
}
#pragma mark - 保存的方法

/**
 保存的方法
 */
-(void)baocun{
    NSIndexPath * path = nil;
    NSString *FirstHourTime = nil;
    NSString *FirstMinuteTime = nil;
    NSString *SecondHourTime =nil;
    NSString *SecondMinuteTime =nil;
    NSString *CaoZuoState = nil;
    NSString * SencondCaoZuoState =nil;
    NSString * Actionstr = nil;
    NSMutableArray *arr1 = [[NSMutableArray   alloc]init];
    NSMutableString * mutstr = [[NSMutableString alloc]init];
    path = [NSIndexPath indexPathForRow:0 inSection:0];
    CommonTimeTableViewCell * moudelCell = [self.myTable cellForRowAtIndexPath:path];
    NSString * TheMoudelID = moudelCell.RightNameL.text;
    TheMoudelID = [self backTheMoudelID:TheMoudelID];
    NSDictionary * baseDic = nil;
    if ([TheMoudelID isEqualToString:@"1000201"]) {
        path = [NSIndexPath indexPathForRow:0 inSection:1];
        CommonTimeTableViewCell * moudelCell1 = [self.myTable cellForRowAtIndexPath:path];
        path = [NSIndexPath indexPathForRow:1 inSection:1];
        CommonTimeTableViewCell * moudelCell2 = [self.myTable cellForRowAtIndexPath:path];
        path = [NSIndexPath indexPathForRow:2 inSection:1];
        CommonTimeTableViewCell * moudelCell3 = [self.myTable cellForRowAtIndexPath:path];
        CaoZuoState = moudelCell1.RightNameL.text?:@"";
        CaoZuoState = [self backCaoZuoStateID:CaoZuoState];
        FirstHourTime = moudelCell2.RightNameL.text?:@"";
        FirstHourTime = [self backHourStr:FirstHourTime];
        FirstMinuteTime = moudelCell2.RightNameL.text?:@"";
        FirstMinuteTime =[self backMinuteStr:FirstMinuteTime];
        Actionstr =moudelCell3.RightNameL.text;
        if (![Actionstr isEqualToString:@"仅一次"]) {
            NSArray * arr = [Actionstr  componentsSeparatedByString:@","];
            for (NSString * str  in arr) {
                [arr1 addObject:[self backCycelSetTime:str]];
            }
            for (NSString * str  in arr1) {
                [mutstr appendString:str];
                [mutstr appendString:@","];
            }
            [mutstr substringWithRange:NSMakeRange(0, mutstr.length-2)];
            
        } else{
             mutstr = [NSMutableString stringWithString:@""];
        }
        
        if ([FirstHourTime isEqualToString:@""]||[FirstMinuteTime isEqualToString:@""]||[CaoZuoState isEqualToString:@""] ) {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"" message:@"定时和执行操作需要设置" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
            
        }else{
            
            baseDic = @{@"firstActionParams":[self dictionaryToJson:@{
                                                                      @"attrSet": @[
                                                                              @"Switch"
                                                                              ],
                                                                      @"Switch": @{
                                                                              @"value": CaoZuoState
                                                                              }
                                                                      }] ,@"deviceUuid":DEVICEMoudleManger.listModel.uuid,@"minute":FirstMinuteTime,@"hour":FirstHourTime,@"week":mutstr,@"timeZone":@"GMT+8"};
            NSDictionary *  dic = @{@"deviceUuid":DEVICEMoudleManger.listModel.uuid,@"id":self.model.id,@"jsonValues":[self dictionaryToJson:baseDic],@"state":@"",@"name":@"",@"sceneGroup":@""};
            WeakSelf
            [[NetworkTool sharedTool]requestWithURLparameters:dic method:@"mtop.openalink.case.template.case.update" View:self.view sessionExpiredOption:AKLoginOptionAutoLoginOnly needLogin:YES callBack:^(AlinkResponse *responseObject) {
                [weakSelf.navigationController popViewControllerAnimated:YES];
                NSLog(@"%@",responseObject);
            } errorBack:^(id error) {
                
            }];
        }
    }
    if ([TheMoudelID isEqualToString:@"1000202"]) {
        path = [NSIndexPath indexPathForRow:0 inSection:1];
        CommonTimeTableViewCell * moudelCell1 = [self.myTable cellForRowAtIndexPath:path];
        path = [NSIndexPath indexPathForRow:1 inSection:1];
        CommonTimeTableViewCell * moudelCell2 = [self.myTable cellForRowAtIndexPath:path];
        path = [NSIndexPath indexPathForRow:2 inSection:1];
        CommonTimeTableViewCell * moudelCell3 = [self.myTable cellForRowAtIndexPath:path];
        CaoZuoState = moudelCell1.RightNameL.text?:@"";
        CaoZuoState = [self backCaoZuoStateID:CaoZuoState];
        FirstHourTime = moudelCell2.RightNameL.text?:@"";
        FirstHourTime = [self backHourStr:FirstHourTime];
        FirstMinuteTime = moudelCell2.RightNameL.text?:@"";
        FirstMinuteTime =[self backMinuteStr:FirstMinuteTime];
        Actionstr = moudelCell3.RightNameL.text ;
        if (![Actionstr isEqualToString:@"仅一次"]) {
            NSArray * arr = [Actionstr  componentsSeparatedByString:@","];
            for (NSString * str  in arr) {
                [arr1 addObject:[self backCycelSetTime:str]];
            }
            for (NSString * str  in arr1) {
                [mutstr appendString:str];
                [mutstr appendString:@","];
            }
            [mutstr substringWithRange:NSMakeRange(0, mutstr.length-2)];
            
        } else{
            mutstr = [NSMutableString stringWithString:@""];
        }
        
        if ([FirstHourTime isEqualToString:@""]||[FirstMinuteTime isEqualToString:@""]||[CaoZuoState isEqualToString:@""] ) {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"" message:@"定时和执行操作需要设置" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
            
        }else{
            
            baseDic = @{@"firstActionParams":[self dictionaryToJson:@{
                                                                      @"attrSet": @[
                                                                              @"Switch"
                                                                              ],
                                                                      @"Switch": @{
                                                                              @"value": CaoZuoState
                                                                              }
                                                                      }] ,@"deviceUuid":DEVICEMoudleManger.listModel.uuid,@"minute":FirstMinuteTime,@"hour":FirstHourTime,@"week":mutstr,@"timeZone":@"GMT+8"};
            NSDictionary *  dic = @{@"deviceUuid":DEVICEMoudleManger.listModel.uuid,@"id":self.model.id,@"jsonValues":[self dictionaryToJson:baseDic],@"state":@"",@"name":@"",@"sceneGroup":@""};
            WeakSelf
            [[NetworkTool sharedTool]requestWithURLparameters:dic method:@"mtop.openalink.case.template.case.update" View:self.view sessionExpiredOption:AKLoginOptionAutoLoginOnly needLogin:YES callBack:^(AlinkResponse *responseObject) {
                [weakSelf.navigationController popViewControllerAnimated:YES];
                NSLog(@"%@",responseObject);
            } errorBack:^(id error) {
                
            }];
        }
    }
    if ([TheMoudelID isEqualToString:@"1000203"]) {
        
        path = [NSIndexPath indexPathForRow:0 inSection:1];
        CommonTimeTableViewCell * moudelCell1 = [self.myTable cellForRowAtIndexPath:path];//操作一 执行操作
        path = [NSIndexPath indexPathForRow:1 inSection:1];
        CommonTimeTableViewCell * moudelCell2 = [self.myTable cellForRowAtIndexPath:path];//操作一 执行时间
        path = [NSIndexPath indexPathForRow:0 inSection:3];
        CommonTimeTableViewCell * moudelCell3 = [self.myTable cellForRowAtIndexPath:path];//重复设置 week
        CaoZuoState = moudelCell1.RightNameL.text?:@"";
        CaoZuoState = [self backCaoZuoStateID:CaoZuoState];
        FirstHourTime = moudelCell2.RightNameL.text?:@"";
        FirstHourTime = [self backHourStr:FirstHourTime];
        FirstMinuteTime = moudelCell2.RightNameL.text?:@"";
        FirstMinuteTime =[self backMinuteStr:FirstMinuteTime];
        Actionstr = moudelCell3.RightNameL.text ;
        if (![Actionstr isEqualToString:@"仅一次"]) {
            NSArray * arr = [Actionstr  componentsSeparatedByString:@","];
            for (NSString * str  in arr) {
                [arr1 addObject:[self backCycelSetTime:str]];
            }
            for (NSString * str  in arr1) {
                [mutstr appendString:str];
                [mutstr appendString:@","];
            }
            [mutstr substringWithRange:NSMakeRange(0, mutstr.length-2)];
            
        } else{
            mutstr = [NSMutableString stringWithString:@""];
        }
        path = [NSIndexPath indexPathForRow:0 inSection:2];
        CommonTimeTableViewCell * moudelCell4 = [self.myTable cellForRowAtIndexPath:path];
        SencondCaoZuoState =moudelCell4.RightNameL.text?:@"";
        SencondCaoZuoState =[self backCaoZuoStateID:SencondCaoZuoState];
        path = [NSIndexPath indexPathForRow:1 inSection:2];
        CommonTimeTableViewCell * moudelCell5 = [self.myTable cellForRowAtIndexPath:path];
        SecondHourTime = moudelCell5.RightNameL.text?:@"";
        SecondHourTime = [self backHourStr:SecondHourTime];
        SecondMinuteTime = moudelCell5.RightNameL.text?:@"";
        SecondMinuteTime = [self backMinuteStr:SecondMinuteTime];
        
        if ([FirstHourTime isEqualToString:@""]||[FirstMinuteTime isEqualToString:@""]||[CaoZuoState isEqualToString:@""]||[SecondHourTime isEqualToString:@""]||[SecondMinuteTime isEqualToString:@""]||[SencondCaoZuoState isEqualToString:@""]) {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"" message:@"定时和执行操作需要设置" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
            
        }else{
            baseDic = @{
                        @"firstActionParams":[self dictionaryToJson:@{
                                                                      @"attrSet": @[
                                                                              @"Switch"
                                                                              ],
                                                                      @"Switch": @{
                                                                              @"value": CaoZuoState
                                                                              }
                                                                      }] ,
                        @"secondHour": SecondHourTime,
                        @"firstHour": FirstHourTime,
                        @"deviceUuid": DEVICEMoudleManger.listModel.uuid,
                        @"firstMinute": FirstMinuteTime,
                        @"secondMinute": SecondMinuteTime,
                        @"timeZone": @"GMT+8",
                        @"secondActionParams":[self dictionaryToJson:@{
                                                                       @"attrSet": @[
                                                                               @"Switch"
                                                                               ],
                                                                       @"Switch": @{
                                                                               @"value": SencondCaoZuoState
                                                                               }
                                                                       }] ,
                        @"week": mutstr
                        };
            NSDictionary *  dic = @{@"deviceUuid":DEVICEMoudleManger.listModel.uuid,@"id":self.model.id,@"jsonValues":[self dictionaryToJson:baseDic],@"state":@"",@"name":@"",@"sceneGroup":@""};
            WeakSelf
            [[NetworkTool sharedTool]requestWithURLparameters:dic method:@"mtop.openalink.case.template.case.update" View:self.view sessionExpiredOption:AKLoginOptionAutoLoginOnly needLogin:YES callBack:^(AlinkResponse *responseObject) {
                
                [weakSelf.navigationController popViewControllerAnimated:YES];
                NSLog(@"%@",responseObject);
            } errorBack:^(id error) {
                
            }];
        }
    }
   
}
#pragma mark -JSON字符串转化为字典
-(NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}
#pragma mark - 解析firstActionParams
-(NSString *)backAnalysisFirstActionParams:(NSString *)modelStr{
    NSDictionary * dic = [self dictionaryWithJsonString:modelStr];
    dic = [dic valueForKey:@"Switch"];
    NSString * str =[dic valueForKey:@"value"];
    if ([str isEqualToString:@"1"]) {
        str = @"关";
    }else{
         str = @"开";
    }
    return str;
}
#pragma mark - 解析secondActionParams
-(NSString *)backAnalysisSecondActionParams:(NSString *)modelStr{
    NSDictionary * dic = [self dictionaryWithJsonString:modelStr];
    dic = [dic valueForKey:@"Switch"];
    NSString * str =[dic valueForKey:@"value"];
    if ([str isEqualToString:@"1"]) {
        str = @"关";
    }else{
        str = @"开";
    }
    return str;
}

#pragma mark - 设置UI
/**
 设置UI
 */
-(void)setTheUI{
    self.myTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 69, SCREEN_WIDTH, SCREEN_HEIGHT-69-65) style:UITableViewStylePlain];
    [self.myTable registerNib:[UINib nibWithNibName:@"CommonTimeTableViewCell" bundle:nil] forCellReuseIdentifier:@"CommonTimeTableViewCell"];
    [self.view addSubview:self.myTable  ];
    self.myTable.backgroundColor = Gray_Color;
    self.myTable.delegate = self;
    self.myTable.dataSource = self;
    self.myTable.estimatedRowHeight = 50;
    self.myTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.btn = [UIButton buttonWithType:UIButtonTypeCustom];
    _btn.frame=CGRectMake(0, SCREEN_HEIGHT-100, SCREEN_WIDTH, 50);
    [_btn setTitle:@"删除定时" forState:UIControlStateNormal];
    _btn.backgroundColor= [UIColor whiteColor];
    [self.view addSubview:_btn];
    [_btn addTarget:self action:@selector(deleteTime) forControlEvents:UIControlEventTouchUpInside];
    [_btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
}
-(void)deleteTime{
    WeakSelf
    [[NetworkTool sharedTool]requestWithURLparameters:@{@"id":self.model.id,@"creator":self.model.creator,@"deviceUuid":self.model.jsonValues.deviceUuid} method:@"mtop.openalink.case.template.case.delete" View:self.view sessionExpiredOption:AKLoginOptionAutoLoginOnly needLogin:YES callBack:^(AlinkResponse *responseObject) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }errorBack:^(id error) {
        NSLog(@"%@",error);
    }];
}
-(void)leftBtn{
    [super leftBtn];
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 逻辑处理
- (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}
#pragma mark - tableview的代理方法实现
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.configueArr.count == 2) {
        if (section == 0) {
            return 1;
        }else{
            NSArray * arr = self.configueArr[1];
            return arr.count;
        }
    }else if(self.configueArr.count == 4){
        if (section == 0) {
            return 1;
        }else if(section ==1){
            NSArray * arr = self.configueArr[1];
            return arr.count;
            
        }else if(section ==2){
            NSArray * arr = self.configueArr[2];
            return arr.count;
        }else{
            NSArray * arr = self.configueArr[3];
            return arr.count;
        }
        
    }
    return 0;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CommonTimeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CommonTimeTableViewCell"];
    if (cell == nil) {
        cell = [[CommonTimeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CommonTimeTableViewCell"];
    }
    if (indexPath.section == 0&& indexPath.row == 0) {
        cell.accessoryType =UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (self.configueArr.count == 2) {
        if (indexPath.section == 0) {
            NSArray * arr = self.configueArr[0];
            NSDictionary *dic = arr[indexPath.row];
            cell.leftNameL.text = [dic valueForKey:@"SectionName"];
            cell.RightNameL.text = [dic valueForKey:@"Status"];
        }else{
            NSArray * arr = self.configueArr[1];
            NSDictionary *dic = arr[indexPath.row];
            cell.leftNameL.text = [dic valueForKey:@"SectionName"];
            if ([[dic valueForKey:@"Status"] isEqualToString:@""]) {
                if ([cell.leftNameL.text isEqualToString:@"重复设置"]) {
                    cell.RightNameL.text = @"仅一次";
                }else{
                    cell.RightNameL.text = @"";
                }
            }else{
                cell.RightNameL.text = [dic valueForKey:@"Status"];
            }
        }
    }else{
        if (indexPath.section == 0) {
            NSArray * arr = self.configueArr[0];
            NSDictionary *dic = arr[indexPath.row];
            cell.leftNameL.text = [dic valueForKey:@"SectionName"];
            cell.RightNameL.text = [dic valueForKey:@"Status"];
        }else if(indexPath.section == 1){
            NSArray * arr = self.configueArr[1];
            NSDictionary *dic = arr[indexPath.row];
            cell.leftNameL.text = [dic valueForKey:@"SectionName"];
            cell.RightNameL.text = [dic valueForKey:@"Status"];
        }else if(indexPath.section == 2){
            NSArray * arr = self.configueArr[2];
            NSDictionary *dic = arr[indexPath.row];
            cell.leftNameL.text = [dic valueForKey:@"SectionName"];
            cell.RightNameL.text = [dic valueForKey:@"Status"];
            
        }else{
            NSArray * arr = self.configueArr[3];
            NSDictionary *dic = arr[indexPath.row];
            cell.leftNameL.text = [dic valueForKey:@"SectionName"];
            if ([[dic valueForKey:@"Status"] isEqualToString:@""]) {
                cell.RightNameL.text = @"仅一次";
            }else{
                cell.RightNameL.text = [dic valueForKey:@"Status"];
            }
        }
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    CommonTimeTableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    WeakSelf
    if ([cell.leftNameL.text isEqualToString:@"执行操作"]) {
        SetTimeActionViewController * vc = [[SetTimeActionViewController alloc]init];
        vc.backblock = ^(NSString *content) {
            cell.RightNameL.text = content;
        };
        vc.WhoPushMe = @"MainTImeSelectedPushViewController";
        vc.Sign = indexPath.section;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }
    if ([cell.leftNameL.text isEqualToString:@"重复设置"]) {
        CycleSetTimeViewController *vc = [[CycleSetTimeViewController alloc]init];
        vc.backblock = ^(NSString *content) {
            if ([content isEqualToString:@""]) {
                cell.RightNameL.text = @"仅一次";
            }else
                cell.RightNameL.text = content;
        };
        vc.WhoPushMe = @"MainTImeSelectedPushViewController";
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }
    
    if ([cell.leftNameL.text isEqualToString:@"执行时间"]) {
        self.btn.userInteractionEnabled = NO;
        self.DatePickerView = [LXKDatePickerView makeViewWithMaskDatePicker:self.view.frame setTitle:@"" indexpath:indexPath];
        self.DatePickerView.delegate = self;
        
    }
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.configueArr.count;
}
/**
 backTheMoudelID 根据模块场景来返回对应的场景ID
 
 @param moudleID backTheMoudelID
 @return backTheMoudelID
 */
-(NSString*)backTheMoudelID:(NSString*)moudleID{
    
    if ([moudleID isEqualToString:@"开启"]) {
        return @"1000201";
    }
    if ([moudleID isEqualToString:@"关闭"]) {
        return @"1000202";
    }
    if ([moudleID isEqualToString:@"开启关闭"]) {
        return @"1000203";
    }
    return @"";
}

/**
 DescriptionbackCaoZuoStateID 根据操作返回对应的操作ID
 
 @param stateID backCaoZuoStateID
 @return backCaoZuoStateID
 */
-(NSString *)backCaoZuoStateID:(NSString *)stateID{
    if ([stateID isEqualToString:@"开"]) {
        return @"0";
    }else if([stateID isEqualToString:@"关"]){
        return @"1";
        
    }
    return @"";
}

/**
 backHourStr 根据时间字符串返回小时字符
 
 @param timeStr backHourStr
 @return backHourStr
 */
-(NSString*)backHourStr:(NSString *)timeStr{
    NSArray * arr = [timeStr componentsSeparatedByString:@":"];
    return arr.firstObject;
}

/**
 backMinuteStr 根据时间字符串返回分钟字符
 
 @param timeStr backMinuteStr
 @return backMinuteStr
 */
-(NSString*)backMinuteStr:(NSString *)timeStr{
    
    NSArray * arr = [timeStr componentsSeparatedByString:@":"];
    return arr.lastObject;
}
-(NSString *)backWeek:(NSString *)modelWeek{
    NSString * str1 = nil;
     NSMutableArray *arr1 = [[NSMutableArray   alloc]init];
     NSMutableString * mutstr = [[NSMutableString alloc]init];
    if (![modelWeek isEqualToString:@""]) {
        NSArray * arr = [modelWeek  componentsSeparatedByString:@","];
        for (NSString * str  in arr) {
            [arr1 addObject:[self SetTime:str]];
        }
        [arr1 removeLastObject];
        for (NSString * str  in arr1) {
            [mutstr appendString:str];
            [mutstr appendString:@","];
        }
       str1 = [mutstr  copy];
       str1 =[str1 substringToIndex:str1.length-1];
        return str1;
    } else{
        str1 = nil;
        return str1;
    }
    return nil;
}
-(NSString *)SetTime:(NSString *)time{
    if ([time isEqualToString:@""]) {
        return @"";
    }
    if ([time isEqualToString:@"2"]) {
        return @"周一";
    }
    if ([time isEqualToString:@"3"]) {
        return @"周二";
    }
    if ([time isEqualToString:@"4"]) {
        return @"周三";
    }
    if ([time isEqualToString:@"5"]) {
        return @"周四";
    }
    if ([time isEqualToString:@"6"]) {
        return @"周五";
    }
    if ([time isEqualToString:@"7"]) {
        return @"周六";
    }
    if ([time isEqualToString:@"1"]) {
        return @"周日";
    }
    return @"";
}
/**
 如果有循环则需要给值，如"2,3,4,5,6,7,1"表示从周一到周日每天运行；不传表示只在当天运行一次
 
 @param time 如果有循环则需要给值，如"2,3,4,5,6,7,1"表示从周一到周日每天运行；不传表示只在当天运行一次
 @return 如果有循环则需要给值，如"2,3,4,5,6,7,1"表示从周一到周日每天运行；不传表示只在当天运行一次
 */
-(NSString *)backCycelSetTime:(NSString *)time{
    if ([time isEqualToString:@""]) {
        return @"";
    }
    if ([time isEqualToString:@"周一"]) {
        return @"2";
    }
    if ([time isEqualToString:@"周二"]) {
        return @"3";
    }
    if ([time isEqualToString:@"周三"]) {
        return @"4";
    }
    if ([time isEqualToString:@"周四"]) {
        return @"5";
    }
    if ([time isEqualToString:@"周五"]) {
        return @"6";
    }
    if ([time isEqualToString:@"周六"]) {
        return @"7";
    }
    if ([time isEqualToString:@"周日"]) {
        return @"1";
    }
    return @"";
}
#pragma mark == 年月代理方法
-(void)getdatepickerForYearAndMonthChangeValues:(NSString *)values indexpath:(NSIndexPath *)indexpath
{
    CommonTimeTableViewCell * cell = nil;
    
    NSIndexPath * path = [NSIndexPath indexPathForRow:0 inSection:0];
    CommonTimeTableViewCell * cell1 = [self.myTable cellForRowAtIndexPath:path];
    if ([cell1.RightNameL.text isEqualToString:@"开启"]) {
        path = [NSIndexPath indexPathForRow:1 inSection:1];
        cell= [self.myTable cellForRowAtIndexPath:path];
        cell.RightNameL.text = values;
    }else if ([cell1.RightNameL.text isEqualToString:@"关闭"]){
        path = [NSIndexPath indexPathForRow:1 inSection:1];
        cell= [self.myTable cellForRowAtIndexPath:path];
        cell.RightNameL.text = values;
        
    }else{
        if (indexpath.row==1&&indexpath.section==2) {
            path = [NSIndexPath indexPathForRow:1 inSection:2];
            cell= [self.myTable cellForRowAtIndexPath:path];
            cell.RightNameL.text = values;
        }else{
            path = [NSIndexPath indexPathForRow:1 inSection:1];
            cell= [self.myTable cellForRowAtIndexPath:path];
            cell.RightNameL.text = values;
        }
        
    }
    self.btn.userInteractionEnabled = YES;
}
//section头部间距
- (CGFloat)tableView:(UITableView* )tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.configueArr.count ==4) {
        if (section ==1 ||section == 2) {
            return 35;
        }else{
            return 5;
        }
    }
    return 5;//section头部高度
}
//section头部视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.configueArr.count==4) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(5, 10, SCREEN_WIDTH-10, 15  )];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = [UIColor darkGrayColor];
        if (section == 1) {
            label.text = @"  操作一";
            return label;
        }else if(section == 2){
            label.text = @"  操作二";
            return label;
        }else{
            UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
            view.backgroundColor = [UIColor clearColor];
            return view;
        }
    }
    
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
    view.backgroundColor = [UIColor clearColor];
    return view ;
}
//section底部间距
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
//section底部视图
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView* view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //     UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    return 50;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
