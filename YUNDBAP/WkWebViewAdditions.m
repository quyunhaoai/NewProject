//
//  WkWebViewAdditions.m
//  NewCloudApp
//
//  Created by 9vs on 15/5/28.
//
//

#import "WkWebViewAdditions.h"

@implementation WKWebView (WkWebViewAdditions)

- (CGSize)windowSize
{
    CGSize size;
//    size.width = [[self stringByEvaluatingJavaScriptFromString:@"window.innerWidth"] integerValue];
//    size.height = [[self stringByEvaluatingJavaScriptFromString:@"window.innerHeight"] integerValue];
    return size;
}

- (CGPoint)scrollOffset
{
    CGPoint pt;
//    pt.x = [[self stringByEvaluatingJavaScriptFromString:@"window.pageXOffset"] integerValue];
//    pt.y = [[self stringByEvaluatingJavaScriptFromString:@"window.pageYOffset"] integerValue];
    return pt;
}

@end
