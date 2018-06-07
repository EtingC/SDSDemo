//
//  MySelfViewController.m
//  AlinkDemo
//
//  Created by gubeidianzi on 2017/11/30.
//  Copyright © 2017年 aliyun. All rights reserved.
//

#import "MySelfViewController.h"
#import "myHeaderTableViewCell.h"
#import "MyTableViewCell.h"
#import "LiangBaLoginViewController.h"
#import "UserSetViewController.h"
#import "AboutViewController.h"
#import "VersionViewController.h"
#import "JibenSheZhiViewController.h"
@interface MySelfViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) NSArray *dataArr;
@end

@implementation MySelfViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    NSIndexPath * path = [NSIndexPath indexPathForRow:0 inSection:0];
    myHeaderTableViewCell * cell = [self.myTable  cellForRowAtIndexPath:path];
    [cell.headerIMG sd_setImageWithURL:[NSURL URLWithString:[DATACache valueForKey:@"ICONURL"]] placeholderImage:[UIImage imageNamed:@"默认头像"]];
    if ([DATACache valueForKey:@"NICKNAME"]) {
        cell.PhoneL.text = [DATACache valueForKey:@"NICKNAME"];
    }else{
        cell.PhoneL.text = @"";
    }
    
    NSArray *userIDarr = [[NSUserDefaults standardUserDefaults] objectForKey:@"thisIsUserID"];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [BLLetAccount getUserInfo:userIDarr completionHandler:^(BLGetUserInfoResult * _Nonnull result) { //通过userid-->获取用户的 nickname  userid  iconUrl
            if (result.error == 0){ ////通过userid-->获取用户的 nickname  userid  iconUrl -->成功
                NSArray * userInfo = result.info;
                BLUserInfo * userIf = userInfo.firstObject;
                [[NSUserDefaults standardUserDefaults]setObject:userIf.nickname forKey:NICKNAME];
                [[NSUserDefaults standardUserDefaults]setObject:userIf.userid forKey:ACCOUNT];
                [[NSUserDefaults standardUserDefaults]setObject:userIf.iconUrl forKey:ICONURL];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.myTable reloadData];
            });
        }];
    });
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated ];
    
}
- (void)viewDidLoad {
     [super viewDidLoad];
    
     self.navigationItem.title = NSLocalizedString(@"我的", nil) ;
     self.view.backgroundColor=[CommonUtil getColor:@"#F3F3F3"];
      self.navigationController.navigationBar.translucent = NO;
 
    [self MakeTheUI];
    
    // Do any additional setup after loading the view.
}
-(void)MakeTheUI{
    
    self.myTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    [self.myTable registerNib:[UINib nibWithNibName:@"myHeaderTableViewCell" bundle:nil] forCellReuseIdentifier:@"myHeaderTableViewCell"];
    [self.myTable registerNib:[UINib nibWithNibName:@"MyTableViewCell" bundle:nil] forCellReuseIdentifier:@"MyTableViewCell"];
    self.myTable.delegate = self;
    self.myTable.dataSource = self;
    self.myTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.myTable];
}
#pragma mark - tableview的代理方法实现
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        return 1;
    }
    return 3;/*self.dataSource.count*/;
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        myHeaderTableViewCell * cell1 = [tableView dequeueReusableCellWithIdentifier:@"myHeaderTableViewCell"];
        if (cell1 == nil) {
            cell1 = [[myHeaderTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"myHeaderTableViewCell"];
        }
        [cell1.headerIMG sd_setImageWithURL:[NSURL URLWithString:[DATACache valueForKey:@"ICONURL"]] placeholderImage:[UIImage imageNamed:@"头像默认图"]];
        if ([DATACache valueForKey:@"NICKNAME"]) {
            if (iPhone4||iPhone5) {
                cell1.PhoneL.font = [UIFont systemFontOfSize:14];
            }
             cell1.PhoneL.text = [DATACache valueForKey:@"NICKNAME"];
        }else{
            cell1.PhoneL.text = @"";
        }
       
        return cell1;
        
    }else{
        
        MyTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MyTableViewCell"];
        if (cell == nil) {
            cell = [[MyTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyTableViewCell"];
        }
        self.dataArr = @[
                         @{
                             @"IMG":@"版本升级",
                             @"Name":NSLocalizedString( @"版本升级", nil)
                             },
                         @{

                             @"IMG":@"帮助",
                             @"Name":NSLocalizedString( @"关于晾霸", nil)
                             },
                         @{
                             
                             @"IMG":@"设置",
                             @"Name":NSLocalizedString(@"账号设置", nil)
                             }
                         
                         ];
        NSDictionary *dic = self.dataArr[indexPath.row];
        cell.LogoIMG.image = [UIImage imageNamed:[dic objectForKey:@"IMG"]];
        cell.NameL.text = [dic objectForKey:@"Name"];
        return cell;
    }
    
   
    return nil;
}
- (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0) {
        if (SCREEN_HEIGHT ==480) {
            return 120;
        }
        return 170;
    }
    return 50;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (indexPath.section ==1) {
        
        if (indexPath.row == 0) {
            VersionViewController * vc = [[VersionViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            
            
        }
        else if(indexPath.row == 1){
            AboutViewController *vc =[[AboutViewController alloc]init];
               [self.navigationController pushViewController:vc animated:YES];

        }
        else{
             UIStoryboard * strory = [UIStoryboard  storyboardWithName:@"LeftMenuViewController" bundle:[NSBundle mainBundle]];
            JibenSheZhiViewController *jibenvc = [strory instantiateViewControllerWithIdentifier:@"jiben"];
            [self.navigationController pushViewController:jibenvc animated:YES];
        }
    }
 
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 0) {
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
        view.backgroundColor = [CommonUtil getColor:@"#F3F3F3"];
        return view;
    }
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    view.backgroundColor = [UIColor whiteColor];
    return view;
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
