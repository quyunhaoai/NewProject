//
//  ChatViewController.m
//  NewCloudApp
//
//  Created by hao on 16/2/3.
//
//

#import "ChatViewController.h"
#import "AKTabBarController.h"
#import "UIViewController+AKTabBarController.h"
#import "StringsXML.h"
#import "HwTools.h"
@interface ChatViewController ()

@end

@implementation ChatViewController
//-(void)viewWillAppear:(BOOL)animated
//{
//    AKTabBarController *akTab = [self akTabBarController];
//    [akTab hideTabBarAnimated:NO];
//    self.navigationController.navigationBarHidden = NO;
//    StringsXmlBase *sBase = [StringsXML getStringXmlBase];
//    self.navigationController.navigationBar.barTintColor = [HwTools hexStringToColor:sBase.titleBarColor];
//    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor],
//                                                                    NSFontAttributeName : [UIFont boldSystemFontOfSize:18]};
//}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    StringsXmlBase *sBase = [StringsXML getStringXmlBase];
    self.navigationController.navigationBar.barTintColor = [HwTools hexStringToColor:sBase.titleBarColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor],
                                                                    NSFontAttributeName : [UIFont boldSystemFontOfSize:18]};
    if (self.navigationController.viewControllers.count > 1) {
        return;
    }
    AKTabBarController *akTab = [self akTabBarController];
    [akTab showTabBarAnimated:NO];
    
    if ([sBase.titleBarIsShow isEqualToString:@"0"]) {
        self.navigationController.navigationBarHidden = YES;
    }else {
        self.navigationController.navigationBarHidden = NO;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addBackBtnItem];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addBackBtnItem {
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 8, 40, 44)];

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
    [self.navigationController popViewControllerAnimated:YES];
}

@end
