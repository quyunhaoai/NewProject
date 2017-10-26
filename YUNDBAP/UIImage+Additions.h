//
//  UIImage+Additions.h
//  Sodao_Iphone_Show
//
//  Created by yanxue wang on 12-6-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ImageIO/ImageIO.h>
#define kMaxWidth 100.0f
#define kMaxHeight 100.0f
#define MAXImageSize 100.0 //kb
@interface UIImage(SDImageSize)

//长宽比
-(float)hwBI;
+(UIImage*)newBoundImage:(NSString*)imgName;
//压缩图片至指定尺寸
-(UIImage*) scaleToSize:(CGSize)size;
-(UIImage*) thumbImage;
//调整方向
-(UIImage *)fixOrientation:(UIImageOrientation)orientation;
//替换 imageNamed
+(UIImage*)imageByName:(NSString *)name;
-(UIImage*)subImageFromTop;
//取图片的头
-(UIImage*)subImageFromHeader;
//取图片的中间
-(UIImage*)subImageFromCenter;
//取图的右边
-(UIImage*)subImageFromFoot;
-(UIImage*)GetSubImageByRect:(CGRect)r;
//-(NSDictionary*)getInfo;
//
- (NSString *)contentTypeForImageData;
-(UIImage *)rotateImage;
-(UIImage *)rotateImageByLeft90degree;

-(UIImage*)rotateImage:(int)degree;
- (UIImage*)transformWidth:(CGFloat)width
                    height:(CGFloat)height;
@end
