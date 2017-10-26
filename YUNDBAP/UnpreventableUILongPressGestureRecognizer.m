//
//  UnpreventableUILongPressGestureRecognizer.m
//  CloudApp
//
//  Created by 9vs on 15/1/19.
//  Copyright (c) 2015年 zitian. All rights reserved.
//

#import "UnpreventableUILongPressGestureRecognizer.h"

@implementation UnpreventableUILongPressGestureRecognizer
- (BOOL)canBePreventedByGestureRecognizer:(UIGestureRecognizer *)preventedGestureRecognizer {
    return NO;
}
@end
