//
//  ZhuceViewController.m
//  AlinkDemo
//
//  Created by gubeidianzi on 2017/12/4.
//  Copyright © 2017年 aliyun. All rights reserved.
//

#import "ZhuceViewController.h"
#import "SureZhuCeViewController.h"
@interface ZhuceViewController ()
@property (nonatomic,strong) UITextField * phoneTF;
@property (nonatomic,strong) UIButton * nextBtn;
@property (nonatomic,strong) UIImageView *navLine;
@end

@implementation ZhuceViewController
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.barTintColor = RGB(247, 245, 244);
    _navLine.hidden = NO;
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    UIView *backgroundView = [self.navigationController.navigationBar subviews].firstObject;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationItem.leftBarButtonItem.tintColor =  [UIColor blackColor];
    _navLine = backgroundView.subviews.firstObject;
    _navLine.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self changeleftItem];
    self.title =NSLocalizedString(@"注册", nil) ;
     [self setTheUI];
     self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
}
-(void)setTheUI{
    UILabel * leftL  = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 65, 60)];
    leftL.backgroundColor = [UIColor whiteColor];
    leftL.text = @"CN+86";
    leftL.font = [UIFont boldSystemFontOfSize:18];
    leftL.textColor = [CommonUtil getColor:@"#333333"];
    UIView *v1 = [[UIView alloc]initWithFrame:CGRectMake(69, 15, 1, 30)];
    v1.backgroundColor = [UIColor whiteColor];
    v1.backgroundColor =[CommonUtil getColor:@"#BBBBBB"];
    
    UIView *leftV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 80, 60)];
    leftV.backgroundColor = [UIColor whiteColor];
    [leftV addSubview:leftL];
    [leftV addSubview:v1];
    self.phoneTF = [[UITextField alloc]initWithFrame:CGRectMake(30, 104, SCREEN_HEIGHT-60, 60)];
    [self.view addSubview:self.phoneTF];
    _phoneTF.placeholder  =NSLocalizedString(@"输入手机号码", nil) ;
    [_phoneTF setValue:[CommonUtil getColor:@"#BBBBBB"] forKeyPath:@"_placeholderLabel.textColor"];
    _phoneTF.font = [UIFont systemFontOfSize:18];
    _phoneTF.textColor = [CommonUtil getColor:@"#333333"];
    _phoneTF.leftView = leftV;
    _phoneTF.leftViewMode = UITextFieldViewModeAlways;
    _phoneTF.clearButtonMode=UITextFieldViewModeWhileEditing;
    UIView * v = [[UIView alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(_phoneTF.frame), SCREEN_WIDTH-60, 1)];
    v.backgroundColor = Gray_Color;
    [self.view addSubview:v];
    
    self.nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _nextBtn.frame =  CGRectMake((SCREEN_WIDTH-315)/2, CGRectGetMaxY(self.phoneTF.frame)+50, 315, 50);
    
    [self.nextBtn setTitle:NSLocalizedString(@"下一步", nil)  forState:UIControlStateNormal];
    [self.nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.nextBtn.backgroundColor = [CommonUtil getColor:@"#F1AA3E"];
    [self.nextBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [self.view addSubview:self.nextBtn];
    [self.nextBtn AddLayer:10];
    [self.nextBtn addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)next{
    [self.phoneTF resignFirstResponder];
    UIStoryboard  * story = [UIStoryboard   storyboardWithName:@"LliangBaStoryBoard" bundle:[NSBundle mainBundle]];
    SureZhuCeViewController  *vc = [story instantiateViewControllerWithIdentifier:@"SureZhuCe"];
    
    WeakSelf
    if ([CommonUtil isMobileNumber:self.phoneTF.text]) {
        [UsingHUD showInView:self.view];
        [BLLetAccount   sendRegVCode:_phoneTF.text countryCode:@"+86" completionHandler:^(BLBaseResult * _Nonnull result) {

            dispatch_async(dispatch_get_main_queue(), ^{
                [UsingHUD hideInView:self.view];
                if (result.error == 0) {
                    [CommonUtil  setTip:NSLocalizedString(@"获取验证码成功", nil) ];
                    vc.phoneStr =weakSelf.phoneTF.text;

                    [weakSelf.navigationController pushViewController:vc animated:YES];
                    NSLog(@"成功%@",result);
                }else{

                    [CommonUtil  setTip:result.msg];
                }

            });
        }];
    }else{

        [CommonUtil  setTip:@"请正确填写手机号码"];
    };
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.phoneTF endEditing:YES];
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
