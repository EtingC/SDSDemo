//
//  CycleSetTimeViewController.m
//  AlinkDemo
//
//  Created by gubeidianzi on 2017/11/15.
//  Copyright © 2017年 aliyun. All rights reserved.
//

#import "CycleSetTimeViewController.h"
#import "ControllSetTableViewCell.h"
@interface CycleSetTimeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong ) NSMutableArray * contenArr;
@end

@implementation CycleSetTimeViewController
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if ([self.WhoPushMe isEqualToString:@"MainTImeSelectedPushViewController"]) {
        if (self.contenArr.count<1) {
            
        }else{
            NSMutableString * mutstr = [[NSMutableString alloc]init];
            for (NSString * str  in self.contenArr) {
                [mutstr appendString:str];
                [mutstr appendString:@","];
            }
            NSString *str1  = [mutstr substringWithRange:NSMakeRange(0, mutstr.length-1)];
            self.backblock(str1);
        }
        
    }else{
        if (self.contenArr.count<1) {
            
        }else{
            NSMutableString * mutstr = [[NSMutableString alloc]init];
            for (NSString * str  in self.contenArr) {
                [mutstr appendString:str];
                [mutstr appendString:@","];
            }
            NSString *str1  = [mutstr substringWithRange:NSMakeRange(0, mutstr.length-1)];
            [[NSUserDefaults standardUserDefaults]setObject:str1 forKey:@"CHONGFUSHEZHI"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            self.backblock(str1);
        }
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"重复设置";
    self.dataSource =[NSMutableArray arrayWithObjects:@"周一",@"周二",@"周三",@"周四",@"周五",@"周六",@"周日", nil];
    self.contenArr = [[NSMutableArray alloc]init];
    [self setTheUI];
    // Do any additional setup after loading the view.
}
-(void)setTheUI{
    self.myTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    [self.view addSubview:self.myTable];
    self.myTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.myTable registerNib:[UINib nibWithNibName:@"ControllSetTableViewCell" bundle:nil] forCellReuseIdentifier:@"ControllSetTableViewCell"];
    
    self.myTable.backgroundColor = Gray_Color;
    self.myTable.delegate = self;
    self.myTable.dataSource = self;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return self.dataSource.count;
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ControllSetTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ControllSetTableViewCell"];
    if (cell == nil) {
        cell = [[ControllSetTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ControllSetTableViewCell"];
    }
    [cell setTheData:self.dataSource[indexPath.row]];
    WeakSelf;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.callbackblock = ^(NSString *index,UIButton *btn) {
        if (btn.selected == YES) {
             [weakSelf.contenArr addObject:index];
            
        }else  if (btn.selected == NO){
            if (weakSelf.contenArr) {
                for (NSString * str  in self.contenArr) {
                    if ([str isEqualToString:index]) {
                        [weakSelf.contenArr removeObject:str];
                    }
                }
            }
        }
    };
//    NSArray * arr =  [self set];
//    for (NSString * str  in arr) {
//        if (indexPath.row == [str intValue]) {
//             [cell.ActionBnt setImage:[UIImage imageNamed:@"已选"] forState:UIControlStateNormal];
//        }
//    }
 

    return cell;
}
-(NSArray *)set{
     NSMutableArray * mutarr = [[NSMutableArray   alloc]init];
      NSString * str = [[NSUserDefaults standardUserDefaults]objectForKey:@"CHONGFUSHEZHI"];
      NSArray * arr= [str componentsSeparatedByString:@","];
    for (int i = 0; i <self.dataSource.count; i++) {
        for (int j = 0; j <arr.count; j++) {
            if ([self.dataSource[i] isEqualToString:arr[j]]) {
                if ([self.dataSource[i] isEqualToString:@"周一"]) {
                    [mutarr addObject:@"0"];
                }
                if ([self.dataSource[i] isEqualToString:@"周二"]) {
                    [mutarr addObject:@"1"];
                }
                if ([self.dataSource[i] isEqualToString:@"周三"]) {
                    [mutarr addObject:@"2"];
                }
                if ([self.dataSource[i] isEqualToString:@"周四"]) {
                    [mutarr addObject:@"3"];
                }
                if ([self.dataSource[i] isEqualToString:@"周五"]) {
                    [mutarr addObject:@"4"];
                }
                if ([self.dataSource[i] isEqualToString:@"周六"]) {
                    [mutarr addObject:@"5"];
                }
                if ([self.dataSource[i] isEqualToString:@"周日"]) {
                    [mutarr addObject:@"6"];
                }
            }
        }
    }
    NSArray * backArr = mutarr;
    
    return backArr;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //     UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    return 54.5;
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
