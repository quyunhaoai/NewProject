//
//  AppDelegate.h
//  CloudApp
//
//  Created by 11 on 15-1-14.
//
//

#import <UIKit/UIKit.h>
//@class HwOnePageViewController;
//#import "AGViewDelegate.h"
#import "HwTools.h"
#import "MMDrawerController.h"
#import "WXApi.h"
#import <WebKit/WebKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,WXApiDelegate>
{
    BOOL _isFull; // 是否全屏
    NSString *_payloadStr;
}
@property (nonatomic)BOOL isFull;
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) UIViewController *currentVC;
//@property (nonatomic, strong) AGViewDelegate *viewDelegate;
@property (nonatomic, strong) ShareModel *sModel;
@property (nonatomic, strong) MMDrawerController *drawerController;
@property (nonatomic, assign)BOOL isHideHud;
@property (nonatomic, strong) WKProcessPool *wkPool;

@property (nonatomic, assign) BOOL isNewPageView;
@property (nonatomic, strong) NSArray *animation;
@property (nonatomic,assign) BOOL isWeixindenglu;
@property (nonatomic, assign) BOOL isleftOrrightMenu;
- (void)showMainVC;
@end
