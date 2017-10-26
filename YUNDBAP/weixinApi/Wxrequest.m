//
//  Wxrequest.m
//  微信小程序
//
//  Created by hao on 17/3/8.
//  Copyright © 2017年 hao. All rights reserved.
//
#import <Foundation/Foundation.h>

typedef void (^requestSuccess)(NSData *data);
typedef void (^requestfail)(NSData *data);
#import "Wxrequest.h"
#import "AFNetworking.h"
@implementation Wxrequest
+(instancetype)shareWxrequest{
    static Wxrequest *requestObject= nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (requestObject == nil) {
            requestObject = [[self alloc]init];
        }

    });
    return requestObject;
}
-(void)PostrequestUrl:(NSString *)UrlStr andData:(id)data header:(id)header method:(int )method dataType:(NSString *)dataType
{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    if ([header isKindOfClass:[NSDictionary class]]) {
        for (NSString *key in header) {
            NSLog(@"%@--%@",[header objectForKey:key],key);
            
            [manager.requestSerializer setValue:[header objectForKey:key]   forHTTPHeaderField:key];
        }
    }
    
    [manager POST:UrlStr parameters:nil constructingBodyWithBlock:^(id formData) {
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"pic----suc---%@----%@",responseObject,[responseObject class]);
        NSString *aString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"pic----succ---%@",aString);
        NSInteger state = operation.response.statusCode;
        _successAndstate(responseObject,state);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"pic----fai---%@",error);
        _failRequestAndStateBlock(nil,operation.response.statusCode);
    }];
    
    
    
}
-(void)GetUrl:(NSString *)UrlStr andData:(id)data header:(id)header method:(int )method dataType:(NSString *)dataType
{
     NSLog(@"URL:%@",UrlStr);
    NSURL *url=[NSURL URLWithString:UrlStr];//创建URL
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc]initWithURL:url];//通过URL创建网络请求
    [request setTimeoutInterval:60];//设置超时时间
    [request setHTTPMethod:@"GET"];//设置请求方式
    if ([header isKindOfClass:[NSDictionary class]]) {
        [request setAllHTTPHeaderFields:header];
    }
    NSError *err;
    NSHTTPURLResponse *urlResponse =nil;
    NSData *datas=[NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&err];
    NSString *str=[[NSString alloc]initWithData:datas encoding:NSUTF8StringEncoding];
    NSLog(@"%@",str);
    NSInteger state = [urlResponse statusCode];
    if (err) {
        NSLog(@"%@",err);
        self.failRequestAndStateBlock(nil,state);
    }
}
-(void)GetAsynUrl:(NSString *)UrlStr andData:(id)data header:(id)header method:(int)method dataType:(NSString *)dataType
{
    NSLog(@"URL:%@",UrlStr);
    NSURL *url=[NSURL URLWithString:UrlStr];//创建URL
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc]initWithURL:url];//通过URL创建网络请求
    [request setTimeoutInterval:60];//设置超时时间
    [request setHTTPMethod:@"GET"];//设置请求方式
    if ([header isKindOfClass:[NSDictionary class]]) {
        [request setAllHTTPHeaderFields:header];
    }
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    queue.maxConcurrentOperationCount = 5;
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        if (connectionError) {
            self.failRequestAndStateBlock(data,[(NSHTTPURLResponse *)response statusCode]);
        }else{
            
            NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
            
            NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            _successAndstate(data,responseCode);
        }
    }];
}

-(void)requestUrl:(NSString *)UrlStr andData:(id)data header:(id)header method:(method )method dataType:(NSString *)dataType
{

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    if (data == nil ) {
    
    }
    
    if ([header isKindOfClass:[NSDictionary class]]) {
        for (NSString *key in header) {
            NSLog(@"%@--%@",[header objectForKey:key],key);
        }
    }
    [manager.requestSerializer setValue:@"application/json/text/html" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:@"UTF-8" forHTTPHeaderField:@"Charset"];

    switch (method) {
        case 0:{
            [manager GET:UrlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"success:%@",responseObject);
                NSData *data = [responseObject dataUsingEncoding:NSUTF8StringEncoding];
                _successBlock(data);
           
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"JSON--error: %@", error.description);
                NSData *data = [error.description dataUsingEncoding:NSUTF8StringEncoding];
                _failRequestBlock(data);
            }];
        }
            break;
        case 1:{
            [manager POST:UrlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"JSON--success: %@", responseObject);
                NSData *data = [responseObject dataUsingEncoding:NSUTF8StringEncoding];
                _successBlock(data);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"JSON--error: %@", error);
                NSData *data = [error.description dataUsingEncoding:NSUTF8StringEncoding];
                _failRequestBlock(data);
            }];}
        default:
            break;
    }

}
-(void)updata:(NSString *)url andfilePath:(NSString *)path name:(NSString *)name header:(id)header formData:(id)formData{
    if (path == nil || url ==nil) {
        return;
    }
    AFHTTPRequestOperationManager *requestManager = [AFHTTPRequestOperationManager manager];
    
    if ([header isKindOfClass:[NSDictionary class]]) {
        for (NSString *key in header) {
            NSLog(@"%@--%@",[header objectForKey:key],key);
            [requestManager.requestSerializer setValue:[header objectForKey:key]   forHTTPHeaderField:key];
        }
    }
    requestManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"image/jpeg",@"image/png",@"application/octet-stream",@"text/json",nil];
    requestManager.responseSerializer = [AFHTTPResponseSerializer serializer];

    NSData *data = [NSData dataWithContentsOfFile:path];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat =@"yyyyMMddHHmmss";
    NSString *str = [formatter stringFromDate:[NSDate date]];
    NSString *filename = [NSString stringWithFormat:@"%@.jpg", str];
    if (data ==nil) {
        return;
    }
    [requestManager POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:data name:name fileName:filename   mimeType:@"application/octet-stream"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);

        self.successAndstate(responseObject,operation.response.statusCode);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        self.failRequestAndStateBlock(nil,operation.response.statusCode);
    }];
}
-(void)downloadfile:(NSString *)url header:(id)header{
     NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        NSLog(@"File downloaded to: %@", filePath);
        NSInteger status = [(NSHTTPURLResponse *)response statusCode];
        self.successAndstate(filePath.absoluteString,status);
        if (error != nil) {
        self.failRequestAndStateBlock(filePath.absoluteString,status);
        }
    }];
    [downloadTask resume];
}
@end
