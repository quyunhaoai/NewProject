//
//  SPHTTPManager.m
//  SPaySDKDemo
//
//  Created by wongfish on 15/6/14.
//  Copyright (c) 2015年 wongfish. All rights reserved.
//

#import "SPHTTPManager.h"
#import "AFNetworking.h"
#import "SPayClientXMLWriter.h"
#import "XMLReader.h"
#import "NSDictionary+SPayUtilsExtras.h"

#import "SPConst.h"
#import "AFHTTPSessionManager.h"

@interface SPHTTPManager ()
@property (nonatomic, strong) AFHTTPSessionManager *currentRequest;
@end


@implementation SPHTTPManager

+ (id)sharedInstance
{
    static SPHTTPManager *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [self httpClientManager];
    });
    return _sharedClient;
}

+ (id)httpClientManager{
    return [[self alloc] init];
}

+ (NSString*)baseServerUrl{
    return kSPayBaseUrl;
}

- (AFHTTPSessionManager *)currentRequest
{
    if (!_currentRequest) {
        _currentRequest = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:[SPHTTPManager baseServerUrl]]];
        _currentRequest.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
        [_currentRequest.requestSerializer setValue:@"application/soap+xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        _currentRequest.requestSerializer.timeoutInterval = 15.0f;
        
    }
    return _currentRequest;
}



- (void)post:(NSString *)url
    paramter:(NSDictionary *)parameter
     success:(void (^)(id operation, id responseObject))success
     failure:(void (^)(id operation, NSError *error))failure
{
    
    NSDictionary *xmlInfo = @{@"xml":parameter};
    NSString *soapMessage = [SPayClientXMLWriter XMLStringFromDictionary:xmlInfo withHeader:NO];
    
    
    [self.currentRequest.requestSerializer setQueryStringSerializationWithBlock:^NSString *(NSURLRequest *request, id parameters, NSError *__autoreleasing *error) {
        return soapMessage;
    }];
    
//    [self.currentRequest POST:url parameters:soapMessage progress:^(NSProgress * _Nonnull uploadProgress) {
//        
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        success(task,responseObject);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        failure(task,error);
//    }];
    
    [self.currentRequest POST:url parameters:soapMessage success:^(NSURLSessionDataTask *task, id responseObject) {
        success(task,responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(task,error);
    }];
    
    //    [self.currentRequest POST:url parameters:soapMessage success:^(AFHTTPRequestOperation *operation, id responseObject) {
    //
    //        success(operation,responseObject);
    //    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    //
    //        failure(operation,error);
    //    }];
}


@end
