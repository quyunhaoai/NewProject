//
//  WkWebViewAdditions.h
//  NewCloudApp
//
//  Created by 9vs on 15/5/28.
//
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
@interface WKWebView (WkWebViewAdditions)
- (CGSize)windowSize;
- (CGPoint)scrollOffset;
@end
