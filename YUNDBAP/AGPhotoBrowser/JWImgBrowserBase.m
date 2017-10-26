//
//  JWImgBrowserBase.m
//
//  Created by 9vs  on 14/12/29
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "JWImgBrowserBase.h"
#import "JWImgBrowserRoot.h"


NSString *const kJWImgBrowserBaseRoot = @"root";


@interface JWImgBrowserBase ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation JWImgBrowserBase

@synthesize root = _root;


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
    NSObject *receivedJWImgBrowserRoot = [dict objectForKey:kJWImgBrowserBaseRoot];
    NSMutableArray *parsedJWImgBrowserRoot = [NSMutableArray array];
    if ([receivedJWImgBrowserRoot isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedJWImgBrowserRoot) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedJWImgBrowserRoot addObject:[JWImgBrowserRoot modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedJWImgBrowserRoot isKindOfClass:[NSDictionary class]]) {
       [parsedJWImgBrowserRoot addObject:[JWImgBrowserRoot modelObjectWithDictionary:(NSDictionary *)receivedJWImgBrowserRoot]];
    }

    self.root = [NSArray arrayWithArray:parsedJWImgBrowserRoot];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    NSMutableArray *tempArrayForRoot = [NSMutableArray array];
    for (NSObject *subArrayObject in self.root) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForRoot addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForRoot addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForRoot] forKey:kJWImgBrowserBaseRoot];

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

    self.root = [aDecoder decodeObjectForKey:kJWImgBrowserBaseRoot];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_root forKey:kJWImgBrowserBaseRoot];
}

- (id)copyWithZone:(NSZone *)zone
{
    JWImgBrowserBase *copy = [[JWImgBrowserBase alloc] init];
    
    if (copy) {

        copy.root = [self.root copyWithZone:zone];
    }
    
    return copy;
}


@end
