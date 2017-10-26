//
//  AppInfoTable.m
//
//  Created by hw  on 15/12/23
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "AppInfoTable.h"


NSString *const kAppInfoTableThumbnail = @"thumbnail";
NSString *const kAppInfoTableSignKey = @"SignKey";
NSString *const kAppInfoTableUrl = @"url";
NSString *const kAppInfoTableAppName = @"app_name";
NSString *const kAppInfoTableSite = @"site";
NSString *const kAppInfoTableOffLinePackageUrl = @"OffLinePackageUrl";
NSString *const kAppInfoTableXmlVersion = @"XmlVersion";
NSString *const kAppInfoTableXmlDataRootUrl = @"XmlDataRootUrl";
NSString *const kAppInfoTableVersion = @"version";
NSString *const kAppInfoTablePackageId = @"package_id";
NSString *const kAppInfoTableIsTimeOut = @"isTimeOut";
NSString *const kAppInfoTableId = @"id";
NSString *const kAppInfoTableUpdateMode = @"UpdateMode";
NSString *const kAppInfoTableAlerText = @"AlerText";
NSString *const kAppInfoTableAppState = @"appState";
NSString *const kAppInfoTableUpgradeRemindInfo = @"UpgradeRemindInfo";
NSString *const kAppInfoTableThemeId = @"theme_id";
NSString *const kAppInfoTableSvnOnlineVersion = @"SvnOnlineVersion";
NSString *const kAppInfoTableIsWifiUpdate = @"IsWifiUpdate";
NSString *const kAppInfoTableXmlNames = @"XmlNames";
NSString *const kAppInfoTableUsername = @"username";
NSString *const kStringsXmlIosDownLimit = @"IosDownLimit";
NSString *const kAppInfoTablecreatetime = @"createtime";
@interface AppInfoTable ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation AppInfoTable

