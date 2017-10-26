//
//  UIImage+Additions.m
//  Sodao_Iphone_Show
//
//  Created by yanxue wang on 12-6-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UIImage+Additions.h"

@implementation UIImage (SDImageSize)
- (NSString *)contentTypeForImageData {
    return nil;
}
//压缩图片至指定尺寸
-(UIImage*) scaleToSize:(CGSize)size{
    UIGraphicsBeginImageContext(size);
    [self drawInRect:CGRectMake(0.0, 0.0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}
//调整方向
-(UIImage *)fixOrientation:(UIImageOrientation)orientation{
    if (self == nil) {
		return nil;
	}
	CGImageRef imgRef = self.CGImage;
	CGFloat width = CGImageGetWidth(imgRef);
	CGFloat height = CGImageGetHeight(imgRef);
	
	CGAffineTransform transform = CGAffineTransformIdentity;
	CGRect bounds = CGRectMake(0, 0, width, height);
	CGFloat scaleRatio = 1;
	CGFloat boundHeight;
	
	UIImageOrientation orient = self.imageOrientation;
	switch(orient)
	{
		case UIImageOrientationUp: //EXIF = 1
		{
			transform = CGAffineTransformIdentity;
			break;
		}
		case UIImageOrientationUpMirrored: //EXIF = 2
		{
			transform = CGAffineTransformMakeTranslation(width, 0.0);
			transform = CGAffineTransformScale(transform, -1.0, 1.0);
			break;
		}
		case UIImageOrientationDown: //EXIF = 3
		{
			transform = CGAffineTransformMakeTranslation(width, height);
			transform = CGAffineTransformRotate(transform, M_PI);
			break;
		}
		case UIImageOrientationDownMirrored: //EXIF = 4
		{
			transform = CGAffineTransformMakeTranslation(0.0, height);
			transform = CGAffineTransformScale(transform, 1.0, -1.0);
			break;
		}
		case UIImageOrientationLeftMirrored: //EXIF = 5
		{
			boundHeight = bounds.size.height;
			bounds.size.height = bounds.size.width;
			bounds.size.width = boundHeight;
			transform = CGAffineTransformMakeTranslation(height, width);
			transform = CGAffineTransformScale(transform, -1.0, 1.0);
			transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
			break;
		}
		case UIImageOrientationLeft: //EXIF = 6
		{
			boundHeight = bounds.size.height;
			bounds.size.height = bounds.size.width;
			bounds.size.width = boundHeight;
			transform = CGAffineTransformMakeTranslation(0.0, width);
			transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
			break;
		}
		case UIImageOrientationRightMirrored: //EXIF = 7
		{
			boundHeight = bounds.size.height;
			bounds.size.height = bounds.size.width;
			bounds.size.width = boundHeight;
			transform = CGAffineTransformMakeScale(-1.0, 1.0);
			transform = CGAffineTransformRotate(transform, M_PI / 2.0);
			break;
		}
		case UIImageOrientationRight: //EXIF = 8
		{
			boundHeight = bounds.size.height;
			bounds.size.height = bounds.size.width;
			bounds.size.width = boundHeight;
			transform = CGAffineTransformMakeTranslation(height, 0.0);
			transform = CGAffineTransformRotate(transform, M_PI / 2.0);
			break;
		}
		default:
		{
			[NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
			break;
		}
	}
	
	UIGraphicsBeginImageContext(bounds.size);
	CGContextRef context = UIGraphicsGetCurrentContext();
	if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
		CGContextScaleCTM(context, -scaleRatio, scaleRatio);
		CGContextTranslateCTM(context, -height, 0);
	}
	else {
		CGContextScaleCTM(context, scaleRatio, -scaleRatio);
		CGContextTranslateCTM(context, 0, -height);
	}
	
	CGContextConcatCTM(context, transform);
	CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
	UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return imageCopy;
    
}
//替换 imageNamed
+(UIImage*)newBoundImage:(NSString*)imgName{
    NSString *path = [[NSBundle mainBundle] pathForResource:imgName ofType:nil];
	UIImage *temp = [[UIImage alloc] initWithContentsOfFile:path];
    return temp;
}
+(UIImage*)imageByName:(NSString *)name{
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:nil];
	UIImage *temp = [UIImage imageWithContentsOfFile:path];
	return temp;
}
-(UIImage*)GetSubImageByRect:(CGRect)r{
    CGImageRef imageRef = self.CGImage;
	CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, r);
	UIImage* subImage = [UIImage imageWithCGImage:subImageRef];
    CFRelease(subImageRef);
	return subImage;
}
-(UIImage*)subImageFromTop{
    CGSize sz=self.size;
	CGRect rect;
	if (sz.width>sz.height) {
		return self;
	}else {
		rect=CGRectMake(0, 0, sz.width, sz.width);
	}
	return [self GetSubImageByRect:rect];
}
//取图片的头
-(UIImage*)subImageFromHeader{
    CGSize sz=self.size;
	CGRect rect;
	if (sz.width>sz.height) {
		rect=CGRectMake(0, 0, sz.height, sz.height);
	}else {
		rect=CGRectMake(0, 0, sz.width, sz.width);
	}
	return [self GetSubImageByRect:rect];
}
//取图片的中间
-(UIImage*)subImageFromCenter{
    CGSize sz=self.size;
	CGRect rect;
	if (sz.width>sz.height) {
		rect=CGRectMake((sz.width-sz.height)/2, 0, sz.height, sz.height);
	}else {
		rect=CGRectMake(0, (sz.height-sz.width)/2, sz.width, sz.width);
	}
	return [self GetSubImageByRect:rect];
}
//取图的右边
-(UIImage*)subImageFromFoot{
    CGSize sz=self.size;
	CGRect rect;
	if (sz.width>sz.height) {
		rect=CGRectMake(sz.width-sz.height, 0, sz.height, sz.height);
	}else {
		rect=CGRectMake(0, sz.height-sz.width, sz.width, sz.width);
	}
	return [self GetSubImageByRect:rect];
}
/**
 *
 *
 

-(NSDictionary*)getInfo{
    NSData *dataOfImageFromGallery = UIImageJPEGRepresentation (self,0.5);
	CGImageSourceRef source;
    source = CGImageSourceCreateWithData((CFDataRef)dataOfImageFromGallery, NULL);
    
    NSDictionary *metadata = (NSDictionary *) CGImageSourceCopyPropertiesAtIndex(source, 0, NULL);
    CFRelease(source);
    NSMutableDictionary *metadataAsMutable =[metadata mutableCopy];

    
    //NSMutableDictionary *EXIFDictionary = [[[metadataAsMutable objectForKey:(NSString *)kCGImagePropertyExifDictionary]mutableCopy]autorelease];
	//    NSMutableDictionary *GPSDictionary = [[[metadataAsMutable objectForKey:(NSString *)kCGImagePropertyGPSDictionary]mutableCopy]autorelease];
    return metadataAsMutable;
}
  */
