//
//  Filemanager.m
//  微信小程序
//
//  Created by hao on 17/3/9.
//  Copyright © 2017年 hao. All rights reserved.
//
#define UserDefaults [NSUserDefaults standardUserDefaults]
#import "Filemanager.h"

@implementation Filemanager
+(instancetype)shareFileManger{
    static Filemanager *fileManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (fileManager == nil) {
            fileManager = [[Filemanager alloc]init];
            fileManager.storageKeys = [NSMutableArray arrayWithCapacity:10];
        }
    });
    return fileManager;
}
-(NSString *)saveFile:(NSString *)path{
    NSString *temPath = [[NSString stringWithFormat:@"%@/wxfile/",[self homePath] ]  stringByAppendingPathComponent:path];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:temPath]) {
        [fileManager createFileAtPath:temPath contents:nil attributes:nil];
    }
    NSLog(@"文件路径：%@",temPath);
    return temPath;
    
}
-(NSMutableArray *)getSaveFilelist{
    NSString *fullPath = [self homePath];
    NSMutableArray *filenamelist = [NSMutableArray arrayWithCapacity:10];
    NSArray *tmplist = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[self homePath] error:nil];
    
    for (NSString *filename in tmplist) {
        NSString *fullp = [fullPath stringByAppendingPathComponent:filename];
        if ([self isFileExistAtPath:fullp]) {
            
        
            NSDictionary *fileDic = [[NSFileManager defaultManager] attributesOfItemAtPath:fullp error:nil];
            BOOL isDir;
            isDir = NO;
            if ([fileDic[@"NSFileType"] isEqualToString:NSFileTypeDirectory]) {
                isDir = YES;
            }
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateStyle:NSDateFormatterMediumStyle];
            [formatter setTimeStyle:NSDateFormatterShortStyle];
            [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
            NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
            [formatter setTimeZone:timeZone];

                    [filenamelist addObject:@{@"Name":filename,@"IsDir":[NSNumber numberWithBool:isDir],@"ModifyDate":[formatter stringFromDate:fileDic[@"NSFileModificationDate"]],@"FileSize":[NSString stringWithFormat:@"%.2fM",([fileDic[@"NSFileSize"] floatValue])/1024/1024]}];
        }
    }
    NSLog(@"文件目录信息：%@",filenamelist);
    return filenamelist;
}
-(NSDictionary *)getsaveFileInfo:(NSString *)filePath{
    if ([self isFileExistAtPath:filePath]) {
        NSDictionary *fileDic = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
        BOOL isDir;
        isDir = NO;
        if ([fileDic[@"NSFileType"] isEqualToString:NSFileTypeDirectory]) {
            isDir = YES;
        }
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
        NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
        [formatter setTimeZone:timeZone];
        NSDictionary *fileInfo = @{@"Name":filePath,@"IsDir":[NSNumber numberWithBool:isDir],@"ModifyDate":[formatter stringFromDate:fileDic[@"NSFileModificationDate"]],@"FileSize":[NSString stringWithFormat:@"%.2fM",([fileDic[@"NSFileSize"] floatValue])/1024/1024]};
        NSLog(@"文件信息：%@",fileInfo);
        return fileInfo;
    }
    return nil;

}
-(BOOL )remoneSaveFile:(NSString *)filePath{
    NSFileManager *filemage = [NSFileManager defaultManager];
    if ([filemage fileExistsAtPath:filePath]) {
        [filemage removeItemAtPath:filePath error:nil];
        return YES;
    }
    return NO;
}
-(void)openDocument:(NSString *)filePath andeVc:(UIViewController *)vc{
    NSURL *url = [NSURL URLWithString:filePath];
    UIDocumentInteractionController *docVc = [UIDocumentInteractionController interactionControllerWithURL:url];
    docVc.delegate = self;
    fatherViewController = vc;
    [docVc presentPreviewAnimated:YES];
}
-(UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller{
    return fatherViewController;
}
- (NSString*)homePath
{
    return NSHomeDirectory();
}
- (BOOL)isFileExistAtPath:(NSString*)fileFullPath {
    BOOL isExist = NO;
    isExist = [[NSFileManager defaultManager] fileExistsAtPath:fileFullPath];
    return isExist;
}
-(NSFileManager *)fileManger{
    if (_fileManger == nil) {
        _fileManger = [NSFileManager defaultManager];
    }
    return _fileManger;
}
-(void)setStorage:(NSString *)key andData:(id)data{
    if (key == nil || data ==nil) return;
    [UserDefaults setValue:data forKey:key];
    [UserDefaults synchronize];
    [self.storageKeys addObject:key];
}
-(void)getStorage:(NSString *)key block:(void (^)(NSData *))blok{
    if (key == nil)return;
    id a =[UserDefaults objectForKey:key];
    NSData *data = [a dataUsingEncoding:NSUTF8StringEncoding];
    blok(data);
}
-(void)getStorageInfoblok:(void (^)(NSDictionary *))blk{
    NSUserDefaults *user = UserDefaults;
    NSMutableDictionary *returndict= [NSMutableDictionary dictionaryWithCapacity:10];
    NSDictionary *dict = [user dictionaryRepresentation];
    CGFloat size = self.storageKeys.description.length;
    [returndict setObject:self.storageKeys forKey:@"keys"];
    [returndict setObject:[NSNumber numberWithFloat:size] forKey:@"currentSize"];
    [returndict setObject:@"10240" forKey:@"limitSize"];
    blk(returndict);
 }
-(void)removeStorage:(NSString *)key{
    if (key == nil) return;
    [UserDefaults removeObjectForKey:key];
    [UserDefaults synchronize];
}
-(NSString *)getCachesPath{
    
    return NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
}
-(void)clearStorage{
    
    NSUserDefaults *user = UserDefaults;
    
    NSDictionary *dict = [user dictionaryRepresentation];
    NSLog(@"--%@",dict);
    for(NSString *key in self.storageKeys){
        [UserDefaults removeObjectForKey:key];
        [UserDefaults synchronize];
    }
}
@end
