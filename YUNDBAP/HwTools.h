//
//  HwTools.h
//  CloudApp
//
//  Created by 9vs on 15/1/31.
//
//

#import <Foundation/Foundation.h>
#import "UXml.h"
#import "StringsXML.h"
#import "DataModels.h"

#import "ThirdClassHeader.h"
#import <TencentOpenAPI/TencentOAuth.h>
#define IS_SHOW_NAV @"isShowNav" //是否显示标题栏
#define IS_ENABLE_DRAG_REFRESH @"isEnableDragRefresh" //是否开启下拉刷新
#define IS_ENABLE_CLOSE @"isEnableClose" //是否打开关闭按钮
#define BACKGROUNDCOLOR @"backgroundColor"

@interface ShareModel : NSObject
@property (nonatomic , strong) NSString *sTitle;
@property (nonatomic , strong) NSString *sContent;
@property (nonatomic , strong) NSString *sUrl;
@property (nonatomic , strong) id sImage;

@end

@interface HwTools : NSObject<TencentSessionDelegate>
@property (copy, nonatomic) void (^completion)(NSString *state,NSString *shareType);
@property (strong, nonatomic) TencentOAuth *tencentOAuth;

+ (HwTools *)shareTools;

- (void)getCacheSizeCompletion:(void(^)(float size))completion;
- (void)clearCache:(void(^)(void))completion;
- (void)shareSdkInitializePlat;
- (void)shareAllButtonClickHandler:(UIView *)vi shareModel:(ShareModel *)sModel;
- (void)initOther;
- (void)launchImageAd;
- (void)prepLoading;
- (void)prepLoadingImgRemove;
+ (UIColor *)hexStringToColor:(NSString *)stringToConvert;
+ (UIImage *)createImageWithColor:(UIColor *)color;
- (void)installStatistics:(NSString *)deviceTokenStr;
-(void)initQQloading;
+ (void)UserDefaultsObj:(id)obj key:(NSString *)key;
+ (id)UserDefaultsObjectForKey:(NSString *)key;
- (void)checkTimeOut;
- (void)danduFenxiang:(int)type fromView:(UIView *)vi shareModel:(ShareModel *)sModel;

@end


