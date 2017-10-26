//
//  MyXmlBase.h
//
//  Created by 9vs  on 15/1/31
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface MyXmlBase : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *weburl;
@property (nonatomic, strong) NSString *version;
@property (nonatomic, strong) NSString *imgurl;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *pptid;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *bid;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *refreshMenu;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
