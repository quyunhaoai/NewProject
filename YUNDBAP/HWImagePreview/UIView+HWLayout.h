//
//  UIView+HWLayout.h
//
//  Created by 谭真 on 15/2/24.
//  Copyright © 2015年 谭真. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    HWOscillatoryAnimationToBigger,
    HWOscillatoryAnimationToSmaller,
} HWOscillatoryAnimationType;

@interface UIView (HWLayout)

@property (nonatomic) CGFloat HW_left;        ///< Shortcut for frame.origin.x.
@property (nonatomic) CGFloat HW_top;         ///< Shortcut for frame.origin.y
@property (nonatomic) CGFloat HW_right;       ///< Shortcut for frame.origin.x + frame.size.width
@property (nonatomic) CGFloat HW_bottom;      ///< Shortcut for frame.origin.y + frame.size.height
@property (nonatomic) CGFloat HW_width;       ///< Shortcut for frame.size.width.
@property (nonatomic) CGFloat HW_height;      ///< Shortcut for frame.size.height.
@property (nonatomic) CGFloat HW_centerX;     ///< Shortcut for center.x
@property (nonatomic) CGFloat HW_centerY;     ///< Shortcut for center.y
@property (nonatomic) CGPoint HW_origin;      ///< Shortcut for frame.origin.
@property (nonatomic) CGSize  HW_size;        ///< Shortcut for frame.size.

+ (void)showOscillatoryAnimationWithLayer:(CALayer *)layer type:(HWOscillatoryAnimationType)type;

@end
