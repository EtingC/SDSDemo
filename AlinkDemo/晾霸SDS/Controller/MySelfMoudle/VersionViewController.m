//
//  VersionViewController.m
//  AlinkDemo
//
//  Created by gubeidianzi on 2017/12/6.
//  Copyright © 2017年 aliyun. All rights reserved.
//

#import "VersionViewController.h"
#import "VersionTableViewCell.h"
#import <AFNetworking.h>
@interface VersionViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UIButton * verBtn;
@property(nonatomic,copy) NSString * appVer;
@end

@implementation VersionViewController
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
     self.tabBarController.tabBar.hidden = NO;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    
    [self getAppStoreVer];
}
-(void)getAppStoreVer{
    WeakSelf
    AFHTTPSessionManager * manger = [AFHTTPSessionManager manager];
    [UsingHUD showInView:self.view];
    [manger POST:@"https://itunes.apple.com/lookup?id=414478124" parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [UsingHUD hideInView:weakSelf.view];
        NSArray *array = responseObject[@"results"];
        NSDictionary *dict = [array lastObject];
        weakSelf.appVer =[dict[@"version"] copy];
        [weakSelf.myTable reloadData];
        NSLog(@"当前版本为：%@", dict[@"version"]);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [UsingHUD hideInView:weakSelf.view];
        [CommonUtil setTip:NSLocalizedString(@"请求失败", nil)];
        weakSelf.appVer = @"##";
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self changeleftItem];
    self.title =NSLocalizedString(@"版本升级", nil) ;
    [[NSNotificationCenter defaultCenter ]addObserver:self selector:@selector(getAppStoreVer) name:@"applicationWillEnterForeground" object:nil];
    self.view.backgroundColor = [CommonUtil getColor:@"#F3F3F3"];
    self.myTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 120) style:UITableViewStylePlain];
    self.myTable.delegate = self;
    self.myTable.backgroundColor = Gray_Color;
    self.myTable.dataSource = self;
    self.myTable.userInteractionEnabled = NO;
    [self.view addSubview:self.myTable];
    [self.myTable   registerNib:[UINib nibWithNibName:@"VersionTableViewCell" bundle:nil] forCellReuseIdentifier:@"VersionTableViewCell"];
    
    self.verBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.verBtn];
    [self.verBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-50);
        make.height.mas_equalTo(@50);
    }];
    self.verBtn.backgroundColor = [UIColor whiteColor];
    self.verBtn.userInteractionEnabled = NO;
    [self.verBtn setTitle:NSLocalizedString(@"正在对比版本中", nil)  forState:UIControlStateNormal];
    [self.verBtn.titleLabel setFont:[UIFont systemFontOfSize:20]];
    [self.verBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    self.verBtn.layer.borderWidth = 0.5;
    self.verBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [self.verBtn addTarget:self action:@selector(gengxin) forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view.
}
-(void)gengxin{
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/cn/app/jie-zou-da-shi/id493901993?mt=8"]];
 
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
        if (cell == nil) {
            cell = [[VersionTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"VersionTableViewCell"];
        }
    if (indexPath.row == 0) {
        cell.vername.text =NSLocalizedString(@"当前版本", nil) ;
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
        cell.versionNum.text = app_Version;
        if (self.appVer) {
            if ([app_Version doubleValue] ==[self.appVer doubleValue]) {
                self.verBtn.userInteractionEnabled = NO;
                [self.verBtn setTitle:NSLocalizedString(@"已是最新版本", nil)  forState:UIControlStateNormal];
            }else{
                [self.verBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
                [self.verBtn setTitle:NSLocalizedString(@"升级至最新版本", nil) forState:UIControlStateNormal];
                self.verBtn.userInteractionEnabled = YES;
            }
        }
    }
    if (indexPath.row == 1) {
        cell.vername.text = NSLocalizedString(@"最新版本", nil);
        if (self.appVer) {
            cell.versionNum.text = self.appVer;
        }else{
            cell.versionNum.text = @"##";
        }
    }
        return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 60;
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
