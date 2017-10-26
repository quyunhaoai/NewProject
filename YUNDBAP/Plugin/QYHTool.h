//
//  QYHTool.h
//  YUNDBAP
//
//  Created by hao on 17/9/25.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface QYHTool : NSObject
+(UIImage *) getImageFromURL:(NSString *)fileURL ;
+(NSData *) getDataFromURL:(NSString *)fileURL ;
+(void) saveImage:(UIImage *)image withFileName:(NSString *)imageName ofType:(NSString *)extension;
+(UIImage *) loadImage:(NSString *)fileName;
@end
