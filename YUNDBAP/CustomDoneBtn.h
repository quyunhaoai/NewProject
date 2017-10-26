//
//  CustomDoneBtn.h
//  WebViewAD
//
//  Created by hw on 16/3/4.
//  Copyright © 2016年 hw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomDoneBtn : UIButton
- (instancetype)initWithFrame:(CGRect)frame time:(int)mytime;
@property (copy, nonatomic) void (^completionHandler)();
@end
