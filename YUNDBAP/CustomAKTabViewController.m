//
//  CustomAKTabViewController.m
//  CloudApp
//
//  Created by 9vs on 15/3/11.
//
//

#import "CustomAKTabViewController.h"
#import "HwTools.h"
#import "CustomNavigationController.h"
#import "HwOnePageViewController.h"
#import "GGTabBarAppearanceKeys.h"
#import "JSCustomBadge.h"


@interface CustomAKTabViewController ()

@end

@implementation CustomAKTabViewController

- (instancetype)init {
     NSMutableArray *array = [[UXml shareUxml] jiexiXML:@"myxml" two:@"daohang"];
    NSDictionary *dic = [array firstObject];
    MyXmlBase *base = [MyXmlBase modelObjectWithDictionary:dic];
    float tabHeight = 0;
    if (base.imgurl.length > 0 && base.name.length > 0) {
        tabHeight = 50;
        [self setTextFont:[UIFont systemFontOfSize:13]];
    }else {
        tabHeight = 40;
        [self setTextFont:[UIFont systemFontOfSize:13]];
    }
    StringsXmlBase *sBase = [StringsXML getStringXmlBase];
    tabHeight = [sBase.bottomMenuBarHeight floatValue];
    self = [super initWithTabBarHeight:tabHeight];
    if (self) {
     [self setMinimumHeightToDisplayTitle:30.0];
        
       NSMutableArray *array = [[UXml shareUxml] jiexiXML:@"myxml" two:@"daohang"];
        NSMutableArray *vcArray = [NSMutableArray array];
        int diCount = 0;
        if (array.count <=5) {
            diCount = (int)array.count;
        }else {
            diCount = 4;
        }
        
        
        for (int i = 0 ;i < array.count; i++) {
            if (i < diCount) {
                NSDictionary *dic = array[i];
                MyXmlBase *base = [MyXmlBase modelObjectWithDictionary:dic];
                HwOnePageViewController *one = [[HwOnePageViewController alloc] init];
                one.currentUrlStr = [base.weburl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                one.refreshMenuStr = base.refreshMenu;
                if (base.name.length > 0) {
                    one.tabTitleStr = base.name;
                    self.textFont = [UIFont systemFontOfSize:13];
                }
                
                if (base.imgurl.length > 0) {
                    one.tabImageNameStr = [NSString stringWithFormat:@"db_%d",i + 1];
                    one.activeTabImageNameStr = [NSString stringWithFormat:@"db_%da",i + 1];
                    self.textFont = [UIFont systemFontOfSize:13];
                }

                CustomNavigationController *nav = [[CustomNavigationController alloc] initWithRootViewController:one];
                [vcArray addObject:nav];
            }else if (i == diCount) {
                NSDictionary *dic = array[i];
                MyXmlBase *base = [MyXmlBase modelObjectWithDictionary:dic];
                HwOnePageViewController *one = [[HwOnePageViewController alloc] init];
                one.tabTitleStr = NSLocalizedString(@"more", nil);
                if (base.imgurl.length > 0) {
                    one.tabImageNameStr = [NSString stringWithFormat:@"db_%d",i + 1];
                    one.activeTabImageNameStr = [NSString stringWithFormat:@"db_%da",i + 1];
                }

                CustomNavigationController *nav = [[CustomNavigationController alloc] initWithRootViewController:one];
                [vcArray addObject:nav];
            }
            
        }
       
        self.viewControllers = vcArray;
        [self setHidesBottomBarWhenPushed:YES];
        
        [self setIconColors:@[[UIColor clearColor],
                              [UIColor clearColor]]];
        
        [self setSelectedIconColors:@[[UIColor clearColor],
                                                   [UIColor clearColor]]];

//        [self setBackgroundImage:[UIImage imageNamed:@"tabbar_background"]];
//        [self setSelectedBackgroundImage:[UIImage imageNamed:@"tabbar_background"]];
        //顶部颜色
        [self setTopEdgeColor:[HwTools hexStringToColor:sBase.menuBarLineColor]];
        
        [self setTabColors:@[[UIColor colorWithRed:0.502 green:0.000 blue:0.000 alpha:1.000],
                                          [UIColor colorWithRed:0.400 green:1.000 blue:0.400 alpha:1.000]]];

        StringsXmlBase *sBase = [StringsXML getStringXmlBase];
        
        [self setBackgroundImage:[HwTools createImageWithColor:[HwTools hexStringToColor:sBase.bottomMenuBarBackColor]]];
        [self setSelectedBackgroundImage:[HwTools createImageWithColor:[HwTools hexStringToColor:sBase.bottomMenuBarBackColor]]];
        self.tabEdgeColor = [HwTools hexStringToColor:sBase.bottomMenuBarBackColor];//分割线
        

        [self setTabEdgeColor:[UIColor clearColor]];
        [self setTabStrokeColor:[UIColor clearColor]];
        
//        self.topEdgeColor = [UIColor clearColor];
        
        StringsXmlBase *base = [StringsXML getStringXmlBase];
        self.selectedIconOuterGlowColor = [UIColor clearColor];
        // Text Color
        
        self.iconGlossyIsHidden = YES;
        [self setTextColor:[HwTools hexStringToColor:base.bMenubarTextcolorNomal]];
        
        
        
        
        [self setSelectedTextColor:[HwTools hexStringToColor:base.bMenubarTextcolorActive]];
        
        self.defaultBadge = [JSCustomBadge customBadgeWithString:@""
                                                              withStringColor:[UIColor whiteColor]
                                                               withInsetColor:[UIColor redColor]
                                                               withBadgeFrame:YES
                                                          withBadgeFrameColor:[UIColor whiteColor]
                                                                    withScale:1.0f
                                                                  withShining:NO];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