@synthesize thumbnail = _thumbnail;
@synthesize signKey = _signKey;
@synthesize url = _url;
@synthesize appName = _appName;
@synthesize site = _site;
@synthesize offLinePackageUrl = _offLinePackageUrl;
@synthesize xmlVersion = _xmlVersion;
@synthesize xmlDataRootUrl = _xmlDataRootUrl;
@synthesize version = _version;
@synthesize packageId = _packageId;
@synthesize isTimeOut = _isTimeOut;
@synthesize tableIdentifier = _tableIdentifier;
@synthesize updateMode = _updateMode;
@synthesize alerText = _alerText;
@synthesize appState = _appState;
@synthesize upgradeRemindInfo = _upgradeRemindInfo;
@synthesize themeId = _themeId;
@synthesize svnOnlineVersion = _svnOnlineVersion;
@synthesize isWifiUpdate = _isWifiUpdate;
@synthesize xmlNames = _xmlNames;
@synthesize username = _username;
@synthesize iosDownLimit = _iosDownLimit;
@synthesize createtime = _createtime;
+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
        self.thumbnail = [self objectOrNilForKey:kAppInfoTableThumbnail fromDictionary:dict];
        self.signKey = [self objectOrNilForKey:kAppInfoTableSignKey fromDictionary:dict];
        self.url = [self objectOrNilForKey:kAppInfoTableUrl fromDictionary:dict];
        self.appName = [self objectOrNilForKey:kAppInfoTableAppName fromDictionary:dict];
        self.site = [self objectOrNilForKey:kAppInfoTableSite fromDictionary:dict];
        self.offLinePackageUrl = [self objectOrNilForKey:kAppInfoTableOffLinePackageUrl fromDictionary:dict];
        self.xmlVersion = [[self objectOrNilForKey:kAppInfoTableXmlVersion fromDictionary:dict] doubleValue];
        self.xmlDataRootUrl = [self objectOrNilForKey:kAppInfoTableXmlDataRootUrl fromDictionary:dict];
        self.version = [self objectOrNilForKey:kAppInfoTableVersion fromDictionary:dict];
        self.packageId = [[self objectOrNilForKey:kAppInfoTablePackageId fromDictionary:dict] doubleValue];
        self.isTimeOut = [self objectOrNilForKey:kAppInfoTableIsTimeOut fromDictionary:dict];
        self.tableIdentifier = [[self objectOrNilForKey:kAppInfoTableId fromDictionary:dict] doubleValue];
        self.updateMode = [[self objectOrNilForKey:kAppInfoTableUpdateMode fromDictionary:dict] doubleValue];
        self.alerText = [self objectOrNilForKey:kAppInfoTableAlerText fromDictionary:dict];
        self.appState = [self objectOrNilForKey:kAppInfoTableAppState fromDictionary:dict];
        self.upgradeRemindInfo = [self objectOrNilForKey:kAppInfoTableUpgradeRemindInfo fromDictionary:dict];
        self.themeId = [[self objectOrNilForKey:kAppInfoTableThemeId fromDictionary:dict] doubleValue];
        self.svnOnlineVersion = [[self objectOrNilForKey:kAppInfoTableSvnOnlineVersion fromDictionary:dict] doubleValue];
        self.isWifiUpdate = [[self objectOrNilForKey:kAppInfoTableIsWifiUpdate fromDictionary:dict] boolValue];
        self.xmlNames = [self objectOrNilForKey:kAppInfoTableXmlNames fromDictionary:dict];
        self.username = [self objectOrNilForKey:kAppInfoTableUsername fromDictionary:dict];
        self.iosDownLimit = [[self objectOrNilForKey:kStringsXmlIosDownLimit fromDictionary:dict] boolValue];
        self.createtime = [self objectOrNilForKey:kAppInfoTablecreatetime fromDictionary:dict];
    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.thumbnail forKey:kAppInfoTableThumbnail];
    [mutableDict setValue:self.signKey forKey:kAppInfoTableSignKey];
    [mutableDict setValue:self.url forKey:kAppInfoTableUrl];
    [mutableDict setValue:self.appName forKey:kAppInfoTableAppName];
    [mutableDict setValue:self.site forKey:kAppInfoTableSite];
    [mutableDict setValue:self.offLinePackageUrl forKey:kAppInfoTableOffLinePackageUrl];
    [mutableDict setValue:[NSNumber numberWithDouble:self.xmlVersion] forKey:kAppInfoTableXmlVersion];
    [mutableDict setValue:self.xmlDataRootUrl forKey:kAppInfoTableXmlDataRootUrl];
    [mutableDict setValue:self.version forKey:kAppInfoTableVersion];
    [mutableDict setValue:[NSNumber numberWithDouble:self.packageId] forKey:kAppInfoTablePackageId];
    [mutableDict setValue:self.isTimeOut forKey:kAppInfoTableIsTimeOut];
    [mutableDict setValue:[NSNumber numberWithDouble:self.tableIdentifier] forKey:kAppInfoTableId];
    [mutableDict setValue:[NSNumber numberWithDouble:self.updateMode] forKey:kAppInfoTableUpdateMode];
    [mutableDict setValue:self.alerText forKey:kAppInfoTableAlerText];
    [mutableDict setValue:self.appState forKey:kAppInfoTableAppState];
    [mutableDict setValue:self.upgradeRemindInfo forKey:kAppInfoTableUpgradeRemindInfo];
    [mutableDict setValue:[NSNumber numberWithDouble:self.themeId] forKey:kAppInfoTableThemeId];
    [mutableDict setValue:[NSNumber numberWithDouble:self.svnOnlineVersion] forKey:kAppInfoTableSvnOnlineVersion];
    [mutableDict setValue:[NSNumber numberWithBool:self.isWifiUpdate] forKey:kAppInfoTableIsWifiUpdate];
    [mutableDict setValue:self.xmlNames forKey:kAppInfoTableXmlNames];
    [mutableDict setValue:self.username forKey:kAppInfoTableUsername];
    [mutableDict setObject:[NSNumber numberWithBool:self.iosDownLimit] forKey:kStringsXmlIosDownLimit];
    [mutableDict setValue:self.createtime forKey:kAppInfoTablecreatetime];
    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@", [self dictionaryRepresentation]];
}

#pragma mark - Helper Method
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict
{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}


