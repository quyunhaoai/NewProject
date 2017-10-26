//
//  HwReaderViewController.h
//  CloudApp
//
//  Created by 9vs on 15/1/31.
//
//

#import "SideSuperViewController.h"

@interface HwReaderViewController : SideSuperViewController
@property (copy, nonatomic) void (^completionHandler)(NSString *itemStr);
@property (assign, nonatomic) BOOL isGetScan;
@end
