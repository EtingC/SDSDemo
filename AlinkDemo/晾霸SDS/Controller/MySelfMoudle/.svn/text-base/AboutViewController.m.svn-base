//
//  AboutViewController.m
//  AlinkDemo
//
//  Created by gubeidianzi on 2017/12/6.
//  Copyright © 2017年 aliyun. All rights reserved.
//

#import "AboutViewController.h"
#import "VersionTableViewCell.h"
@interface AboutViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UIImageView *imageV;
@property (nonatomic,strong) UILabel *verL;
@end

@implementation AboutViewController
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     
     @{NSFontAttributeName:[UIFont systemFontOfSize:18],
       
       NSForegroundColorAttributeName:[CommonUtil getColor:@"#333333"]}];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self changeleftItem];
     self.view.backgroundColor = [CommonUtil getColor:@"#F3F3F3"];
    self.title =NSLocalizedString(@"关于晾霸", nil  ) ;
    [self   makeUIElement];
    // Do any additional setup after loading the view.
}
-(void)makeUIElement{ 
    self.imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon"]];
    [self.view addSubview:self.imageV];
    self.verL = [[UILabel alloc]init];
    self.verL.textColor = [CommonUtil getColor:@"#333333"];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    self.verL.text =[NSString stringWithFormat:@"%@%@",NSLocalizedString(@"版本:V", nil),app_Version];
    self.verL.textAlignment = NSTextAlignmentCenter;
    self.verL.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:self.verL];
    
    [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
    
        make.top.equalTo(self.view.mas_top).with.offset(50);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(50, 50));
        
    }];
    [self.verL mas_makeConstraints:^(MASConstraintMaker *make) {
       //165 45
        make.top.equalTo(self.imageV.mas_bottom).with.offset(12.5);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(165, 45));
        
    }];
    
    self.myTable = [[UITableView alloc]init];
    [self.view addSubview:self.myTable];
    
    [self.myTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(@120);
        make.top.equalTo(self.verL.mas_bottom).with.offset(20);
    }];
    
    self.myTable.delegate = self;
    self.myTable.dataSource = self;
//    self.myTable.userInteractionEnabled = NO;
     [self.myTable   registerNib:[UINib nibWithNibName:@"VersionTableViewCell" bundle:nil] forCellReuseIdentifier:@"VersionTableViewCell"];
    
    UILabel * companyNameL = [[UILabel alloc]init];
    [self.view addSubview:companyNameL];
    [companyNameL mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-20);
        make.height.mas_equalTo(@50);
    }];
 
    companyNameL.text =NSLocalizedString(@"广东晾霸智能科技有限公司\n中国·广东省广州市黄浦区经济技术开发区环岭路13号", nil) ;
    companyNameL.numberOfLines = 0;
    companyNameL.textAlignment= NSTextAlignmentCenter;
    companyNameL.textColor = [CommonUtil getColor:@"#999999"];
    companyNameL.font = [UIFont systemFontOfSize:12];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return 2;/*self.dataSource.count*/;
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    VersionTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"VersionTableViewCell"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (cell == nil) {
        cell = [[VersionTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"VersionTableViewCell"];
    }
    if (indexPath.row == 0) {
        cell.vername.text =NSLocalizedString( @"客服电话", nil);
        cell.versionNum.text = @"400-8166-208";
        
    }
    if (indexPath.row == 1) {
        cell.vername.text = NSLocalizedString(@"公司客服", nil) ;
        cell.versionNum.text = @"www.l-best.com.cn";
        
    }
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    VersionTableViewCell *cell = [self.myTable cellForRowAtIndexPath:indexPath];
    if (indexPath.row == 0) {
        NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",cell.versionNum.text];
        UIWebView *callWebview = [[UIWebView alloc] init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
        [self.view addSubview:callWebview];
      
    }else if (indexPath.row == 1){
        NSString *urlText =  [ NSString stringWithFormat:@"http://%@",cell.versionNum.text];
        [[ UIApplication sharedApplication] openURL:[ NSURL URLWithString:urlText]];
        
    }
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
