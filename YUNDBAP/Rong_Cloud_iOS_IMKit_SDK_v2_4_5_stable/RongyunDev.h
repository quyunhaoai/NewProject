//
//  RongyunDev.h
//  RongyunMessage
//
//  Created by hao on 16/1/22.
//  Copyright © 2016年 hao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RongIMKit/RongIMKit.h>
#import <RongIMLib/RongIMLib.h>
#import "ChatViewController.h"
#import "ListViewController.h"
@interface RongyunDev : NSObject<RCIMUserInfoDataSource,RCIMReceiveMessageDelegate>
@property (strong,nonatomic)NSString *name;
@property (strong,nonatomic)NSString *appid;
@property (strong,nonatomic)NSString *pass;
@property (strong,nonatomic)NSString *userid;
@property (strong,nonatomic)NSString *portaitUrl;
@property (strong,nonatomic)NSString *signKey;
@property (strong,nonatomic)NSString *discussionID;



+(RongyunDev *)sharedObject;
-(void)requestToken:(NSString *)userid andName:(NSString *)name andtoken:(NSString *)token andportaitUrl:(NSString *)portaitUri;
-(ChatViewController *)creatChat:(NSString *)userid andChatName:(NSString *)name andheadurl:(NSString *)portraiturl;;
-(ListViewController *)rongyunChatViewList;
-(void)setUserid:(NSString *)userid andname:(NSString *)name andportraitUrl:(NSString *)url;
-(ChatViewController *)creatchatRoom:(NSString *)userid andRoomName:(NSString *)name;
-(void)addDiscussion:(NSArray *)userid andDiscussionName:(NSString *)name andheadurl:(NSString *)portraiturl;
-(void)remDiscussion:(NSString *)userid andDiscussionName:(NSString *)name;
@end
