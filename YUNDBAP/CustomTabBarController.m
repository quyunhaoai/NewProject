//
//  CustomTabBarController.m
//  CloudApp
//
//  Created by 9vs on 15/2/5.
//
//

#import "CustomTabBarController.h"
#import "HwTools.h"
#import "CustomNavigationController.h"
#import "HwOnePageViewController.h"
@interface CustomTabBarController () <UITabBarControllerDelegate>

@end

@implementation CustomTabBarController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBar.translucent = NO;

    
    self.delegate = self;
    NSMutableArray *array = [[UXml shareUxml] jiexiXML:@"myxml" two:@"daohang"];
    NSMutableArray *vcArray = [NSMutableArray array];

    for (int i = 0 ;i < array.count; i++) {
        NSDictionary *dic = array[i];
        MyXmlBase *base = [MyXmlBase modelObjectWithDictionary:dic];
        HwOnePageViewController *one = [[HwOnePageViewController alloc] init];
        one.currentUrlStr = [base.weburl stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
       one.refreshMenuStr = base.refreshMenu;
        
        CustomNavigationController *nav = [[CustomNavigationController alloc] initWithRootViewController:one];
        [vcArray addObject:nav];
    }
    self.viewControllers = vcArray;
    
    for (int i = 0 ;i < array.count; i++) {
        
        NSDictionary *dic = array[i];
        MyXmlBase *base = [MyXmlBase modelObjectWithDictionary:dic];
        [self createTabBarItemWithTitle:base.name withUnSelectedImage:@"sz_gy" withSelectedImage:@"sz_sj" withTag:i];
    }
    
    
    self.tabBar.backgroundColor = [UIColor clearColor];
    self.tabBar.barTintColor = [UIColor colorWithRed:1.000 green:0.976 blue:0.992 alpha:1.000];

}


-(void)createTabBarItemWithTitle:(NSString *)title withUnSelectedImage:(NSString *)unSelectedImage withSelectedImage:(NSString *)selectedImage withTag:(int)tag
{
    UIImage *image1_0 = [UIImage imageNamed:unSelectedImage];
    UIImage *image1_1 = [UIImage imageNamed:selectedImage];
    if (IS_IOS7)
    {
        image1_1 = [image1_1 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        image1_0 = [image1_0 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        (void)[[self.tabBar.items objectAtIndex:tag] initWithTitle:title image:image1_0 selectedImage:image1_1];
        
    }
    else
    {
        [[self.tabBar.items objectAtIndex:tag] setFinishedSelectedImage:image1_1
                                            withFinishedUnselectedImage:image1_0];
    }
    [[self.tabBar.items objectAtIndex:tag] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                   [UIColor colorWithWhite:0.794 alpha:1.000], NSForegroundColorAttributeName,
                                                                   nil] forState:UIControlStateNormal];
    [[self.tabBar.items objectAtIndex:tag] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                   [UIColor colorWithWhite:0.016 alpha:1.000], NSForegroundColorAttributeName,
                                                                   nil] forState:UIControlStateSelected];
    
    
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    
    int index = (int)[tabBarController.viewControllers indexOfObject:viewController];
    if (index == 1) {
        
       
        
    }
    else if (index == 2)
    {
        
    }
    else if (index == 3)
    {
        
    }
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
