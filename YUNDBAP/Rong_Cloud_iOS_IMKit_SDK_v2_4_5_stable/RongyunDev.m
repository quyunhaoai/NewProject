//
//  RongyunDev.m
//  RongyunMessage
//
//  Created by hao on 16/1/22.
//  Copyright © 2016年 hao. All rights reserved.
//
#define iPhone6                                                                \
([UIScreen instancesRespondToSelector:@selector(currentMode)]                \
? CGSizeEqualToSize(CGSizeMake(750, 1334),                              \
[[UIScreen mainScreen] currentMode].size)           \
: NO)
#define iPhone6Plus                                                            \
([UIScreen instancesRespondToSelector:@selector(currentMode)]                \
? CGSizeEqualToSize(CGSizeMake(1242, 2208),                             \
[[UIScreen mainScreen] currentMode].size)           \
: NO)

#define rongyun [RCIM sharedRCIM]
#define reURL @"http://apiinfoios.ydbimg.com/RongToken.ashx"
#import "WXUtil.h"
#import "RongyunDev.h"
#import "AFHTTPRequestOperationManager.h"
#import <RongIMKit/RCConversationListViewController.h>
#import "HwTools.h"
#import "ListViewController.h"
#import "ChatViewController.h"
@implementation RongyunDev
    NSMutableArray *userArray;
