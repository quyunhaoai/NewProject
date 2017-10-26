//
//  CustomNavigationController.m
//  EMM
//
//  Created by 9vs on 15/1/12.
//  Copyright (c) 2015年 9vs. All rights reserved.
//

#import "CustomNavigationController.h"
#import "HwTools.h"
@interface CustomNavigationController () <UIGestureRecognizerDelegate>

@end

@implementation CustomNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.interfaceOrientation = UIInterfaceOrientationPortrait;
    self.interfaceOrientationMask = UIInterfaceOrientationMaskPortrait;
    
    NSMutableDictionary *stringDic = [[StringsXML shareStringsXML] jiexiStringsXML:@"strings"];
    StringsXmlBase *base = [StringsXmlBase modelObjectWithDictionary:stringDic];
    [self.navigationBar setTranslucent:NO];
    self.navigationBar.barTintColor = [self hexStringToColor:base.titleBarColor];
    if (base.LogoColor.length > 0 && base.LogoColor != nil) {
        self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [self hexStringToColor:base.LogoColor],
                                                   NSFontAttributeName : [UIFont boldSystemFontOfSize:18]};
    }else{
        self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor],
                                                   NSFontAttributeName : [UIFont boldSystemFontOfSize:18]};
    }
    
    __weak typeof (self) weakSelf = self;
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.delegate = weakSelf;
    }
//    NSString *titleColor = (NSString *)[HwTools UserDefaultsObjectForKey:@"NavBarTitleColor"];
//    UIColor *HexTitleColor = [self hexStringToColor:titleColor];
//    if (titleColor != nil && titleColor.length > 0) {
//        self.navigationBar.titleTextAttributes =@{NSForegroundColorAttributeName:HexTitleColor,NSFontAttributeName : [UIFont boldSystemFontOfSize:18]};
//    }

    
    
}
//设置是否允许自动旋转
- (BOOL)shouldAutorotate {
    return YES;
}

//设置支持的屏幕旋转方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return self.interfaceOrientationMask ;
}

- (UIColor *) hexStringToColor: (NSString *) stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    
    if ([cString length] < 6) return [UIColor blackColor];
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    if ([cString length] != 6) return [UIColor blackColor];
    
    // Separate into r, g, b substrings
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated

{

//    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//        self.interactivePopGestureRecognizer.enabled = NO;
//    }
    [super pushViewController:viewController animated:animated];
    
    if (viewController.navigationItem.leftBarButtonItem== nil && [self.viewControllers count] > 1) {
        
        viewController.navigationItem.leftBarButtonItem =[self createBackButton];
        
    }
    

}



-(UIBarButtonItem*) createBackButton
{
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
    //    backButton.backgroundColor = [UIColor clearColor];
//    [backButton setImage:[UIImage imageNamed:@"left_btn"] forState:UIControlStateNormal];
//    [backButton setImage:[UIImage imageNamed:@"left_btn"] forState:UIControlStateSelected];
    //backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    
    
    [backButton setFrame:CGRectMake(0, 8, 40, 40)];
    [backButton setImage:[UIImage imageNamed:@"icon_goback"] forState:UIControlStateNormal];
    [backButton setTitle:NSLocalizedString(@"back", nil) forState:UIControlStateNormal];
    backButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -backButton.titleLabel.bounds.size.width, 0, backButton.titleLabel.bounds.size.width)];
    [backButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 35, 0, -35)];
    [backButton setTintColor:[UIColor whiteColor]];
    
    
//    [backButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -imgArrow.size.width, 0, imgArrow.size.width)];
//    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, btnRight.titleLabel.bounds.size.width, 0, -btnRight.titleLabel.bounds.size.width)];
    
    
    [backButton addTarget:self action:@selector(BackButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = barButtonItem;
    return barButtonItem;
    
}
-(void)BackButtonPressed:(UIButton*)sender
{
    [self popViewControllerAnimated:YES];
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
