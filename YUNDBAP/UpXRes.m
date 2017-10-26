//
//  UpXRes.m
//  NewCloudApp
//
//  Created by hw on 15/12/23.
//
//

#import "UpXRes.h"
#import "AFURLSessionManager.h"
#import "DataModels.h"
#import "StringsXML.h"
#import "UIAlertView+Blocks.h"
#define LOCAL_XMLVER @"localVersion"
#import "HwProgressView.h"

@interface UpXRes ()
{
    AppInfoTable *_aTable;
    BOOL _isShowHud;
    BOOL _isShowMain;
}


@end

@implementation UpXRes
+ (UpXRes *)shareUpdateXML {
    static UpXRes *res = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        res = [[UpXRes alloc] init];
    });
    return res;
}

- (void)checkXMlRes:(AppInfoTable *)table {
    
    _aTable = table;
    float localXMlV = 0;
    StringsXmlBase *xBase = [StringsXML getStringXmlBase];
    localXMlV = [[NSUserDefaults standardUserDefaults] floatForKey:[NSString stringWithFormat:@"%@xmlLocalVersion",xBase.appsid]];
    if (localXMlV == 0) {
        
        localXMlV = xBase.ydbXmlversion.floatValue;
    }
    
    
    if (table.xmlVersion <= localXMlV) {
        return;
    }
    
    if (table.xmlVersion <= localXMlV) {
        return;
    }
    if (table.updateMode == 4) {
        return;
    }
    
        //更新方式 1：提醒用户是否下载 2：强制并显示更新 3：强制静默更新（仅适用于云开发）4:关闭更新

    
    if (_aTable.isWifiUpdate) {
        if (![AFNetworkReachabilityManager sharedManager].isReachableViaWiFi) {
            return;
        }
    }
    
    if (table.updateMode == 1) {
        
//        _isShowHud = NO;
//        [self startDownXml];
//        return;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                        message:table.alerText.length > 0 ? table.alerText : @"您有新的资源包需要更新，是否现在下载？"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定",nil];
    
   
        
     
        alert.tag = 66;
        [alert show];
        
    }
    if (table.updateMode == 2) {
        _isShowHud = NO;
        [self startDownXml];
    }
    if (table.updateMode == 3) {
        _isShowHud = NO;
        [self startDownXml];
    }
    
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1 && alertView.tag == 66) {
        _isShowHud = YES;
        [self startDownXml];
    }
}
- (void)startDownXml {
    
    if (_aTable.isWifiUpdate) {
        if (![AFNetworkReachabilityManager sharedManager].isReachableViaWiFi) {
            return;
        }
    }
    NSArray *xmlNames = [_aTable.xmlNames componentsSeparatedByString:@","];
    for (NSString *str in xmlNames) {
        NSString *urlStr;
        if ([str isEqualToString:@"strings.xml"]) {
            urlStr = [NSString stringWithFormat:@"%@/ios/%@",_aTable.xmlDataRootUrl,str];
        }else {
            urlStr = [NSString stringWithFormat:@"%@/%@",_aTable.xmlDataRootUrl,str];
        }
        
        [self downloadxml:urlStr];
    }
}



#pragma mark -下载xml文件-
- (void)downloadxml:(NSString *)urlStr {
    if (_isShowHud) {
        [HwProgressView showProgress:1];
    }

    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        NSLog(@"File downloaded to: %@", filePath);
        [HwProgressView dismiss];
        if (error == nil) {
            [self fileMove:[urlStr lastPathComponent] newFile:[NSString stringWithFormat:@"%.f%@",_aTable.tableIdentifier,[urlStr lastPathComponent]]];
        }else {
            [self fileMove:[urlStr lastPathComponent] newFile:@"xxx"];
        }
        
    }];
    [downloadTask resume];
    
}

- (void)fileMove:(NSString *)oldFile newFile:(NSString *)newFileStr {
    
    NSError *error;
    
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    
    NSString *documentsDirectory= [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
    NSString *filePath= [documentsDirectory
                         stringByAppendingPathComponent:oldFile];
    
    
    NSString *filePath2= [documentsDirectory
                          stringByAppendingPathComponent:newFileStr];
    
    if ([fileMgr removeItemAtPath:filePath2 error:&error] != YES)
        NSLog(@"Unable to delete file: %@", [error localizedDescription]);
    
    if ([fileMgr moveItemAtPath:filePath toPath:filePath2 error:&error] != YES) {
       NSLog(@"Unable to move file: %@", [error localizedDescription]);
    }else {
        StringsXmlBase *xBase = [StringsXML getStringXmlBase];
        [[NSUserDefaults standardUserDefaults] setFloat:_aTable.xmlVersion forKey:[NSString stringWithFormat:@"%@xmlLocalVersion",xBase.appsid]];
        [[NSUserDefaults standardUserDefaults] synchronize];
       [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(delayMethod) userInfo:nil repeats:NO];

    }
    if ([fileMgr removeItemAtPath:filePath error:&error] != YES)
        NSLog(@"Unable to delete file: %@", [error localizedDescription]);
    
    NSLog(@"Documentsdirectory: %@",
          [fileMgr contentsOfDirectoryAtPath:documentsDirectory error:&error]);
    
    
    
}
- (void)delayMethod{
    
    if (!_isShowMain) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"showMainVC" object:nil];
    }
    _isShowMain = YES;
}
@end
