//
//  AppInfoTable1.h
//
//  Created by 9vs  on 15/1/31
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface AppInfoTable1 : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) double pagecount;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
