//
//  GeTuiTool.h
//  CloudApp
//
//  Created by 9vs on 15/2/2.
//
//

#import <Foundation/Foundation.h>
#import "GexinSdk.h"
typedef enum {
    SdkStatusStoped,
    SdkStatusStarting,
    SdkStatusStarted
} SdkStatus;

@interface GeTuiTool : NSObject <GexinSdkDelegate>


@property (strong, nonatomic) GexinSdk *gexinPusher;

@property (retain, nonatomic) NSString *appKey;
@property (retain, nonatomic) NSString *appSecret;
@property (retain, nonatomic) NSString *appID;
@property (retain, nonatomic) NSString *clientId;
@property (assign, nonatomic) SdkStatus sdkStatus;

@property (assign, nonatomic) int lastPayloadIndex;
@property (retain, nonatomic) NSString *payloadId;
@property (assign, nonatomic) BOOL appBecome;

+ (GeTuiTool *)shareTool;
- (void)initGeTui;
- (void)registerDevice:(NSString *)deviceToken;
- (void)startSdk;
- (void)stopSdk;
- (void)clearbadgeNumber;

@end
