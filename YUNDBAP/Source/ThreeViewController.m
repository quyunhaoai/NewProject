//
//  ThreeViewController.m
//  NewCloudApp
//
//  Created by hao on 15/12/19.
//
//
#define screenW   [[UIScreen mainScreen] bounds].size.width

#define screenH  [[UIScreen mainScreen] bounds].size.height
#import "UIViewController+MJPopupViewController.h"
#import "ThreeViewController.h"
#import "AppDelegate.h"
@interface ThreeViewController ()
{
    double w;
    double h;
}
@end

@implementation ThreeViewController
@synthesize delegate;
-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:YES];
    self.view.alpha = 1;
//    self.view.frame = CGRectMake(200, 200, screenW, screenH);
    self.navigationItem.rightBarButtonItem.customView.hidden=YES;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    w= 1;
    h= 0.5;
    /**
    self.view.alpha = 0.0001;
    self.webView.alpha = 0.4;
    self.view.frame = CGRectMake(0, 0, screenW*w, screenH*h);
    self.view.center = CGPointMake(0, 0);
     **/
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    NSRange range = [self.url rangeOfString:@"site=qq"];
    NSRange weixin = [self.url rangeOfString:@"weixin://"];
    NSRange tims = [self.url rangeOfString:@"itms-services"];
    NSRange wpdQQ = [self.url rangeOfString:@"wpd.b.qqc.com"];
    NSRange dwz = [self.url rangeOfString:@"dwz.cn"];
    NSRange webqq2 = [self.url rangeOfString:@"mqqwpa://"];
    if (range.location != NSNotFound || weixin.location != NSNotFound|| tims.location != NSNotFound || wpdQQ.location != NSNotFound ||dwz.location !=NSNotFound|| webqq2.location != NSNotFound) {
        if (self.webView) {
            [self.webView loadRequest:request];
            [self performSelector:@selector(goBackView) withObject:self afterDelay:3];

        }else{
            self.webView = [[UIWebView alloc] init];
            self.webView.translatesAutoresizingMaskIntoConstraints = NO;
            self.webView.delegate = self;
            [self.webView loadRequest:request];
            [self performSelector:@selector(goBackView) withObject:self afterDelay:3];
        }
        return;
    }
        

            [self.wkWebView loadRequest:request];
    
    UISwipeGestureRecognizer *swiper = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(returnPath:)];
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    int a = [delegate.animation[1] intValue] ;
    switch (a) {
        case 0:
            swiper.direction = UISwipeGestureRecognizerDirectionRight;

            break;
        case 1:
            swiper.direction = UISwipeGestureRecognizerDirectionLeft;
            break;
        case 2:
            swiper.direction = UISwipeGestureRecognizerDirectionDown;
            break;
        case 3:
            swiper.direction = UISwipeGestureRecognizerDirectionUp;
            break;
            
        default:
            swiper.direction = UISwipeGestureRecognizerDirectionRight;
            break;
    }
       [self.view addGestureRecognizer:swiper];
    
    
}
- (void)showBackMenu {
    
    self.navigationItem.leftBarButtonItem.customView.hidden=NO;
    if (self.wkWebView) {
        /* self.wkWebView.allowsBackForwardNavigationGestures = YES;*/
    }else {
        /* self.webView.enablePanGesture = YES;*/
    }
}
- (void)hideBackMenu {
    self.navigationItem.leftBarButtonItem.customView.hidden=NO;
    if (self.wkWebView) {
        
    }else {
        
    }
}
- (void)showMenu {
    
    
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:^(BOOL finished) {
        NSLog(@"---%d",finished);
        
    }];
    
}
- (void)goBackView
{
    if (self.wkWebView) {
        if ([self.wkWebView canGoBack]) {
            [self.wkWebView goBack];
        }else {
            AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            delegate.isNewPageView = NO;
            int a = [delegate.animation[1] intValue] ;
            switch (a) {
                case 0:
                    [self dismissPopupViewControllerWithanimationType:6];
                    
                    break;
                case 1:
                    [self dismissPopupViewControllerWithanimationType:7];
                    break;
                case 2:
                    [self dismissPopupViewControllerWithanimationType:4];
                    break;
                case 3:
                    [self dismissPopupViewControllerWithanimationType:1];
                    break;
                    
                default:
                    [self dismissPopupViewControllerWithanimationType:7];
                    break;
            }
        }
    }else {
        if ([self.webView canGoBack]) {
            [self.webView goBack];
        }
    }
    
    
}


-(void)returnPath:(UIPanGestureRecognizer *)pan
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(cancelButtonClicked:)]) {
        NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:@"AnimationType"];
        self.outType = array[1] ;
        [self.delegate cancelButtonClicked:self.outType];
    }
    
}
@end
