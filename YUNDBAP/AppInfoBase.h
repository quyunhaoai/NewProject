//
//  AppInfoBase.h
//
//  Created by 9vs  on 15/1/31
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface AppInfoBase : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSArray *table;
@property (nonatomic, strong) NSArray *table1;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