+(RongyunDev *)sharedObject
{
    static RongyunDev *sharedObject;
    static dispatch_once_t onceObject;
    dispatch_once(&onceObject, ^{
        sharedObject = [[RongyunDev alloc]init];
    StringsXmlBase *base = [StringsXML getStringXmlBase];
        [[RCIM sharedRCIM] initWithAppKey:base.RongyonAppkey];
        [RCIM sharedRCIM].receiveMessageDelegate = sharedObject;
        [RCIM sharedRCIM].userInfoDataSource = sharedObject;
        userArray = [NSMutableArray new];
        
    });
    
    
    return sharedObject;
}
/*注册用户*/
-(void)requestToken:(NSString *)userid andName:(NSString *)name andtoken:(NSString *)token andportaitUrl:(NSString *)portaitUri
{
 
        [[RCIM sharedRCIM] connectWithToken:token success:^(NSString *userId) {
            NSLog(@"userid:%@",userId);
            RCUserInfo *userinfo = [[RCUserInfo alloc]initWithUserId:userid name:name portrait:portaitUri];
            [RCIM sharedRCIM].currentUserInfo = userinfo;
            [[RCIM sharedRCIM] refreshUserInfoCache:userinfo withUserId:userid];
            rongyun.enableMessageAttachUserInfo = NO;

            /*设置会话列表中显示的头像形状与大小*/
//            [RCIM sharedRCIM].globalConversationAvatarStyle = RC_USER_AVATAR_CYCLE;
//            rongyun.globalConversationPortraitSize = CGSizeMake(45, 45);
            /**设置聊天界面中显示的头像形状与大小*/
//            rongyun.globalMessageAvatarStyle = RC_USER_AVATAR_CYCLE;
//            rongyun.globalMessagePortraitSize = CGSizeMake(45, 45);
            if (iPhone6Plus) {
                [RCIM sharedRCIM].globalConversationPortraitSize = CGSizeMake(56, 56);
            } else {
                NSLog(@"iPhone6 %d", iPhone6);
                [RCIM sharedRCIM].globalConversationPortraitSize = CGSizeMake(46, 46);
            }
        } error:^(RCConnectErrorCode status) {
            NSLog(@"--%d",status);
            
            
            
        } tokenIncorrect:^{
            NSLog(@"token错误");
        }];//3,链接融云

}
/*单聊*/
-(ChatViewController *)creatChat:(NSString *)userid andChatName:(NSString *)name andheadurl:(NSString *)portraiturl
{
    ChatViewController *chat = [[ChatViewController alloc]init];
    chat.conversationType = ConversationType_PRIVATE;
    chat.targetId = userid;
    chat.title = name;
    [self setUserid:userid andname:name andportraitUrl:portraiturl];
    return chat;
//    [self.navigationController pushViewController:chat animated:YES];
}
/*回话列表*/
-(ListViewController *)rongyunChatViewList
{
    /*
    RCConversationListViewController *listView = [[RCConversationListViewController alloc]init];
    [listView setDisplayConversationTypes:@[@(ConversationType_PRIVATE),
                                        @(ConversationType_DISCUSSION),
                                        @(ConversationType_CHATROOM),
                                        @(ConversationType_GROUP),
                                        @(ConversationType_APPSERVICE),
                                        @(ConversationType_SYSTEM)]];
    
    
    [listView setCollectionConversationType:@[@(ConversationType_DISCUSSION),
                                          @(ConversationType_GROUP)]];
    */
    /*
    ListViewController *listView = [[ListViewController alloc]init];
    [listView setDisplayConversationTypes:@[@(ConversationType_PRIVATE),
                                            @(ConversationType_DISCUSSION),
                                            @(ConversationType_CHATROOM),
                                            @(ConversationType_GROUP),
                                            @(ConversationType_APPSERVICE),
                                            @(ConversationType_SYSTEM)]];
    
    
    [listView setCollectionConversationType:@[@(ConversationType_DISCUSSION),
                                              @(ConversationType_GROUP)]];
     */
    ListViewController *listView = [[ListViewController alloc]init];
    return listView;
}
-(void)setUserid:(NSString *)userid andname:(NSString *)name andportraitUrl:(NSString *)url
{
    if ([userid isEqualToString:[RCIM sharedRCIM].currentUserInfo.userId]) {
        RCUserInfo *userinfo = [[RCUserInfo alloc]initWithUserId:userid name:name portrait:url];
        [RCIM sharedRCIM].currentUserInfo = userinfo;
        [[RCIM sharedRCIM] refreshUserInfoCache:userinfo withUserId:userid];
        
        return;
    }
    
//NSLog(@"----%@----%@-----%@",userid,name,url);
    if (userArray.count > 0) {
        for (int a = 0; a<userArray.count; a++) {
            RongyunDev *userinfo = [userArray objectAtIndex:a];
            if ([userinfo.userid isEqualToString:userid]) {
                return;
            }
        }
    
    }
    
    RongyunDev *userinfo = [[RongyunDev alloc]init];
    userinfo.userid = userid;
    userinfo.name = name;
    userinfo.portaitUrl = url;
    [userArray addObject:userinfo];
    
//    [[NSUserDefaults standardUserDefaults] setObject:userArray forKey:@"rongyunuserinfo"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
}
/*打开聊天室*/
-(ChatViewController *)creatchatRoom:(NSString *)userid andRoomName:(NSString *)name
{
    //新建一个聊天会话View Controller对象
    ChatViewController *chat = [[ChatViewController alloc]init];
    //设置会话的类型为聊天室
    chat.conversationType = ConversationType_DISCUSSION;
    //设置会话的目标会话ID
    chat.targetId = userid;
    //设置聊天会话界面要显示的标题
    chat.title = name;
    //设置加入聊天室时需要获取的历史消息数量，最大值为50
    chat.defaultHistoryMessageCountOfChatRoom = 20;
    //显示聊天会话界面
    //    [self.navigationController pushViewController:chat animated:YES];
    return chat;
}

/*添加好友*/
-(void)addDiscussion:(NSArray *)userid andDiscussionName:(NSString *)name andheadurl:(NSString *)portraiturl
{
    NSArray *array = [[userid objectAtIndex:1] componentsSeparatedByString:@"|"];
    [self setUserid:userid[1] andname:userid[2] andportraitUrl:portraiturl];
    [[RCIMClient sharedRCIMClient] addMemberToDiscussion:name userIdList:array success:^(RCDiscussion *discussion) {
        
    } error:^(RCErrorCode status) {
        
    }];
}
/*移除好友*/
-(void)remDiscussion:(NSString *)userid andDiscussionName:(NSString *)name
{
    [[RCIMClient sharedRCIMClient]removeMemberFromDiscussion:name userId:userid success:^(RCDiscussion *discussion) {
        
    } error:^(RCErrorCode status) {
        
    }];
}

