//
//  AppInfoBase.m
//
//  Created by 9vs  on 15/1/31
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "AppInfoBase.h"
#import "AppInfoTable.h"
#import "AppInfoTable1.h"


NSString *const kAppInfoBaseTable = @"Table";
NSString *const kAppInfoBaseTable1 = @"Table1";


@interface AppInfoBase ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation AppInfoBase

@synthesize table = _table;
@synthesize table1 = _table1;


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
    NSObject *receivedAppInfoTable = [dict objectForKey:kAppInfoBaseTable];
    NSMutableArray *parsedAppInfoTable = [NSMutableArray array];
    if ([receivedAppInfoTable isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedAppInfoTable) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedAppInfoTable addObject:[AppInfoTable modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedAppInfoTable isKindOfClass:[NSDictionary class]]) {
       [parsedAppInfoTable addObject:[AppInfoTable modelObjectWithDictionary:(NSDictionary *)receivedAppInfoTable]];
    }

    self.table = [NSArray arrayWithArray:parsedAppInfoTable];
    NSObject *receivedAppInfoTable1 = [dict objectForKey:kAppInfoBaseTable1];
    NSMutableArray *parsedAppInfoTable1 = [NSMutableArray array];
    if ([receivedAppInfoTable1 isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedAppInfoTable1) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedAppInfoTable1 addObject:[AppInfoTable1 modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedAppInfoTable1 isKindOfClass:[NSDictionary class]]) {
       [parsedAppInfoTable1 addObject:[AppInfoTable1 modelObjectWithDictionary:(NSDictionary *)receivedAppInfoTable1]];
    }

    self.table1 = [NSArray arrayWithArray:parsedAppInfoTable1];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    NSMutableArray *tempArrayForTable = [NSMutableArray array];
    for (NSObject *subArrayObject in self.table) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForTable addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForTable addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForTable] forKey:kAppInfoBaseTable];
    NSMutableArray *tempArrayForTable1 = [NSMutableArray array];
    for (NSObject *subArrayObject in self.table1) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForTable1 addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForTable1 addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForTable1] forKey:kAppInfoBaseTable1];

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

    self.table = [aDecoder decodeObjectForKey:kAppInfoBaseTable];
    self.table1 = [aDecoder decodeObjectForKey:kAppInfoBaseTable1];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_table forKey:kAppInfoBaseTable];
    [aCoder encodeObject:_table1 forKey:kAppInfoBaseTable1];
}

- (id)copyWithZone:(NSZone *)zone
{
    AppInfoBase *copy = [[AppInfoBase alloc] init];
    
    if (copy) {

        copy.table = [self.table copyWithZone:zone];
        copy.table1 = [self.table1 copyWithZone:zone];
    }
    
    return copy;
}


@end
