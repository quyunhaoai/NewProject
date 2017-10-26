//
//  IsLocationGPS.h
//  GetGPSstate
//
//  Created by hao on 16/4/18.
//  Copyright © 2016年 hao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
@interface IsLocationGPS : NSObject<CLLocationManagerDelegate>
@property (strong,nonatomic) CLLocationManager *locationManager;
@property (nonatomic,copy) void(^location)(NSDictionary *locationInfo);
@property (nonatomic,copy) void(^compassChange)(CGFloat compassInfo);
+(IsLocationGPS *)sharedObject;
-(NSString *)retanIsOpenGPS;
-(void)startLocation;
-(void)startLocationHead;
-(void)stopLocation;


@end
