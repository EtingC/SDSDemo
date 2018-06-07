//
//  JibenSheZhiViewController.m
//  AlinkDemo
//
//  Created by gubeidianzi on 2017/11/6.
//  Copyright © 2017年 aliyun. All rights reserved.
//

#import "JibenSheZhiViewController.h"
#import "BianJiViewController.h"
#import "PassWordViewController.h"

#import <AKDevKit/AKOpenDevKit.h>
#import <AlinkSDK/AlinkOpenSDK.h>
#import <UTDID/UTDevice.h>
#import "LoginViewController.h"
#import <AssetsLibrary/ALAsset.h>

#import <AssetsLibrary/ALAssetsLibrary.h>

#import <AssetsLibrary/ALAssetsGroup.h>

#import <AssetsLibrary/ALAssetRepresentation.h>
#import "LiangBaLoginViewController.h"
@interface JibenSheZhiViewController ()<UIActionSheetDelegate,UIGestureRecognizerDelegate,UIAlertViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic,strong)UITapGestureRecognizer *tap1;
@property (weak, nonatomic) IBOutlet UIButton *logoutBTN;
@property (weak, nonatomic) IBOutlet UILabel *NICKNameL;
@property (weak, nonatomic) IBOutlet UILabel *ImageL;
@property (weak, nonatomic) IBOutlet UILabel *ChangePasswordL;
@property (nonatomic,strong)UITapGestureRecognizer *tap2;
@end

@implementation JibenSheZhiViewController
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
  
    self.tabBarController.tabBar.hidden = NO;
}
- (IBAction)changeNameAction:(id)sender {
    BianJiViewController * vc = [[BianJiViewController   alloc]init];
    vc.callblock = ^(NSString *progress) {
        self.nameL.text = progress;
    };
    [self.navigationController pushViewController:vc animated:YES]; 
}
- (IBAction)changeImageAction:(id)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle: UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil)  style:UIAlertActionStyleCancel handler:nil];
    if ([Device_Ver doubleValue]>=9.0) {
        [cancelAction setValue:[CommonUtil getColor:@"#333333"] forKey:@"titleTextColor"];
    }
    
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"拍照", nil)  style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        /**
         其实和从相册选择一样，只是获取方式不同，前面是通过相册，而现在，我们要通过相机的方式
         */
        UIImagePickerController *PickImage = [[UIImagePickerController alloc]init];
        //获取方式，通过相机
        PickImage.sourceType = UIImagePickerControllerSourceTypeCamera;
        PickImage.allowsEditing = YES;
        PickImage.delegate = self;
        [self presentViewController:PickImage animated:YES completion:nil];
        
    }];
    if ([Device_Ver doubleValue]>=9.0) {
        [deleteAction setValue:[CommonUtil getColor:@"#333333"] forKey:@"titleTextColor"];
    }
    
    UIAlertAction *archiveAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"从手机相册选择", nil)  style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *PickerImage = [[UIImagePickerController alloc]init];
        //获取方式1：通过相册（呈现全部相册），UIImagePickerControllerSourceTypePhotoLibrary
        //获取方式2，通过相机，UIImagePickerControllerSourceTypeCamera
        //获取方法3，通过相册（呈现全部图片），UIImagePickerControllerSourceTypeSavedPhotosAlbum
        PickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        //允许编辑，即放大裁剪
        PickerImage.allowsEditing = YES;
        //自代理
        PickerImage.delegate = self;
        //页面跳转
        [self presentViewController:PickerImage animated:YES completion:nil];
    }];
    if ([Device_Ver doubleValue]>=9.0) {
        [archiveAction setValue:[CommonUtil getColor:@"#333333"] forKey:@"titleTextColor"];
    }
    
    [alertController addAction:cancelAction];
    [alertController addAction:deleteAction];
    [alertController addAction:archiveAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
    
}
/**
 跳转到修改密码界面
 
 @param sender 密码
 */
