//
//  UXml.m
//  AXml
//
//  Created by user  on 13-4-22.
//
//

#import "UXml.h"

@implementation UXml
+ (UXml *)shareUxml {
    static UXml *xml = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        xml = [[UXml alloc] init];
    });
    return xml;
}
- (NSMutableArray *)jiexiXML:(NSString*)filename two:(NSString*)filetype
{
    //解析xml
    NSString *documentsDirectory= [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *path;
    NSRange range=[filename rangeOfString:@"myxml"];
    NSRange topmenuRange = [filename rangeOfString:@"topmenu"];
    NSRange shareSdkDevInfoRange = [filename rangeOfString:@"ShareSDKDevInfor"];;
    if(range.location != NSNotFound){
        
        
        NSString *filePath2= [documentsDirectory
                              stringByAppendingPathComponent:[NSString stringWithFormat:@"%@myxml.xml",[[NSUserDefaults standardUserDefaults] objectForKey:@"myappsid"]]];
        
        if ([fileManager fileExistsAtPath:filePath2]) {
            path = filePath2;
        }else {
            path=[[NSBundle mainBundle] pathForResource:filename ofType:@"xml"];
        }
    }else if(topmenuRange.location != NSNotFound) {
        NSString *filePath2= [documentsDirectory
                              stringByAppendingPathComponent:[NSString stringWithFormat:@"%@topmenu.xml",[[NSUserDefaults standardUserDefaults] objectForKey:@"myappsid"]]];
        
        if ([fileManager fileExistsAtPath:filePath2]) {
            path = filePath2;
        }else {
            path=[[NSBundle mainBundle] pathForResource:filename ofType:@"xml"];
        }
    }else if(shareSdkDevInfoRange.location != NSNotFound) {
        NSString *filePath2= [documentsDirectory
                              stringByAppendingPathComponent:[NSString stringWithFormat:@"%@ShareSDKDevInfor.xml",[[NSUserDefaults standardUserDefaults] objectForKey:@"myappsid"]]];
        
        if ([fileManager fileExistsAtPath:filePath2]) {
            path = filePath2;
        }else {
            path=[[NSBundle mainBundle] pathForResource:filename ofType:@"xml"];
        }
    }else {
        path=[[NSBundle mainBundle] pathForResource:filename ofType:@"xml"];
    }
    
    
    
    filetystr=filetype;
    
//    NSFileHandle *file = [NSFileHandle fileHandleForReadingAtPath:path];
//    NSData *data = [file readDataToEndOfFile];
//    [file closeFile];
    
    
     NSString *xmlContent=[[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    xmlContent = [xmlContent stringByReplacingOccurrencesOfString:@"&" withString:@"%26"];
    NSData *xmlData = [xmlContent dataUsingEncoding:NSUTF8StringEncoding];
    
    NSXMLParser *aParser=[[NSXMLParser alloc] initWithData:xmlData];
    
    [aParser setDelegate:self];
    [aParser parse];
    return array;
    
}
# pragma mark - - 解析XML配置文件


-(void)parserDidStartDocument:(NSXMLParser *)parser
{
    //开始遍历,并初始数组
    
   array = [[NSMutableArray alloc] init];
    
    
}
//遍例xml的节点,并输出节点内容
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if ([filetystr isEqualToString:@"daohang"]) {
        
        if ([[attributeDict objectForKey:@"weburl"] length] != 0)
        {
            [array addObject:attributeDict];
        }
        else
        {
            
        }
    }else if ([filetystr isEqualToString:@"share"]){
        
       if ([[attributeDict objectForKey:@"AppKey"] length] != 0|| [[attributeDict objectForKey:@"AppId"] length]!= 0 )
        {
            [array addObject:attributeDict];
        }
        else
        {
            
        }
        
        
    }else if ([filetystr isEqualToString:@"menu"]){
        
        if ([[attributeDict objectForKey:@"name"] length] != 0 )
        {
            [array addObject:attributeDict];
        }
        else
        {
            
        }
        
       
    }
    
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    
}


@end
