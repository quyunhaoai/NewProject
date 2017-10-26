//
//  TestViewController.m
//  RongyunMessage
//
//  Created by hao on 16/1/8.
//  Copyright © 2016年 hao. All rights reserved.
//
#import <RongIMKit/RongIMKit.h>
#import "ListViewController.h"
#import "AKTabBarController.h"
#import "UIViewController+AKTabBarController.h"
#import "ChatViewController.h"
#import "AppDelegate.h"
@interface ListViewController ()

@end

@implementation ListViewController
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
-(id)init
{
    self = [super self];
    if (self) {
        //设置要显示的会话类型
        [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE),@(ConversationType_DISCUSSION), @(ConversationType_APPSERVICE), @(ConversationType_PUBLICSERVICE),@(ConversationType_GROUP),@(ConversationType_SYSTEM)]];
        
        //聚合会话类型
        [self setCollectionConversationType:@[@(ConversationType_GROUP),@(ConversationType_DISCUSSION)]];
        
    }
    return self;
}
//-(id)initWithCoder:(NSCoder *)aDecoder
//{
//    self =[super initWithCoder:aDecoder];
//    if (self) {
//        //设置要显示的会话类型
//        [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE),@(ConversationType_DISCUSSION), @(ConversationType_APPSERVICE), @(ConversationType_PUBLICSERVICE),@(ConversationType_GROUP),@(ConversationType_SYSTEM)]];
//        
//        //聚合会话类型
//        [self setCollectionConversationType:@[@(ConversationType_GROUP),@(ConversationType_DISCUSSION)]];

        
//        //设置为不用默认渲染方式
//        self.tabBarItem.image = [[UIImage imageNamed:@"icon_chat"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//        self.tabBarItem.selectedImage = [[UIImage imageNamed:@"icon_chat_hover"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        // _myDataSource = [NSMutableArray new];
        
        // [self setConversationAvatarStyle:RCUserAvatarCycle];
//    }
//    return self;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"会话列表";
     [self addBackBtnItem];
}
-(void)onSelectedTableRow:(RCConversationModelType)conversationModelType conversationModel:(RCConversationModel *)model atIndexPath:(NSIndexPath *)indexPath
{
    if (conversationModelType == RC_CONVERSATION_MODEL_TYPE_NORMAL) {
        ChatViewController *_conversationVC = [[ChatViewController alloc]init];
        _conversationVC.conversationType = model.conversationType;
        _conversationVC.targetId = model.targetId;
        _conversationVC.userName = model.conversationTitle;
        _conversationVC.title = model.conversationTitle;
//        _conversationVC. = model;
        _conversationVC.unReadMessage = model.unreadMessageCount;
        _conversationVC.enableNewComingMessageIcon=YES;//开启消息提醒
        _conversationVC.enableUnreadMessageIcon=YES;
        if (model.conversationType == ConversationType_SYSTEM) {
            _conversationVC.userName = @"系统消息";
            _conversationVC.title = @"系统消息";
        }
        [self.navigationController pushViewController:_conversationVC animated:YES];
    }
    if (conversationModelType == RC_CONVERSATION_MODEL_TYPE_COLLECTION) {
        
        ListViewController *temp = [[ListViewController alloc] init];
        NSArray *array = [NSArray arrayWithObject:[NSNumber numberWithInt:model.conversationType]];
        [temp setDisplayConversationTypes:array];
        [temp setCollectionConversationType:nil];
        temp.isEnteredToCollectionViewController = YES;
        [self.navigationController pushViewController:temp animated:YES];
    }
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
