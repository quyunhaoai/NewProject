//
//  StringsXML.m
//  shiyou
//
//  Created by bianruifeng on 14-2-14.
//  Copyright (c) 2014年 Xue. All rights reserved.
//

#import "StringsXML.h"

@implementation StringsXML
+ (StringsXML *)shareStringsXML {
    static StringsXML *xml = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        xml = [[StringsXML alloc] init];
    });
    return xml;
}
- (NSMutableDictionary *)jiexiStringsXML: (NSString *)xmlName
{
    NSString *documentsDirectory= [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
    NSString *filePath2= [documentsDirectory
                          stringByAppendingPathComponent:[NSString stringWithFormat:@"%@strings.xml",[[NSUserDefaults standardUserDefaults] objectForKey:@"myappsid"]]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *path;
    if ([fileManager fileExistsAtPath:filePath2]) {
        path = filePath2;
    }else {
        path=[[NSBundle mainBundle] pathForResource:xmlName ofType:@"xml"];
    }
    
    
    //解析XML
    
    NSFileHandle *file = [NSFileHandle fileHandleForReadingAtPath:path];
    NSData *data = [file readDataToEndOfFile];
    [file closeFile];
    
    NSXMLParser *aParser=[[NSXMLParser alloc] initWithData:data];
    [aParser setDelegate:self];
    [aParser parse];
    return xmlDic;
}

-(void)parserDidStartDocument:(NSXMLParser *)parser
{
    //初始化字典
    xmlDic = [[NSMutableDictionary alloc] initWithCapacity:10];

}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    StrKey = [[attributeDict objectForKey:@"name"] copy];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    
    NSString *ABBAB =[[string stringByReplacingOccurrencesOfString:@"\n" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""];

    
    if ([ABBAB length] != 0 && StrKey != NULL)
    {   
        [xmlDic setObject:ABBAB forKey:StrKey];
    }
    
}
+ (StringsXmlBase *)getStringXmlBase {
    NSMutableDictionary *stringDic = [[self shareStringsXML] jiexiStringsXML:@"strings"];
    StringsXmlBase *base = [StringsXmlBase modelObjectWithDictionary:stringDic];
    return base;
}
//输出注释内容
//- (void)parser:(NSXMLParser *)parser foundComment:(NSString *)comment{
//    NSLog(@"%@",comment);
//}
@end
