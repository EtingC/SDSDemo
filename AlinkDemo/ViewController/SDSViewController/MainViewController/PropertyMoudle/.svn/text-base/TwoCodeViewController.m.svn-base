//
//  TwoCodeViewController.m
//  AlinkDemo
//
//  Created by gubeidianzi on 2017/11/24.
//  Copyright © 2017年 aliyun. All rights reserved.
//

#import "TwoCodeViewController.h"
#import <CoreImage/CoreImage.h>
#import "ShareModel.h"
@interface TwoCodeViewController ()
@property (nonatomic,strong) UIImageView * CodeimageV;
@end

@implementation TwoCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self changeleftItem];
    self.title = @"设备分享";
    [self setTheCode];
    [self getCode];
    // Do any additional setup after loading the view.
}
-(void)getCode{
    WeakSelf
    [[NetworkTool sharedTool]requestWithURLparameters:@{@"uuid":DEVICEMoudleManger.listModel.uuid} method:@"mtop.openalink.app.core.user.saveqr" View:self.view sessionExpiredOption:1 needLogin:YES callBack:^(AlinkResponse *responseObject) {
        if (responseObject) {
            
            ShareModel *model = [ShareModel mj_objectWithKeyValues:responseObject.dataObject];
            CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
            // 滤镜恢复默认设置
            [filter setDefaults];
            
            // 2. 给滤镜添加数据
            NSString *string = model.qrKey;
            NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
            // 使用KVC的方式给filter赋值
            [filter setValue:data forKeyPath:@"inputMessage"];
            
            // 3. 生成二维码
            CIImage *image = [filter outputImage];
           UIImage * image1 = [weakSelf createNonInterpolatedUIImageFormCIImage:image withSize:weakSelf.CodeimageV.frame.size.width];
            // 4. 显示二维码
            weakSelf.CodeimageV.image = image1;
        }
    } errorBack:^(id error) {
        
    }];
}
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size {
    
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}
-(void)setTheCode{
    double percent = 0.53 ; //宽 与 屏幕的比例  210/395
    self.CodeimageV = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-SCREEN_WIDTH*percent)/2 , 99, SCREEN_WIDTH*percent, SCREEN_WIDTH*percent)];
    [self.view addSubview:self.CodeimageV];
    self.CodeimageV.backgroundColor = [UIColor whiteColor];
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.CodeimageV.frame), CGRectGetMaxY(self.CodeimageV.frame)+8, self.CodeimageV.frame.size.width, 70)];
    label.backgroundColor = [UIColor clearColor];
    [self.view addSubview:label];
    label.text = @"扫描二维码即可控制该设备\n此二维码五分钟之内有效";
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines=0;
    label.textColor = [UIColor blackColor];
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
