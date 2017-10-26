//
//  Kble.h
//  bleDemo2
//
//  Created by hao on 16/5/26.
//  Copyright © 2016年 hao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Kble : NSObject
//@property (nonatomic,strong) void
@property (copy, nonatomic) void (^StateString)(NSString *info);
@property (copy, nonatomic) void (^complateString)(NSString *info);
@property (copy, nonatomic) void (^CharacteristicString)(NSString *info);
@property (copy, nonatomic) void (^DescriptorString)(NSString *info);
@property (copy, nonatomic) void (^NotifyString)(NSString *info);
@property (copy, nonatomic) void (^readDescriptorString)(NSString *info);
@property (copy, nonatomic) void (^writeString)(NSString *info);
@property (copy, nonatomic) void (^writeDescriptorString)(NSString *info);
@property (copy, nonatomic) void (^complate)(BOOL result);
+(Kble *)sharedObject;
-(NSString *)createManager;
- (NSString *)scan:(NSDictionary *)paramsDict_;
- (NSString *)getPeripheral:(NSDictionary *)paramsDict_;
- (NSString *)isScanning:(NSDictionary *)paramsDict_;
- (NSString *)stopScan:(NSDictionary *)paramsDict_ ;
- (NSString *)connect:(NSString *)paramsDict_ ;
- (NSString *)disconnect:(NSString *)paramsDict_;
- (NSString *)isConnected:(NSString *)paramsDict_;
- (NSString *)retrievePeripheral:(NSArray *)paramsDict_ ;
- (NSString *)retrieveConnectedPeripheral:(NSArray *)paramsDict_;
- (NSString *)discoverService:(NSString *)paramsDict_ ;
- (void)discoverCharacteristics:(NSArray *)paramsDict_;
- (void)discoverDescriptorsForCharacteristic:(NSArray *)paramsDict_ ;
- (void)setNotify:(NSArray *)paramsDict_;
- (void)readValueForCharacteristic:(NSArray *)paramsDict_;
- (void)readValueForDescriptor:(NSArray *)paramsDict_ ;
- (void)readValueForDescriptor:(NSArray *)paramsDict_;
- (void)writeValueForCharacteristic:(NSArray *)paramsDict_;
- (void)writeValueForDescriptor:(NSArray *)paramsDict_ ;
@end
