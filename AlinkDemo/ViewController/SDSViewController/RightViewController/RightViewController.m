//
//  RightViewController.m
//  AlinkDemo
//
//  Created by gubeidianzi on 2017/11/6.
//  Copyright © 2017年 aliyun. All rights reserved.
//

#import "RightViewController.h"
#import "AddDeviceTableViewCell.h"
#import "SearchDeviceViewController.h"
#import "FirstAddViewController.h"
#import "LKProductBriefModel.h"
#import "SSSearchBar.h"
#import "STSearchBar.h"
#define isIOS(a) [[[UIDevice currentDevice]systemVersion] floatValue] == a
#define aboveIOS(a) [[[UIDevice currentDevice]systemVersion] floatValue] >= a
#define UIScreenHeight  [[UIScreen mainScreen]bounds].size.height

#define UIScreenWidth   [[UIScreen mainScreen]bounds].size.width
@interface RightViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UITextFieldDelegate,STSearchBarDelegate>
@property (nonatomic,retain) UISearchController *searchController;
@property(nonatomic,retain)NSMutableArray *searchResults;//接收数据源结果
@property (nonatomic,strong) SSSearchBar *searchBar;
@property (nonatomic,strong) STSearchBar * stSearchBar;
@property (nonatomic,assign) BOOL IscancleShow;
// placeholder 和icon 和 间隙的整体宽度
@property (nonatomic, assign) CGFloat placeholderWidth;
@end
 
@implementation RightViewController
- (STSearchBar *)stSearchBar
{
    if (!_stSearchBar) {
        _stSearchBar = [[STSearchBar alloc]initWithFrame:CGRectMake(0, 20, self.view.frame.size.width , 0)];
        _stSearchBar.delegate = self;
        _stSearchBar.placeholder = NSLocalizedString(@"请输入名称或型号", nil) ;
    }
    return _stSearchBar;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.IscancleShow = NO;
    
    self.navigationController.navigationBar.tintColor = RGB(39, 39, 39);
    self.title =NSLocalizedString(@"添加设备", nil) ;
    [self setTheUI];
    self.searchResults = [[NSMutableArray alloc]init];
    
    self.navigationItem.leftBarButtonItem = [self setNavLeftRightFrame:self.navigationController imageName:@"导航栏返回" selector:@"leftBtn"];
    
    self.navigationItem.leftBarButtonItem.target =self;
    self.navigationItem.leftBarButtonItem.style = UIBarButtonItemStylePlain;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
       [self getData];
    });
    // Do any additional setup after loading the view.
}
-(void)leftBtn{
    [super leftBtn ];
    if ([self isKindOfClass:[RightViewController class]]) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[RightViewController class]]) {
                RightViewController *A =(RightViewController *)controller;
                [self.navigationController popToViewController:A animated:YES];
            }
        }
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated ];
   
}
-(void)getData{
    dispatch_async(dispatch_get_main_queue(), ^{
        [UsingHUD showInView:self.view];
    });
    WeakSelf;
    [kAlinkSDK invokeWithMethod:@"mtop.openalink.app.product.list" params:@{} completionHandler:^(AlinkResponse * _Nonnull businessResponse) {
        if (businessResponse.successed == YES) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [UsingHUD hideInView:self.view];
            });
            NSArray *jsonArray = businessResponse.dataObject;
//            {
//                brandName = LBestGB;
//                deviceName = "SD50\U667a\U80fd\U667e\U8863\U67b6-\U8c6a\U534e\U6b3e";
//                icon = "https://gtms04.alicdn.com/tps/i4/TB1zqDad46I8KJjSszfXXaZVXXa";
//                id = 1236;
//                model = "LBESTGB_LIVING_AIRER_SD50_1_0_20445";
//                shortModel = "";
//            }
            LKProductBriefModel * customDeviceModel = [[LKProductBriefModel  alloc]init];
            customDeviceModel.brandName = @"智能晾衣机";
            customDeviceModel.deviceName = @"X23 X30 X50 K3 K5 M08 X60 Z80";
            customDeviceModel.icon = @"X23-X30";
            customDeviceModel.id =@"1234";
            customDeviceModel.model =@"LBESTGB_LIVING_AIRER_SD50_1_0_20184";
            customDeviceModel.shortModel = @"";
            
            //拿到产品列表列表
            NSArray<LKProductBriefModel *> * products = [LKProductBriefModel  mj_objectArrayWithKeyValuesArray:jsonArray];
            
            NSMutableArray * custonMutArr = [NSMutableArray arrayWithArray:products];
            LKProductBriefModel *custonM = custonMutArr[0];
            custonM.brandName = @"智能晾衣机";
            custonM.deviceName = @"X90";
            [custonMutArr addObject:customDeviceModel];
            
            for (LKProductBriefModel* model in custonMutArr) {
                
                NSString * dd = [CommonUtil GetTheDeviceModel:model.model][1];
                if (![dd isEqualToString:@"2"]) {
                     [weakSelf.dataSource addObject:model];
                }
            }
                [weakSelf.myTable reloadData];
        }
        else {
              NSError * err =businessResponse.responseError;
              [CommonUtil setTip:[NSString stringWithFormat:@"%@",err]];
              NSLog(@"%@",err);
            dispatch_async(dispatch_get_main_queue(), ^{
                 [UsingHUD hideInView:self.view];
            });
            if (err.code == LKDCErrCodeIllegalToken) {
                //账号登录超过一个时期，账号token失效，此时需要调起登录页面重新登录一下账号。这个错误必须处理。否则重试还会失败
                [[AlinkAccount sharedInstance] loginWithViewController:nil completionHandler:^(BOOL isSuccessful, NSDictionary *loginResult) {
                    //账号
                } cancelationHandler:^{
                    
                }];
            }
        }
    }];
}

