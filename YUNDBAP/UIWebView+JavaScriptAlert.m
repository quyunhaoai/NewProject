//
//  UIWebView+JavaScriptAlert.m
//  UIAlertDemo
//
//  Created by 许谢良 on 2017/4/6.
//  Copyright © 2017年 许谢良. All rights reserved.
//

#import "UIWebView+JavaScriptAlert.h"
//#import "UIView+XLAlert.h"

@implementation UIWebView (JavaScriptAlert)

#pragma mark - js的alert-一个按钮
- (void)webView:(UIWebView *)sender runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(id)frame {
//    [self xl_showAlertWithMessage:message confirmHandler:^(UIAlertAction *confirmAction) {
//        
//    }];
    
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"goodInfo", nil) message:message preferredStyle:UIAlertControllerStyleAlert];
//    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"submit", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//       
//    }]];
////    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"cancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
////        completionHandler(NO);
////    }]];
//    [self presentViewController:alertController animated:YES completion:^{}];
    UIAlertView* customAlert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [customAlert show];
}


#pragma mark - js的confirm-两个按钮
static BOOL diagStat = NO;
static NSInteger bIdx = -1;
- (BOOL)webView:(UIWebView *)sender runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(id)frame {
//    [self xl_showAlertWithTitle:@"提示" message:message confirmTitle:@"确定" cancleTitle:@"取消" confirmHandle:^(UIAlertAction *confirmAction) {
//        bIdx = 1;
//    } cancleHandle:^(UIAlertAction *confirmAction) {
//        bIdx = 0;
//    }];
    UIAlertView *confirmDiag = [[UIAlertView alloc] initWithTitle:@"提示"
                                                          message:message
                                                         delegate:self
                                                cancelButtonTitle:@"取消"
                                                otherButtonTitles:@"确定", nil, nil];
    
    [confirmDiag show];
    bIdx = -1;
    
    while (bIdx==-1) {
        //[NSThread sleepForTimeInterval:0.2];
        [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1f]];
    }
    if (bIdx == 0){//取消;
        diagStat = NO;
    }
    else if (bIdx == 1) {//确定;
        diagStat = YES;
    }
    return diagStat;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    bIdx = buttonIndex;
}


@end
