//
//  UXml.h
//  AXml
//
//  Created by user  on 13-4-22.
//
//

#import <Foundation/Foundation.h>

@interface UXml : NSObject<NSXMLParserDelegate>
{
    NSMutableArray *array;
    NSString *filetystr;
}
+ (UXml *)shareUxml;
- (NSMutableArray *)jiexiXML:(NSString*)filename two:(NSString*)filetype;
@end
