//
//  SearchDeviceViewController.m
//  AlinkDemo
//
//  Created by gubeidianzi on 2017/11/6.
//  Copyright © 2017年 aliyun. All rights reserved.
//

#import "SearchDeviceViewController.h"
#import "AddDeviceTableViewCell.h"
#import "FirstAddViewController.h"
@interface SearchDeviceViewController ()<UITableViewDelegate,UITableViewDataSource,
UISearchControllerDelegate,UISearchResultsUpdating>

@property (nonatomic,retain) UISearchController *searchController;

//tableView
@property (nonatomic,strong) UITableView *skTableView;
@property(nonatomic,retain)NSMutableArray *searchResults;//接收数据源结果

@end

@implementation SearchDeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    self.title = @"添加设备";
    [self setUI];
   
}
-(void)setUI{
    self.skTableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH    ,SCREEN_HEIGHT )];
    [self.skTableView registerNib:[UINib nibWithNibName:@"AddDeviceTableViewCell" bundle:nil] forCellReuseIdentifier:@"AddDeviceTableViewCell"];
    self.skTableView.backgroundColor = Gray_Color;
    self.skTableView.delegate = self;
    self.skTableView.dataSource = self;
    //隐藏tableViewCell下划线
   self.skTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    //创建UISearchController
    self.searchController = [[UISearchController alloc]initWithSearchResultsController:nil];
    //设置代理
    self.searchController.delegate= self;
    self.searchController.searchResultsUpdater = self;
    //包着搜索框外层的颜色
    self.searchController.searchBar.barTintColor = Gray_Color;
    //提醒字眼
    self.searchController.searchBar.placeholder= @"请输入关键字搜索";
    UIImageView *barImageView = [[[_searchController.searchBar.subviews firstObject] subviews] firstObject];
    barImageView.layer.borderColor =  [UIColor groupTableViewBackgroundColor].CGColor;
    barImageView.layer.borderWidth = 1;
    
    [_searchController.searchBar sizeToFit];
    //提前在搜索框内加入搜索词
    //    self.searchController.searchBar.text = @"";
    //设置UISearchController的显示属性，以下3个属性默认为YES
    //搜索时，背景变暗色
    self.searchController.dimsBackgroundDuringPresentation = NO;
    //搜索时，背景变模糊
    //    self.searchController.obscuresBackgroundDuringPresentation = NO;
    //点击搜索的时候,是否隐藏导航栏
    
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    //位置
    self.searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x, self.searchController.searchBar.frame.origin.y, self.searchController.searchBar.frame.size.width, 55);
    // 添加 searchbar 到 headerview
    self.searchController.searchBar.layer.borderColor =Gray_Color.CGColor;
    self.skTableView.tableHeaderView = self.searchController.searchBar;
    [[UIBarButtonItem appearanceWhenContainedIn: [UISearchBar class], nil] setTintColor:[UIColor blackColor]];
    [[UIBarButtonItem appearanceWhenContainedIn: [UISearchBar class], nil] setTitle:@"取消"];
    //出现 ✘ 按钮
    for (UIView *view in self.searchController.searchBar.subviews) {
        if ([view isKindOfClass:NSClassFromString(@"UIView")] && view.subviews.count > 1) {
            if ( [[view.subviews objectAtIndex:1] isKindOfClass:[UITextField class]]) {
                UITextField *textField = (UITextField *)[view.subviews objectAtIndex:1];
                [textField setClearButtonMode:UITextFieldViewModeWhileEditing];
            }
            break;
        }
    }
    
    
    [self.view addSubview: self.skTableView];
}
//设置区域的行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 0;
}

//返回单元格内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *flag=@"AddDeviceTableViewCell";
    AddDeviceTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:flag];
    if (cell==nil) {
        cell=[[AddDeviceTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:flag];
    }
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //     UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    return 80;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard * strory = [UIStoryboard  storyboardWithName:@"LeftMenuViewController" bundle:[NSBundle mainBundle]];
    FirstAddViewController * vc = [strory instantiateViewControllerWithIdentifier:@"firstAdd"];
    
    [self.navigationController  pushViewController:vc animated:YES];
     [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
//谓词搜索过滤
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
     [self.searchController  setActive:NO];
    
    
}
-(void)viewDidDisappear:(BOOL)animated{
     [super viewDidDisappear:animated];
    
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.searchController.searchBar resignFirstResponder];
    [self.searchController  setActive:NO];
}
#pragma mark - UISearchControllerDelegate代理,可以省略,主要是为了验证打印的顺序
//测试UISearchController的执行过程

- (void)willPresentSearchController:(UISearchController *)searchController
{
    NSLog(@"willPresentSearchController");
}

- (void)didPresentSearchController:(UISearchController *)searchController
{
    NSLog(@"didPresentSearchController");
#warning 如果进入预编辑状态,searchBar消失(UISearchController套到TabBarController可能会出现这个情况),请添加下边这句话
    //    [self.view addSubview:self.searchController.searchBar];
}

- (void)willDismissSearchController:(UISearchController *)searchController
{
    NSLog(@"willDismissSearchController");
}

- (void)didDismissSearchController:(UISearchController *)searchController
{
    NSLog(@"didDismissSearchController");
}

- (void)presentSearchController:(UISearchController *)searchController
{
    NSLog(@"presentSearchController");
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
