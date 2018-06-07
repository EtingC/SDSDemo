//
//  TimeManagerViewController.m
//  AlinkDemo
//
//  Created by gubeidianzi on 2017/11/13.
//  Copyright © 2017年 aliyun. All rights reserved.
//

#import "TimeManagerViewController.h"
#import "TimeManagerTableViewCell.h"
#import "AddTimeViewController.h"
#import "SetTimeModel.h"
#import "SetTimeSceneList.h"
#import "SelectedsArr.h"
#import "MainTImeSelectedPushViewController.h"
#import "NoTimeView.h"

#define MyDataArr [self.dataArr mutableArrayValueForKeyPath:@"DataSourceArr"]
@interface TimeManagerViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) SelectedsArr * dataArr;
@property (nonatomic,strong) UIButton * addTimeBtn;
@property (nonatomic,strong) NoTimeView * noTimeV;

@end

@implementation TimeManagerViewController
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self setTheUI];
    [self getData];
    
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.dataArr.DataSourceArr removeAllObjects];
    self.dataArr.succssed = nil;
}
-(void)dealloc{
    [self.dataArr removeObserver:self forKeyPath:@"DataSourceArr"];
     [self.dataArr removeObserver:self forKeyPath:@"succssed"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"定时";
    self.dataArr = [[SelectedsArr alloc]init];
    [self.dataArr addObserver:self forKeyPath:@"succssed" options:NSKeyValueObservingOptionNew context:nil];
    [self.dataArr addObserver:self forKeyPath:@"DataSourceArr" options:NSKeyValueObservingOptionNew context:nil];
    self.navigationItem.leftBarButtonItem.title = @"";
    // Do any additional setup after loading the view.
}
/**
 *  3.重写监听方法
 */
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
   
        
    if ([keyPath isEqualToString:@"succssed"]) {
        if ([self.dataArr.succssed isEqualToString: @"YES"]) {
            if (self.dataArr.DataSourceArr.count <1) {
                self.addTimeBtn.hidden = YES;
                self.noTimeV.hidden = NO;
            }else{
                
                self.addTimeBtn.hidden = NO;
                self.noTimeV.hidden = YES;
              }
         }else{
             self.addTimeBtn.hidden = YES;
             self.noTimeV.hidden = YES;
            
        }
     }
    
        NSLog(@"-----------------------------------------------%ld",self.dataArr.DataSourceArr.count);
  
}

