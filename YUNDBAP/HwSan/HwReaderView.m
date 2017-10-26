//
//  HwReaderView.m
//  NewCloudAppAPS
//
//  Created by hw on 16/11/17.
//
//

#import "HwReaderView.h"
#import <AVFoundation/AVFoundation.h>
#import "UIAlertView+Blocks.h"
#import "HwOnePageViewController.h"
#import "AFSoundManager.h"
@interface HwReaderView() <AVCaptureMetadataOutputObjectsDelegate>
@property(strong,nonatomic) AVCaptureSession *session; // 二维码生成的会话
@property(strong,nonatomic) AVCaptureVideoPreviewLayer *previewLayer;

@property (strong, nonatomic) UIImageView *centerImageView;
@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) UIImageView *lineImgView;
@end

@implementation HwReaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupScanView:frame];
    }
    return self;
}

- (void)setupScanView:(CGRect)sFrame {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    
    self.centerImageView = [[UIImageView alloc] init];
    self.centerImageView.frame = CGRectMake(5, 5, sFrame.size.width - 10, sFrame.size.height - 10);
    self.centerImageView.image = [UIImage imageNamed:@"reader_kuang"];
    [self addSubview:self.centerImageView];
    self.lineImgView = [[UIImageView alloc] init];
    self.lineImgView.image = [UIImage imageNamed:@"reader_line"];
    self.lineImgView.frame = CGRectMake(0, 0, self.centerImageView.frame.size.width, 1);
    [self.centerImageView addSubview:self.lineImgView];
    [self readQRcode];

     [self startReader];
    
    
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
    [preview setFrame:self.bounds];
    // 5.3 将图层添加到视图的图层
    [self.layer insertSublayer:preview atIndex:0];
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
            return;
            
        }
        NSRange httpRange = [obj.stringValue rangeOfString:@"http"];
        if (httpRange.location != NSNotFound) {
//            HwOnePageViewController *one = [[HwOnePageViewController alloc] initWithNibName:@"HwOnePageViewController" bundle:nil];
//            one.currentUrlStr = obj.stringValue;
//            [self.navigationController pushViewController:two animated:YES];
          
            
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

@end
