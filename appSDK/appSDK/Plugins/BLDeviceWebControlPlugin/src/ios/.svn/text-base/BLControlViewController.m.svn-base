//
//  BLControlViewController.m
//  NewElectrolux
//
//  Created by gubeidianzi on 2017/6/2.
//  Copyright © 2017年 gubeidianzi. All rights reserved.
//

#import "BLControlViewController.h"
#import "BLDeviceService.h"
#import "KxMenu.h"
#import "PropertySetViewController.h"
@interface BLControlViewController ()

@property (strong, nonatomic) BLDNADevice *device;
@property (nonatomic,strong)UIView* stateView;
@end

@implementation BLControlViewController

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated    ];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self.stateView removeFromSuperview];
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = NO;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[CommonUtil getColor:@"#333333"]}];
    
}
-(void)openDevicePropertyPage{
    
    PropertySetViewController  * vc = [[PropertySetViewController    alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    
    
}
-(void)closeWebView{
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
   
    // Do any additional setup after loading the view.
    self.title = self.device.name;
//    if (iPhone4 ||iPhone5) {
         self.automaticallyAdjustsScrollViewInsets =NO;
//    }
    //NSString *version = [UIDevice currentDevice].systemVersion;
    
//    if (version.doubleValue >=11.0) {
//
//        self.webView.frame = CGRectMake(0, -20, SCREEN_WIDTH, SCREEN_HEIGHT+20);
//    }
    
    if (@available(iOS 11.0, *))  {
         self.webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
  
    [self loadContents];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:nil];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(openDevicePropertyPage) name:@"openDevicePropertyPage" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(closeWebView) name:@"closeWebView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notice:) name:BL_H5_NAVI object:nil];
//    [self setLeftBarButtonItemWithImageName:@"头部箭头-左"];
    [self createBarItemWithLeftItemTitle:nil leftImage:[UIImage imageNamed:@"Path"] leftTintColor:[UIColor orangeColor] rightTitle:nil rightImage:nil rightTintColor:nil title:self.title];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        [self copyCordovaJsToUIPathWithFileName:DNAKIT_CORVODA_JS_FILE];
        [self copyCordovaPluginsJsToUIPathWithFileName:DNAKIT_CORVODA_PLUGIN_JS_FILE];
    });
}

- (void)createBarItemWithLeftItemTitle:(NSString *)leftTitle leftImage:(UIImage *)leftImage leftTintColor:(UIColor *)leftTintColor rightTitle:(NSString *)rightTitle rightImage:(UIImage *)rightImage rightTintColor:(UIColor *)rightTintColor title:(NSString *)title
{
    //    self.naviItem = [[UINavigationItem alloc] initWithTitle:self.title];
     [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor whiteColor]}];
  
    UIBarButtonItem *backItem;
    if (leftImage) {
        backItem = [[UIBarButtonItem alloc] initWithImage:leftImage style:UIBarButtonItemStylePlain target:self action:@selector(returnSettingViewController:)];
    } else if (leftTitle) {
        backItem = [[UIBarButtonItem alloc] initWithTitle:leftTitle style:UIBarButtonItemStylePlain target:self action:@selector(returnSettingViewController:)];
    }
    if (leftTintColor) {
        backItem.tintColor = [UIColor orangeColor];
    }
    //    self.naviItem.leftBarButtonItem = backItem;
    backItem.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = backItem;
    UIBarButtonItem *rightItem;
    if (rightTitle) {
        rightItem = [[UIBarButtonItem alloc] initWithTitle:rightTitle style:UIBarButtonItemStylePlain target:self action:@selector(onNaviRightButtonTouchup:)];
    } else if (rightImage) {
        rightItem = [[UIBarButtonItem alloc] initWithImage:rightImage style:UIBarButtonItemStylePlain target:self action:@selector(onNaviRightButtonTouchup:)];
    }
    if (rightTintColor) {
        rightItem.tintColor = [UIColor orangeColor];
    }
    //    self.naviItem.rightBarButtonItem = rightItem;
    rightItem =[self setNavLeftRightFrame:self.navigationController imageName:@"更多(1)" selector:@"onNaviRightButtonTouchup:"];
    rightItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightItem;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
