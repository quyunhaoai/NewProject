//
//  JWImgBrowserRoot.m
//
//  Created by 9vs  on 14/12/29
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "JWImgBrowserRoot.h"


NSString *const kJWImgBrowserRootTitle = @"title";
NSString *const kJWImgBrowserRootUrl = @"url";


@interface JWImgBrowserRoot ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation JWImgBrowserRoot

@synthesize title = _title;
@synthesize url = _url;


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
            self.title = [self objectOrNilForKey:kJWImgBrowserRootTitle fromDictionary:dict];
            self.url = [self objectOrNilForKey:kJWImgBrowserRootUrl fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.title forKey:kJWImgBrowserRootTitle];
    [mutableDict setValue:self.url forKey:kJWImgBrowserRootUrl];

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

    self.title = [aDecoder decodeObjectForKey:kJWImgBrowserRootTitle];
    self.url = [aDecoder decodeObjectForKey:kJWImgBrowserRootUrl];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_title forKey:kJWImgBrowserRootTitle];
    [aCoder encodeObject:_url forKey:kJWImgBrowserRootUrl];
}

- (id)copyWithZone:(NSZone *)zone
{
    JWImgBrowserRoot *copy = [[JWImgBrowserRoot alloc] init];
    
    if (copy) {

        copy.title = [self.title copyWithZone:zone];
        copy.url = [self.url copyWithZone:zone];
    }
    
    return copy;
}


@end
