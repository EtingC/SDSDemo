//
//  SetTimeActionViewController.m
//  AlinkDemo
//
//  Created by gubeidianzi on 2017/11/14.
//  Copyright © 2017年 aliyun. All rights reserved.
//

#import "SetTimeActionViewController.h"
#import "AliJSBackModel.h"
#import "ControllSetTableViewCell.h"
#import "value_range1Model.h"
#import "value_range2Model.h"
#import "CommonTimeTableViewCell.h"

@interface SetTimeActionViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation SetTimeActionViewController

- (void)viewDidLoad {
    self.title = @"执行操作";
    [super viewDidLoad];
    [self setTheUI];
    [self setTheConfigue];
    // Do any additional setup after loading the view.
}
-(void)setTheConfigue{
    
    for (AliJSBackModel *mode in [JsCallBackModelManager sharedManager].model.params_ali) {
        
        if (![mode.act isEqualToString:@"1"]) {
             [self.dataSource addObject:mode];
         }
       
    }
      [self.myTable   reloadData];
    
}
-(void)setTheUI{
    self.myTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    [self.view addSubview:self.myTable];
    self.myTable.separatorStyle = UITableViewCellSeparatorStyleNone;
     [self.myTable registerNib:[UINib nibWithNibName:@"ControllSetTableViewCell" bundle:nil] forCellReuseIdentifier:@"ControllSetTableViewCell"];
     [self.myTable registerNib:[UINib nibWithNibName:@"CommonTimeTableViewCell" bundle:nil] forCellReuseIdentifier:@"CommonTimeTableViewCell"];
    self.myTable.backgroundColor = Gray_Color;
    self.myTable.delegate = self;
    self.myTable.dataSource = self;
}
#pragma mark - tableview的代理方法实现
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  
     AliJSBackModel *model = self.dataSource[section];
    if ([model.type isEqualToString:@"1"]) {
        NSArray * value1 = model.value_range1;
        
        return value1.count;
    }else{
       
        return 1;
        
    }
    return 0;
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSource.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ControllSetTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ControllSetTableViewCell"];
    if (cell == nil) {
        cell = [[ControllSetTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ControllSetTableViewCell"];
    }
  
     cell.selectionStyle = UITableViewCellSelectionStyleNone;
    AliJSBackModel *model = self.dataSource[indexPath.section];
    if ([model.type isEqualToString:@"1"]) {
        NSArray * value1 = model.value_range1;
        value_range1Model *valuemodel = value1[indexPath.row];
        cell.ActionL.text= valuemodel.name;
        
        WeakSelf;
        cell.callbackblock = ^(NSString *index,UIButton *btn) {
            NSArray *arr = [self.myTable indexPathsForVisibleRows];
            
            for (NSIndexPath *indexPath in arr){
                //根据索引，获取cell 然后就可以做你想做的事情啦
                ControllSetTableViewCell *cell = [weakSelf.myTable cellForRowAtIndexPath:indexPath];
                //我这里要隐藏cell 的图片
                [cell.ActionBnt setImage:[UIImage imageNamed:@"未选"] forState:UIControlStateNormal];
            }
            if ([self.WhoPushMe isEqualToString:@"MainTImeSelectedPushViewController"]) {
                  [btn setImage:[UIImage imageNamed:@"已选"] forState:UIControlStateNormal];
                   weakSelf.backblock(index);
            }else{
                [btn setImage:[UIImage imageNamed:@"已选"] forState:UIControlStateNormal];
                if (weakSelf.Sign == 1) {
                    [[NSUserDefaults standardUserDefaults]setObject:index forKey:@"ZHIXINGCAOZUO"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }else{
                    [[NSUserDefaults standardUserDefaults]setObject:index forKey:@"CLOSEZHIXINGCAOZUO"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
                weakSelf.backblock(index);
            }
        };
        
            if (self.Sign == 1) {
                NSString * str = [[NSUserDefaults standardUserDefaults]objectForKey:@"ZHIXINGCAOZUO"]?:@"";
                if ([cell.ActionL.text isEqualToString:str]) {
                    [cell.ActionBnt setImage:[UIImage imageNamed:@"已选"] forState:UIControlStateNormal];
                }else{
                    [cell.ActionBnt setImage:[UIImage imageNamed:@"未选"] forState:UIControlStateNormal];
                    
                }
            }else{
                NSString * str = [[NSUserDefaults standardUserDefaults]objectForKey:@"CLOSEZHIXINGCAOZUO"]?:@"";
                if ([cell.ActionL.text isEqualToString:str]) {
                    [cell.ActionBnt setImage:[UIImage imageNamed:@"已选"] forState:UIControlStateNormal];
                }else{
                    [cell.ActionBnt setImage:[UIImage imageNamed:@"未选"] forState:UIControlStateNormal];
                    
                }
                
            }
             return cell;
        } else  if ([model.type isEqualToString:@"2"]){
            value_range2Model *mode = model.value_range2;
            CommonTimeTableViewCell * cell1 = [tableView dequeueReusableCellWithIdentifier:@"CommonTimeTableViewCell"];
            if (cell1 == nil) {
                cell1 = [[CommonTimeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CommonTimeTableViewCell"];
            }
    
            return cell1;
        }
    return nil;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
//section头部间距
- (CGFloat)tableView:(UITableView* )tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 25;//section头部高度
}
//section头部视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *view=[[UILabel alloc] initWithFrame:CGRectMake(5, 5, 320, 10)];
    AliJSBackModel *model =self.dataSource[section];
    view.text =[NSString stringWithFormat:@"  %@",model.name];
    view.font = [UIFont systemFontOfSize:14];
    view.textColor = [UIColor darkGrayColor];
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
