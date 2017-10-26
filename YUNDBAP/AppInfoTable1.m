//
//  AppInfoTable1.m
//
//  Created by 9vs  on 15/1/31
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "AppInfoTable1.h"


NSString *const kAppInfoTable1Pagecount = @"pagecount";


@interface AppInfoTable1 ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation AppInfoTable1

@synthesize pagecount = _pagecount;


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
            self.pagecount = [[self objectOrNilForKey:kAppInfoTable1Pagecount fromDictionary:dict] doubleValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.pagecount] forKey:kAppInfoTable1Pagecount];

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

    self.pagecount = [aDecoder decodeDoubleForKey:kAppInfoTable1Pagecount];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_pagecount forKey:kAppInfoTable1Pagecount];
}

- (id)copyWithZone:(NSZone *)zone
{
    AppInfoTable1 *copy = [[AppInfoTable1 alloc] init];
    
    if (copy) {

        copy.pagecount = self.pagecount;
    }
    
    return copy;
}


@end