-(void)setTheUI{
    self.view.backgroundColor = [UIColor whiteColor];
    self.myTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH , SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    [self.myTable registerNib:[UINib nibWithNibName:@"AddDeviceTableViewCell" bundle:nil] forCellReuseIdentifier:@"AddDeviceTableViewCell"];
    self.myTable.delegate = self;
    self.myTable.dataSource= self;
    self.myTable.backgroundColor = [UIColor whiteColor];
    self.myTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.myTable];
      self.myTable.tableHeaderView =self.stSearchBar;
}
#pragma mark - --- delegate 视图委托 ---

-(BOOL)searchBarShouldBeginEditing:(STSearchBar *)searchBar{
    self.IscancleShow = YES;
    return YES;
}                     // return NO to not become first responder
- (void)searchBarTextDidBeginEditing:(STSearchBar *)searchBar{

    NSLog(@"111111");

    if (self.stSearchBar ==searchBar) {
         self.IscancleShow = YES;
    }

}// called when text starts editing
- (BOOL)searchBarShouldEndEditing:(STSearchBar *)searchBar{
    return YES;
}                       // return NO to not resign first responder
                     // called when text ends editing
- (void)searchBarTextDidEndEditing:(STSearchBar *)searchBar {

    if (self.stSearchBar == searchBar) {

        self.IscancleShow =  NO;
    }
}

-(void)searchBar:(STSearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (self.stSearchBar == searchBar) {
        NSString *searchString = searchText;

        if (self.searchResults!= nil) {
            [self.searchResults removeAllObjects];
        }
        if (self.dataSource) {
            if (searchString!=nil &&![searchString isEqualToString:@""]) {
                //过滤数据
                for (LKProductBriefModel*model in self.dataSource) {
                    NSPredicate *preicate = [NSPredicate predicateWithFormat:@"brandName CONTAINS[c] %@", searchString];
                    if ([preicate evaluateWithObject:model]) {
                        [self.searchResults addObject:model];
                    }
                }
            }else{
                for (LKProductBriefModel*model in self.dataSource) {
                        [self.searchResults addObject:model];
                }
            }
            //刷新表格
            [self.myTable reloadData];
        }
  }
}
- (BOOL)searchBar:(STSearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    return YES;
} // called before text changes

- (void)searchBarSearchButtonClicked:(STSearchBar *)searchBar{
    self.IscancleShow = NO;
}                    // called when keyboard search button pressed
- (void)searchBarCancelButtonClicked:(STSearchBar *)searchBar {
    if (self.stSearchBar == searchBar) {
         self.IscancleShow = NO;
        _stSearchBar.text = nil;
        [self.stSearchBar resignFirstResponder];
        [self.myTable reloadData];
    }
}
#pragma mark - tableview的代理方法实现
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.IscancleShow == YES) {

        return [self.searchResults count];
    }
    else{
//
       return self.dataSource.count;
    }


    return 0;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AddDeviceTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"AddDeviceTableViewCell"];
    if (cell == nil) {
        cell = [[AddDeviceTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AddDeviceTableViewCell"];
    }
    if (indexPath.row == 0) {
        UIView * bgline = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
        bgline.backgroundColor = Gray_Color;
        [cell addSubview:bgline];
    }
    
    if (self.IscancleShow == YES) {
        [cell setTheModel:self.searchResults[indexPath.row]];
    }
    else{
        [cell setTheModel:self.dataSource[indexPath.row]];
     }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 80;
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
      self.IscancleShow = NO;
     [self.stSearchBar resignFirstResponder];
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
      [tableView deselectRowAtIndexPath:indexPath animated:NO];
//      [self.stSearchBar resignFirstResponder];
    
     LKProductBriefModel * model = nil;
     UIStoryboard * strory = [UIStoryboard  storyboardWithName:@"LeftMenuViewController" bundle:[NSBundle mainBundle]];
     FirstAddViewController * vc = [strory instantiateViewControllerWithIdentifier:@"firstAdd"];
    if (self.IscancleShow == YES) {
        vc.lkmodel  = self.searchResults[indexPath.row];
         model = self.searchResults[indexPath.row];
    [DeviceInfoManager sharedManager].imagePath =model.icon;
    [DeviceInfoManager sharedManager].TheAddDevieceName = vc.lkmodel.brandName;
    [DeviceInfoManager sharedManager].PID = [DeviceInfoManager getPidStringDecimal:[[CommonUtil GetTheDeviceModel:model.model][2] integerValue]];

     }
     else{
         vc.lkmodel  = self.dataSource [indexPath.row];
         model = self.dataSource [indexPath.row];
         [DeviceInfoManager sharedManager].imagePath =model.icon;
         [DeviceInfoManager sharedManager].TheAddDevieceName = vc.lkmodel.brandName;
         
         [DeviceInfoManager sharedManager].PID = [DeviceInfoManager getPidStringDecimal:[[CommonUtil GetTheDeviceModel:model.model][2] integerValue]];
     }
#warning this 临时这样写 应该是  [self.navigationController  pushViewController:vc animated:YES];
          [self.navigationController  pushViewController:vc animated:YES];
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
