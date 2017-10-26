//
//  AboutViewController.m
//  CloudApp
//
//  Created by 9vs on 15/1/31.
//
//

#import "AboutViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "HwTools.h"
#import "UMMobClick/MobClick.h"
@interface AboutViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *appNameLab;
@property (weak, nonatomic) IBOutlet UILabel *RightLab;

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self checkCommonOrEnterprise];
}
- (void)checkCommonOrEnterprise
{
    self.title = NSLocalizedString(@"about", nil);
    NSMutableDictionary *stringDic = [[StringsXML shareStringsXML] jiexiStringsXML:@"strings"];
    StringsXmlBase *base = [StringsXmlBase modelObjectWithDictionary:stringDic];
    if ([base.banquaninfo isEqualToString:NSLocalizedString(@"banquaninfo", nil)]) {
        [self common];
    }else {
        [self enterprise];
    }
    
}

- (void)enterprise
{

    [self.iconImageView setImage:[UIImage imageNamed:@"AppIcon-160x60"]];
    NSString *App_version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *App_name  = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];

    NSString *Lab1Str = [NSString stringWithFormat:@"%@\n%@ %@",App_name,NSLocalizedString(@"versioninfo", nil),App_version];
    self.appNameLab.text = Lab1Str;

    NSString *Lab2Str = [NSString stringWithFormat:@"©  %@  inc, All Rights Reserved\n\n%@%@",App_name,App_name,NSLocalizedString(@"supplytech", nil)];
    self.RightLab.text = Lab2Str;

}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"AboutPage"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"AboutPage"];
}
- (void)common
{
//    NSString *IConImage = [[NSBundle mainBundle] pathForResource:@"ipgy_logo" ofType:@"png"];
    self.iconImageView.image = [UIImage imageNamed:@"ipgy_logo"];

    NSString *App_version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *App_name  = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];

     NSString *Lab1Str = [NSString stringWithFormat:@"%@\n%@ %@",App_name,NSLocalizedString(@"versioninfo", nil),App_version];
    self.appNameLab.text = Lab1Str;

    NSString *Lab2Str = [NSString stringWithFormat:@"©  %@  inc, All Rights Reserved\n\n%@%@",App_name,App_name,NSLocalizedString(@"supplytech", nil)];
    self.RightLab.text = Lab2Str;

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
