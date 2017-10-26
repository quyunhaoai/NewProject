//
//  SideSuperViewController.m
//  CloudApp
//
//  Created by 9vs on 15/2/5.
//
//

#import "SideSuperViewController.h"
#import "AppDelegate.h"
#import "UIViewController+MMDrawerController.h"
@interface SideSuperViewController ()

@end

@implementation SideSuperViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
//    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
   
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addBackBtnItem];
    AppDelegate * appDelegate = [[UIApplication sharedApplication] delegate];
    
    appDelegate.isFull = NO;
    
  
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        
        SEL selector = NSSelectorFromString(@"setOrientation:");
        
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        
        [invocation setSelector:selector];
        
        [invocation setTarget:[UIDevice currentDevice]];
        
        int val =UIInterfaceOrientationPortrait;
        
        [invocation setArgument:&val atIndex:2];
        
        [invocation invoke];
        
    }
}
- (void)addBackBtnItem {
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 8, 40, 44)];
    
    
//    [button setTitle:@"< 返回" forState:UIControlStateNormal];
//    button.titleLabel.font = [UIFont systemFontOfSize:14];
//    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
//    [button setTintColor:[UIColor whiteColor]];
    
    [button setImage:[UIImage imageNamed:@"icon_goback"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"icon_goback"] forState:UIControlStateHighlighted];
    [button setTitle:NSLocalizedString(@"back", nil) forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 10)];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -10)];
    [button setTintColor:[UIColor whiteColor]];
    
    
    [button addTarget:self action:@selector(goBackView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *btnItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = btnItem;
    
}
- (void)goBackView
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.drawerController setCenterViewController:delegate.currentVC];
//    [delegate.drawerController setGestureShouldRecognizeTouchBlock:^BOOL(MMDrawerController *drawerController, UIGestureRecognizer *gesture, UITouch *touch) {
//        BOOL shouldRecognizeTouch = NO;
//        if(drawerController.openSide == MMDrawerSideNone &&
//           [gesture isKindOfClass:[UIPanGestureRecognizer class]]){
//            UIView * customView = [drawerController.centerViewController view];
//            CGPoint location = [touch locationInView:customView];
//            CGRect rect = CGRectMake(customView.bounds.size.width-15, 0, 15, customView.bounds.size.height);
//            shouldRecognizeTouch = (CGRectContainsPoint(rect, location));
//            
//        }
//        return shouldRecognizeTouch;
//    }];
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
