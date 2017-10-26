//
//  LaunchImageTable.h
//
//  Created by 9vs  on 15/2/2
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface LaunchImageTable : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *typename;
@property (nonatomic, assign) double icontypeId;
@property (nonatomic, strong) NSString *iconurl;
@property (nonatomic, assign) double tableIdentifier;
@property (nonatomic, assign) double appsId;
@property (nonatomic, strong) NSString *iconname;
@property (nonatomic, strong) NSString *appName;
@property (nonatomic, strong) NSString *remark;
@property (nonatomic, strong) NSString *iconlink;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
