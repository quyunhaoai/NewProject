//
//  AddressBookClass.h
//  通讯录
//
//  Created by hao on 16/4/18.
//  Copyright © 2016年 hao. All rights reserved.
//
#define PHONE_PROPERTY_KEY @"phone"
#define MAIL_PROPERTY_KEY @"mail"
#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
@interface AddressBookClass : NSObject<ABPeoplePickerNavigationControllerDelegate>
+(AddressBookClass *)sharedObject;
-(id)chackAllpeopleInfo;
-(id)selectPeople;
-(void)deleteperson:(id)personid;
-(void)addperson:(id)personInfo;
-(void)updataperson:(id)personInfo;
//-(void)isaddsuccessful:(void ^complate)(BOOL result);

@property (copy, nonatomic) void (^complate)(BOOL result);
@property (copy, nonatomic) void (^complateString)(NSString *dataSting);
@end
