//
//  HwTwoPageViewController.m
//  CloudApp
//
//  Created by 9vs on 15/1/30.
//
//

#import "HwTwoPageViewController.h"
#import "AppDelegate.h"
#import "UMMobClick/MobClick.h"
@interface HwTwoPageViewController ()

@end

@implementation HwTwoPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.titleView = nil;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor],
                                                                    NSFontAttributeName : [UIFont boldSystemFontOfSize:18]};
    self.navigationItem.leftBarButtonItem.customView.hidden = NO;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]];
    
    
    NSRange range = [self.urlStr rangeOfString:@"site=qq"];
    NSRange weixin = [self.urlStr rangeOfString:@"weixin://"];
    NSRange tims = [self.urlStr rangeOfString:@"itms-services"];
    NSRange wpdQQ = [self.urlStr rangeOfString:@"wpd.b.qq.com"];
    NSRange dwz = [self.urlStr rangeOfString:@"dwz.cn"];
    if (range.location != NSNotFound || weixin.location != NSNotFound|| tims.location != NSNotFound || wpdQQ.location != NSNotFound ||dwz.location !=NSNotFound) {
        if (self.webView) {
            [self.webView loadRequest:request];
        }else{
            self.webView = [[UIWebView alloc] init];
            self.webView.translatesAutoresizingMaskIntoConstraints = NO;
            self.webView.delegate = self;
            [self.webView loadRequest:request];
            [self.navigationController popViewControllerAnimated:NO];
        }
        return;
    }
    
    
    if (self.urlStr.length > 0) {
        if (self.wkWebView) {
            [self.wkWebView loadRequest:request];
        }else {
            [self.webView loadRequest:request];
        }
        
    }
    
    
    
    if ([self.ydbSetHeadBarStr isEqualToString:@"0"]) {
        self.navigationController.navigationBarHidden = YES;
    }
    if ([self.ydbSetHeadBarStr isEqualToString:@"1"]) {
        self.navigationController.navigationBarHidden = NO;
        if (self.wkWebView) {
            CGRect webViewRect = self.wkWebView.frame;
            webViewRect.origin.y = 0;
            webViewRect.size.height += 20;
            self.wkWebView.frame = webViewRect;
        }else {
            CGRect webViewRect = self.webView.frame;
            webViewRect.origin.y = 0;
            webViewRect.size.height += 20;
            self.webView.frame = webViewRect;
        }
        
    }
    if ([self.ydbSetDragRefreshStr isEqualToString:@"0"]) {
        if (self.wkWebView) {
            [self.wkWebView.scrollView removeHeader];
            self.wkWebView.scrollView.bounces = NO;
        }else {
            [self.webView.scrollView removeHeader];
            self.webView.scrollView.bounces = NO;
        }
        
        
    }
    if ([self.ydbSetDragRefreshStr isEqualToString:@"1"])  {
        if (self.wkWebView) {
            [self.wkWebView.scrollView addHeaderWithTarget:self action:@selector(reloadOrStop)];
            self.wkWebView.scrollView.bounces = YES;
        }else {
            [self.webView.scrollView addHeaderWithTarget:self action:@selector(reloadOrStop)];
            self.webView.scrollView.bounces = YES;
        }
        
        
    }
    if ([self.ydbSetMoreButtonStr isEqualToString:@"0"]) {
        self.navigationItem.rightBarButtonItem.customView.hidden = YES;
    }
    if ([self.ydbSetMoreButtonStr isEqualToString:@"1"]) {
        self.navigationItem.rightBarButtonItem.customView.hidden = NO;
    }
    if ([self.ydbSetPopUpStr isEqualToString:@"0"]) {
        
    }
    if (self.ydbSetTitleStr.length > 0) {
        self.navigationItem.titleView = nil;
        self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor],
                                                                        NSFontAttributeName : [UIFont boldSystemFontOfSize:18]};
        self.jsCustomTitleStr = [self.ydbSetTitleStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        self.isShowJsCustomTitle = YES;
    }else {
        self.isShowJsCustomTitle = NO;
    }
    
    
}


