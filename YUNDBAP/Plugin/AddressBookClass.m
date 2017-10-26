//
//  AddressBookClass.m
//  通讯录
//
//  Created by hao on 16/4/18.
//  Copyright © 2016年 hao. All rights reserved.
//

#import "AddressBookClass.h"

@implementation AddressBookClass
{
    NSMutableDictionary *dict;
    
    NSMutableArray *allpeople;
    
    ABAddressBookRef ab;
    // 定义ABRecordRef类型的变量保存当前正在更新的记录
    ABRecordRef rec;
    // 定义ABMutableMultiValueRef变量记录正在修改修改的电话号码属性值。
    ABMutableMultiValueRef phoneValue;
    // 定义ABMutableMultiValueRef变量记录正在修改修改的电子邮件属性值。
    ABMutableMultiValueRef mailValue;
    
    NSArray *phoneNumber;
    
    NSArray *emil;
    
    NSMutableDictionary *peopleDict;
}
+(AddressBookClass *)sharedObject{
    static AddressBookClass *shared = nil;
    static dispatch_once_t tonken;
    dispatch_once(&tonken,^{
        shared = [[AddressBookClass alloc]init];
    });
    return shared;
}
-(id)chackAllpeopleInfo
{
    allpeople = [[NSMutableArray alloc]init];
    int __block tip = 0;
    ABAddressBookRef addbook = nil;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0) {
        addbook = ABAddressBookCreateWithOptions(nil, nil);
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        ABAddressBookRequestAccessWithCompletion(addbook, ^(bool granted, CFErrorRef error) {
            if (!granted) {
                tip = 1;
            }
            dispatch_semaphore_signal(sema);
        });
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    }else{
        
        addbook = ABAddressBookCreate();
    }
    CFArrayRef allLinkPeople = ABAddressBookCopyArrayOfAllPeople(addbook);
    CFIndex number = ABAddressBookGetPersonCount(addbook);
    
    NSMutableDictionary *Kpeople = [NSMutableDictionary dictionary];
    for (NSInteger i=0; i<number; i++) {
        //获取联系人对象的引用
         dict = [[NSMutableDictionary alloc]init];

        ABRecordRef  person = CFArrayGetValueAtIndex(allLinkPeople, i);
        NSNumber *peopleID = [NSNumber numberWithInteger:i];
//        [self setvalues:peopleID forKey:@"id"];
        
//        [personDict setValue:peopleID forKey:@"id"];
        ABRecordID recId = ABRecordGetRecordID(person);
        NSNumber *contactID = [NSNumber numberWithInteger:recId];
        [self setvalues:contactID forKey:@"contactId"];
        NSString*firstName=( NSString*)CFBridgingRelease(ABRecordCopyValue(person, kABPersonFirstNameProperty));
//        [self setvalues:firstName forKey:@"firstName"];
        [self setvalues:firstName forKey:@"firstName"];
        //获取当前联系人姓氏
        
        NSString *lastName=( NSString *)CFBridgingRelease(ABRecordCopyValue(person, kABPersonLastNameProperty));
//        [self setvalues:lastName forKey:@"lastName"];
        [self setvalues:lastName forKey:@"lastName"];
        NSString *displayName;
        if (firstName.length>0 && lastName.length > 0) {
            displayName = [NSString stringWithFormat:@"%@%@",lastName,firstName];

        }else if (firstName.length > 0){
            displayName = firstName;
        }else{
            displayName = lastName;
        }
        [self setvalues:displayName forKey:@"displayName"];
 /*       //获取当前联系人中间名
        NSString*middleName=(__bridge NSString*)(ABRecordCopyValue(person, kABPersonMiddleNameProperty));
        [self setvalues:middleName forKey:@"middleName"];
        //获取当前联系人的名字前缀
        NSString*prefix=(__bridge NSString*)(ABRecordCopyValue(person, kABPersonPrefixProperty));
        [self setvalues:prefix forKey:@"perfix"];
        //获取当前联系人的名字后缀
        NSString*suffix=(__bridge NSString*)(ABRecordCopyValue(person, kABPersonSuffixProperty));
        [self setvalues:suffix forKey:@"suffix"];
        //获取当前联系人的昵称
        NSString*nickName=(__bridge NSString*)(ABRecordCopyValue(person, kABPersonNicknameProperty));
        //    [self setvalues:nickName forKey:@"nickName"];
        //获取当前联系人的名字拼音
        NSString*firstNamePhoneic=(__bridge NSString*)(ABRecordCopyValue(person, kABPersonFirstNamePhoneticProperty));
        //获取当前联系人的姓氏拼音
        NSString*lastNamePhoneic=(__bridge NSString*)(ABRecordCopyValue(person, kABPersonLastNamePhoneticProperty));
        //获取当前联系人的中间名拼音
        NSString*middleNamePhoneic=(__bridge NSString*)(ABRecordCopyValue(person, kABPersonMiddleNamePhoneticProperty));
        //获取当前联系人的公司
        NSString*organization=(__bridge NSString*)(ABRecordCopyValue(person, kABPersonOrganizationProperty));
        [self setvalues:organization forKey:@"company"];
        //获取当前联系人的职位
        NSString*job=(__bridge NSString*)(ABRecordCopyValue(person, kABPersonJobTitleProperty));
        [self setvalues:job forKey:@"title"];
        //获取当前联系人的部门
//        NSString*department=(__bridge NSString*)(ABRecordCopyValue(person, kABPersonDepartmentProperty));
        //获取当前联系人的生日
//        NSString*birthday=(__bridge NSDate*)(ABRecordCopyValue(person, kABPersonBirthdayProperty));
  */
        NSString *emailaddress;
        ABMultiValueRef emails= ABRecordCopyValue(person, kABPersonEmailProperty);
        for (NSInteger j=0; j<ABMultiValueGetCount(emails); j++) {
            //        [emailArr addObject:( NSString*)CFBridgingRelease(ABMultiValueCopyValueAtIndex(emails, j))];
            NSString *email = (NSString *)CFBridgingRelease(ABMultiValueCopyValueAtIndex(emails, j));
            NSString*eLable = (NSString *)CFBridgingRelease(ABMultiValueCopyLabelAtIndex(emails, j));
            NSLog(@"%@  ---  %@",eLable,kABHomeLabel);
            if ([eLable isEqualToString:(NSString*)kABWorkLabel]) {
                emailaddress = email;
                
            } else if ([email isEqualToString:(NSString*)kABHomeLabel]) {
                
                emailaddress = email;
                
            } else {
                
                emailaddress = email;
            }
        }
        //    if (ABMultiValueGetCount(emails)||ABMultiValueGetCount(emails)>0) {
        [self setvalues:emailaddress forKey:@"email"];

        
        //获取当前联系人的备注
//        NSString*notes=(__bridge NSString*)(ABRecordCopyValue(person, kABPersonNoteProperty));
//        [self setvalues:notes forKey:@"note"];
        //获取当前联系人的电话 数组
        NSString *Mobile;
        NSString *HomeNum;
        NSString *workNum;
        NSMutableArray * phoneArr = [[NSMutableArray alloc]init];
        ABMultiValueRef phones= ABRecordCopyValue(person, kABPersonPhoneProperty);
        for (NSInteger j=0; j<ABMultiValueGetCount(phones); j++) {
            [phoneArr addObject:( NSString*)CFBridgingRelease(ABMultiValueCopyValueAtIndex(phones, j))];
            NSString *aPhone =( NSString*)CFBridgingRelease(ABMultiValueCopyValueAtIndex(phones, j));
            NSString *aLabel = (NSString *)CFBridgingRelease(ABMultiValueCopyLabelAtIndex(phones, j));
            if ([aLabel isEqualToString:@"_$!<Mobile>!$_"]) {
                Mobile= aPhone;
                
            }
            
            if ([aLabel isEqualToString:@"_$!<Home>!$_"]) {
                HomeNum = aPhone;
            }
            
            if ([aLabel isEqualToString:@"_$!<Work>!$_"]) {
                workNum= aPhone;
            }
            if (aPhone != nil && aPhone.length > 0) {
                aLabel = [aLabel stringByReplacingOccurrencesOfString:@"_$!<" withString:@""];
                aLabel = [aLabel stringByReplacingOccurrencesOfString:@">!$_" withString:@""];
                [self setvalues:aPhone forKey:aLabel];
            }
        }

        NSLog(@"mobile:%@homeNum:%@jobNum:%@",Mobile,HomeNum,workNum);
        
//        if (ABMultiValueGetCount(phones)||ABMultiValueGetCount(phones)>0) {
//            [self setvalues:phoneArr forKey:@"phones"];
            
//        [self setvalues :Mobile forKey:@"mobile"];
//        [self setvalues:HomeNum forKey:@"homeNum"];
//        [self setvalues:workNum forKey:@"jobNum"];
//        }
        
            //获取创建当前联系人的时间 注意是NSDate
//        NSDate*creatTime=(__bridge NSDate*)(ABRecordCopyValue(person, kABPersonCreationDateProperty));
        //获取最近修改当前联系人的时间
//        NSDate*alterTime=(__bridge NSDate*)(ABRecordCopyValue(person, kABPersonModificationDateProperty));
        //获取地址
        /*
        ABMultiValueRef address = ABRecordCopyValue(person, kABPersonAddressProperty);
        NSDictionary * temDic;
        for (int j=0; j<ABMultiValueGetCount(address); j++) {
            //地址类型
//            NSString * type = ( NSString*)CFBridgingRelease(ABMultiValueCopyLabelAtIndex(address, j));
            temDic = (__bridge NSDictionary *)(ABMultiValueCopyValueAtIndex(address, j));
            //地址字符串，可以按需求格式化
//            NSString * adress = [NSString stringWithFormat:@"国家:%@\n省:%@\n市:%@\n街道:%@\n邮编:%@",[temDic valueForKey:(NSString*)kABPersonAddressCountryKey],[temDic valueForKey:(NSString*)kABPersonAddressStateKey],[temDic valueForKey:(NSString*)kABPersonAddressCityKey],[temDic valueForKey:(NSString*)kABPersonAddressStreetKey],[temDic valueForKey:(NSString*)kABPersonAddressZIPKey]];
//            [self setvalues:temDic forKey:@"address"];
        }
//        [self setvalues:temDic forKey:@"address"];
        //获取当前联系人头像图片
//        NSData*userImage=(__bridge NSData*)(ABPersonCopyImageData(person));
        //获取当前联系人纪念日
        NSMutableArray * dateArr = [[NSMutableArray alloc]init];
        ABMultiValueRef dates= ABRecordCopyValue(person, kABPersonDateProperty);
        for (NSInteger j=0; j<ABMultiValueGetCount(dates); j++) {
            //获取纪念日日期
            NSDate * data =(__bridge NSDate*)(ABMultiValueCopyValueAtIndex(dates, j));
            //获取纪念日名称
            NSString * str =(__bridge NSString*)(ABMultiValueCopyLabelAtIndex(dates, j));
            NSDictionary * temDic = [NSDictionary dictionaryWithObject:data forKey:str];
            [dateArr addObject:temDic];
        }
        */
//        NSString *keystr = [NSString stringWithFormat:@"contactld%ld",i];
//        [Kpeople setObject:personDict forKey:keystr];
        
        [allpeople addObject:dict];
        
        if (person) CFRelease(person);
        if (phones) CFRelease(phones);
        if (emails) CFRelease(emails);
    }