-(void)getData{
    WeakSelf
    [[NetworkTool    sharedTool ]requestWithURLparameters:@{@"deviceUuid":DEVICEMoudleManger.listModel.uuid} method:@"mtop.openalink.case.template.case.query" View:self.view sessionExpiredOption:AKLoginOptionAutoLoginOnly needLogin:YES callBack:^(AlinkResponse *responseObject) {
        NSDictionary *dic =responseObject.dataObject;
        NSArray * arr = [dic  valueForKey:@"sceneList"];
        arr = [SetTimeSceneList mj_objectArrayWithKeyValuesArray:arr    ];
        //SetTimeModel * mode = [SetTimeModel mj_objectWithKeyValues:dic];
        for (SetTimeSceneList *scenelistModel in arr) {
             [[weakSelf.dataArr mutableArrayValueForKeyPath:@"DataSourceArr"] addObject:scenelistModel];
            //[weakSelf.dataSource addObject:scenelistModel];
        }
        weakSelf.dataArr.succssed= @"YES";
        [weakSelf.myTable reloadData];
    } errorBack:^(id error) {
        weakSelf.dataArr.succssed= @"NO";
    }];
}
-(void)setTheUI{
    
    self.myTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 72, SCREEN_WIDTH, SCREEN_HEIGHT-72) style:UITableViewStylePlain];
    self.myTable.backgroundColor = Gray_Color;
    self.myTable.delegate = self;
    self.myTable.dataSource= self;
    
    [self.myTable registerNib:[UINib nibWithNibName:@"TimeManagerTableViewCell" bundle:nil] forCellReuseIdentifier:@"TimeManagerTableViewCell"];
    [self.view addSubview:self.myTable];
    self.myTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.addTimeBtn = [UIButton  buttonWithType:UIButtonTypeCustom];
    self.addTimeBtn.frame =CGRectMake(0, SCREEN_HEIGHT-60, SCREEN_WIDTH, 60);
    self.addTimeBtn.backgroundColor = [UIColor whiteColor];
    [self.addTimeBtn setImage:[UIImage imageNamed:@"添加定时2"] forState:UIControlStateNormal];
    [self.addTimeBtn setTitle:@"添加定时" forState:UIControlStateNormal];
    [self.addTimeBtn setTitleColor:RGB(251, 150, 9) forState:UIControlStateNormal];
    [self.addTimeBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    self.addTimeBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 25, 0, 25);
    [self.addTimeBtn addTarget:self action:@selector(addTime) forControlEvents:UIControlEventTouchUpInside];
    self.addTimeBtn.hidden = YES;
    [self.view addSubview:self.addTimeBtn];
    
    self.noTimeV = [[NoTimeView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-252)/2, SCREEN_HEIGHT/4, 252, 275)];
    [self.view addSubview:self.noTimeV];
    self.noTimeV.backgroundColor = Gray_Color;
    [self.noTimeV.AddtimeBnt addTarget:self action:@selector(addTime) forControlEvents:UIControlEventTouchUpInside];
    self.noTimeV.hidden =NO;
}
#pragma mark - tableview的代理方法实现
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return self.dataArr.DataSourceArr.count;
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    TimeManagerTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TimeManagerTableViewCell"];
    if (cell == nil) {
        cell = [[TimeManagerTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TimeManagerTableViewCell"];
    }
    [cell setTheData:self.dataArr.DataSourceArr[indexPath.row]];
    cell.vackvalue = ^(UISwitch *timeSwitchBtn, SetTimeSceneList *model) {
        NSDictionary *baseDic = nil;
        NSDictionary *  dic = nil;
        NSString * stateStr = nil;
        NSString * raleStr = nil;
        BOOL value = timeSwitchBtn.isOn;
        if (value == YES) {
            stateStr = @"1";
            raleStr = @"0";
        }else{
            stateStr = @"0";
            raleStr = @"1";
        }
        WeakSelf
        if ([model.templateId isEqualToString:@"1000203"]) {
            baseDic = @{
                        @"firstActionParams":model.jsonValues.firstActionParams ,
                        @"secondHour": model.jsonValues.secondHour,
                        @"firstHour": model.jsonValues.firstHour,
                        @"deviceUuid": DEVICEMoudleManger.listModel.uuid,
                        @"firstMinute": model.jsonValues.firstMinute,
                        @"secondMinute": model.jsonValues.secondMinute,
                        @"timeZone": model.jsonValues.timeZone,
                        @"secondActionParams":model.jsonValues.secondActionParams,
                        @"week": model.jsonValues.week
                        };
            dic = @{@"deviceUuid":DEVICEMoudleManger.listModel.uuid,@"id":model.id,@"jsonValues":[weakSelf dictionaryToJson:baseDic],@"state":raleStr,@"name":@"",@"sceneGroup":@""};
            
            [[NetworkTool sharedTool]requestWithURLparameters:dic method:@"mtop.openalink.case.template.case.update" View:self.view sessionExpiredOption:AKLoginOptionAutoLoginOnly needLogin:YES callBack:^(AlinkResponse *responseObject) {
                if (responseObject.successed == YES) {
                     timeSwitchBtn.on = value;
                }
                NSLog(@"%@",responseObject);
            } errorBack:^(id error) {
                     timeSwitchBtn.on = !value;
            }];
        }
        if ([model.templateId isEqualToString:@"1000201"]) {
            baseDic = @{@"firstActionParams":model.jsonValues.firstActionParams ,@"deviceUuid":DEVICEMoudleManger.listModel.uuid,@"minute":model.jsonValues.minute,@"hour":model.jsonValues.hour,@"week":model.jsonValues.week,@"timeZone":model.jsonValues.timeZone};
            dic = @{@"deviceUuid":DEVICEMoudleManger.listModel.uuid,@"id":model.id,@"jsonValues":[weakSelf dictionaryToJson:baseDic],@"state":stateStr,@"name":@"",@"sceneGroup":@""};
            
            [[NetworkTool sharedTool]requestWithURLparameters:dic method:@"mtop.openalink.case.template.case.update" View:[DeviceInfoManager getCurrentVC].view sessionExpiredOption:AKLoginOptionAutoLoginOnly needLogin:YES callBack:^(AlinkResponse *responseObject) {
                if (responseObject.successed == YES) {
                    timeSwitchBtn.on = value;
                }
                NSLog(@"%@",responseObject);
            } errorBack:^(id error) {
               timeSwitchBtn.on = !value;
            }];
        }
        if ([model.templateId isEqualToString:@"1000202"]) {
            baseDic = @{@"firstActionParams":model.jsonValues.firstActionParams ,@"deviceUuid":DEVICEMoudleManger.listModel.uuid,@"minute":model.jsonValues.minute,@"hour":model.jsonValues.hour,@"week":model.jsonValues.week,@"timeZone":model.jsonValues.timeZone};
            dic = @{@"deviceUuid":DEVICEMoudleManger.listModel.uuid,@"id":model.id,@"jsonValues":[weakSelf dictionaryToJson:baseDic],@"state":stateStr,@"name":@"",@"sceneGroup":@""};
            
            [[NetworkTool sharedTool]requestWithURLparameters:dic method:@"mtop.openalink.case.template.case.update" View:[DeviceInfoManager getCurrentVC].view sessionExpiredOption:AKLoginOptionAutoLoginOnly needLogin:YES callBack:^(AlinkResponse *responseObject) {
                if (responseObject.successed == YES) {
                    timeSwitchBtn.on = value;
                }
                NSLog(@"%@",responseObject);
            } errorBack:^(id error) {
                timeSwitchBtn.on = !value;
            }];
        }
        
        
    };
    
    return cell;
}
- (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //     UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    return 100;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    MainTImeSelectedPushViewController    *vc = [[MainTImeSelectedPushViewController alloc]init];
    vc.model = MyDataArr[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    WeakSelf
    SetTimeSceneList *model = MyDataArr[indexPath.row];
    [[NetworkTool sharedTool]requestWithURLparameters:@{@"id":model.id,@"creator":model.creator,@"deviceUuid":model.jsonValues.deviceUuid} method:@"mtop.openalink.case.template.case.delete" View:self.view sessionExpiredOption:AKLoginOptionAutoLoginOnly needLogin:YES callBack:^(AlinkResponse *responseObject) {
        // 删除模型
        [[weakSelf.dataArr mutableArrayValueForKeyPath:@"DataSourceArr"] removeObjectAtIndex:indexPath.row];
        // 刷新
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        [weakSelf.myTable reloadData];
        weakSelf.dataArr.succssed = @"YES";
        
    } errorBack:^(id error) {
         weakSelf.dataArr.succssed = @"NO";
    }];
}

/**
 *  修改Delete按钮文字为“删除”
 */
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

//#pragma mark - DZNEmptyDataSetSource ——实现该协议
//- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
//    return [UIImage imageNamed:@"定时为空"];
//}
//- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
//    NSString *title = @"还没有添加定时";
//    NSDictionary *attributes = @{
//                                 NSFontAttributeName:[UIFont boldSystemFontOfSize:20.0f],
//                                 NSForegroundColorAttributeName:RGB(217, 217, 217)
//                                 };
//    return [[NSAttributedString alloc] initWithString:title attributes:attributes];
//}
//- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
//    // 设置按钮标题
//    NSString *buttonTitle = @"添加定时";
//    NSDictionary *attributes = @{
//                                 NSFontAttributeName:[UIFont boldSystemFontOfSize:19.0f],NSForegroundColorAttributeName:[UIColor whiteColor]
//                                 };
//    return [[NSAttributedString alloc] initWithString:buttonTitle attributes:attributes];
//}
//- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
//    return -64.0;
//}
//- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView{
//
//    return 30;
//}
//- (UIImage *)buttonBackgroundImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state{
//    return  [UIImage imageNamed:@"添加定时"];
//
//}
//- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView {
//    UIColor *appleGreenColor = Gray_Color;
//    return appleGreenColor;
//}
///**
// *  自定义视图 （关键方法，可以做一些自定义占位视图）
// */
////- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView {
////    UIView * view = [UIView alloc]initWithFrame:CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)
////
////}
//- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button {
//    [self addTime];
//}
-(void)addTime{
    AddTimeViewController * vc = [[AddTimeViewController alloc]init];
    [self.navigationController  pushViewController:vc animated:YES  ];
    
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