- (IBAction)changePasswordAction:(id)sender {
    
    UIStoryboard * strory = [UIStoryboard  storyboardWithName:@"LeftMenuViewController" bundle:[NSBundle mainBundle]];
    PassWordViewController *vc = [strory instantiateViewControllerWithIdentifier:@"password"];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
     self.tabBarController.tabBar.hidden = YES;
    self.nameL.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"NICKNAME"];
    NSString *url =[[NSUserDefaults standardUserDefaults]objectForKey:@"ICONURL"];
   
    [self.imagePhoto sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"默认头像"]];
    self.imagePhoto.layer.cornerRadius = self.imagePhoto.frame.size.width/2;
    self.imagePhoto.layer.masksToBounds = YES;
    
   
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self changeleftItem];
    self.view.backgroundColor = [CommonUtil getColor:@"#F3F3F3"];
    self.logoutBTN.layer.borderWidth= 0.5;
    self.logoutBTN.layer.borderColor = [UIColor grayColor].CGColor;
    self.title =NSLocalizedString(@"账号设置", nil) ;
    self.NICKNameL.text = NSLocalizedString(@"昵称", nil  );
    self.ImageL.text =NSLocalizedString(@"头像", nil  );
    self.ChangePasswordL.text =NSLocalizedString(@"修改密码", nil  );
    [self.logoutBTN setTitle:NSLocalizedString(@"退出登录", nil) forState:UIControlStateNormal];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    
    // Do any additional setup after loading the view.
}
#pragma mark - PickerImage完成后的代理方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *newPhoto = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    CGSize size = CGSizeMake(150, 150);
    newPhoto  = [self imageWithImageSimple:newPhoto scaledToSize:size];
    NSString *cachePath = CACHE_PATH;
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSString *DateTime = [formatter stringFromDate:date];
    cachePath = [NSString stringWithFormat:@"%@/%@",cachePath,DateTime];
    
    NSString * imagepath = cachePath;
    [UIImagePNGRepresentation(newPhoto) writeToFile:imagepath atomically:YES];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        [UsingHUD showInView:self.view];
        WeakSelf
        [BLLetAccount modifyUserIcon:imagepath completionHandler:^(BLModifyUserIconResult * _Nonnull result) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [UsingHUD hideInView:weakSelf.view];
                if (result.error == 0) {
                     [self.imagePhoto sd_setImageWithURL:[NSURL URLWithString:result.iconUrl]  placeholderImage:[UIImage imageNamed:@"默认头像"]];
                    [[NSUserDefaults standardUserDefaults]setObject:result.iconUrl forKey:@"ICONURL"];
                    [[NSUserDefaults standardUserDefaults]synchronize];
                    
                }else{
                    [[BLLet sharedLet].account refreshAccessTokenWithRefreshToken:[UserInfoManager sharedTool].RefreshToken clientId:LiangBaClientID clientSecret:CLIENT_SECRET completionHandler:^(BLOauthResult * _Nonnull result) {
                        
                        [[NSUserDefaults standardUserDefaults]setObject:result.refreshToken forKey:REFRESHTOKEN];
                        [[NSUserDefaults standardUserDefaults]setObject:result.accessToken forKey:DEVICETOKEN];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        [BLLetAccount modifyUserIcon:imagepath completionHandler:^(BLModifyUserIconResult * _Nonnull result) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [UsingHUD hideInView:weakSelf.view];
                                if (result.error == 0) {
                                    [self.imagePhoto sd_setImageWithURL:[NSURL URLWithString:result.iconUrl]  placeholderImage:[UIImage imageNamed:@"默认头像"]];
                                    [[NSUserDefaults standardUserDefaults]setObject:result.iconUrl forKey:@"ICONURL"];
                                    [[NSUserDefaults standardUserDefaults]synchronize];
                                    
                                }else{
                                    
                                    if ([CommonUtil isLoginExpired:result.error]) {
                                        
                                        NSLog(@"session过期了 需要重新登录");
                                        
                                    }else{
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            [CommonUtil setTip:result.msg];
                                        });
                                    }
                                }
                            });
                        }];
                    }];
                }
            });
        }];
    }];
}
//压缩图片
- (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    // End the context
    UIGraphicsEndImageContext();
    // Return the new image.
    return newImage;
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:^{}];
}

- (IBAction)loginout:(UIButton *)btn {
    
    __weak typeof(self)weakSelf = self;
    [UsingHUD showInView:self.view];
    if([[AlinkAccount sharedInstance] isLogin]){
        
        [[AlinkAccount sharedInstance] logout:^(NSError * _Nonnull error) {
            btn.enabled = YES;
            [UsingHUD hideInView:weakSelf.view];
            [[NSUserDefaults standardUserDefaults]setObject:@"NO" forKey:ISLOGIN];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:DEVICETOKEN];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:NICKNAME];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:ICONURL];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:ACCOUNT];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:SESSION];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:FAMILYID];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:FAMILYVERSION];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:USERID];
            
            UIStoryboard * strory = [UIStoryboard  storyboardWithName:@"LliangBaStoryBoard" bundle:[NSBundle mainBundle]];
            LiangBaLoginViewController *jibenvc = [strory instantiateViewControllerWithIdentifier:@"LiangBaLoginViewController"];
            NaviViewController *nav = [[NaviViewController alloc] initWithRootViewController:jibenvc];
            [[AppDelegate shareAppDelegate].window setRootViewController: nav];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }];
    }else{
        [UsingHUD hideInView:weakSelf.view];
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"已经处于登出状态" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
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
