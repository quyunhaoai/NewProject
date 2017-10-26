//
//  MyXmlBase.m
//
//  Created by 9vs  on 15/1/31
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "MyXmlBase.h"


NSString *const kMyXmlBaseWeburl = @"weburl";
NSString *const kMyXmlBaseVersion = @"Version";
NSString *const kMyXmlBaseImgurl = @"imgurl";
NSString *const kMyXmlBaseTitle = @"title";
NSString *const kMyXmlBasePptid = @"pptid";
NSString *const kMyXmlBaseType = @"type";
NSString *const kMyXmlBaseBid = @"bid";
NSString *const kMyXmlBaseName = @"name";
NSString *const kMyXmlBaseRefreshMenu = @"RefreshMenu";

@interface MyXmlBase ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation MyXmlBase

@synthesize weburl = _weburl;
@synthesize version = _version;
@synthesize imgurl = _imgurl;
@synthesize title = _title;
@synthesize pptid = _pptid;
@synthesize type = _type;
@synthesize bid = _bid;
@synthesize name = _name;


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
            self.weburl = [self objectOrNilForKey:kMyXmlBaseWeburl fromDictionary:dict];
            self.weburl = [self.weburl stringByReplacingOccurrencesOfString:@"amp;" withString:@""];
            self.weburl = [self.weburl stringByReplacingOccurrencesOfString:@"%26" withString:@"&"];
            self.version = [self objectOrNilForKey:kMyXmlBaseVersion fromDictionary:dict];
            self.imgurl = [self objectOrNilForKey:kMyXmlBaseImgurl fromDictionary:dict];
            self.title = [self objectOrNilForKey:kMyXmlBaseTitle fromDictionary:dict];
            self.pptid = [self objectOrNilForKey:kMyXmlBasePptid fromDictionary:dict];
            self.type = [self objectOrNilForKey:kMyXmlBaseType fromDictionary:dict];
            self.bid = [self objectOrNilForKey:kMyXmlBaseBid fromDictionary:dict];
            self.name = [self objectOrNilForKey:kMyXmlBaseName fromDictionary:dict];
            self.refreshMenu = [self objectOrNilForKey:kMyXmlBaseRefreshMenu fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.weburl forKey:kMyXmlBaseWeburl];
    [mutableDict setValue:self.version forKey:kMyXmlBaseVersion];
    [mutableDict setValue:self.imgurl forKey:kMyXmlBaseImgurl];
    [mutableDict setValue:self.title forKey:kMyXmlBaseTitle];
    [mutableDict setValue:self.pptid forKey:kMyXmlBasePptid];
    [mutableDict setValue:self.type forKey:kMyXmlBaseType];
    [mutableDict setValue:self.bid forKey:kMyXmlBaseBid];
    [mutableDict setValue:self.name forKey:kMyXmlBaseName];
    [mutableDict setValue:self.refreshMenu forKey:kMyXmlBaseRefreshMenu];

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

    self.weburl = [aDecoder decodeObjectForKey:kMyXmlBaseWeburl];
    self.version = [aDecoder decodeObjectForKey:kMyXmlBaseVersion];
    self.imgurl = [aDecoder decodeObjectForKey:kMyXmlBaseImgurl];
    self.title = [aDecoder decodeObjectForKey:kMyXmlBaseTitle];
    self.pptid = [aDecoder decodeObjectForKey:kMyXmlBasePptid];
    self.type = [aDecoder decodeObjectForKey:kMyXmlBaseType];
    self.bid = [aDecoder decodeObjectForKey:kMyXmlBaseBid];
    self.name = [aDecoder decodeObjectForKey:kMyXmlBaseName];
    self.refreshMenu = [aDecoder decodeObjectForKey:kMyXmlBaseRefreshMenu];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_weburl forKey:kMyXmlBaseWeburl];
    [aCoder encodeObject:_version forKey:kMyXmlBaseVersion];
    [aCoder encodeObject:_imgurl forKey:kMyXmlBaseImgurl];
    [aCoder encodeObject:_title forKey:kMyXmlBaseTitle];
    [aCoder encodeObject:_pptid forKey:kMyXmlBasePptid];
    [aCoder encodeObject:_type forKey:kMyXmlBaseType];
    [aCoder encodeObject:_bid forKey:kMyXmlBaseBid];
    [aCoder encodeObject:_name forKey:kMyXmlBaseName];
    [aCoder encodeObject:_refreshMenu forKey:kMyXmlBaseRefreshMenu];
}

- (id)copyWithZone:(NSZone *)zone
{
    MyXmlBase *copy = [[MyXmlBase alloc] init];
    
    if (copy) {

        copy.weburl = [self.weburl copyWithZone:zone];
        copy.version = [self.version copyWithZone:zone];
        copy.imgurl = [self.imgurl copyWithZone:zone];
        copy.title = [self.title copyWithZone:zone];
        copy.pptid = [self.pptid copyWithZone:zone];
        copy.type = [self.type copyWithZone:zone];
        copy.bid = [self.bid copyWithZone:zone];
        copy.name = [self.name copyWithZone:zone];
        copy.refreshMenu = [self.refreshMenu copyWithZone:zone];

    }
    
    return copy;
}


@end
