//
//  IsLocationGPS.m
//  GetGPSstate
//
//  Created by hao on 16/4/18.
//  Copyright © 2016年 hao. All rights reserved.
//

#import "IsLocationGPS.h"
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>
#import "UIAlertView+Blocks.h"
@implementation IsLocationGPS
{
    CLLocationManager *locationManager;
    
}
+(IsLocationGPS *)sharedObject
{
    static IsLocationGPS *shared= nil;
    static dispatch_once_t oncetoken;
    dispatch_once(&oncetoken,^{
        shared = [[IsLocationGPS alloc]init];
    });
    return shared;
}
-(NSString *)retanIsOpenGPS{
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;;
    self.locationManager.distanceFilter = 1000.0f;
    if ([[[UIDevice currentDevice] systemVersion]floatValue]  >=8) {
//        [self.locationManager requestWhenInUseAuthorization];//使用程序其间允许访问位置数据（iOS8定位需要）
    }
    BOOL isOpenGps;
    NSString *str;
    if ([CLLocationManager locationServicesEnabled] &&
        ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusAuthorizedAlways
         || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined||[CLLocationManager authorizationStatus]==kCLAuthorizationStatusAuthorizedWhenInUse)) {
            isOpenGps = true;
            str = @"true";
        }
    else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied ||[CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted){
        
        isOpenGps = false;
        str = @"false";
    }
    NSDictionary *dict = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:isOpenGps] forKey:@"gps"];
    str =  [self DataTOjsonString:dict];
    return str;
}
-(void)startLocation{
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;;
    self.locationManager.distanceFilter = 1000.0f;
    if ([[[UIDevice currentDevice] systemVersion]floatValue]  >=8) {
        [self.locationManager requestWhenInUseAuthorization];//使用程序其间允许访问位置数据iOS8定位需要）
    }
    if ([CLLocationManager locationServicesEnabled]) {
        [self.locationManager startUpdatingLocation];
    }
}
-(void)startLocationHead{
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;;
    self.locationManager.distanceFilter = 1000.0f;
    if ([[[UIDevice currentDevice] systemVersion]floatValue]  >=8) {
        [self.locationManager requestWhenInUseAuthorization];//使用程序其间允许访问位置数据iOS8定位需要）
    }
    if ([CLLocationManager headingAvailable]) {
        [self.locationManager startUpdatingHeading];
    }else{
        NSLog(@"compass not Available!");
        UIAlertView *aler = [UIAlertView showAlertViewWithTitle:nil message:@"compass not Available!" cancelButtonTitle:@"cancel" otherButtonTitles:nil onDismiss:^(int buttonIndex, UIAlertView *alertView) {
            
        } onCancel:^{
            
        }];
    }
    
}
-(NSString*)DataTOjsonString:(id)object
{
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"%@",error);
    
}
-(void)stopLocation{
    if (self.locationManager) {
        [self.locationManager stopUpdatingLocation];
        [self.locationManager stopUpdatingHeading];
    }
}
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    CLLocation *location = [locations lastObject];

    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.roundingMode = NSNumberFormatterRoundFloor;
    formatter.maximumFractionDigits = 2;
    NSString *latitudeStr = [formatter stringFromNumber:[NSNumber numberWithFloat:location.coordinate.latitude]];
    NSString *longitudeStr =[formatter stringFromNumber:[NSNumber numberWithFloat:location.coordinate.longitude]];
    NSString *speedStr =[formatter stringFromNumber:[NSNumber numberWithFloat:location.speed]];
    NSString *accuracyStr = [formatter stringFromNumber:[NSNumber numberWithFloat:location.verticalAccuracy]];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:9];
    [dic setObject:[formatter numberFromString:latitudeStr] forKey:@"latitude"];
    [dic setObject:[formatter numberFromString:longitudeStr]forKey:@"longitude"];
    [dic setObject:[formatter numberFromString:speedStr] forKey:@"speed"];
    [dic setObject:[formatter numberFromString:accuracyStr] forKey:@"accuracy"];

    self.location(dic);
    if (dic) {
        [self stopLocation];
    }
}
-(void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading{
    CGFloat heading = -1.0f * M_PI *newHeading.magneticHeading /180.0f;
    NSLog(@"----%@",[NSString stringWithFormat:@"angle:%f",newHeading.magneticHeading]);
    //    arrow.transform = CGAffineTransformMakeRotation(heading);
    self.compassChange(heading);
}

@end
