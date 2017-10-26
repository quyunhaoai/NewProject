//
//  TopMenuXmlBase.m
//
//  Created by 9vs  on 15/3/16
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "TopMenuXmlBase.h"


NSString *const kTopMenuXmlBaseName = @"name";
NSString *const kTopMenuXmlBaseType = @"type";
NSString *const kTopMenuXmlBaseWeburl = @"weburl";


@interface TopMenuXmlBase ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation TopMenuXmlBase

@synthesize name = _name;
@synthesize type = _type;
@synthesize weburl = _weburl;


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
            self.name = [self objectOrNilForKey:kTopMenuXmlBaseName fromDictionary:dict];
            self.type = [self objectOrNilForKey:kTopMenuXmlBaseType fromDictionary:dict];
            self.weburl = [self objectOrNilForKey:kTopMenuXmlBaseWeburl fromDictionary:dict];
            self.weburl = [self.weburl stringByReplacingOccurrencesOfString:@"amp;" withString:@""];
            self.weburl = [self.weburl stringByReplacingOccurrencesOfString:@"%26" withString:@"&"];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.name forKey:kTopMenuXmlBaseName];
    [mutableDict setValue:self.type forKey:kTopMenuXmlBaseType];
    [mutableDict setValue:self.weburl forKey:kTopMenuXmlBaseWeburl];

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

    self.name = [aDecoder decodeObjectForKey:kTopMenuXmlBaseName];
    self.type = [aDecoder decodeObjectForKey:kTopMenuXmlBaseType];
    self.weburl = [aDecoder decodeObjectForKey:kTopMenuXmlBaseWeburl];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_name forKey:kTopMenuXmlBaseName];
    [aCoder encodeObject:_type forKey:kTopMenuXmlBaseType];
    [aCoder encodeObject:_weburl forKey:kTopMenuXmlBaseWeburl];
}

- (id)copyWithZone:(NSZone *)zone
{
    TopMenuXmlBase *copy = [[TopMenuXmlBase alloc] init];
    
    if (copy) {

        copy.name = [self.name copyWithZone:zone];
        copy.type = [self.type copyWithZone:zone];
        copy.weburl = [self.weburl copyWithZone:zone];
    }
    
    return copy;
}


@end
