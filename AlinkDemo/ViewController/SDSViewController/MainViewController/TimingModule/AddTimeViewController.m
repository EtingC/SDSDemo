//
//  AddTimeViewController.m
//  AlinkDemo
//
//  Created by gubeidianzi on 2017/11/13.
//  Copyright © 2017年 aliyun. All rights reserved.
//

#import "AddTimeViewController.h"
#import "CommonTimeTableViewCell.h"
#import "JSCallBackDeviceModel.h"
#import "AliJSBackModel.h"
#import "SetTimeActionViewController.h"
#import "LXKDatePickerView.h"
#import "CycleSetTimeViewController.h"

@interface AddTimeViewController ()<UITableViewDelegate,UITableViewDataSource,LXKDatePickerViewDelegate,UIGestureRecognizerDelegate >
@property (nonatomic,strong)NSMutableArray * configueArr;
@property(nonatomic,strong)LXKDatePickerView * DatePickerView;
@property (nonatomic,copy) NSString * cycleTimeStr;
@property (nonatomic,strong) UIButton * btn;

@end

@implementation AddTimeViewController
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];

}
- (void)viewDidLoad {
    self.configueArr = [[NSMutableArray alloc]init];
    self.title = @"定时设置";
    [super viewDidLoad];
    [self setTheUI];
    [self setTheConfigue:@"开启"];
    self.navigationItem.leftBarButtonItem = [self setNavLeftRightFrame:self.navigationController imageName:@"Back Chevron" selector:@"leftBtn"];
    self.navigationItem.leftBarButtonItem.target =self;
    self.navigationItem.leftBarButtonItem.style = UIBarButtonItemStylePlain;
    // Do any additional setup after loading the view.
}
-(void)leftBtn{
     [super leftBtn];
     [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"CHONGFUSHEZHI"];
     [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ZHIXINGCAOZUO"];
     [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ZHIXINGSHIJING"];
     [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"CLOSEZHIXINGSHIJING"];
     [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"CLOSEZHIXINGCAOZUO"];
     [[NSUserDefaults standardUserDefaults] synchronize];
     [self.navigationController popViewControllerAnimated:YES];
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
                                    @"Status":[[NSUserDefaults standardUserDefaults]objectForKey:@"ZHIXINGCAOZUO"]?:@""
                                   
                                   },
                                  @{
                                      @"SectionName":@"执行时间",
                                      @"Status":[[NSUserDefaults standardUserDefaults]objectForKey:@"ZHIXINGSHIJING"]?:@""
                                      
                                      },
                                  @{
                                      @"SectionName":@"重复设置",
                                      @"Status": [[NSUserDefaults standardUserDefaults]objectForKey:@"CHONGFUSHEZHI"]?: @""
                                      
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
                                           @"Status":[[NSUserDefaults standardUserDefaults]objectForKey:@"ZHIXINGCAOZUO"]?:@""
                                           
                                           },
                                       @{
                                           @"SectionName":@"执行时间",
                                           @"Status":[[NSUserDefaults standardUserDefaults]objectForKey:@"ZHIXINGSHIJING"]?:@""
                                           
                                           },
                                       @{
                                           @"SectionName":@"重复设置",
                                           @"Status": [[NSUserDefaults standardUserDefaults]objectForKey:@"CHONGFUSHEZHI"]?: @""
                                           
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
                                            @"Status":[[NSUserDefaults standardUserDefaults]objectForKey:@"ZHIXINGCAOZUO"]?:@""
                                            
                                            },
                                        @{
                                            @"SectionName":@"执行时间",
                                            @"Status":[[NSUserDefaults standardUserDefaults]objectForKey:@"ZHIXINGSHIJING"]?:@""
                                            
                                            }
                                        ],
                                         /*3*/ @[@{
                                                 @"SectionName":@"执行操作",
                                                 @"Status":[[NSUserDefaults standardUserDefaults]objectForKey:@"CLOSEZHIXINGCAOZUO"]?:@""
                                                     
                                                     },
                                            @{
                                            @"SectionName":@"执行时间",
                                            @"Status":[[NSUserDefaults standardUserDefaults]objectForKey:@"CLOSEZHIXINGSHIJING"]?:@""
                                            
                                            }
                                        ],
                                       /*4*/@[
                                             @{
                                                 @"SectionName":@"重复设置",
                                                 @"Status":[[NSUserDefaults standardUserDefaults]objectForKey:@"CHONGFUSHEZHI"]?:@""
                                                 
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
-(void)setTheUI{
    self.myTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 69, SCREEN_WIDTH, SCREEN_HEIGHT-69-65) style:UITableViewStylePlain];
    [self.myTable registerNib:[UINib nibWithNibName:@"CommonTimeTableViewCell" bundle:nil] forCellReuseIdentifier:@"CommonTimeTableViewCell"];
    [self.view addSubview:self.myTable];
    self.myTable.backgroundColor = Gray_Color;
    self.myTable.delegate = self;
    self.myTable.dataSource = self;
    self.myTable.estimatedRowHeight = 50;
    self.myTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    _btn  = [UIButton buttonWithType:UIButtonTypeCustom];
    _btn.frame = CGRectMake(0 , CGRectGetMaxY(self.myTable.frame), SCREEN_WIDTH, 65);
    _btn.backgroundColor = [UIColor orangeColor];
    [_btn setTitle:@"保存" forState:UIControlStateNormal];
    [_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btn addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btn];
    
    
}
- (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}
-(void)save{
    NSIndexPath * index = [NSIndexPath indexPathForRow:0 inSection:0];
    CommonTimeTableViewCell * cell = [self.myTable cellForRowAtIndexPath:index];
    NSString * moudleid = cell.RightNameL.text;
    NSString *TheMoudelID = [self backTheMoudelID:moudleid];
    NSString *FirstHourTime = [[NSUserDefaults standardUserDefaults]valueForKey:@"ZHIXINGSHIJING"]?:@"";
    FirstHourTime = [self backHourStr:FirstHourTime];
    NSString *FirstMinuteTime = [[NSUserDefaults standardUserDefaults]objectForKey:@"ZHIXINGSHIJING"]?:@"";
    FirstMinuteTime =[self backMinuteStr:FirstMinuteTime];
    
    NSString *SecondHourTime = [[NSUserDefaults standardUserDefaults]objectForKey:@"CLOSEZHIXINGSHIJING"]?:@"";
    SecondHourTime = [self backHourStr:SecondHourTime];
    NSString *SecondMinuteTime = [[NSUserDefaults standardUserDefaults]objectForKey:@"CLOSEZHIXINGSHIJING"]?:@"";
    SecondMinuteTime = [self backMinuteStr:SecondMinuteTime];
    
    NSString *CaoZuoState = [[NSUserDefaults standardUserDefaults]objectForKey:@"ZHIXINGCAOZUO"]?:@"";
    CaoZuoState = [self backCaoZuoStateID:CaoZuoState];
    NSString * SencondCaoZuoState =[[NSUserDefaults standardUserDefaults]objectForKey:@"CLOSEZHIXINGCAOZUO"]?:@"";
    SencondCaoZuoState =[self backCaoZuoStateID:SencondCaoZuoState];
    
    NSString * Actionstr = nil;
    Actionstr = [[NSUserDefaults standardUserDefaults]objectForKey:@"CHONGFUSHEZHI"]?:@"";
    NSMutableArray *arr1 = [[NSMutableArray   alloc]init];
    NSMutableString * mutstr = [[NSMutableString alloc]init];
    if (![Actionstr isEqualToString:@""]) {
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
    
    NSDictionary * baseDic = nil;
    if ([TheMoudelID isEqualToString:@"1000201"]) {//开
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
            NSDictionary *  dic = @{@"deviceUuid":DEVICEMoudleManger.listModel.uuid,@"templateId":TheMoudelID,@"jsonValues":[self dictionaryToJson:baseDic],@"state":@"",@"name":@"",@"sceneGroup":@""};
            WeakSelf
            [[NetworkTool sharedTool]requestWithURLparameters:dic method:@"mtop.openalink.case.template.case.add" View:self.view sessionExpiredOption:AKLoginOptionAutoLoginOnly needLogin:YES callBack:^(AlinkResponse *responseObject) {
                
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"CHONGFUSHEZHI"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ZHIXINGCAOZUO"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ZHIXINGSHIJING"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"CLOSEZHIXINGSHIJING"];
                 [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"CLOSEZHIXINGCAOZUO"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [weakSelf.navigationController popViewControllerAnimated:YES];
                NSLog(@"%@",responseObject);
            } errorBack:^(id error) {
                
            }];
        }
    }
    if ([TheMoudelID isEqualToString:@"1000202"]) {//关
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
        NSDictionary *  dic = @{@"deviceUuid":DEVICEMoudleManger.listModel.uuid,@"templateId":TheMoudelID,@"jsonValues":[self dictionaryToJson:baseDic],@"state":@"",@"name":@"",@"sceneGroup":@""};
        WeakSelf
        [[NetworkTool sharedTool]requestWithURLparameters:dic method:@"mtop.openalink.case.template.case.add" View:self.view sessionExpiredOption:AKLoginOptionAutoLoginOnly needLogin:YES callBack:^(AlinkResponse *responseObject) {
            
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"CHONGFUSHEZHI"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ZHIXINGCAOZUO"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ZHIXINGSHIJING"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"CLOSEZHIXINGCAOZUO"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"CLOSEZHIXINGSHIJING"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [weakSelf.navigationController popViewControllerAnimated:YES];
            NSLog(@"%@",responseObject);
        } errorBack:^(id error) {
            
        }];
        }
    }
    if ([TheMoudelID isEqualToString:@"1000203"]) {//开 关
        if ([FirstHourTime isEqualToString:@""]||[FirstMinuteTime isEqualToString:@""]||[CaoZuoState isEqualToString:@""]||[SecondHourTime isEqualToString:@""]||[SecondMinuteTime isEqualToString:@""]) {
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
        NSDictionary *  dic = @{@"deviceUuid":DEVICEMoudleManger.listModel.uuid,@"templateId":TheMoudelID,@"jsonValues":[self dictionaryToJson:baseDic],@"state":@"",@"name":@"",@"sceneGroup":@""};
        WeakSelf
        [[NetworkTool sharedTool]requestWithURLparameters:dic method:@"mtop.openalink.case.template.case.add" View:self.view sessionExpiredOption:AKLoginOptionAutoLoginOnly needLogin:YES callBack:^(AlinkResponse *responseObject) {
            
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"CHONGFUSHEZHI"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ZHIXINGCAOZUO"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ZHIXINGSHIJING"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"CLOSEZHIXINGSHIJING"];
             [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"CLOSEZHIXINGCAOZUO"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [weakSelf.navigationController popViewControllerAnimated:YES];
            NSLog(@"%@",responseObject);
        } errorBack:^(id error) {
            
        }];
        }
    }
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
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.configueArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CommonTimeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CommonTimeTableViewCell"];
    if (cell == nil) {
        cell = [[CommonTimeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CommonTimeTableViewCell"];
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
    if (indexPath.section == 0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil   message:nil preferredStyle: UIAlertControllerStyleActionSheet];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *OPENAction = [UIAlertAction actionWithTitle:@"开启" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self setTheConfigue:@"开启"];
           
        }];
        UIAlertAction *CLOSEAction = [UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self setTheConfigue:@"关闭"];
            
        }];
        
        UIAlertAction *openCLOSEAction =[UIAlertAction actionWithTitle:@"开启关闭" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self setTheConfigue:@"开启关闭"];
            
        }];
            [cancelAction setValue:[UIColor orangeColor] forKey:@"_titleTextColor"];
            [OPENAction setValue:[UIColor blackColor] forKey:@"_titleTextColor"];
            [CLOSEAction setValue:[UIColor blackColor] forKey:@"_titleTextColor"];
            [openCLOSEAction setValue:[UIColor blackColor] forKey:@"_titleTextColor"];
   
        [alertController addAction:cancelAction];
        [alertController addAction:OPENAction];
        [alertController addAction:CLOSEAction];
        [alertController addAction:openCLOSEAction];
        //修改按钮
        
      [self presentViewController:alertController animated:YES completion:nil];
    }
    
    CommonTimeTableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        WeakSelf
    if ([cell.leftNameL.text isEqualToString:@"执行操作"]) {
        SetTimeActionViewController * vc = [[SetTimeActionViewController alloc]init];
        vc.backblock = ^(NSString *content) {
            cell.RightNameL.text = content;
        };
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
        
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }
   
        if ([cell.leftNameL.text isEqualToString:@"执行时间"]) {
            self.btn.userInteractionEnabled = NO;
            self.DatePickerView = [LXKDatePickerView makeViewWithMaskDatePicker:self.view.frame setTitle:@"" indexpath:indexPath];
            self.DatePickerView.delegate = self;
    
    }
  
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
        [[NSUserDefaults standardUserDefaults]setObject:values forKey:@"ZHIXINGSHIJING"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSLog(@"-------------------------%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"ZHIXINGSHIJING"]);
        
    }else if ([cell1.RightNameL.text isEqualToString:@"关闭"]){
        path = [NSIndexPath indexPathForRow:1 inSection:1];
        cell= [self.myTable cellForRowAtIndexPath:path];
        cell.RightNameL.text = values;
          [[NSUserDefaults standardUserDefaults]setObject:values forKey:@"ZHIXINGSHIJING"];
         [[NSUserDefaults standardUserDefaults] synchronize];
    }else{
        
        if (indexpath.row==1&&indexpath.section==2) {
            path = [NSIndexPath indexPathForRow:1 inSection:2];
            cell= [self.myTable cellForRowAtIndexPath:path];
            cell.RightNameL.text = values;
            [[NSUserDefaults standardUserDefaults]setObject:values forKey:@"CLOSEZHIXINGSHIJING"];
            [[NSUserDefaults standardUserDefaults] synchronize];
           
        }else{
            path = [NSIndexPath indexPathForRow:1 inSection:1];
            cell= [self.myTable cellForRowAtIndexPath:path];
            cell.RightNameL.text = values;
              [[NSUserDefaults standardUserDefaults]setObject:values forKey:@"ZHIXINGSHIJING"];
              [[NSUserDefaults standardUserDefaults] synchronize];
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
