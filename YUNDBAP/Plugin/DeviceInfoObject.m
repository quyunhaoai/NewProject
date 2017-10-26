//
//  DeviceInfoObject.m
//  GetDvierInfo
//
//  Created by hao on 16/3/11.
//  Copyright © 2016年 hao. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DeviceInfoObject.h"
#import "sys/utsname.h"

//#import <Security/Security.h>
//#import "KeychainItemWrapper.h"
@implementation DeviceInfoObject
+(DeviceInfoObject *)sharedObject{
    static DeviceInfoObject *shareObject;
    if (shareObject == nil) {
        shareObject = [[DeviceInfoObject alloc]init];
        NSLog(@"单例：、");
    }
    return shareObject;
}
-(NSString *)identifier
{
    /*
    NSString *key = @"com.app.keychain.uuid";
    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:key accessGroup:nil];
    
    NSString *strUUID = [keychainItem objectForKey:(__bridge id)kSecValueData];
    
    if (strUUID.length <= 0) {
        strUUID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        
        [keychainItem setObject:@"uuid" forKey:(__bridge id)kSecAttrAccount];
        [keychainItem setObject:strUUID forKey:(__bridge id)kSecValueData];
    }
    */
    NSString *strUUID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    return strUUID;
}

//手机别名
-(NSString *)phoneName
{
    return [[UIDevice currentDevice] name];
}
//手机系统版本
/**
 *  手机系统版本
 *
 *  @return e.g. 8.0
 */
-(NSString *)phoneVersion{
    return [[UIDevice currentDevice] systemVersion];
}
//手机型号
//这个方法只能获取到iphone、iPad这种信息，无法获取到是iPhone 4、iphpone5这种具体的型号。

/**
 *  手机型号
 *
 *  @return e.g. iPhone
 */
-(NSString *)phoneModel{
    return [[UIDevice currentDevice] model];
}
//设备版本
//这个代码可以获取到具体的设备版本（已更新到iPhone 6s、iPhone 6s Plus），缺点是：采用的硬编码。具体的对应关系可以参考：https://www.theiphonewiki.com/wiki/Models

//这个方法可以通过AppStore的审核，放心用吧。

/**
 *  设备版本
 *
 *  @return e.g. iPhone 5S
 */
