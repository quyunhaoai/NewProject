//
//  ClockView.m
//  CloudApp
//
//  Created by 9vs on 15/1/30.
//
//

#import "ClockView.h"



@implementation ClockView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (ClockView *)shareCView {
    static ClockView *clockView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        clockView = [[self alloc] init];
//        clockView.backgroundColor = [UIColor colorWithRed:1.000 green:0.877 blue:1.000 alpha:1.000];
        clockView.frame = CGRectMake(0, 0, 120, 120);
        clockView.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);
        clockView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    });
    
    return clockView;
}

+ (void)show {
    [[UIApplication sharedApplication].keyWindow addSubview:[self shareCView]];
    [self shareCView].hidden = NO;
    
    [[self shareCView] showAldClock];
}
+ (void)dismiss {
    [self shareCView].hidden = YES;
    [[self shareCView] hideAldClock];
}
- (void)cloudReloadClock
{
    
    self.aldM++;
    if (self.aldM == 60) {
        self.aldM = 0;
        self.aldH++;
    }
    [self.aldClock setHour:self.aldH minute:self.aldM animated:YES];

   
}
- (void)showAldClock
{
        if (!self.aldTimer) {
            self.aldTimer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(cloudReloadClock) userInfo:nil repeats:YES];
            [[NSRunLoop mainRunLoop] addTimer:self.aldTimer forMode:NSRunLoopCommonModes];
        }
   
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideAldClock) object:nil];
    [self performSelector:@selector(hideAldClock) withObject:self afterDelay:20.0];
}
- (void)hideAldClock
{
    
    if (self.aldClock) {
        [self.aldClock removeFromSuperview];
        self.aldClock = nil;
    }
    if (self.aldTimer) {
        [self.aldTimer invalidate];
        self.aldTimer = nil;
    }
    
}
- (ALDClock *)aldClock
{
    if (!_aldClock) {
        _aldClock = [[ALDClock alloc] init];
        _aldClock.bounds = CGRectMake(0,0,88*1.5,63*1.5);
        _aldClock.center = CGPointMake(60, 60);
        _aldClock.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        _aldH = 0;
        _aldM = 0;
        
        // Put the clock in the centre of the frame
//        [_aldClock setHour:0 minute:0 animated:NO];
    }
     [self addSubview:_aldClock];
    return _aldClock;
}
@end