#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    self.thumbnail = [aDecoder decodeObjectForKey:kAppInfoTableThumbnail];
    self.signKey = [aDecoder decodeObjectForKey:kAppInfoTableSignKey];
    self.url = [aDecoder decodeObjectForKey:kAppInfoTableUrl];
    self.appName = [aDecoder decodeObjectForKey:kAppInfoTableAppName];
    self.site = [aDecoder decodeObjectForKey:kAppInfoTableSite];
    self.offLinePackageUrl = [aDecoder decodeObjectForKey:kAppInfoTableOffLinePackageUrl];
    self.xmlVersion = [aDecoder decodeDoubleForKey:kAppInfoTableXmlVersion];
    self.xmlDataRootUrl = [aDecoder decodeObjectForKey:kAppInfoTableXmlDataRootUrl];
    self.version = [aDecoder decodeObjectForKey:kAppInfoTableVersion];
    self.packageId = [aDecoder decodeDoubleForKey:kAppInfoTablePackageId];
    self.isTimeOut = [aDecoder decodeObjectForKey:kAppInfoTableIsTimeOut];
    self.tableIdentifier = [aDecoder decodeDoubleForKey:kAppInfoTableId];
    self.updateMode = [aDecoder decodeDoubleForKey:kAppInfoTableUpdateMode];
    self.alerText = [aDecoder decodeObjectForKey:kAppInfoTableAlerText];
    self.appState = [aDecoder decodeObjectForKey:kAppInfoTableAppState];
    self.upgradeRemindInfo = [aDecoder decodeObjectForKey:kAppInfoTableUpgradeRemindInfo];
    self.themeId = [aDecoder decodeDoubleForKey:kAppInfoTableThemeId];
    self.svnOnlineVersion = [aDecoder decodeDoubleForKey:kAppInfoTableSvnOnlineVersion];
    self.isWifiUpdate = [aDecoder decodeBoolForKey:kAppInfoTableIsWifiUpdate];
    self.xmlNames = [aDecoder decodeObjectForKey:kAppInfoTableXmlNames];
    self.username = [aDecoder decodeObjectForKey:kAppInfoTableUsername];
    self.iosDownLimit = [aDecoder decodeObjectForKey:kStringsXmlIosDownLimit];
    self.createtime = [aDecoder decodeObjectForKey:kAppInfoTablecreatetime];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    
    [aCoder encodeObject:_thumbnail forKey:kAppInfoTableThumbnail];
    [aCoder encodeObject:_signKey forKey:kAppInfoTableSignKey];
    [aCoder encodeObject:_url forKey:kAppInfoTableUrl];
    [aCoder encodeObject:_appName forKey:kAppInfoTableAppName];
    [aCoder encodeObject:_site forKey:kAppInfoTableSite];
    [aCoder encodeObject:_offLinePackageUrl forKey:kAppInfoTableOffLinePackageUrl];
    [aCoder encodeDouble:_xmlVersion forKey:kAppInfoTableXmlVersion];
    [aCoder encodeObject:_xmlDataRootUrl forKey:kAppInfoTableXmlDataRootUrl];
    [aCoder encodeObject:_version forKey:kAppInfoTableVersion];
    [aCoder encodeDouble:_packageId forKey:kAppInfoTablePackageId];
    [aCoder encodeObject:_isTimeOut forKey:kAppInfoTableIsTimeOut];
    [aCoder encodeDouble:_tableIdentifier forKey:kAppInfoTableId];
    [aCoder encodeDouble:_updateMode forKey:kAppInfoTableUpdateMode];
    [aCoder encodeObject:_alerText forKey:kAppInfoTableAlerText];
    [aCoder encodeObject:_appState forKey:kAppInfoTableAppState];
    [aCoder encodeObject:_upgradeRemindInfo forKey:kAppInfoTableUpgradeRemindInfo];
    [aCoder encodeDouble:_themeId forKey:kAppInfoTableThemeId];
    [aCoder encodeDouble:_svnOnlineVersion forKey:kAppInfoTableSvnOnlineVersion];
    [aCoder encodeBool:_isWifiUpdate forKey:kAppInfoTableIsWifiUpdate];
    [aCoder encodeObject:_xmlNames forKey:kAppInfoTableXmlNames];
    [aCoder encodeObject:_username forKey:kAppInfoTableUsername];
    [aCoder encodeBool:_iosDownLimit forKey:kStringsXmlIosDownLimit];
    [aCoder encodeObject:_createtime forKey:kAppInfoTablecreatetime];
}

- (id)copyWithZone:(NSZone *)zone
{
    AppInfoTable *copy = [[AppInfoTable alloc] init];
    
    if (copy) {
        
        copy.thumbnail = [self.thumbnail copyWithZone:zone];
        copy.signKey = [self.signKey copyWithZone:zone];
        copy.url = [self.url copyWithZone:zone];
        copy.appName = [self.appName copyWithZone:zone];
        copy.site = [self.site copyWithZone:zone];
        copy.offLinePackageUrl = [self.offLinePackageUrl copyWithZone:zone];
        copy.xmlVersion = self.xmlVersion;
        copy.xmlDataRootUrl = [self.xmlDataRootUrl copyWithZone:zone];
        copy.version = [self.version copyWithZone:zone];
        copy.packageId = self.packageId;
        copy.isTimeOut = [self.isTimeOut copyWithZone:zone];
        copy.tableIdentifier = self.tableIdentifier;
        copy.updateMode = self.updateMode;
        copy.alerText = [self.alerText copyWithZone:zone];
        copy.appState = [self.appState copyWithZone:zone];
        copy.upgradeRemindInfo = [self.upgradeRemindInfo copyWithZone:zone];
        copy.themeId = self.themeId;
        copy.svnOnlineVersion = self.svnOnlineVersion;
        copy.isWifiUpdate = self.isWifiUpdate;
        copy.xmlNames = [self.xmlNames copyWithZone:zone];
        copy.username = [self.username copyWithZone:zone];
        copy.iosDownLimit = self.iosDownLimit;
        copy.createtime = [self.createtime copyWithZone:zone];
    }
    
    return copy;
}


@end
