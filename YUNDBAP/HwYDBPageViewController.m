//
//  HwYDBPageViewController.m
//  CloudApp
//
//  Created by 9vs on 15/3/13.
//
//

#import "HwYDBPageViewController.h"
#import "AppDelegate.h"

@interface HwYDBPageViewController ()

@end

@implementation HwYDBPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

  
    self.navigationItem.titleView = nil;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor],
                                                                    NSFontAttributeName : [UIFont boldSystemFontOfSize:18]};
    self.navigationItem.leftBarButtonItem.customView.hidden = NO;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]];
    if (self.urlStr.length > 0) {
        [self.webView loadRequest:request];
    }

    
}
- (void)goBackView
{
    if (self.wkWebView) {
        if ([self.wkWebView canGoBack]) {
            [self.wkWebView goBack];
        }else {
            AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [delegate showMainVC];
        }
    }else {
        if ([self.webView canGoBack]) {
            [self.webView goBack];
        }else {
            AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [delegate showMainVC];
        }
    }
}
- (void)updateLoadingStatus {
    self.navigationItem.leftBarButtonItem.customView.hidden = NO;
    if (self.jsCustomTitleStr.length > 0) {
        self.navigationItem.titleView = nil;
        self.title = self.jsCustomTitleStr;
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
    
    
    self.title = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
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
