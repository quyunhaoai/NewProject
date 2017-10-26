//
//  Filemanager.h
//  微信小程序
//
//  Created by hao on 17/3/9.
//  Copyright © 2017年 hao. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface Filemanager : NSObject<UIDocumentInteractionControllerDelegate>
{
    UIViewController *fatherViewController;
}
@property (nonatomic,strong) NSFileManager *fileManger;
@property (nonatomic,strong) NSMutableArray *storageKeys;
+(instancetype)shareFileManger;
-(NSString *)saveFile:(NSString *)path;
-(NSMutableArray *)getSaveFilelist;
-(NSDictionary *)getsaveFileInfo:(NSString *)filePath;
-(BOOL)remoneSaveFile:(NSString *)filePath;
-(void)openDocument:(NSString *)filePath andeVc:(UIViewController *)vc;
/*数据缓存*/
-(void)setStorage:(NSString *)key andData:(id)data;
-(void)getStorage:(NSString *)key block:(void(^)(NSData *data))blok;
-(void)getStorageInfoblok:(void(^)(NSDictionary*))blk;
-(void)removeStorage:(NSString *)key;
-(void)clearStorage;
@end
