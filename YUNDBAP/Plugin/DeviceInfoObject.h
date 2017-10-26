//
//  DeviceInfoObject.h
//  GetDvierInfo
//
//  Created by hao on 16/3/11.
//  Copyright © 2016年 hao. All rights reserved.
//
#import <CoreMotion/CoreMotion.h>
#import <Foundation/Foundation.h>
typedef void(^accelerometer)(float x,float y,float z);
typedef void (^accDict)(NSMutableDictionary *dict);

@interface DeviceInfoObject : NSObject
@property (nonatomic,copy) accDict accXYZ;
@property (nonatomic) CMMotionManager *motionmanager;
+(DeviceInfoObject *)sharedObject;
-(NSString *)identifier;
-(NSString *)phoneName;
-(NSString *)phoneVersion;
-(NSString *)phoneModel;
-(NSString *) getBatteryInfo;
-(NSString*)deviceVersion;
-(void) didLoad;
-(NSDictionary *)retanDeviceInfo;
-(void)useAccelerometerPush;
-(void)startmotionmagngerUpdata;
-(void)stopmotionmagnger;
@end
