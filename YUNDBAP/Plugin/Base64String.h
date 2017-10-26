//
//  Base64String.h
//  test
//
//  Created by hao on 16/9/6.
//  Copyright © 2016年 hao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Base64String : NSObject
+ (NSData*) base64Decode:(NSString *)string;
+ (NSString*) base64Encode:(NSData *)data;




@end
