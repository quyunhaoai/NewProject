//
//  Wxrequest.h
//  微信小程序
//
//  Created by hao on 17/3/8.
//  Copyright © 2017年 hao. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum {
    GET = 0 ,
    POST,
    
}method;
typedef void (^sss)(id);
@interface Wxrequest : NSObject<NSURLConnectionDelegate,NSURLConnectionDataDelegate>
{
    
}

+(instancetype)shareWxrequest;
-(void)PostrequestUrl:(NSString *)UrlStr andData:(id)data header:(id)header method:(int )method dataType:(NSString *)dataType;
-(void)GetUrl:(NSString *)UrlStr andData:(id)data header:(id)header method:(int )method dataType:(NSString *)dataType;
-(void)GetAsynUrl:(NSString *)UrlStr andData:(id)data header:(id)header method:(int )method dataType:(NSString *)dataType;
-(void)requestUrl:(NSString *)UrlStr andData:(id)data header:(id)header method:(method )method dataType:(NSString *)dataType;
-(void)updata:(NSString *)url andfilePath:(NSString *)path name:(NSString *)name header:(id)header formData:(id)formData;
-(void)downloadfile:(NSString *)url header:(id)header;

@property (nonatomic,copy) void (^successBlock)(NSData *);
@property (nonatomic,copy) sss blk;
@property (nonatomic,copy)  void (^successAndstate)(id,NSInteger );

@property (nonatomic,strong) void (^sAs)(NSString *data);
@property (nonatomic,copy) void (^failRequestBlock)(NSData *b);
@property (nonatomic,copy) void (^failRequestAndStateBlock)(id data,NSInteger state);
@property (nonatomic,copy) void (^reluest)(NSString *sss);
@end
