//
//  MyWebViewAdditions.m
//  WebviewCache
//
//  Created by 9vs on 15/5/13.
//  Copyright (c) 2015年 9vs. All rights reserved.
//

#import "MyWebViewAdditions.h"

@implementation UIWebView (MyWebViewAdditions)
- (NSString*)title
{
    return [self stringByEvaluatingJavaScriptFromString:@"document.title"];
}

- (NSURL*)url
{
    NSString *urlString = [self stringByEvaluatingJavaScriptFromString:@"location.href"];
    if (urlString) {
        return [NSURL URLWithString:urlString];
    } else {
        return nil;
    }
}

@end
