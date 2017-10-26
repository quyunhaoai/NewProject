//
//  StringsXML.h
//  shiyou
//
//  Created by bianruifeng on 14-2-14.
//  Copyright (c) 2014年 Xue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataModels.h"
@interface StringsXML : NSObject<NSXMLParserDelegate>
{
        NSMutableDictionary *xmlDic;
        NSString *StrKey;
}
+ (StringsXML *)shareStringsXML;
- (NSMutableDictionary *)jiexiStringsXML: (NSString *)xmlName;
+ (StringsXmlBase *)getStringXmlBase;

@end
