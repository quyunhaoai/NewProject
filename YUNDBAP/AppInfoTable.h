//
//  AppInfoTable.h
//
//  Created by hw  on 15/12/23
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface AppInfoTable : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *thumbnail;
@property (nonatomic, strong) NSString *signKey;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *appName;
@property (nonatomic, strong) NSString *site;
@property (nonatomic, strong) NSString *offLinePackageUrl;
@property (nonatomic, assign) double xmlVersion;
@property (nonatomic, strong) NSString *xmlDataRootUrl;
@property (nonatomic, strong) NSString *version;
@property (nonatomic, assign) double packageId;
@property (nonatomic, strong) NSString *isTimeOut;
@property (nonatomic, assign) double tableIdentifier;
@property (nonatomic, assign) double updateMode;
@property (nonatomic, strong) NSString *alerText;
@property (nonatomic, strong) NSString *appState;
@property (nonatomic, strong) NSString *upgradeRemindInfo;
@property (nonatomic, assign) double themeId;
@property (nonatomic, assign) double svnOnlineVersion;
@property (nonatomic, assign) BOOL isWifiUpdate;
@property (nonatomic, strong) NSString *xmlNames;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, assign) BOOL iosDownLimit;
@property (nonatomic, strong) NSString *createtime;
+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