- (void)viewDidLayoutSubviews {
    
    self.wkWebView.scrollView.backgroundColor = [HwTools hexStringToColor:@"#ffffff"];

    StringsXmlBase *sssBase = [StringsXML getStringXmlBase];
    if ([sssBase.titleBarIsShow isEqualToString:@"0"] && [sssBase.adaptIOS7Nav isEqualToString:@"1"] && self.navigationController.navigationBarHidden && [sssBase.isClosePhoneState isEqualToString:@"1"]) {
        self.view.backgroundColor = [HwTools hexStringToColor:sssBase.statusbarBgColor];
        if (self.wkWebView) {
            CGRect webViewRect = self.wkWebView.frame;
            webViewRect.origin.y = 20;
            if (self.wkWebView.frame.origin.y != 20) {
                webViewRect.size.height -= 20;
                self.wkWebView.frame = webViewRect;
            }
        }else {
            CGRect webViewRect = self.webView.frame;
            webViewRect.origin.y = 20;
            if (self.webView.frame.origin.y != 20) {
                webViewRect.size.height -= 20;
                self.webView.frame = webViewRect;
            }
        }

        
    }
    
   
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
   
    self.navigationItem.leftBarButtonItem.customView.hidden = NO;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
}


- (void)addBackBtnItem {
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 8, 40, 40)];
    
    
    [button setImage:[UIImage imageNamed:@"icon_goback"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"icon_goback"] forState:UIControlStateHighlighted];
    [button setTitle:NSLocalizedString(@"back", nil) forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 10)];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -10)];
    [button setTintColor:[UIColor whiteColor]];
    
    
    [button addTarget:self action:@selector(goBackView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *btnItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    
    
    UIButton* button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button1 setFrame:CGRectMake(0, 8, 40, 40)];
    

    [button1 setTitle:NSLocalizedString(@"homePage", nil) forState:UIControlStateNormal];
    button1.titleLabel.font = [UIFont systemFontOfSize:15];

    [button1 setTintColor:[UIColor whiteColor]];
    
    
    [button1 addTarget:self action:@selector(goHomeView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *btnItem1 = [[UIBarButtonItem alloc] initWithCustomView:button1];
    
    
    
    if ([[HwTools UserDefaultsObjectForKey:IS_ENABLE_CLOSE] isEqualToString:@"YES"]) {
        self.navigationItem.leftBarButtonItems = @[btnItem,btnItem1];
    }else {
        self.navigationItem.leftBarButtonItem = btnItem;
    }
    
//    self.navigationItem.leftBarButtonItem = btnItem;
    
}
- (void)goHomeView {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshMyFrame" object:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)goBackView
{
        if (self.wkWebView) {
        if ([self.wkWebView canGoBack]) {
            [self.wkWebView goBack];
        }else {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshMyFrame" object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else {
        if ([self.webView canGoBack]) {
            [self.webView goBack];
        }else {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshMyFrame" object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}
- (void)updateLoadingStatus {
    self.navigationItem.leftBarButtonItem.customView.hidden = NO;
    if (self.jsCustomTitleStr.length > 0) {
        self.navigationItem.titleView = nil;
        self.title = self.jsCustomTitleStr;
    }
    if (self.ydbSetTitleStr.length > 0) {
        self.title = [self.ydbSetTitleStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {

    [self hideAldClock];
    [self updateLoadingStatus];
    self.reloadControl.hidden = YES;
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.sModel.sTitle = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
//    delegate.sModel.sContent =[NSString stringWithFormat:@"%@%@",delegate.sModel.sTitle,self.shareUrlStr];
    delegate.sModel.sContent = NSLocalizedString(@"shareEnterContent", nil);
    delegate.sModel.sUrl = self.shareUrlStr;

    if (!self.isShowJsCustomTitle) {
        self.title = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    }
    return;
    NSMutableArray *array = [[UXml shareUxml] jiexiXML:@"myxml" two:@"daohang"];
    if (array.count  == 1) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"ModifyLinkTargets" ofType:@"js"];
        NSString *jsCode = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        
        [webView stringByEvaluatingJavaScriptFromString:jsCode];
        
        [webView stringByEvaluatingJavaScriptFromString:@"MyIPhoneApp_ModifyLinkTargets()"];
        [webView stringByEvaluatingJavaScriptFromString:@"MyIPhoneApp_ModifyWindowOpen()"];
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
