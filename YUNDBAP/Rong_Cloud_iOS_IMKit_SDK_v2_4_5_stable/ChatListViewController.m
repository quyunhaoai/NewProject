//
//  chatListViewController.m
//  rongyun
//
//  Created by hao on 17/6/20.
//  Copyright © 2017年 hao. All rights reserved.
//

#import "ChatListViewController.h"
#import "StringsXmlBase.h"
#import "StringsXML.h"
#import "AKTabBarController.h"
#import "HwTools.h"
#import "UIViewController+AKTabBarController.h"
@interface ChatListViewController ()

@end

@implementation ChatListViewController
- (void)viewDidLayoutSubviews{
    CGRect frame = self.conversationListTableView.frame;
    if (frame.origin.y < 44) {
        frame.origin.y = 64;
        self.conversationListTableView.frame = frame;
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    //重写显示相关的接口，必须先调用super，否则会屏蔽SDK默认的处理
    [super viewDidLoad];
    
    //设置需要显示哪些类型的会话
    [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE),
                                        @(ConversationType_DISCUSSION),
                                        @(ConversationType_CHATROOM),
                                        @(ConversationType_GROUP),
                                        @(ConversationType_APPSERVICE),
                                        @(ConversationType_SYSTEM)]];
    //设置需要将哪些类型的会话在会话列表中聚合显示
    [self setCollectionConversationType:@[@(ConversationType_DISCUSSION),
                                          @(ConversationType_GROUP)]];
    [self addBackBtnItem];
}
//重写RCConversationListViewController的onSelectedTableRow事件
- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType
         conversationModel:(RCConversationModel *)model
               atIndexPath:(NSIndexPath *)indexPath {
    ChatViewController *conversationVC = [[ChatViewController alloc]init];
    conversationVC.conversationType = model.conversationType;
    conversationVC.targetId = model.targetId;
    conversationVC.title = model.conversationTitle;
    [self.navigationController pushViewController:conversationVC animated:YES];
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