#pragma userINFO delegate
-(void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *))completion
{
    NSLog(@"getUserInfoWithUserId ----- %@", userId);
    
    if (userId == nil || [userId length] == 0 )
        
    {
        
        completion(nil);
        
        return ;
        
    }
    if ([userId isEqualToString:self.userid]) {
        RCUserInfo *user = [[RCUserInfo alloc]init];
        user.userId = self.userid;
        user.name = self.name;
        user.portraitUri = self.portaitUrl;
        return completion(user);
    }
//    NSArray *array = [[NSUserDefaults standardUserDefaults] arrayForKey:@"rongyunuserinfo"];
    if (userArray.count >0) {
        for (int a = 0; a<userArray.count; a++) {
            RongyunDev *userinfo = [userArray objectAtIndex:a];
            if ([userinfo.userid isEqualToString:userId]) {
                RCUserInfo *user = [[RCUserInfo alloc]init];
                user.userId = userinfo.userid;
                user.name = userinfo.name;
                user.portraitUri = userinfo.portaitUrl;
                return completion(user);
            }
        }
    }

}

//获取群组的信息
-(void)getGroupInfoWithGroupId:(NSString *)groupId completion:(void (^)(RCGroup *))completion
{
    
}
#pragma rongyun---message
/*!
 接收消息的回调方法
 
 @param message     当前接收到的消息
 @param left        还剩余的未接收的消息数，left>=0
 
 @discussion 如果您设置了IMKit消息监听之后，SDK在接收到消息时候会执行此方法（无论App处于前台或者后台）。
 其中，left为还剩余的、还未接收的消息数量。比如刚上线一口气收到多条消息时，通过此方法，您可以获取到每条消息，left会依次递减直到0。
 您可以根据left数量来优化您的App体验和性能，比如收到大量消息时等待left为0再刷新UI。
 */
- (void)onRCIMReceiveMessage:(RCMessage *)message
                        left:(int)left;
{
    NSLog(@"=--%@",message.content);
}

/*!
 当App处于后台时，接收到消息并弹出本地通知的回调方法
 
 @param message     接收到的消息
 @param senderName  消息发送者的用户名称
 @return            当返回值为NO时，SDK会弹出默认的本地通知提示；当返回值为YES时，SDK针对此消息不再弹本地通知提示
 
 @discussion 如果您设置了IMKit消息监听之后，当App处于后台，收到消息时弹出本地通知之前，会执行此方法。
 如果App没有实现此方法，SDK会弹出默认的本地通知提示。
 流程：
 SDK接收到消息 -> App处于后台状态 -> 通过用户/群组/群名片信息提供者获取消息的用户/群组/群名片信息
 -> 用户/群组信息为空 -> 不弹出本地通知
 -> 用户/群组信息存在 -> 回调此方法准备弹出本地通知 -> App实现并返回YES        -> SDK不再弹出此消息的本地通知
 -> App未实现此方法或者返回NO -> SDK弹出默认的本地通知提示
 
 
 您可以通过RCIM的disableMessageNotificaiton属性，关闭所有的本地通知(此时不再回调此接口)。
 
 @warning 如果App在后台想使用SDK默认的本地通知提醒，需要实现用户/群组/群名片信息提供者，并返回正确的用户信息或群组信息。
 参考RCIMUserInfoDataSource、RCIMGroupInfoDataSource与RCIMGroupUserInfoDataSource
 */
-(BOOL)onRCIMCustomLocalNotification:(RCMessage*)message
                      withSenderName:(NSString *)senderName
{
    return NO;
}

/*!
 当App处于前台时，接收到消息并播放提示音的回调方法
 
 @param message 接收到的消息
 @return        当返回值为NO时，SDK会播放默认的提示音；当返回值为YES时，SDK针对此消息不再播放提示音
 
 @discussion 到消息时播放提示音之前，会执行此方法。
 如果App没有实现此方法，SDK会播放默认的提示音。
 流程：
 SDK接收到消息 -> App处于前台状态 -> 回调此方法准备播放提示音 -> App实现并返回YES        -> SDK针对此消息不再播放提示音
 -> App未实现此方法或者返回NO -> SDK会播放默认的提示音
 
 您可以通过RCIM的disableMessageAlertSound属性，关闭所有前台消息的提示音(此时不再回调此接口)。
 */
-(BOOL)onRCIMCustomAlertSound:(RCMessage*)message;
{
    return NO;
}

@end
