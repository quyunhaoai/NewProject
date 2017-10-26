//
//  HwReaderViewController.m
//  CloudApp
//
//  Created by 9vs on 15/1/31.
//
//

#import "HwReaderViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "HwTwoPageViewController.h"
#import "UIAlertView+Blocks.h"
#import "AFSoundManager.h"
@interface HwReaderViewController () <AVCaptureMetadataOutputObjectsDelegate>
@property(strong,nonatomic) AVCaptureSession *session; // 二维码生成的会话
@property(strong,nonatomic) AVCaptureVideoPreviewLayer *previewLayer;

@property (weak, nonatomic) IBOutlet UIImageView *centerImageView;
@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) UIImageView *lineImgView;
@end

@implementation HwReaderViewController

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    [self startReader];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
   self.title = NSLocalizedString(@"qrscan", nil);
    self.centerImageView.image = [UIImage imageNamed:@"reader_kuang"];
    
    self.lineImgView = [[UIImageView alloc] init];
    self.lineImgView.image = [UIImage imageNamed:@"reader_line"];
    self.lineImgView.frame = CGRectMake(0, 0, self.centerImageView.frame.size.width, 1);
    [self.centerImageView addSubview:self.lineImgView];
    [self readQRcode];
    
    
}
- (void)startReader {
    if (self.session) {
        [self.session startRunning];
    }
    if (!self.timer) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(updateLineLoc) userInfo:nil repeats:YES];
    }
    
    
}
- (void)updateLineLoc {
    CGRect rect = self.lineImgView.frame;
    if (rect.origin.y >= self.centerImageView.frame.size.height) {
        rect.origin.y = 0;
    }else {
        rect.origin.y += 1;
    }
    self.lineImgView.frame = rect;
}

- (void)readQRcode {
    // 1. 摄像头设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    // 2. 设置输入
    // 因为模拟器是没有摄像头的，因此在此最好做一个判断
    NSError *error = nil;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    if (error) {
        NSLog(@"没有摄像头-%@", error.localizedDescription);
        return;
    }
    // 3. 设置输出(Metadata元数据)
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    // 3.1 设置输出的代理
    // 说明：使用主线程队列，相应比较同步，使用其他队列，相应不同步，容易让用户产生不好的体验
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    //    [output setMetadataObjectsDelegate:self queue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    
    // 4. 拍摄会话
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    // 添加session的输入和输出
    [session addInput:input];
    [session addOutput:output];
    // 4.1 设置输出的格式
    // 提示：一定要先设置会话的输出为output之后，再指定输出的元数据类型！
    [output setMetadataObjectTypes:@[AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code,AVMetadataObjectTypeQRCode]];
    

    
    // 5. 设置预览图层（用来让用户能够看到扫描情况）
    AVCaptureVideoPreviewLayer *preview = [AVCaptureVideoPreviewLayer layerWithSession:session];
    // 5.1 设置preview图层的属性
    [preview setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    // 5.2 设置preview图层的大小
    [preview setFrame:[UIScreen mainScreen].bounds];
    // 5.3 将图层添加到视图的图层
    [self.view.layer insertSublayer:preview atIndex:0];
    self.previewLayer = preview;
    
    self.session = session;
//    // 6. 启动会话
    [self startReader];
    
    
}
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    // 会频繁的扫描，调用代理方法
    // 1. 如果扫描完成，停止会话
    [self.session stopRunning];
    // 2. 删除预览图层
//    [self.previewLayer removeFromSuperlayer];
    
//    NSLog(@"%@", metadataObjects);
    // 3. 设置界面显示扫描结果
    
    if (metadataObjects.count > 0) {
        AVMetadataMachineReadableCodeObject *obj = metadataObjects[0];
        // 提示：如果需要对url或者名片等信息进行扫描，可以在此进行扩展！
        NSLog(@"=======%@",obj.stringValue);
        [[AFSoundManager sharedManager] startPlayingLocalFileWithName:@"qrcode_found.wav" andBlock:^(int percentage, CGFloat elapsedTime, CGFloat timeRemaining, NSError *error, BOOL finished) {
            
        }];
        
        if (self.timer) {
            [self.timer invalidate];
            self.timer = nil;
        }
        
        if (self.completionHandler) {
            self.completionHandler(obj.stringValue);
            [self goBackView];
            return;

        }
        NSRange httpRange = [obj.stringValue rangeOfString:@"http"];
        if (httpRange.location != NSNotFound) {
            HwTwoPageViewController *two = [[HwTwoPageViewController alloc] initWithNibName:@"HwOnePageViewController" bundle:nil];
            two.urlStr = obj.stringValue;
            [self.navigationController pushViewController:two animated:YES];
//            if (!self.isGetScan) {
//                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:obj.stringValue]];
//            }
            
        }else {
            if (!self.completionHandler) {
                [UIAlertView showAlertViewWithTitle:NSLocalizedString(@"goodInfo", nil) message:obj.stringValue cancelButtonTitle:NSLocalizedString(@"cancel", nil) otherButtonTitles:@[NSLocalizedString(@"try_again", nil)] onDismiss:^(int buttonIndex, UIAlertView *alertView) {
                    [self startReader];
                } onCancel:^{
                    
                }];
            }
        }
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
