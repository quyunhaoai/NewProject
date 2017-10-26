//
//  ClockView.h
//  CloudApp
//
//  Created by 9vs on 15/1/30.
//
//

#import <UIKit/UIKit.h>
#import "ALDClock.h"
@interface ClockView : UIView


@property (nonatomic, retain) ALDClock *aldClock;
@property (nonatomic, retain) NSTimer *aldTimer;
@property (nonatomic, assign) int aldH;
@property (nonatomic, assign) int aldM;

//+ (ClockView *)shareCView;
+ (void)show;
+ (void)dismiss;
@end
