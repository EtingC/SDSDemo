//
//  PassWordViewController.m
//  AlinkDemo
//
//  Created by gubeidianzi on 2017/11/6.
//  Copyright © 2017年 aliyun. All rights reserved.
//

#import "PassWordViewController.h"

@interface PassWordViewController ()
@property (weak, nonatomic) IBOutlet UIButton *passwordBtn;
@property (nonatomic,strong) UIButton * v;
@property (nonatomic,strong) UIButton * v1;
@property (weak, nonatomic) IBOutlet UILabel *PStopL;
@property (weak, nonatomic) IBOutlet UILabel *PSMIDL;
@property (nonatomic,strong) UIButton * v2;
@end

@implementation PassWordViewController
- (IBAction)SureThePassWordChange:(id)sender {
    [self.yuanmiamaTF resignFirstResponder];
    [self.xinmimaTF resignFirstResponder];
    [self.querenxinmimaTF resignFirstResponder];
    
    if (![self.yuanmiamaTF.text isEqualToString:[DATACache objectForKey:@"PASSWORD"]]) {
        [CommonUtil setTip:@"请正确填写原密码"];
    }else if (![self.xinmimaTF.text isEqualToString:self.querenxinmimaTF.text]) {
        [CommonUtil setTip:@"请确保新密码输入相同！" Yposition:SCREEN_HEIGHT-150];
    }else{
        [UsingHUD showInView:self.view];
        WeakSelf
        [BLLetAccount modifyPassword:self.yuanmiamaTF.text newPassword:self.querenxinmimaTF.text completionHandler:^(BLBaseResult * _Nonnull result) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [UsingHUD hideInView:weakSelf.view];
                if (result) {
                    if (result.error == 0) {
                        
                        [weakSelf.navigationController popViewControllerAnimated:YES];
                        
                    }else{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [CommonUtil setTip:result.msg];
                        }); 
                    }
                }
            });
        }];
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self changeleftItem];
    self.title =NSLocalizedString(@"修改密码", nil) ;
    self.view.backgroundColor = [CommonUtil getColor:@"#F3F3F3"];
    [self.passwordBtn setTitle:NSLocalizedString(@"确定", nil) forState:UIControlStateNormal];
    [self.passwordBtn AddLayer:10];
    self.PSMIDL.text = NSLocalizedString(@"新密码", nil);
    self.PStopL.text = NSLocalizedString(@"原密码", nil);
     _v = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 19, 14)];
     [_v addTarget:self action:@selector(securityChange:) forControlEvents:UIControlEventTouchUpInside];
     _v.backgroundColor = [UIColor clearColor];
     [_v setImage:[UIImage imageNamed:@"密码不可见"] forState:UIControlStateNormal];
     _v1 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 14)];
     [_v1 addTarget:self action:@selector(securityChange:) forControlEvents:UIControlEventTouchUpInside];
     _v1.backgroundColor = [UIColor clearColor];
     [_v1 setImage:[UIImage imageNamed:@"密码不可见"] forState:UIControlStateNormal];
     _v2 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 21, 14)];
     _v2.backgroundColor = [UIColor clearColor];
     [_v2 addTarget:self action:@selector(securityChange:) forControlEvents:UIControlEventTouchUpInside];
     [_v2 setImage:[UIImage imageNamed:@"密码不可见"] forState:UIControlStateNormal];
    self.yuanmiamaTF.rightView =_v;
    self.yuanmiamaTF.placeholder = NSLocalizedString(@"请输入原密码", nil);
    self.yuanmiamaTF.secureTextEntry = YES;
    self.yuanmiamaTF.rightViewMode = UITextFieldViewModeAlways;
    self.xinmimaTF.rightView= _v1;
    self.xinmimaTF.placeholder = NSLocalizedString(@"请输入新密码", nil);
    self.xinmimaTF.secureTextEntry = YES;
    self.xinmimaTF.rightViewMode = UITextFieldViewModeAlways;
    self.querenxinmimaTF.rightView = _v2;
     self.querenxinmimaTF.placeholder = NSLocalizedString(@"请再次输入新密码", nil);
    self.querenxinmimaTF.secureTextEntry = YES;
    self.querenxinmimaTF.rightViewMode = UITextFieldViewModeAlways;
    // Do any additional setup after loading the view.
}
-(void)securityChange:(UIButton *)btn{
    
    if (btn == _v) {
        self.yuanmiamaTF.secureTextEntry =  !self.yuanmiamaTF.secureTextEntry;
        if ( self.yuanmiamaTF.secureTextEntry == YES) {
            [_v setImage:[UIImage imageNamed:@"密码不可见"] forState:UIControlStateNormal];
        }else{
            
             [_v setImage:[UIImage imageNamed:@"密码可见"] forState:UIControlStateNormal];
        }
    }
    if (btn == _v1) {
        self.xinmimaTF.secureTextEntry =  !self.xinmimaTF.secureTextEntry;
        if ( self.xinmimaTF.secureTextEntry == YES) {
            [_v1 setImage:[UIImage imageNamed:@"密码不可见"] forState:UIControlStateNormal];
        }else{
            
            [_v1 setImage:[UIImage imageNamed:@"密码可见"] forState:UIControlStateNormal];
        }
    }
    if (btn == _v2) {
        self.querenxinmimaTF.secureTextEntry =  !self.querenxinmimaTF.secureTextEntry;
        if ( self.querenxinmimaTF.secureTextEntry == YES) {
            [_v2 setImage:[UIImage imageNamed:@"密码不可见"] forState:UIControlStateNormal];
        }else{
            
            [_v2 setImage:[UIImage imageNamed:@"密码可见"] forState:UIControlStateNormal];
        }
    }
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.yuanmiamaTF endEditing:YES];
    [self.xinmimaTF endEditing:YES];
    [self.querenxinmimaTF endEditing:YES];
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
