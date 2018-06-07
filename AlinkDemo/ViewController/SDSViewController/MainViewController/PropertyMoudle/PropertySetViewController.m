//
//  PropertySetViewController.m
//  AlinkDemo
//
//  Created by gubeidianzi on 2017/11/23.
//  Copyright © 2017年 aliyun. All rights reserved.
//

#import "PropertySetViewController.h"
#import "CommonTimeTableViewCell.h"
#import "PropertyTableViewCell.h"
#import "ChangeNameViewController.h"
#import "SheBeiDetailModel.h"
#import "relAccountsModel.h"
#import "DeviceShareViewController.h"
#import "TheFirmwareUpdateViewController.h"
@interface PropertySetViewController ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate>
 @property (nonatomic,strong)SheBeiDetailModel * DetailModel ;
@end

@implementation PropertySetViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated  ];
    self.navigationController.navigationBar.barTintColor = [CommonUtil getColor:@"#EFEFF1"];
    self.tabBarController.tabBar.hidden = YES;
    self.dataSource = [[NSMutableArray alloc]init];
    [self.myTable reloadData];
     //[self getData];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    [self changeleftItem];
    self.title =NSLocalizedString(@"属性", nil) ;
    [self setTheUI];
   
    // Do any additional setup after loading the view.
}
-(void)setTheUI{
    self.myTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 255) style:UITableViewStylePlain];
    self.myTable.delegate = self;
    self.myTable.dataSource = self;
    self.myTable.backgroundColor = Gray_Color;
    self.myTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.myTable registerNib:[UINib nibWithNibName:@"CommonTimeTableViewCell" bundle:nil] forCellReuseIdentifier:@"CommonTimeTableViewCell"];
    [self.myTable registerNib:[UINib nibWithNibName:@"PropertyTableViewCell" bundle:nil] forCellReuseIdentifier:@"PropertyTableViewCell"];
    [self.view addSubview:self.myTable];
    
    UIButton * deleteBTN = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteBTN.frame = CGRectMake(0, SCREEN_HEIGHT-150, SCREEN_WIDTH, 50);
    [self.view addSubview:deleteBTN];
    deleteBTN.layer.borderWidth = 0.2;
    deleteBTN.backgroundColor = [UIColor whiteColor];
    [deleteBTN addTarget:self action:@selector(delete) forControlEvents:UIControlEventTouchUpInside];
    [deleteBTN.titleLabel setFont:[UIFont systemFontOfSize:19]];
    [deleteBTN setTitle:NSLocalizedString(@"删除设备", nil)  forState:UIControlStateNormal];
    [deleteBTN setTitleColor:[UIColor redColor] forState:(UIControlState)UIControlStateNormal];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"addDevSUC" object:nil];
        WeakSelf
        /**
         Delete module from family
         
         @param moduleId            Delete module ID
         @param familyId            Family ID
         @param version             Family current version
         @param completionHandler   Callback with delete result
         */
        //    - (void)delModuleWithId:(nonnull NSString *)moduleId fromFamilyId:(nonnull NSString *)familyId familyVersion:(nullable NSString *)version completionHandler:(nullable void (^)(BLModuleControlResult * __nonnull result))completionHandler;
        [UsingHUD showInView:self.view];
        [[BLLet sharedLet].familyManager delModuleWithId:[SDSFamliyManager sharedInstance].deFaInfoData.moduleInfo.moduleId fromFamilyId:[SDSFamliyManager sharedInstance].famliyID familyVersion:[SDSFamliyManager sharedInstance].familyVer completionHandler:^(BLModuleControlResult * _Nonnull result) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [UsingHUD hideInView:weakSelf.view];
                if (result.error == 0) {
                    [SDSsqlite deleteDeviceWithDeviceDid:[SDSFamliyManager sharedInstance].deFaInfoData.deviceInfo.did];
                    [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                    
                }else if (result.error == -2014) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [CommonUtil setTip:@"设备已删除"];
                    });
                }else{
                    [[BLLet sharedLet].account refreshAccessTokenWithRefreshToken:[UserInfoManager sharedTool].RefreshToken clientId:LiangBaClientID clientSecret:CLIENT_SECRET completionHandler:^(BLOauthResult * _Nonnull result) {
                        
                        [[NSUserDefaults standardUserDefaults]setObject:result.refreshToken forKey:REFRESHTOKEN];
                        [[NSUserDefaults standardUserDefaults]setObject:result.accessToken forKey:DEVICETOKEN];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        [[BLLet sharedLet].familyManager delModuleWithId:[SDSFamliyManager sharedInstance].deFaInfoData.moduleInfo.moduleId fromFamilyId:[SDSFamliyManager sharedInstance].famliyID familyVersion:[SDSFamliyManager sharedInstance].familyVer completionHandler:^(BLModuleControlResult * _Nonnull result) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [UsingHUD hideInView:weakSelf.view];
                                if (result.error == 0) {
                                     [SDSsqlite deleteDeviceWithDeviceDid:[SDSFamliyManager sharedInstance].deFaInfoData.deviceInfo.did];
                                    [weakSelf.navigationController popToRootViewControllerAnimated:YES];
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
    }
}
-(void)delete{
    
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"" message:NSLocalizedString(@"确定删除设备", nil)  delegate:self cancelButtonTitle:NSLocalizedString(@"取消", nil) otherButtonTitles:NSLocalizedString(@"确定", nil), nil];
    [alert show];
   
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    if (indexPath.section == 1  ) {
        PropertyTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PropertyTableViewCell"];
        if (cell == nil) {
            cell.backgroundColor = [UIColor whiteColor];
            cell = [[PropertyTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PropertyTableViewCell"];
         
        }
        NSString *str = [SDSFamliyManager sharedInstance].deFaInfoData.moduleInfo.iconPath;
        if ([str isEqualToString:@"X23-X30"] || [str isEqualToString:@"X90"]) {
            cell.imageV.image = [UIImage imageNamed:str];
        }else if ([str hasPrefix:@"file"]){
            cell.imageV.image = [UIImage imageNamed:@"X23-X30"];
        }else{
            [cell.imageV sd_setImageWithURL:[NSURL URLWithString:[SDSFamliyManager sharedInstance].deFaInfoData.moduleInfo.iconPath] placeholderImage:[UIImage imageNamed:@"FY_背景图片"]];
        }
        cell.name.text =NSLocalizedString(@"设备图片", nil) ;
        return cell;
    }else{
        
        CommonTimeTableViewCell * commonCell = [tableView  dequeueReusableCellWithIdentifier:@"CommonTimeTableViewCell"];
        commonCell.backgroundColor = [UIColor whiteColor];
        if (commonCell == nil) {
            commonCell = [[CommonTimeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CommonTimeTableViewCell"];
        }
        
        if (indexPath.section == 0 ) {
            
            commonCell.leftNameL.text = NSLocalizedString(@"设备名称", nil);
            commonCell.RightNameL.text = [SDSFamliyManager sharedInstance].deFaInfoData.moduleInfo.name;
         
          
        }
        if (indexPath.section == 2) {
            commonCell.leftNameL.text =NSLocalizedString(@"固件升级", nil);
            commonCell.Line.hidden = YES;
            commonCell.RightNameL.text = @"";
         
        }
       

        return commonCell;
     }
    return nil;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * v = [[UIView alloc  ]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    v.backgroundColor = Gray_Color;
    return v;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section== 0 ||section==1) {
        return 0;
    }
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (section== 0 ||section==1) {
        return 0.1;
    }
    return 0.1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 ) {
        return 85;
    }
    return 50;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (indexPath.section == 0) {
        CommonTimeTableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        ChangeNameViewController * vc = [[ChangeNameViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        vc.name = [SDSFamliyManager sharedInstance].deFaInfoData.moduleInfo.name;
        vc.back = ^(NSString *text) {
            cell.RightNameL.text = text;
        };
    }
    if (indexPath.section == 1) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle: UIAlertControllerStyleActionSheet];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:nil];
        if (ios9_Last) {
            [cancelAction setValue:[UIColor orangeColor] forKey:@"titleTextColor"];
        }
        UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"拍照", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
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
        if (ios9_Last) {
          [deleteAction setValue:[UIColor blackColor] forKey:@"titleTextColor"];
        }
      
        UIAlertAction *archiveAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"从手机相册选择", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
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
        if (ios9_Last) {
         [archiveAction setValue:[UIColor blackColor] forKey:@"titleTextColor"];
        }
       
        [alertController addAction:cancelAction];
        [alertController addAction:deleteAction];
        [alertController addAction:archiveAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
    if (indexPath.section == 2) {
        
        TheFirmwareUpdateViewController *vc = [[TheFirmwareUpdateViewController   alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    
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
//        /ec4/v1/system/addpic
        
        [[BLLet sharedLet].familyManager familyMultipartPost:@"/ec4/v1/system/addpic" head:@{@"head":@""} body: @{@"userid":[DATACache valueForKey:@"ACCOUNT"]}  image:newPhoto completionHandler:^(NSData * _Nonnull data, NSError * _Nullable error) {
            if (data) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [UsingHUD hideInView:weakSelf.view ];
                    
                    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//                    NSLog(@"%@",dictionary);

//                    {
//                        error = 0;
//                        msg = ok;
//                        picpath = "https://1497ee24cbf2367decc3f8edd04d3cf4bizihcv0.ibroadlink.com/ec4pic/67/f8/a97bf3efcf8acd9705f7fb201641.png";
//                        status = 0;
//                    }
                            BLModuleInfo * info = [[BLModuleInfo alloc]init];
                            info = [SDSFamliyManager sharedInstance].deFaInfoData.moduleInfo;
                            info.iconPath =[dictionary valueForKey:@"picpath"];
                            [UsingHUD showInView:self.view];
                            [[BLLet sharedLet].familyManager modifyModule:info fromFamilyId:[SDSFamliyManager sharedInstance].famliyID familyVersion:[SDSFamliyManager sharedInstance].familyVer completionHandler:^(BLModuleControlResult * _Nonnull result) {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [UsingHUD hideInView:weakSelf.view];
                                    if (result.error == 0) {
                                         NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:1];
                                        PropertyTableViewCell *cell = [self.myTable cellForRowAtIndexPath:path];
                                        [cell.imageV sd_setImageWithURL:[NSURL URLWithString:[dictionary valueForKey:@"picpath"]]  placeholderImage:[UIImage imageNamed:@"默认头像"]];
                                        [SDSsqlite UpdateDeviceImage:[dictionary valueForKey:@"picpath"] WithDid:[SDSFamliyManager sharedInstance].deFaInfoData.deviceInfo.did];
                                        [[NSUserDefaults standardUserDefaults]setObject:result.version forKey:@"FAMILYVERSION"];
//                                        [weakSelf.navigationController popViewControllerAnimated:YES];
                    
                                    }else{
                                        [[BLLet sharedLet].account refreshAccessTokenWithRefreshToken:[UserInfoManager sharedTool].RefreshToken clientId:LiangBaClientID clientSecret:CLIENT_SECRET completionHandler:^(BLOauthResult * _Nonnull result) {
                                            
                                            [[NSUserDefaults standardUserDefaults]setObject:result.refreshToken forKey:REFRESHTOKEN];
                                            [[NSUserDefaults standardUserDefaults]setObject:result.accessToken forKey:DEVICETOKEN];
                                            [[NSUserDefaults standardUserDefaults] synchronize];
                                            
                                            [[BLLet sharedLet].familyManager modifyModule:info fromFamilyId:[SDSFamliyManager sharedInstance].famliyID familyVersion:[SDSFamliyManager sharedInstance].familyVer completionHandler:^(BLModuleControlResult * _Nonnull result) {
                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                    [UsingHUD hideInView:weakSelf.view];
                                                    if (result.error == 0) {
                                                        NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:1];
                                                        PropertyTableViewCell *cell = [self.myTable cellForRowAtIndexPath:path];
                                                        [cell.imageV sd_setImageWithURL:[NSURL URLWithString:[dictionary valueForKey:@"picpath"]]  placeholderImage:[UIImage imageNamed:@"默认头像"]];
                                                          [SDSsqlite UpdateDeviceImage:[dictionary valueForKey:@"picpath"] WithDid:[SDSFamliyManager sharedInstance].deFaInfoData.deviceInfo.did];
                                                        [[NSUserDefaults standardUserDefaults]setObject:result.version forKey:@"FAMILYVERSION"];
                                                        //                                        [weakSelf.navigationController popViewControllerAnimated:YES];
                                                        
                                                    }else{
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            [UsingHUD hideInView:weakSelf.view];
                                                            if ([CommonUtil isLoginExpired:error.code]) {
                                                                
                                                                NSLog(@"session过期了 需要重新登录");
                                                                
                                                            }else{
                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                    [CommonUtil setTip:result.msg];
                                                                });
                                                            }
                                                        });
                                                        
                                                    }
                                                });
                                            }];
                                        }];
                                    }
                                });
                               }];
                    });
              }
            if (error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                   [UsingHUD hideInView:weakSelf.view ];
                    if ([CommonUtil isLoginExpired:error.code]) {
                        
                        NSLog(@"session过期了 需要重新登录");
                        
                    }else{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [CommonUtil setTip:error.userInfo[ERROR_MESSAGE]];
                        });
                    }
                    
                });
            }
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
