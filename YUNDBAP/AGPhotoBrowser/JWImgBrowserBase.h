//
//  JWImgBrowserBase.h
//
//  Created by 9vs  on 14/12/29
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface JWImgBrowserBase : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSArray *root;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
