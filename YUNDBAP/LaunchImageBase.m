//
//  LaunchImageBase.m
//
//  Created by 9vs  on 15/2/2
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "LaunchImageBase.h"
#import "LaunchImageTable.h"
#import "LaunchImageTable1.h"


NSString *const kLaunchImageBaseTable = @"Table";
NSString *const kLaunchImageBaseTable1 = @"Table1";


@interface LaunchImageBase ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation LaunchImageBase

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
    NSObject *receivedLaunchImageTable = [dict objectForKey:kLaunchImageBaseTable];
    NSMutableArray *parsedLaunchImageTable = [NSMutableArray array];
    if ([receivedLaunchImageTable isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedLaunchImageTable) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedLaunchImageTable addObject:[LaunchImageTable modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedLaunchImageTable isKindOfClass:[NSDictionary class]]) {
       [parsedLaunchImageTable addObject:[LaunchImageTable modelObjectWithDictionary:(NSDictionary *)receivedLaunchImageTable]];
    }

    self.table = [NSArray arrayWithArray:parsedLaunchImageTable];
    NSObject *receivedLaunchImageTable1 = [dict objectForKey:kLaunchImageBaseTable1];
    NSMutableArray *parsedLaunchImageTable1 = [NSMutableArray array];
    if ([receivedLaunchImageTable1 isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedLaunchImageTable1) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedLaunchImageTable1 addObject:[LaunchImageTable1 modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedLaunchImageTable1 isKindOfClass:[NSDictionary class]]) {
       [parsedLaunchImageTable1 addObject:[LaunchImageTable1 modelObjectWithDictionary:(NSDictionary *)receivedLaunchImageTable1]];
    }

    self.table1 = [NSArray arrayWithArray:parsedLaunchImageTable1];

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
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForTable] forKey:kLaunchImageBaseTable];
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
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForTable1] forKey:kLaunchImageBaseTable1];

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

    self.table = [aDecoder decodeObjectForKey:kLaunchImageBaseTable];
    self.table1 = [aDecoder decodeObjectForKey:kLaunchImageBaseTable1];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_table forKey:kLaunchImageBaseTable];
    [aCoder encodeObject:_table1 forKey:kLaunchImageBaseTable1];
}

- (id)copyWithZone:(NSZone *)zone
{
    LaunchImageBase *copy = [[LaunchImageBase alloc] init];
    
    if (copy) {

        copy.table = [self.table copyWithZone:zone];
        copy.table1 = [self.table1 copyWithZone:zone];
    }
    
    return copy;
}


@end