//    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
 
 
    //    self.naviBar.items = [NSArray arrayWithObjects:self.naviItem, nil];
}
-(UIBarButtonItem *)setNavLeftRightFrame:(UINavigationController *)nav imageName:(NSString *)name selector:(NSString *)selector{
    
    UIButton *settingButton = [UIButton buttonWithType:UIButtonTypeCustom];
      
    [settingButton addTarget:self action:@selector(onNaviRightButtonTouchup:) forControlEvents:UIControlEventTouchUpInside];
    
    [settingButton setImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
    [settingButton setFrame:CGRectMake(15, 20, 25.0, 8)];
    //修改方法
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 44.0, 44.0)];
    [view addSubview:settingButton];
    
    return  [[UIBarButtonItem alloc] initWithCustomView:view];
}
- (void)showPopupMenuWithArray:(NSArray *)menus
{
    
    NSMutableArray *arr = [NSMutableArray arrayWithArray:menus];

    const int screenWidth = self.view.bounds.size.width;
    const int width = 60;
    CGRect rect = CGRectMake(screenWidth - width, 5, width, 22 * menus.count);
    KxMenu.tintColor = [UIColor whiteColor];
    [KxMenu showMenuInView:self.view.window fromRect:rect menuItems:arr];
}
- (NSMutableArray *)getMenusArray
{
    NSMutableArray *menuItems = [NSMutableArray array];
    
    for (NSDictionary *item in self.rightButtons) {
        NSString *text = item[@"text"];
        UIImage *icon = nil;
        
        if ([item[@"handler"] isEqualToString:@"appProperty"]) {
          
            [menuItems addObject:[KxMenuItem menuItem:text image:icon target:self action:@selector(enterSettingViewController:)]];
        }
        if ([item[@"handler"] isEqualToString:@"BL_NAVBAR_RIGHT_HANDLER0"]) {
            [menuItems addObject:[KxMenuItem menuItem:text image:icon target:self action:@selector(action:) jsFuncName:item[@"handler"]]];
        }
    }
    
    return menuItems;
}
- (void)enterSettingViewController:(UIButton *)sender {
    PropertySetViewController  * vc = [[PropertySetViewController    alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)action:(id)sender {
    KxMenuItem *item = (KxMenuItem *)sender;
    if (item.jsFuncName) {
        [self.webViewEngine.engineWebView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"%@();", item.jsFuncName]];
    }
}
- (void)sigleRightButton {
    if ([self.myJsFuncName isEqualToString:@"appProperty"]) {
         [self enterSettingViewController:nil];
    } else {
        PropertySetViewController  * vc = [[PropertySetViewController    alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
         //[self.webViewEngine.engineWebView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"%@();", self.myJsFuncName]];
    }
}

- (void)onNaviRightButtonTouchup:(id)sender
{
    if (!self.rightButtons || self.rightButtons.count <= 1) {
        [self sigleRightButton];
    } else {
        [self showPopupMenuWithArray:[self getMenusArray]];
    }
}
-(void)notice:(NSNotification *)notification {
    NSDictionary *naviDic = [notification.userInfo[@"hander"] objectAtIndex:0];
    NSDictionary *leftButtonDic = nil;
    if (naviDic[@"rightButtons"]) {
    self.rightButtons = naviDic[@"rightButtons"];
    if (self.rightButtons.count <= 0) {
    [self createBarItemWithLeftItemTitle:nil leftImage:[UIImage imageNamed:@"backArrow.png"] leftTintColor:[UIColor orangeColor] rightTitle:nil rightImage:nil rightTintColor:nil title:self.title];
    } else if (self.rightButtons.count == 1) {
        NSDictionary *item = [self.rightButtons objectAtIndex:0];
        self.myJsFuncName = item[@"handler"];
        NSString *rightTitle = nil;
        if ([self.myJsFuncName isEqualToString:@"appProperty"]) {
            rightTitle =@"属性";// BLLocalizedString(@"", nil);
        } else {
            rightTitle = item[@"text"];
        }
        [self createBarItemWithLeftItemTitle:nil leftImage:[UIImage imageNamed:@"backArrow.png"] leftTintColor:[UIColor orangeColor] rightTitle:rightTitle rightImage:nil rightTintColor:[UIColor orangeColor] title:self.title];
        }
        else {
        [self createBarItemWithLeftItemTitle:nil leftImage:[UIImage imageNamed:@"backArrow.png"] leftTintColor:[UIColor orangeColor] rightTitle:nil rightImage:[UIImage imageNamed:@"btn_more"] rightTintColor:[UIColor orangeColor] title:self.title];
        }
    }
    else {
        [self createBarItemWithLeftItemTitle:nil leftImage:[UIImage imageNamed:@"backArrow.png"] leftTintColor:[UIColor orangeColor] rightTitle:nil rightImage:nil rightTintColor:nil title:self.title];
    }

    NSDictionary *titleBarDic = nil;
    if (naviDic[@"titleBar"]) {
        titleBarDic = naviDic[@"titleBar"];
        if (titleBarDic.allKeys.count<=0) {
            titleBarDic = nil;
        }else{
           self.navigationController.navigationBar.barTintColor =[CommonUtil getColor:@"#ffab03"] /*[CommonUtil getColor:naviDic[@"titleBar"][@"backgroundColor"]]*/;
            
        }
    }
   
    
    if (naviDic[@"leftButton"]) {
        leftButtonDic = naviDic[@"leftButton"];
        self.myLeftJsFuncName = leftButtonDic[@"handler"];
    }

    if (titleBarDic && titleBarDic[@"title"]) {
        [self setTitle:titleBarDic[@"title"]];
    }
    else{
        [self setTitle:[self.device getName]];
    }
}
- (void)backSettingViewController:(UIButton *)sender {
    [self.webViewEngine.engineWebView stringByEvaluatingJavaScriptFromString:@"BL_NAVBAR_LEFT_HANDLER()"];
}
 
- (void)returnSettingViewController:(UIButton *)sender {
    
    if ([self.myLeftJsFuncName isEqualToString:@"appBack"]) {
        if ([self.webViewEngine.engineWebView  canGoBack]) {
            [self.webViewEngine.engineWebView  goBack];
            return;
        }
        else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else if ([self.myLeftJsFuncName isEqualToString:@"appClose"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if (self.myLeftJsFuncName) {
        [self.webViewEngine.engineWebView  stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"%@();", self.myLeftJsFuncName]];
        return;
    }
    else {
        if ([self.webViewEngine.engineWebView  canGoBack]) {
            [self.webViewEngine.engineWebView  goBack];
            return;
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
 
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
     // Dispose of any resources that can be recreated.
}
 
- (void)viewWillAppear:(BOOL)animated {
     [super viewWillAppear:animated];
    //[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    // View defaults to full size.  If you want to customize the view's size, or its subviews (e.g. webView),
//    // you can do so here.
//    //设置导航栏背景图片为一个空的image，这样就透明了
//    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init]      forBarMetrics:UIBarMetricsDefault];
//
//    //去掉透明后导航栏下边的黑边
//    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
//    self.navigationController.navigationBar.alpha = 0;
//
//    NSString *version = [UIDevice currentDevice].systemVersion;
//    self.stateView = [[UIView alloc]init];
//    if (version.doubleValue<11.0) {
//        self.stateView.frame =CGRectMake(0, 0, self.view.bounds.size.width, 20);
//    }else{
//
//        self.stateView.frame= CGRectMake(0, 0, self.view.bounds.size.width, 20);
//
//    }
//      
//    self.stateView.backgroundColor = [CommonUtil getColor:@"#333333"];
//    [self.view addSubview:self.stateView];
    
    self.navigationController.navigationBar.barTintColor =[CommonUtil getColor:@"#ffab03"] ;
    self.tabBarController.tabBar.hidden = YES;
   // self.navigationController.navigationBarHidden = NO;
     self.navigationController.navigationBar.hidden = YES;
    
//    [[UIApplication sharedApplication] setStatusBarHidden:YES];
  
}
 
- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.navigationController.navigationBarHidden = NO;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return [super shouldAutorotateToInterfaceOrientation:interfaceOrientation];
}
 
- (void)loadContents {
     
     NSString *pid = self.device.pid;
     
     //h5文件的相对路径
//     NSString *uiPath = [[[BLLet sharedLet].controller queryUIPath:pid] stringByAppendingPathComponent:[self getPreferredLanguage]]; //  ../Let/ui/pid/zh-cn/
    NSString *uiPath = [[[BLLet sharedLet].controller queryUIPath:pid] stringByAppendingPathComponent:@"zh-cn"];
    BOOL isDir = FALSE;
    if ([[NSFileManager defaultManager] fileExistsAtPath:uiPath isDirectory:&isDir]) {
         if (isDir) {
             NSString *appHtml = [uiPath stringByAppendingPathComponent:DNAKIT_DEFAULTH5PAGE_NAME]; //  ../Let/ui/pid/zh-cn/app.html
             NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:appHtml]];
             [self.webViewEngine loadRequest:request];
         }
    }
}

- (BOOL)copyCordovaJsToUIPathWithFileName:(NSString*)fileName {
    NSString *uiPath = [[[BLLet sharedLet].controller queryUIPath:[self.device getPid]] stringByDeletingLastPathComponent];  //  ../Let/ui/
    NSString *fullPathFileName = [uiPath stringByAppendingPathComponent:fileName];  // ../Let/ui/fileName
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:fullPathFileName] == NO) {
        NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:nil inDirectory:@"www"];
        NSError *error;
        BOOL success = [fileManager copyItemAtPath:path toPath:fullPathFileName error:&error];
        if (success) {
            NSLog(@"%@ copy success",fileName);
            return YES;
        } else {
            NSLog(@"%@ copy failed",fileName);
            return NO;
        }
    }
    
    return YES;
}

- (BOOL)copyCordovaPluginsJsToUIPathWithFileName:(NSString*)fileName {
    NSString *uiPath = [[[BLLet sharedLet].controller queryUIPath:[self.device getPid]] stringByDeletingLastPathComponent];  //  ../Let/ui/
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *pluginsFilePath = [uiPath stringByAppendingPathComponent:fileName];
    if ([fileManager fileExistsAtPath:pluginsFilePath] == NO) {
        NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:nil inDirectory:@"www"];
        NSError *error;
        BOOL success = [fileManager copyItemAtPath:path toPath:pluginsFilePath error:&error];
        if (success) {
            NSLog(@"%@ copy success",fileName);
            return YES;
        } else {
            NSLog(@"%@ copy failed",fileName);
            return NO;
        }
    }
    
    return YES;
}
 
