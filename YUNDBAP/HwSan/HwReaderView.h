//
//  HwReaderView.h
//  NewCloudAppAPS
//
//  Created by hw on 16/11/17.
//
//

#import <UIKit/UIKit.h>

@interface HwReaderView : UIView
@property (copy, nonatomic) void (^completionHandler)(NSString *itemStr);
@end
