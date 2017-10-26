//
//  UpdateXMLRes.h
//  NewCloudApp
//
//  Created by hw on 15/12/23.
//
//

#import <Foundation/Foundation.h>
@class AppInfoTable;

@interface UpdateXMLRes : NSObject
+ (UpdateXMLRes *)shareUpdateXML;
- (void)checkXMlRes:(AppInfoTable *)table;
@end
