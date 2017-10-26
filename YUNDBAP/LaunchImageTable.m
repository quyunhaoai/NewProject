//
//  LaunchImageTable.m
//
//  Created by 9vs  on 15/2/2
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "LaunchImageTable.h"


NSString *const kLaunchImageTableTypename = @"typename";
NSString *const kLaunchImageTableIcontypeId = @"icontype_id";
NSString *const kLaunchImageTableIconurl = @"iconurl";
NSString *const kLaunchImageTableId = @"id";
NSString *const kLaunchImageTableAppsId = @"apps_id";
NSString *const kLaunchImageTableIconname = @"iconname";
NSString *const kLaunchImageTableAppName = @"app_name";
NSString *const kLaunchImageTableRemark = @"remark";
NSString *const kLaunchImageIconlink = @"iconlink";

@interface LaunchImageTable ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation LaunchImageTable

@synthesize typename = _typename;
@synthesize icontypeId = _icontypeId;
@synthesize iconurl = _iconurl;
@synthesize tableIdentifier = _tableIdentifier;
@synthesize appsId = _appsId;
@synthesize iconname = _iconname;
@synthesize appName = _appName;
@synthesize remark = _remark;
@synthesize iconlink = _iconlink;

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
        self.typename = [self objectOrNilForKey:kLaunchImageTableTypename fromDictionary:dict];
        self.icontypeId = [[self objectOrNilForKey:kLaunchImageTableIcontypeId fromDictionary:dict] doubleValue];
        self.iconurl = [self objectOrNilForKey:kLaunchImageTableIconurl fromDictionary:dict];
        self.tableIdentifier = [[self objectOrNilForKey:kLaunchImageTableId fromDictionary:dict] doubleValue];
        self.appsId = [[self objectOrNilForKey:kLaunchImageTableAppsId fromDictionary:dict] doubleValue];
        self.iconname = [self objectOrNilForKey:kLaunchImageTableIconname fromDictionary:dict];
        self.appName = [self objectOrNilForKey:kLaunchImageTableAppName fromDictionary:dict];
        self.remark = [self objectOrNilForKey:kLaunchImageTableRemark fromDictionary:dict];
        self.iconlink = [self objectOrNilForKey:kLaunchImageIconlink fromDictionary:dict];
    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.typename forKey:kLaunchImageTableTypename];
    [mutableDict setValue:[NSNumber numberWithDouble:self.icontypeId] forKey:kLaunchImageTableIcontypeId];
    [mutableDict setValue:self.iconurl forKey:kLaunchImageTableIconurl];
    [mutableDict setValue:[NSNumber numberWithDouble:self.tableIdentifier] forKey:kLaunchImageTableId];
    [mutableDict setValue:[NSNumber numberWithDouble:self.appsId] forKey:kLaunchImageTableAppsId];
    [mutableDict setValue:self.iconname forKey:kLaunchImageTableIconname];
    [mutableDict setValue:self.appName forKey:kLaunchImageTableAppName];
    [mutableDict setValue:self.remark forKey:kLaunchImageTableRemark];
    [mutableDict setValue:self.iconlink forKey:kLaunchImageIconlink];
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
    
    self.typename = [aDecoder decodeObjectForKey:kLaunchImageTableTypename];
    self.icontypeId = [aDecoder decodeDoubleForKey:kLaunchImageTableIcontypeId];
    self.iconurl = [aDecoder decodeObjectForKey:kLaunchImageTableIconurl];
    self.tableIdentifier = [aDecoder decodeDoubleForKey:kLaunchImageTableId];
    self.appsId = [aDecoder decodeDoubleForKey:kLaunchImageTableAppsId];
    self.iconname = [aDecoder decodeObjectForKey:kLaunchImageTableIconname];
    self.appName = [aDecoder decodeObjectForKey:kLaunchImageTableAppName];
    self.remark = [aDecoder decodeObjectForKey:kLaunchImageTableRemark];
    self.iconlink = [aDecoder decodeObjectForKey:kLaunchImageIconlink];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    
    [aCoder encodeObject:_typename forKey:kLaunchImageTableTypename];
    [aCoder encodeDouble:_icontypeId forKey:kLaunchImageTableIcontypeId];
    [aCoder encodeObject:_iconurl forKey:kLaunchImageTableIconurl];
    [aCoder encodeDouble:_tableIdentifier forKey:kLaunchImageTableId];
    [aCoder encodeDouble:_appsId forKey:kLaunchImageTableAppsId];
    [aCoder encodeObject:_iconname forKey:kLaunchImageTableIconname];
    [aCoder encodeObject:_appName forKey:kLaunchImageTableAppName];
    [aCoder encodeObject:_remark forKey:kLaunchImageTableRemark];
    [aCoder encodeObject:_iconlink forKey:kLaunchImageIconlink];
}

- (id)copyWithZone:(NSZone *)zone
{
    LaunchImageTable *copy = [[LaunchImageTable alloc] init];
    
    if (copy) {
        
        copy.typename = [self.typename copyWithZone:zone];
        copy.icontypeId = self.icontypeId;
        copy.iconurl = [self.iconurl copyWithZone:zone];
        copy.tableIdentifier = self.tableIdentifier;
        copy.appsId = self.appsId;
        copy.iconname = [self.iconname copyWithZone:zone];
        copy.appName = [self.appName copyWithZone:zone];
        copy.remark = [self.remark copyWithZone:zone];
        copy.iconlink = [self.iconlink copyWithZone:zone];
    }
    
    return copy;
}


@end