/*
 *  @brief      获取本机语言代码
 *  @return     返回本机语言代码
 */
 - (NSString*)getPreferredLanguage {
     //使用ios标准的语言格式，如："zh-Hans"
     NSMutableString *languageStr = [NSMutableString stringWithCapacity:0];
     [languageStr setString:[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLocale"]];
     [languageStr replaceOccurrencesOfString:@"_" withString:@"-" options:0 range:NSMakeRange(0, [languageStr length] - 1)];
     NSString *preferredLang = [languageStr lowercaseString];
     
     return preferredLang;
 }

+ (BLControlViewController *)controlVCWithDevice:(BLDNADevice *)device
{
    BLControlViewController *vc = [[UIStoryboard storyboardWithName:@"DeviceControl" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([BLControlViewController class])];
    vc.device = device;
    [BLDeviceService sharedDeviceService].selectDevice = device;
    
    return vc;
}

@end

#pragma mark CDVCommandDelegate implementation
@implementation DeviceControlIndexCommandDelegate
/* To override the methods, uncomment the line in the init function(s)
 in MainViewController.m
 */

#pragma mark CDVCommandDelegate implementation

- (id)getCommandInstance:(NSString*)className {
    return [super getCommandInstance:className];
}

- (NSString*)pathForResource:(NSString*)resourcepath {
    return [super pathForResource:resourcepath];
}

@end


@implementation DeviceControlIndexCommandQueue

/* To override, uncomment the line in the init function(s)
 in MainViewController.m
 */
- (BOOL)execute:(CDVInvokedUrlCommand*)command {
    return [super execute:command];
}

@end