- (NSString*)deviceVersion
{
    // 需要#import "sys/utsname.h"
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    //iPhone
    if ([deviceString isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([deviceString isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([deviceString isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"Verizon iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,3"])    return @"iPhone 5C";
    if ([deviceString isEqualToString:@"iPhone5,4"])    return @"iPhone 5C";
    if ([deviceString isEqualToString:@"iPhone6,1"])    return @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPhone6,2"])    return @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([deviceString isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceString isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([deviceString isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    if ([deviceString isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
    
    if ([deviceString isEqualToString:@"iPhone9,1"]) return @"iPhone 7";
    
    if ([deviceString isEqualToString:@"iPhone9,2"]) return @"iPhone 7 Plus";
    

    //iPod
    if ([deviceString isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([deviceString isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([deviceString isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([deviceString isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([deviceString isEqualToString:@"iPod5,1"])      return @"iPod Touch 5G";
    
    //iPad
    if ([deviceString isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceString isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([deviceString isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([deviceString isEqualToString:@"iPad2,4"])      return @"iPad 2 (32nm)";
    if ([deviceString isEqualToString:@"iPad2,5"])      return @"iPad mini (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,6"])      return @"iPad mini (GSM)";
    if ([deviceString isEqualToString:@"iPad2,7"])      return @"iPad mini (CDMA)";
    
    if ([deviceString isEqualToString:@"iPad3,1"])      return @"iPad 3(WiFi)";
    if ([deviceString isEqualToString:@"iPad3,2"])      return @"iPad 3(CDMA)";
    if ([deviceString isEqualToString:@"iPad3,3"])      return @"iPad 3(4G)";
    if ([deviceString isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([deviceString isEqualToString:@"iPad3,5"])      return @"iPad 4 (4G)";
    if ([deviceString isEqualToString:@"iPad3,6"])      return @"iPad 4 (CDMA)";
    
    if ([deviceString isEqualToString:@"iPad4,1"])      return @"iPad Air";
    if ([deviceString isEqualToString:@"iPad4,2"])      return @"iPad Air";
    if ([deviceString isEqualToString:@"iPad4,3"])      return @"iPad Air";
    if ([deviceString isEqualToString:@"iPad5,3"])      return @"iPad Air 2";
    if ([deviceString isEqualToString:@"iPad5,4"])      return @"iPad Air 2";
    if ([deviceString isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceString isEqualToString:@"x86_64"])       return @"Simulator";
    
    if ([deviceString isEqualToString:@"iPad4,4"]
        ||[deviceString isEqualToString:@"iPad4,5"]
        ||[deviceString isEqualToString:@"iPad4,6"])      return @"iPad mini 2";
    
    if ([deviceString isEqualToString:@"iPad4,7"]
        ||[deviceString isEqualToString:@"iPad4,8"]
        ||[deviceString isEqualToString:@"iPad4,9"])      return @"iPad mini 3";
    
    return deviceString;
}

//获取电池当前的状态，共有4种状态
-(NSString*) getBatteryState {
    UIDevice *device = [UIDevice currentDevice];
    device.batteryMonitoringEnabled = YES;
    if (device.batteryState == UIDeviceBatteryStateUnknown) {
        return @"UnKnow";
    }else if (device.batteryState == UIDeviceBatteryStateUnplugged){
        return @"Unplugged";
    }else if (device.batteryState == UIDeviceBatteryStateCharging){
        return @"Charging";
    }else if (device.batteryState == UIDeviceBatteryStateFull){
        return @"Full";
    }
    return nil;
}
//获取电量的等级，0.00~1.00
-(float) getBatteryLevel {
    return [UIDevice currentDevice].batteryLevel;
}

-(NSString *) getBatteryInfo
{
    NSString *state =[self getBatteryState];
//                      getBatteryState();
    float level =[self getBatteryLevel]*100.0;
    NSLog(@"电池状态:%@  电量:%.f",state,level);
    NSString *Battery = [NSString stringWithFormat:@"%@,%.f",state,level];
//    getBatteryLevel()*100.0;
    //yourControlFunc(state, level);  //写自己要实现的获取电量信息后怎么处理
    return Battery;
}

//打开对电量和电池状态的监控，类似定时器的功能
-(void) didLoad
{
//    [[UIDevice currentDevice] setBatteryMonitoringEnable:YES];
//    [[UIDevice currentDevice] setBatteryMonitoringEnabled:YES];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getBatteryInfo:) name:UIDeviceBatteryStateDidChangeNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getBatteryInfo:) name:UIDeviceBatteryLevelDidChangeNotification object:nil];
//    [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(getBatteryInfo:) userInfo:nil repeats:YES];
}
-(NSDictionary *)retanDeviceInfo{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:10];
    [dic setValue:[self deviceVersion] forKey:@"model"];
    [dic setValue:@"2" forKey:@"pixelRatio"];
    [dic setValue:[NSNumber numberWithFloat:[UIScreen mainScreen].bounds.size.width] forKey:@"screenWidth"];
    [dic setObject:[NSNumber numberWithFloat:[UIScreen mainScreen].bounds.size.height] forKey:@"screenHeight"];
    if ([self.phoneVersion floatValue] >= 8.0) {
        
    }
    [dic setValue:[NSNumber numberWithFloat:[UIScreen mainScreen].bounds.size.width] forKey:@"windowWidth"];
    [dic setObject:[NSNumber numberWithFloat:[UIScreen mainScreen].bounds.size.height-20] forKey:@"windowHeight"];
    [dic setObject:[self getCurrentLanguage] forKey:@"language"];
    [dic setObject:@"" forKey:@"version"];
    [dic setObject:[self phoneVersion] forKey:@"system"];
    [dic setObject:[self sysname] forKey:@"platform"];
    [dic setObject:@"" forKey:@"SDKVersion"];
    return dic;
}
- (NSString *)getCurrentLanguage
{
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];
    NSLog( @"%@" , currentLanguage);
    return currentLanguage;
}
-(NSString *)sysname{
    return [UIDevice currentDevice].systemName;
}
-(NSString*)DataTOjsonString:(id)object
{
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}
#pragma mark 加速
- (void)useAccelerometerPush{
    //初始化全局管理对象
    CMMotionManager *manager = [[CMMotionManager alloc] init];
    self.motionmanager = manager;
    //判断加速度计可不可用，判断加速度计是否开启
    //    if ([manager isAccelerometerAvailable] && [manager isAccelerometerActive]){
    //告诉manager，更新频率是100Hz
    manager.accelerometerUpdateInterval = 1;
    [manager startDeviceMotionUpdates];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    //Push方式获取和处理数据
    [manager startAccelerometerUpdatesToQueue:queue
                                  withHandler:^(CMAccelerometerData *accelerometerData, NSError *error)
     {
         NSLog(@"X = %.04f",accelerometerData.acceleration.x);
         NSLog(@"Y = %.04f",accelerometerData.acceleration.y);
         NSLog(@"Z = %.04f",accelerometerData.acceleration.z);
         NSMutableDictionary *returnDict= [NSMutableDictionary dictionaryWithCapacity:9];
         [returnDict setObject:[NSNumber numberWithFloat:accelerometerData.acceleration.x] forKey:@"x"];
         [returnDict setObject:[NSNumber numberWithFloat:accelerometerData.acceleration.y] forKey:@"y"];
         [returnDict setObject:[NSNumber numberWithFloat:accelerometerData.acceleration.z] forKey:@"z"];
         self.accXYZ(returnDict);
         [manager stopDeviceMotionUpdates];
     }];
    //    }
}
-(void)startmotionmagngerUpdata{
    [self.motionmanager startDeviceMotionUpdates];
}
-(void)stopmotionmagnger{
    [self stopmotionmagnger];
}
@end
