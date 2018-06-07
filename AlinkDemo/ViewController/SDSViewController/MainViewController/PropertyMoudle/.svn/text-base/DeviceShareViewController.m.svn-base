//
//  DeviceShareViewController.m
//  AlinkDemo
//
//  Created by gubeidianzi on 2017/11/23.
//  Copyright © 2017年 aliyun. All rights reserved.
//

#import "DeviceShareViewController.h"
#import "relAccountsModel.h"
#import "ShareTableViewCell.h"
#import "TwoCodeViewController.h"
@interface DeviceShareViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) UITableView * subTableV;//子设备tablevew
@end

@implementation DeviceShareViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.dataSource = [[NSMutableArray alloc]initWithArray:self.dataArr];
    UIBarButtonItem * barItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStyleDone target:self action:nil];
    UIBarButtonItem * barItem1 = [[UIBarButtonItem alloc]initWithTitle:@"分享" style:UIBarButtonItemStyleDone target:self action:@selector(share)];
    if ([self.shebeiDetailModel.managerFlag isEqualToString:@"0"]) {
          self.navigationItem.rightBarButtonItem = barItem1;
    }else{
          self.navigationItem.rightBarButtonItem = barItem;
    }
}

/**
 分享
 */
-(void)share{
    TwoCodeViewController * codev = [[TwoCodeViewController alloc]init];
    [self.navigationController pushViewController:codev animated:YES];
    
}
- (void)viewDidLoad {
    self.title = @"设备分享";
    [super viewDidLoad];
    [self setTheUI];
    // Do any additional setup after loading the view.
}
-(void)setTheUI{
  //是否是管理员，0：是，1：不是
        self.myTable = [[UITableView alloc]initWithFrame:CGRectMake(1, 68, SCREEN_WIDTH-2, 255) style:UITableViewStylePlain];
        self.myTable.delegate = self;
        self.myTable.dataSource = self;
        self.myTable.backgroundColor = Gray_Color;
        self.myTable.separatorStyle =UITableViewCellSeparatorStyleNone;
        [self.myTable registerNib:[UINib nibWithNibName:@"ShareTableViewCell" bundle:nil] forCellReuseIdentifier:@"ShareTableViewCell"];
        [self.view addSubview:self.myTable];

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataSource.count;
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
        ShareTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ShareTableViewCell"];
        if (cell == nil) {
            cell.backgroundColor = [UIColor whiteColor];
            cell = [[ShareTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ShareTableViewCell"];
            
        }
       if (self.dataArr) {
        relAccountsModel * model = self.dataSource[indexPath.row];
           cell.superPersonImage.hidden = YES;
           cell.superNameL.text = model.name;
        }
   
        return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 80;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.shebeiDetailModel.managerFlag isEqualToString:@"0"]){
        
        return YES;
        
    }else{
       return NO;
        
    }
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    WeakSelf
    if (tableView == self.myTable) {
        relAccountsModel * model = self.dataSource[indexPath.row];
        [[NetworkTool sharedTool]requestWithURLparameters:@{@"uuid":DEVICEMoudleManger.listModel.uuid,@"destAuid":model.auid} method:@"mtop.openalink.uc.unbind.by.manager" View:self.view sessionExpiredOption:1 needLogin:YES callBack:^(AlinkResponse *responseObject) {
            if (responseObject.successed) {
                // 删除模型
                [weakSelf.dataSource removeObjectAtIndex:indexPath.row];
                // 刷新
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
            }
        } errorBack:^(id error) {
            
        }];
    }
}

/**
 *  修改Delete按钮文字为“删除”
 */
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"解除绑定";
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