//    [allpeople addObject:dict];
    
    NSLog(@"allpeople:%@",Kpeople);
    NSString *allpeopleInfo = [self DataTOjsonString:allpeople];
    return allpeopleInfo;
}
-(void)setvalues:(id)value forKey:(NSString *)key
{
    if (key == nil || key == NULL || [key isKindOfClass:[NSNull class]]) {
        key = @"电话";
    }
    if (value ==nil|| value == NULL || [value isKindOfClass:[NSNull class]]) {
//        [dict setvalue:@"" forKey:key];
        [dict setValue:@"" forKey:key];
    }else{
        [dict setValue:value forKey:key];
        
    }
    
}
-(id)selectPeople
{
    ABPeoplePickerNavigationController *controller = [[ABPeoplePickerNavigationController alloc]init];
    
    controller.peoplePickerDelegate = self;
    
//    [self presentViewController:controller animated:YES completion:NULL];
    
    
    return controller;
    
}
-(void)deleteperson:(id)personid
{
    NSArray *personArray = (NSArray *)personid;
    NSInteger Id = [[personArray objectAtIndex:0] integerValue];
//    NSInteger Id = 6;
    CFErrorRef error = nil;
    // 创建ABAddressBook，该函数第一个参数暂时并为使用，直接传入NULL即可。
    ABAddressBookRef ab = ABAddressBookCreateWithOptions(NULL, &error);
    if (!error)
    {
        // 请求访问用户地址薄
        ABAddressBookRequestAccessWithCompletion(ab,
                                                 ^(bool granted,CFErrorRef error)
                                                 {
                                                     // 如果用户允许访问地址簿
                                                     if (granted)
                                                     {
                                                         // 从地址薄中获取ID为3的记录
                                                         ABRecordRef rec = ABAddressBookGetPersonWithRecordID(ab , Id);
                                                         BOOL result = ABAddressBookRemoveRecord(ab, rec , NULL);
                                                         if(result)
                                                         {
                                                             // 将程序所做的修改保存到地址薄中，如果保存成功
                                                             if(ABAddressBookSave(ab, NULL))
                                                             {
//                                                                 [self showAlert:@"成功删除ID为3的联系人"];
                                                                 self.complate(YES);
                                                             }
                                                             else
                                                             {
                                                                  self.complate(NO);
//                                                                 [self showAlert:@"保存修改时出现错误"];
                                                             }
                                                         }
                                                         else
                                                         {
                                                              self.complate(NO);
//                                                             [self showAlert:@"删除失败"];
                                                         }
                                                     }
                                                 });
    }
//    if (ab) CFRelease(ab);
}
- (void) showAlert:(NSString*) msg
{
    // 使用UIAlertView显示msg信息
    [[[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
}
-(void)addperson:(id)personInfo
{
    NSArray *personArray = (NSArray *)personInfo;
    NSString* firstName = personArray[1];
    NSString* lastName =  personArray[0];
    NSString* homePhone = personArray[2];
    NSString* mobilePhone = personArray[3];
    NSString* workMail = personArray[4];
    NSString* privateMail = nil;
    NSString* country = nil;
    NSString* state = nil;
    CFErrorRef error = nil;
//    BOOL issuccessful;
    // 创建ABAddressBook，该函数第一个参数暂时并为使用，直接传入NULL即可。
    ABAddressBookRef ab = ABAddressBookCreateWithOptions(NULL, &error);
    if (!error)
    {
        // 请求访问用户地址薄
        ABAddressBookRequestAccessWithCompletion(ab,
                                                 ^(bool granted,CFErrorRef error)
                                                 {
                                                     // 如果用户允许访问地址簿
                                                     if (granted)
                                                     {
                                                         // 创建一条新的记录
                                                         ABRecordRef rec = ABPersonCreate();
                                                         // 为rec的kABPersonFirstNameProperty（名字）属性设置值
                                                         ABRecordSetValue(rec, kABPersonFirstNameProperty
                                                                          , (__bridge CFStringRef)firstName, NULL);
                                                         // 为rec的kABPersonFirstNameProperty（姓氏）属性设置值
                                                         ABRecordSetValue(rec, kABPersonLastNameProperty
                                                                          , (__bridge CFStringRef)lastName, NULL);
                                                         // 创建ABMutableMultiValueRef用来管理多个电话号码
                                                         ABMutableMultiValueRef phoneValue = ABMultiValueCreateMutable
                                                         (kABPersonPhoneProperty);
                                                         // 添加label为家庭的电话号码
                                                         ABMultiValueAddValueAndLabel(phoneValue
                                                                                      , (__bridge CFTypeRef)homePhone
                                                                                      , kABHomeLabel , NULL);
                                                         // 添加label为移动的电话号码
                                                         ABMultiValueAddValueAndLabel(phoneValue
                                                                                      , (__bridge CFTypeRef)mobilePhone
                                                                                      , kABPersonPhoneMobileLabel , NULL);
                                                         // 为rec的kABPersonPhoneProperty（电话）属性设置值
                                                         ABRecordSetValue(rec, kABPersonPhoneProperty
                                                                          , phoneValue , NULL);
                                                         // 创建ABMutableMultiValueRef用来管理多个电子邮件
                                                         ABMutableMultiValueRef mailValue = ABMultiValueCreateMutable
                                                         (kABPersonEmailProperty);
                                                         // 添加label为工作的电子邮件
                                                         ABMultiValueAddValueAndLabel(mailValue
                                                                                      , (__bridge CFStringRef)workMail
                                                                                      , (__bridge CFStringRef)@"工作"  , NULL);
                                                         // 添加label为私人的电子邮件
                                                         ABMultiValueAddValueAndLabel(mailValue
                                                                                      , (__bridge CFStringRef)privateMail
                                                                                      , (__bridge CFStringRef)@"私人" , NULL);
                                                         // 为rec的kABPersonEmailProperty（电子邮件）属性设置值
                                                         ABRecordSetValue(rec, kABPersonEmailProperty
                                                                          , mailValue , NULL);
                                                         // 创建ABMutableMultiValueRef用来管理多个地址
                                                         ABMutableMultiValueRef addrValue = ABMultiValueCreateMutable
                                                         (kABPersonAddressProperty);
                                                         NSDictionary* addrDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                                                                   country, kABPersonAddressCountryKey,
                                                                                   state, kABPersonAddressStateKey, nil];  // ①
                                                         // 添加label为住址的地址
                                                         ABMultiValueAddValueAndLabel(addrValue
                                                                                      , (__bridge CFTypeRef)addrDict
                                                                                      , (__bridge CFStringRef)@"住址" , NULL);
                                                         // 为rec的kABPersonAddressProperty（地址）属性设置值
                                                         ABRecordSetValue(rec, kABPersonAddressProperty, addrValue , NULL);
                                                         BOOL result = ABAddressBookAddRecord(ab, rec , NULL);
                                                         if(result)
                                                         {
                                                             // 将程序所做的修改保存到地址薄中，如果保存成功
                                                             if(ABAddressBookSave(ab, NULL))
                                                             {
                                                                  self.complate(YES);
//                                                                 [self showAlert:@"成功添加新的联系人"];
//                                                                 return result;
                                                             }
                                                            
                                                             else
                                                             {
                                                                  self.complate(NO);
//                                                                 [self showAlert:@"保存添加操作出现错误"];
                                                             }
//                                                             if (rec) {
//                                                                 CFRelease(rec);
//                                                             }
                                                         }
                                                         else
                                                         {
                                                              self.complate(NO);
//                                                             [self showAlert:@"添加失败"];
//                                                             if (ab) {
//                                                                 CFRelease(ab);
//                                                             }
                                                         }

                                                     }
                                                 });
        
        
    }
//    if (ab) CFRelease(ab);
}
    /*
    NSString* firstName = @"";
    NSString* lastName = @"";
    NSString* middleName = @"";
    NSString* prefix = @"";
    NSString* suffix = @"";
    NSString* homePhone = @"";
    NSString* mobilePhone = @"";
    NSString* workMail = @"";
    NSString* privateMail = @"";
    NSString* company = @"";
    NSString* title = @"";
    NSString* city = @"";
    NSString* street = @"";
    NSString* country = @"";
    NSString* state = @"";
    NSString* ZIP = @"";
    NSString* note = @"";
    CFErrorRef error = nil;
    BOOL isOk = nil;
    // 创建ABAddressBook，该函数第一个参数暂时并为使用，直接传入NULL即可。
    ABAddressBookRef ab = ABAddressBookCreateWithOptions(NULL, &error);
    if (!error)
    {
        // 请求访问用户地址薄
        ABAddressBookRequestAccessWithCompletion(ab,
                                                 ^(bool granted,CFErrorRef error)
                                                 {
                                                     // 如果用户允许访问地址簿
                                                     if (granted)
                                                     {
                                                         // 创建一条新的记录
                                                         ABRecordRef rec = ABPersonCreate();
                                                         // 为rec的kABPersonFirstNameProperty（名字）属性设置值
                                                         ABRecordSetValue(rec, kABPersonFirstNameProperty
                                                                          , (__bridge CFStringRef)firstName, NULL);
                                                         // 为rec的kABPersonFirstNameProperty（姓氏）属性设置值
                                                         ABRecordSetValue(rec, kABPersonLastNameProperty
                                                                          , (__bridge CFStringRef)lastName, NULL);
                                                         // 为rec的kABPersonPrefixProperty（）属性设置值
                                                         ABRecordSetValue(rec, kABPersonPrefixProperty
                                                                          , (__bridge CFStringRef)prefix, NULL);
                                                         // 为rec的kABPersonPrefixProperty（）属性设置值
                                                         ABRecordSetValue(rec, kABPersonSuffixProperty
                                                                          , (__bridge CFStringRef)suffix, NULL);
                                                         
                                                         //为rec的KABPersonOrgan属性（公司）设置值
                                                         ABRecordSetValue(rec, kABPersonOrganizationProperty, (__bridge CFStringRef)company, NULL);
                                                         // 为rec的kABPersonJobTitleProperty（职称）属性设置值
                                                         ABRecordSetValue(rec, kABPersonJobTitleProperty, (__bridge CFStringRef)title, NULL);
                                                         // 创建ABMutableMultiValueRef用来管理多个电话号码
                                                         ABMutableMultiValueRef phoneValue = ABMultiValueCreateMutable
                                                         (kABPersonPhoneProperty);
                                                         // 添加label为家庭的电话号码
                                                         ABMultiValueAddValueAndLabel(phoneValue
                                                                                      , (__bridge CFTypeRef)homePhone
                                                                                      , kABHomeLabel , NULL);
                                                         // 添加label为移动的电话号码
                                                         ABMultiValueAddValueAndLabel(phoneValue
                                                                                      , (__bridge CFTypeRef)mobilePhone
                                                                                      , kABPersonPhoneMobileLabel , NULL);
                                                         // 为rec的kABPersonPhoneProperty（电话）属性设置值
                                                         ABRecordSetValue(rec, kABPersonPhoneProperty
                                                                          , phoneValue , NULL);
                                                         // 创建ABMutableMultiValueRef用来管理多个电子邮件
                                                         ABMutableMultiValueRef mailValue = ABMultiValueCreateMutable
                                                         (kABPersonEmailProperty);
                                                         // 添加label为工作的电子邮件
                                                         ABMultiValueAddValueAndLabel(mailValue
                                                                                      , (__bridge CFStringRef)workMail
                                                                                      , (__bridge CFStringRef)@"工作"  , NULL);
                                                         // 添加label为私人的电子邮件
                                                         ABMultiValueAddValueAndLabel(mailValue
                                                                                      , (__bridge CFStringRef)privateMail
                                                                                      , (__bridge CFStringRef)@"私人" , NULL);
                                                         // 为rec的kABPersonEmailProperty（电子邮件）属性设置值
                                                         ABRecordSetValue(rec, kABPersonEmailProperty
                                                                          , mailValue , NULL);
                                                         // 创建ABMutableMultiValueRef用来管理多个地址
                                                         ABMutableMultiValueRef addrValue = ABMultiValueCreateMutable
                                                         (kABPersonAddressProperty);
                                                         NSDictionary* addrDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                                                                   country, kABPersonAddressCountryKey,
                                                                                   state, kABPersonAddressStateKey,
                                                                                   city,kABPersonAddressCityKey,
                                                                                   street,kABPersonAddressStreetKey,
                                                                                   ZIP,kABPersonAddressZIPKey,
                                                                                   nil];  // ①
                                                         // 添加label为住址的地址
                                                         ABMultiValueAddValueAndLabel(addrValue
                                                                                      , (__bridge CFTypeRef)addrDict
                                                                                      , (__bridge CFStringRef)@"住址" , NULL);
                                                         // 为rec的kABPersonAddressProperty（地址）属性设置值
                                                         ABRecordSetValue(rec, kABPersonAddressProperty, addrValue , NULL);
                                                         
                                                         BOOL result = ABAddressBookAddRecord(ab, rec , NULL);
                                                         if(result)
                                                         {
                                                             // 将程序所做的修改保存到地址薄中，如果保存成功
                                                             if(ABAddressBookSave(ab, NULL))
                                                             {
                                                                 [self showAlert:@"成功添加新的联系人"];
                                                                 
                                                             }
                                                             else
                                                             {
                                                                 [self showAlert:@"保存添加操作出现错误"];
                                                             }
                                                             
                                                         }
                                                         else
                                                         {
                                                             [self showAlert:@"添加失败"];
                                                         }
                                                     }
                                                     
                                                 });
        
        
    }
    */
    
//    return  nil;
//}
-(void)updataperson:(id)personInfo
{
    NSArray *personArray = (NSArray *)personInfo;
    
    NSInteger Id = [personArray[0] integerValue];
    CFErrorRef error = nil;
//    if (personInfo[1]) {
    NSString* firstName = personArray[2];
//    }
    phoneNumber = @[personArray[3],personArray[4]];
    emil = [personArray[5] componentsSeparatedByString:@","];
    NSString* lastName = personArray[1];
//    NSString* middleName = @"";
//    NSString* prefix = @"";
//    NSString* suffix = @"";
//    NSString* company = @"";
//    NSString* title = @"";
//    NSString* city = @"";
//    NSString* street = @"";
//    NSString* country = @"";
//    NSString* state = @"";
//    NSString* ZIP = @"";
//    NSString* note = @"";
//    phoneNumber = [NSArray arrayWithObjects:personArray[2],personArray[3], nil];
//    phoneNumber = @[@"3333333",@"44444444444"];
    // 创建ABAddressBook，该函数第一个参数暂时并为使用，直接传入NULL即可。
    ab = ABAddressBookCreateWithOptions(NULL, &error);
    if (!error)
    {
        // 请求访问用户地址薄
        ABAddressBookRequestAccessWithCompletion(ab,
                                                 ^(bool granted,CFErrorRef error)
                                                 {
                                                     // 如果用户允许访问地址簿
                                                     if (granted)
                                                     {
                                                         // 获取ID为1的ABRecordRef记录
                                                         rec = ABAddressBookGetPersonWithRecordID(ab , Id);
                                                         //修改名字
                                                         ABRecordSetValue(rec, kABPersonFirstNameProperty
                                                                          , (__bridge CFStringRef)firstName, NULL);
                                                         //修改姓氏
                                                         ABRecordSetValue(rec, kABPersonLastNameProperty
                                                                          , (__bridge CFStringRef)lastName, NULL);
                                                           /*
                                                         //修改中间名字
                                                         ABRecordSetValue(rec, kABPersonMiddleNameProperty, (__bridge CFStringRef)middleName, NULL);
                                                         
                                                         ABRecordSetValue(rec, kABPersonSuffixProperty, (__bridge CFStringRef)suffix, NULL);
                                                         ABRecordSetValue(rec, kABPersonPrefixProperty, (__bridge CFStringRef)prefix, NULL);
                                                         ABRecordSetValue(rec, kABPersonOrganizationProperty, (__bridge CFStringRef)company, NULL);
                                                         ABRecordSetValue(rec, kABPersonJobTitleProperty, (__bridge CFStringRef)title, NULL);
                                                         //修改地址
                                                         ABRecordSetValue(rec, kABPersonAddressCountryKey, (__bridge CFStringRef)country, NULL);
                                                         ABRecordSetValue(rec, kABPersonAddressStateKey, (__bridge CFStringRef)state, NULL);
                                                         ABRecordSetValue(rec, kABPersonAddressCityKey, (__bridge CFStringRef)city, NULL);
                                                         ABRecordSetValue(rec, kABPersonAddressStreetKey, (__bridge CFStringRef)street, NULL);
                                                         ABRecordSetValue(rec, kABPersonAddressZIPKey, (__bridge CFStringRef)ZIP, NULL);
                                                         //修改备注
                                                         ABRecordSetValue(rec, kABPersonNoteProperty, (__bridge CFStringRef)note, NULL);
                                                         */
                                                         phoneValue = ABRecordCopyValue(rec, kABPersonPhoneProperty);
                                                         mailValue = ABRecordCopyValue(rec, kABPersonEmailProperty);
                                                         
                                                         // 调用updateMultiValue:properyKey:property:方法修改ABRecordRef的
                                                         // kABPersonPhoneProperty属性
                                                         [self updateMultiValue:phoneValue properyKey:PHONE_PROPERTY_KEY
                                                                       property:kABPersonPhoneProperty];
                                                         // 调用updateMultiValue:properyKey:property:方法修改ABRecordRef的
                                                         // kABPersonEmailProperty属性
                                                         [self updateMultiValue:mailValue properyKey:MAIL_PROPERTY_KEY
                                                                       property:kABPersonEmailProperty];
                                                         
                                                         
                                                         if(ABAddressBookSave(ab, NULL))
                                                         {
                                                             self.complate(YES);
//                                                             [self showAlert:@"修改成功"];÷  
                                                         }
                                                         else
                                                         {
                                                             self.complate(NO);
//                                                             [self showAlert:@"修改出现错误"];
                                                         }
                                                         
                                                         
                                                     }
                                                 });
    }

    
}



- (void) updateMultiValue:(ABMutableMultiValueRef)multiValue
               properyKey:(NSString*) properyKey property:(ABPropertyID) property
{
    NSInteger num;
    NSArray* textFieldArray;
    NSArray *labels;
    // 取出该属性对应的所有UITextView组成的NSArray
    if ([properyKey isEqualToString:PHONE_PROPERTY_KEY]) {
        textFieldArray = phoneNumber;
        num = textFieldArray.count;
//       labels = [NSArray arrayWithObjects:kABPersonPhoneIPhoneLabel,kABPersonPhoneMobileLabel,nil];
        labels = [NSArray arrayWithObjects:@"_$!<Home>!$_",@"_$!<Mobile>!$_", nil];
    }
    if ([properyKey isEqualToString:MAIL_PROPERTY_KEY]) {
        textFieldArray = emil;
        num = textFieldArray.count;
//        labels = [NSArray arrayWithObjects:kABHomeLabel,nil];
        labels = [NSArray arrayWithObjects:@"home", nil];

    }
    NSLog(@"---%d",num);
    // 创建一个新的ABMutableMultiValueRef
    ABMutableMultiValueRef newMutli = ABMultiValueCreateMutable(property);
    // 遍历UITextView组成的NSArray集合中每个UITextField控件
        for (int i = 0 ; i < num ; i ++)
        {
    // 获取第i个UITextField控件中的字符串，该字符串将作为新的值。
            NSString* value = textFieldArray[i];
            NSLog(@"%@",value);
    // 获取第i条数据原有的Label
//            CFStringRef label = ABMultiValueCopyLabelAtIndex(multiValue, i);
//            CFStringRef label = (CFStringRef )[labels objectAtIndex:i];
//            NSString *aLabel = (NSString *)CFBridgingRelease(ABMultiValueCopyLabelAtIndex(newMutli, i));
//            NSLog(@"%@",label);/
//            NSLog(@"%@",(NSString *)label);
    // 添加新的值和原有的Label（Label不需要修改）
            ABMultiValueAddValueAndLabel(newMutli,
                                         (__bridge CFStringRef)value, (__bridge CFStringRef)[labels objectAtIndex:i], NULL);
        }
    ABRecordSetValue(rec, property, newMutli, NULL);
//    if (newMutli) CFRelease(newMutli);
}
-(void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person
{
    //    ABRecordID * recordID = (__bridge ABRecordID*)ABRecordGetRecordID(person);
    //    ABRecordID recId =    ABRecordGetRecordID(person);
    ////    int a =recordID
    //    NSLog(@"----%d",recId);
    //    NSLog(@"----%@",recordID);
    //    NSNumber *recordId = [NSNumber numberWithInteger:ABRecordGetRecordID(person)];
    //    NSLog(@"record id is %d",recordId);
    //    NSLog(@"1%@",person);
    dict = [[NSMutableDictionary alloc]init];
    ABRecordID recId = ABRecordGetRecordID(person);
    //    NSString* type = (__bridge NSString*)ABRecordGetRecordType(person);
    //    NSLog(@"tecordType:%@",type);
    NSLog(@"recordID:---%d----",recId);
    NSString *name = (__bridge NSString*)ABRecordCopyCompositeName(person);
    NSLog(@"%@",name);
    //    CFStringRef name = ABRecordCopyValue((__bridge ABRecordRef)person,kABGroupNameProperty);
    //    ABRecordID groupId = ABRecordGetRecordID((__bridge ABRecordRef)group);
    //    NSLog(@"Group Name: %@ RecordID:%d",name, recId);
    
    
    NSNumber *peopleID = [NSNumber numberWithInteger:recId];
    [self setvalues:peopleID forKey:@"contactId"];
    NSString*firstName=( NSString*)CFBridgingRelease(ABRecordCopyValue(person, kABPersonFirstNameProperty));
    [self setvalues:firstName forKey:@"firstName"];
    //获取当前联系人姓氏
    
    NSString *lastName=( NSString *)CFBridgingRelease(ABRecordCopyValue(person, kABPersonLastNameProperty));
    [self setvalues:lastName forKey:@"lastName"];
    //全名
    NSString *displayName;
    if (firstName.length>0 && lastName.length > 0) {
        displayName = [NSString stringWithFormat:@"%@%@",lastName,firstName];
        
    }else if (firstName.length > 0){
        displayName = firstName;
    }else{
        displayName = lastName;
    }
    [self setvalues:displayName forKey:@"displayName"];
    /*
    //获取当前联系人中间名
    NSString*middleName=(__bridge NSString*)(ABRecordCopyValue(person, kABPersonMiddleNameProperty));
    [self setvalues:middleName forKey:@"middleName"];
    //获取当前联系人的名字前缀
    NSString*prefix=(__bridge NSString*)(ABRecordCopyValue(person, kABPersonPrefixProperty));
    [self setvalues:prefix forKey:@"perfix"];
    //获取当前联系人的名字后缀
    NSString*suffix=(__bridge NSString*)(ABRecordCopyValue(person, kABPersonSuffixProperty));
    [self setvalues:suffix forKey:@"suffix"];
    //获取当前联系人的昵称
    NSString*nickName=(__bridge NSString*)(ABRecordCopyValue(person, kABPersonNicknameProperty));
    //    [self setvalues:nickName forKey:@"nickName"];
    //获取当前联系人的名字拼音
    NSString*firstNamePhoneic=(__bridge NSString*)(ABRecordCopyValue(person, kABPersonFirstNamePhoneticProperty));
    //获取当前联系人的姓氏拼音
    NSString*lastNamePhoneic=(__bridge NSString*)(ABRecordCopyValue(person, kABPersonLastNamePhoneticProperty));
    //获取当前联系人的中间名拼音
    NSString*middleNamePhoneic=(__bridge NSString*)(ABRecordCopyValue(person, kABPersonMiddleNamePhoneticProperty));
    //获取当前联系人的公司
    NSString*organization=(__bridge NSString*)(ABRecordCopyValue(person, kABPersonOrganizationProperty));
    [self setvalues:organization forKey:@"company"];
    //获取当前联系人的职位
    NSString*job=(__bridge NSString*)(ABRecordCopyValue(person, kABPersonJobTitleProperty));
    [self setvalues:job forKey:@"title"];
    //获取当前联系人的部门
    NSString*department=(__bridge NSString*)(ABRecordCopyValue(person, kABPersonDepartmentProperty));
    //获取当前联系人的生日
    NSString*birthday=(__bridge NSDate*)(ABRecordCopyValue(person, kABPersonBirthdayProperty));
     */
//    NSMutableArray * emailArr = [[NSMutableArray alloc]init];
    //获取当前联系人的邮箱 注意是数组
    NSString *emailaddress;
    ABMultiValueRef emails= ABRecordCopyValue(person, kABPersonEmailProperty);
    for (NSInteger j=0; j<ABMultiValueGetCount(emails); j++) {
//        [emailArr addObject:( NSString*)CFBridgingRelease(ABMultiValueCopyValueAtIndex(emails, j))];
        NSString *email = (NSString *)CFBridgingRelease(ABMultiValueCopyValueAtIndex(emails, j));
        NSString*eLable = (NSString *)CFBridgingRelease(ABMultiValueCopyLabelAtIndex(emails, j));
        NSLog(@"%@  ---  %@",eLable,kABHomeLabel);
        if ([eLable isEqualToString:(NSString*)kABWorkLabel]) {
            emailaddress = email;

        } else if ([email isEqualToString:(NSString*)kABHomeLabel]) {
            
            emailaddress = email;
            
        } else {
            
            emailaddress = email;
        }
    }
//    if (ABMultiValueGetCount(emails)||ABMultiValueGetCount(emails)>0) {
        [self setvalues:emailaddress forKey:@"email"];
//    CFRelease(emails);
//    }
    /*
    //获取当前联系人的备注
    NSString*notes=(__bridge NSString*)(ABRecordCopyValue(person, kABPersonNoteProperty));
    [self setvalues:notes forKey:@"note"];
     */
    //获取当前联系人的电话 数组
    NSString *Mobile;
    NSString *HomeNum;
    NSString *workNum;
    NSMutableArray * phoneArr = [[NSMutableArray alloc]init];
    ABMultiValueRef phones= ABRecordCopyValue(person, kABPersonPhoneProperty);
    for (NSInteger j=0; j<ABMultiValueGetCount(phones); j++) {
        [phoneArr addObject:( NSString*)CFBridgingRelease(ABMultiValueCopyValueAtIndex(phones, j))];
        NSString *aPhone =( NSString*)CFBridgingRelease(ABMultiValueCopyValueAtIndex(phones, j));
        NSString *aLabel = (NSString *)CFBridgingRelease(ABMultiValueCopyLabelAtIndex(phones, j));
        if ([aLabel isEqualToString:@"_$!<Mobile>!$_"]) {
            Mobile= aPhone;
            
        }
        
        if ([aLabel isEqualToString:@"_$!<Home>!$_"]) {
            HomeNum = aPhone;
        }
        
        if ([aLabel isEqualToString:@"_$!<Work>!$_"]) {
            workNum= aPhone;
        }
        if (aPhone != nil && aPhone.length > 0) {
            aLabel = [aLabel stringByReplacingOccurrencesOfString:@"_$!<" withString:@""];
            aLabel = [aLabel stringByReplacingOccurrencesOfString:@">!$_" withString:@""];
            [self setvalues:aPhone forKey:aLabel];
        }
    }

//        [self setvalues:phoneArr forKey:@"phones"];
    
//        [self setvalues:Mobile forKey:@"mobile"];
//        [self setvalues:HomeNum forKey:@"homeNum"];
//        [self setvalues:workNum forKey:@"jobNum"];
    
/*
    //获取创建当前联系人的时间 注意是NSDate
    NSDate*creatTime=(__bridge NSDate*)(ABRecordCopyValue(person, kABPersonCreationDateProperty));
    //获取最近修改当前联系人的时间
    NSDate*alterTime=(__bridge NSDate*)(ABRecordCopyValue(person, kABPersonModificationDateProperty));

    //获取地址
    ABMultiValueRef address = ABRecordCopyValue(person, kABPersonAddressProperty);
    NSDictionary * temDic;
    for (int j=0; j<ABMultiValueGetCount(address); j++) {
        //地址类型
        NSString * type = ( NSString*)CFBridgingRelease(ABMultiValueCopyLabelAtIndex(address, j));
        temDic = (__bridge NSDictionary *)(ABMultiValueCopyValueAtIndex(address, j));
        //地址字符串，可以按需求格式化
        NSString * adress = [NSString stringWithFormat:@"国家:%@\n省:%@\n市:%@\n街道:%@\n邮编:%@",[temDic valueForKey:(NSString*)kABPersonAddressCountryKey],[temDic valueForKey:(NSString*)kABPersonAddressStateKey],[temDic valueForKey:(NSString*)kABPersonAddressCityKey],[temDic valueForKey:(NSString*)kABPersonAddressStreetKey],[temDic valueForKey:(NSString*)kABPersonAddressZIPKey]];
        NSLog(@"%@",adress);

    }
    [self setvalues:temDic forKey:@"address"];

    //获取当前联系人头像图片
    NSData*userImage=(__bridge NSData*)(ABPersonCopyImageData(person));
    //获取当前联系人纪念日
    NSMutableArray * dateArr = [[NSMutableArray alloc]init];
    ABMultiValueRef dates= ABRecordCopyValue(person, kABPersonDateProperty);
    for (NSInteger j=0; j<ABMultiValueGetCount(dates); j++) {
        //获取纪念日日期
        NSDate * data =(__bridge NSDate*)(ABMultiValueCopyValueAtIndex(dates, j));
        //获取纪念日名称
        NSString * str =(__bridge NSString*)(ABMultiValueCopyLabelAtIndex(dates, j));
        NSDictionary * temDic = [NSDictionary dictionaryWithObject:data forKey:str];
        [dateArr addObject:temDic];
    }
*/
    //    NSString *personID = (NSString *)ABRecordGetRecordID(person);
    //    NSLog(@"-----%@",personID);
    //     ABRecordID contactId = ABRecordGetRecordID(person);
    //    NSLog(@"---%@",contactId);
    //    NSString *pid = (__bridge NSString*)contactId;
    //    NSLog(@"--%@",pid);
    NSLog(@"-----%@",dict);
    //     [personPicker dismissViewControllerAnimated:YES completion:nil];
//    if (person) CFRelease(person);
//    if (phones) CFRelease(phones);
//    if (emails) CFRelease(emails);
    NSString *str = [self DataTOjsonString:dict];
    self.complateString(str);
    
}
-(void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
    NSLog(@"取消");
}
-(BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
    return NO;
}
-(NSString*)DataTOjsonString:(id)object
{
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
/*
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        jsonString = [jsonString stringByReplacingOccurrencesOfString:@" " withString:@""];
        
    }
    NSLog(@"--%@--",jsonString);
    NSLog(@"%@",[jsonString class]);
    
    
    return jsonString;*/
}

@end