-(float)hwBI{
    return self.size.width/self.size.height;
}
/**
 - (NSString *)contentTypeForImageData{
 CGImageRef img = self.CGImage;
 NSData* data = CGDataProviderCreateWithCFData((CFDataRef)img);
 uint8_t c;
 [data getBytes:&c length:1];
 switch (c) {
 case 0xFF:
 return @"image/jpeg";
 case 0x89:
 return @"image/png";
 case 0x47:
 return @"image/gif";
 case 0x49:
 case 0x4D:
 return @"image/tiff";
 }
 return nil;
 }
 */
-(UIImage *)rotateImageByLeft90degree
{
    
    CGImageRef imgRef = self.CGImage;
    
    CGFloat width = CGImageGetWidth(imgRef);
    
    CGFloat height = CGImageGetHeight(imgRef);
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    CGRect bounds = CGRectMake(0, 0, width, height);
    
    CGFloat scaleRatio = 1;
    
    transform = CGAffineTransformMakeTranslation(width, 0.0);
    
    transform = CGAffineTransformScale(transform, -1.0, 1.0);
    
    
    UIGraphicsBeginImageContext(bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextScaleCTM(context, -scaleRatio, scaleRatio);
    CGContextTranslateCTM(context, -height, 0);
    CGContextConcatCTM(context, transform);
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    CGContextRestoreGState(context);
    return imageCopy;
    
}

-(UIImage *)rotateImage
{
    
    CGImageRef imgRef = self.CGImage;
    
    CGFloat width = CGImageGetWidth(imgRef);
    
    CGFloat height = CGImageGetHeight(imgRef);
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    CGRect bounds = CGRectMake(0, 0, width, height);
    
    CGFloat scaleRatio = 1;
    
    CGFloat boundHeight;
    
    UIImageOrientation orient = self.imageOrientation;
    
    switch(orient)
    
    {
            
        case UIImageOrientationUp: //EXIF = 1
            
            transform = CGAffineTransformIdentity;
            
            break;
            
        case UIImageOrientationUpMirrored: //EXIF = 2
            
            transform = CGAffineTransformMakeTranslation(width, 0.0);
            
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            
            break;
            
        case UIImageOrientationDown: //EXIF = 3
            
            transform = CGAffineTransformMakeTranslation(width, height);
            
            transform = CGAffineTransformRotate(transform, M_PI);
            
            break;
            
        case UIImageOrientationDownMirrored: //EXIF = 4
            
            transform = CGAffineTransformMakeTranslation(0.0, height);
            
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            
            break;
            
        case UIImageOrientationLeftMirrored: //EXIF = 5
            
            boundHeight = bounds.size.height;
            
            bounds.size.height = bounds.size.width;
            
            bounds.size.width = boundHeight;
            
            transform = CGAffineTransformMakeTranslation(height, width);
            
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            
            break;
            
        case UIImageOrientationLeft: //EXIF = 6
            
            boundHeight = bounds.size.height;
            
            bounds.size.height = bounds.size.width;
            
            bounds.size.width = boundHeight;
            
            transform = CGAffineTransformMakeTranslation(0.0, width);
            
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            
            break;
            
        case UIImageOrientationRightMirrored: //EXIF = 7
            
            boundHeight = bounds.size.height;
            
            bounds.size.height = bounds.size.width;
            
            bounds.size.width = boundHeight;
            
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            
            break;
            
        case UIImageOrientationRight: //EXIF = 8
            
            boundHeight = bounds.size.height;
            
            bounds.size.height = bounds.size.width;
            
            bounds.size.width = boundHeight;
            
            transform = CGAffineTransformMakeTranslation(height, 0.0);
            
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            
            break;
            
        default:
            
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
            
    }
    
    UIGraphicsBeginImageContext(bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        
        CGContextTranslateCTM(context, -height, 0);
        
    }
    
    else {
        
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        
        CGContextTranslateCTM(context, 0, -height);
        
    }
    
    CGContextConcatCTM(context, transform);
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return imageCopy;
    
}
-(UIImage*)rotateImage:(int)degree{
    if (degree%360==0) {
        return self;
    }
    CGImageRef imgRef = self.CGImage;
    
    CGFloat width = CGImageGetWidth(imgRef);
    
    CGFloat height = CGImageGetHeight(imgRef);
    
    CGFloat arc = degree*M_PI/180;
    int newWidth = width;
    int newheight = height;
    if (degree%180!=0) {
        newWidth = height;
        newheight = width;
    }
    UIGraphicsBeginImageContext(CGRectMake(0, 0, newWidth, newheight).size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, newWidth/2, newheight/2);
    CGContextRotateCTM(context, arc);
    CGContextScaleCTM(context,1,-1);
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(-width/2, -height/2, width, height), imgRef);
    
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return imageCopy;
}


