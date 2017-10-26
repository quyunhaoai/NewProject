//
//  GGImageTabBarViewController.m
//  CloudApp
//
//  Created by 9vs on 15/2/5.
//
//

#import "GGImageTabBarViewController.h"
#import "HwTools.h"
#import "CustomNavigationController.h"
#import "HwOnePageViewController.h"
#import "GGTabBarAppearanceKeys.h"
@interface GGImageTabBarViewController () <GGTabBarControllerDelegate>

@end

@implementation GGImageTabBarViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.delegate = self;
//        self.debug = YES;
     
        NSMutableArray *array = [[UXml shareUxml] jiexiXML:@"myxml" two:@"daohang"];
        NSMutableArray *vcArray = [NSMutableArray array];

        for (int i = 0 ;i < array.count; i++) {
            NSDictionary *dic = array[i];
            MyXmlBase *base = [MyXmlBase modelObjectWithDictionary:dic];
            HwOnePageViewController *one = [[HwOnePageViewController alloc] init];
            one.currentUrlStr = [base.weburl stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            one.refreshMenuStr = base.refreshMenu;
            one.tabBarItem = [[UITabBarItem alloc] initWithTitle:base.name image:[UIImage imageNamed:@"sz_gy"] selectedImage:[UIImage imageNamed:@"sz_sj"]];
            
            CustomNavigationController *nav = [[CustomNavigationController alloc] initWithRootViewController:one];
            [vcArray addObject:nav];
        }
        self.tabBarAppearanceSettings = @{kTabBarAppearanceBackgroundColor:[UIColor colorWithWhite:0.965 alpha:1.000],kTabBarAppearanceHeight:[NSNumber numberWithInteger:40]};
        self.viewControllers = vcArray;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
  
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}
- (BOOL)ggTabBarController:(GGTabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController  {
    int index = (int)[tabBarController.viewControllers indexOfObject:viewController];
    NSLog(@"===%d",index);
    return YES;
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
