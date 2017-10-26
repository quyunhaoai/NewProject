//
//  LaunchImageTable1.h
//
//  Created by 9vs  on 15/2/2
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface LaunchImageTable1 : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) double pagecount;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