-(UIImage *)thumbImage
{
    CGFloat h = self.size.height;
    CGFloat w = self.size.width;
    if (h==0.0f || w == 0.0f) {
        return nil;
    }
    if (h>w) {
        if (h > kMaxHeight) {
            CGFloat ratio = kMaxHeight / h;
            w *= ratio;
            h = kMaxHeight;
        }
    }else{
        if (w > kMaxWidth) {
            CGFloat ratio = kMaxWidth / w;
            h *= ratio;
            w = kMaxWidth;
        }
    }

    return [self scaleToSize: CGSizeMake(w, h)];
}


- (UIImage*)transformWidth:(CGFloat)width
                    height:(CGFloat)height {
    
    CGFloat destW = width;
    CGFloat destH = height;
    CGFloat sourceW = width;
    CGFloat sourceH = height;
    
    CGImageRef imageRef = self.CGImage;
    CGContextRef bitmap = CGBitmapContextCreate(NULL,
                                                destW,
                                                destH,
                                                CGImageGetBitsPerComponent(imageRef),
                                                4*destW,
                                                CGImageGetColorSpace(imageRef),
                                                (kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst));
    
    CGContextDrawImage(bitmap, CGRectMake(0, 0, sourceW, sourceH), imageRef);
    
    CGImageRef ref = CGBitmapContextCreateImage(bitmap);
    UIImage *resultImage = [UIImage imageWithCGImage:ref];
    CGContextRelease(bitmap);
    CGImageRelease(ref);
    
    return resultImage;
}

@end
