//
//  Kble.m
//  bleDemo2
//
//  Created by hao on 16/5/26.
//  Copyright © 2016年 hao. All rights reserved.
//

#import "Kble.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreBluetooth/CBService.h>
#import <CoreBluetooth/CBCharacteristic.h>
#import "NSDictionaryUtils.h"
@interface Kble ()
<CBCentralManagerDelegate, CBPeripheralDelegate>
{
    CBCentralManager *_centralManager;
    NSMutableDictionary *_allPeripheral, *_allPeripheralInfo;
    
    NSInteger initCbid, connectCbid, disconnectCbid, discoverServiceCbid, discoverCharacteristicsCbid, discoverDescriptorsForCharacteristicCbid;
    NSInteger setNotifyCbid, readValueForCharacteristicCbid, readValueForDescriptorCbid, writeValueCbid;
    BOOL disconnectClick;
}

@property (strong, nonatomic) CBCentralManager *centralManager;
@property (strong, nonatomic) NSMutableDictionary *allPeripheral, *allPeripheralInfo;

@end


@implementation Kble
@synthesize centralManager = _centralManager;
@synthesize allPeripheral = _allPeripheral;
@synthesize allPeripheralInfo = _allPeripheralInfo;
+(Kble *)sharedObject{
    static Kble *shardObject = nil;
    static dispatch_once_t Tonkent;
    dispatch_once(&Tonkent,^{
//        shardObject = [[Kble alloc]init];
        shardObject = [[Kble alloc]init];
    });
    return shardObject;
}
//- (void)dispose {
//    if (_centralManager) {
//        _centralManager.delegate = nil;
//        self.centralManager = nil;
//    }
    /*
     if (initCbid >= 0) {
     [self deleteCallback:initCbid];
     }
     if (connectCbid >= 0) {
     [self deleteCallback:connectCbid];
     }
     if (setNotifyCbid >= 0) {
     [self deleteCallback:setNotifyCbid];
     }
     if (readValueForCharacteristicCbid >= 0) {
     [self deleteCallback:readValueForCharacteristicCbid];
     }
     */
//    [self cleanStoredPeripheral];
//}

-(id)init{
    
    
    if (self == [super self]) {
//        _allPeripheral = [NSMutableDictionary dictionary];
//        _allPeripheralInfo = [NSMutableDictionary dictionary];
        disconnectClick = NO;
/*
        _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
        if (_centralManager) {
            if(_centralManager.state == CBCentralManagerStatePoweredOn){
                NSLog(@"初始化成功！");
//                self.complateString(@"初始化成功！");
            }else{
                NSLog(@"初始化失败！");
                NSString *state =[[NSString alloc]initWithFormat:@"初始化失败！"];
//                self.complateString(state);
                [self initManagerCall:state];
            }
*/
                
//            [self initManagerCallback:_centralManager.state];
//            NSString *state = _centralManager.state;
//            return;
//        }
    }
    return self;
}
//初始化蓝牙4.0管理器
-(NSString *)createManager
{
    _allPeripheral = [NSMutableDictionary dictionary];
    _allPeripheralInfo = [NSMutableDictionary dictionary];
    _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue()];
    
    NSString *state = nil;
    /*
            switch (_centralManager.state) {
                case CBCentralManagerStatePoweredOff://设备关闭状态
                    state = @"poweredOff";
                    break;
                    
                case CBCentralManagerStatePoweredOn:// 设备开启状态 -- 可用状态
                    state = @"poweredOn";
                    break;
                    
                case CBCentralManagerStateResetting://正在重置状态
                    state = @"resetting";
                    break;
                    
                case CBCentralManagerStateUnauthorized:// 设备未授权状态
                    state = @"unauthorized";
                    break;
                    
                case CBCentralManagerStateUnknown:// 初始的时候是未知的（刚刚创建的时候）
                    state = @"unknown";
                    break;
                    
                case CBCentralManagerStateUnsupported://设备不支持的状态
                    state = @"unsupported";
                    break;
                    
                default:
                    state = @"unknown";
                    break;
            }
     */
    
    self.StateString= ^(NSString *state){
        NSLog(@"%@",state);

    };
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:state,@"state", nil];
    state = [self DataTOjsonString:dic];
    
//    };
    
    return state;
}

-(void)initManagerCall:(NSString *)info
{
//    BOOL isOK = false;
//    self.complateString(info);
//    self.complate(isOK);
}
//开始搜索蓝牙4.0设备
- (NSString *)scan:(NSDictionary *)paramsDict_ {
    NSString *state;
    NSArray *serviceIDs = [paramsDict_ arrayValueForKey:@"serviceUUIDS" defaultValue:@[]];
    NSMutableArray *allCBUUID = [self creatCBUUIDAry:serviceIDs];
    if (allCBUUID.count == 0) {
        allCBUUID = nil;
    }
    [_centralManager scanForPeripheralsWithServices:allCBUUID options:nil];
    if (_centralManager) {
        state = @"ture";
    } else {
        state = @"false";
    }
    NSDictionary *dic = @{@"status":state};
    state = [self DataTOjsonString:dic];
    return state;
}
//获取当前扫描到的所有外围设备信息
- (NSString *)getPeripheral:(NSDictionary *)paramsDict_
{
    NSLog(@"--%@--",paramsDict_);
    NSDictionary *dict;
    NSLog(@"---%@----",_allPeripheralInfo);
//    NSInteger getCurDvcCbid = [paramsDict_ integerValueForKey:@"cbId" defaultValue:-1];
    if (_allPeripheralInfo.count > 0) {
        NSMutableArray *sendAry = [NSMutableArray array];
        for (NSString *targetId in [_allPeripheralInfo allKeys]) {
//            NSDictionary *peripheral = [_allPeripheralInfo dictValueForKey:targetId defaultValue:@{}];
            NSDictionary *peripheral = [_allPeripheralInfo objectForKey:targetId];
            if (peripheral) {
                [sendAry addObject:peripheral];
            }
        }
        dict = [NSDictionary dictionaryWithObject:sendAry forKey:@"peripherals"];
//        [self sendResultEventWithCallbackId:getCurDvcCbid dataDict:[NSDictionary dictionaryWithObject:sendAry forKey:@"peripherals"] errDict:nil doDelete:YES];
    } else {
//        dict = nil;
//        [self sendResultEventWithCallbackId:getCurDvcCbid dataDict:nil errDict:nil doDelete:YES];
        
    }
    
    NSString *peripheral = [self DataTOjsonString:dict];
    return peripheral;
}
-(NSString*)DataTOjsonString:(id)object
{
    
    NSError *parseError = nil;
    if ([object class] == [NSNull class]||[object class] == NULL||object == NULL) {
        return nil;
    }
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:&parseError];
    NSString *str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return str;
}
//判断是否正在扫描
- (NSString *)isScanning:(NSDictionary *)paramsDict_
{
    NSString *isScan;
    if(_centralManager && _centralManager.isScanning ) {
        isScan = @"ture";
    } else {
        isScan = @"false";
    }
    NSDictionary *dic = @{@"status":isScan};
    isScan = [self DataTOjsonString:dic];
    return isScan;
}
//停止搜索附近的蓝牙设备，并清空已搜索到的记录在本地的外围设备信息
- (NSString *)stopScan:(NSDictionary *)paramsDict_ {
    NSString *isStop;
    if (_centralManager) {
        [_centralManager stopScan];
        [self cleanStoredPeripheral];
        self.allPeripheral = [NSMutableDictionary dictionary];
        self.allPeripheralInfo = [NSMutableDictionary dictionary];
    }
    return isStop;
}
//连接指定外围设备
- (NSString *)connect:(NSString *)paramsDict_ {
    NSString *connectState;
    if (connectCbid >= 0) {
//        [self deleteCallback:connectCbid];
    }
//    connectCbid = [paramsDict_ integerValueForKey:@"cbId" defaultValue:-1];
    NSString *peripheralUUID = paramsDict_;
    if (peripheralUUID.length == 0) {
//        [self callbackCodeInfo:NO withCode:1 andCbid:connectCbid doDelete:NO];
        connectState = @"false";
    }
    CBPeripheral *peripheral = [_allPeripheral objectForKey:peripheralUUID];
    if (peripheral && [peripheral isKindOfClass:[CBPeripheral class]]) {
        if(peripheral.state  == CBPeripheralStateConnected) {
//            [self callbackCodeInfo:NO withCode:3 andCbid:connectCbid doDelete:NO];
            connectState = @"ture";
        } else {
            [_centralManager connectPeripheral:peripheral options:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:CBConnectPeripheralOptionNotifyOnDisconnectionKey]];
            connectState = @"ture";
        }
    } else {
        connectState = @"false";
//        [self callbackCodeInfo:NO withCode:2 andCbid:connectCbid doDelete:NO];
    }
    NSDictionary *dic = @{@"status":connectState};
    connectState = [self DataTOjsonString:dic];
    return connectState;
}
//断开与指定外围设备的连接
- (NSString *)disconnect:(NSString *)paramsDict_ {
    NSString *isDisconnect;
    NSString *peripheralUUID = paramsDict_;
    if (peripheralUUID.length == 0) {
        isDisconnect = @"false";
    }
//    disconnectClick = YES;
//    disconnectCbid = [paramsDict_ integerValueForKey:@"cbId" defaultValue:-1];
    CBPeripheral *peripheral = [_allPeripheral objectForKey:peripheralUUID];
    if (peripheral && [peripheral isKindOfClass:[CBPeripheral class]]) {
        if(peripheral.state  == CBPeripheralStateConnected) {
            [_centralManager cancelPeripheralConnection:peripheral];
            isDisconnect = @"ture";
        } else {
//            disconnectClick = NO;
//            [self callbackToJs:YES withID:disconnectCbid];
            isDisconnect = @"ture";
        }
    }else{
            isDisconnect = @"false";
    }
    NSDictionary *dic = @{@"status":isDisconnect};
    isDisconnect = [self DataTOjsonString:dic];
    return isDisconnect;
}
//判断与指定外围设备是否为连接状态
- (NSString *)isConnected:(NSString *)paramsDict_ {
    NSString *isOK;
    NSString *peripheralUUID = paramsDict_;
    if (peripheralUUID.length == 0) {
        isOK = @"false";
    }
//    NSInteger isConnectedCbid = [paramsDict_ integerValueForKey:@"cbId" defaultValue:-1];
    CBPeripheral *peripheral = [_allPeripheral objectForKey:peripheralUUID];
    if (peripheral && [peripheral isKindOfClass:[CBPeripheral class]]) {
        if(peripheral.state  == CBPeripheralStateConnected) {
//            [self callbackToJs:YES withID:isConnectedCbid];
            isOK = @"ture";
        } else {
//            [self callbackToJs:NO withID:isConnectedCbid];
            isOK = @"false";
        }
    }else{
        isOK = @"false";
    }
    NSDictionary *dic = @{@"status":isOK};
    isOK = [self DataTOjsonString:dic];
    return isOK;
}
//根据 UUID 找到所有匹配的蓝牙外围设备信息
- (NSString *)retrievePeripheral:(NSArray *)paramsDict_ {
    NSString *relat;
    NSArray *peripheralUUIDs = paramsDict_;
    NSMutableArray *allPeriphralId = [self creatPeripheralNSUUIDAry:peripheralUUIDs];
    if (allPeriphralId.count == 0) {
//        return nil;
    }
    NSMutableArray *allRetrivedPeripheral = nil;
    if (_centralManager) {
        NSArray *retrivedPer = [_centralManager retrievePeripheralsWithIdentifiers:allPeriphralId];
        allRetrivedPeripheral = [self getAllPeriphoeralInfoAry:retrivedPer];
    }
    if (!allRetrivedPeripheral) {
        allRetrivedPeripheral = [NSMutableArray array];
    }
//    NSInteger retrieveCbid = [paramsDict_ integerValueForKey:@"cbId" defaultValue:-1];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:allRetrivedPeripheral forKey:@"peripherals"];
//    [self sendResultEventWithCallbackId:retrieveCbid dataDict:[NSDictionary dictionaryWithObject:allRetrivedPeripheral forKey:@"peripherals"] errDict:nil doDelete:YES];
    relat = [self DataTOjsonString:dict];
    return relat;
}
//根据指定的服务，找到当前系统处于连接状态的蓝牙中包含这个服务的所有蓝牙外围设备信息
- (NSString *)retrieveConnectedPeripheral:(NSArray *)paramsDict_ {
//    NSArray *serviceIDs = paramsDict_;
    

    NSMutableArray *serviceIDs = [[NSMutableArray alloc]initWithArray:paramsDict_];
    [serviceIDs removeLastObject];
    NSLog(@"---%@---",serviceIDs);
    NSMutableArray *allCBUUID = [self creatCBUUIDAry:serviceIDs];
    if (allCBUUID.count == 0) {
        return nil;
    }
    NSMutableArray *allRetrivedPeripheral = nil;
    if (_centralManager) {
        NSArray *retrivedPer = [_centralManager retrieveConnectedPeripheralsWithServices:allCBUUID];
        allRetrivedPeripheral = [self getAllPeriphoeralInfoAry:retrivedPer];
    }
    if (!allRetrivedPeripheral) {
        allRetrivedPeripheral = [NSMutableArray array];
    }
//    NSInteger retrieveCbid = [paramsDict_ integerValueForKey:@"cbId" defaultValue:-1];
    NSDictionary *dict =[NSDictionary dictionaryWithObject:allRetrivedPeripheral forKey:@"peripherals"];
    NSString *relat = [self DataTOjsonString:dict];
    return relat;
//    [self sendResultEventWithCallbackId:retrieveCbid dataDict:[NSDictionary dictionaryWithObject:allRetrivedPeripheral forKey:@"peripherals"] errDict:nil doDelete:YES];
}
//根据指定的外围设备 UUID 获取该外围设备的所有服务
- (NSString *)discoverService:(NSString *)paramsDict_ {
    
    
//    discoverServiceCbid = [paramsDict_ integerValueForKey:@"cbId" defaultValue:-1];
    NSString *peripheralUUID = paramsDict_;
    if (peripheralUUID.length == 0) {
//        [self callbackCodeInfo:NO withCode:1 andCbid:discoverServiceCbid doDelete:YES];
        return nil;
    }
//    NSArray *serviceIDs = [paramsDict_ arrayValueForKey:@"serviceUUIDS" defaultValue:@[]];
//    NSMutableArray *allCBUUID = [self creatCBUUIDAry:serviceIDs];
//    if (allCBUUID.count == 0) {
//        allCBUUID = nil;
//    }
    CBPeripheral *peripheral = [_allPeripheral objectForKey:peripheralUUID];
    if (peripheral && [peripheral isKindOfClass:[CBPeripheral class]]) {
        peripheral.delegate = self;
        [peripheral discoverServices:nil];
    } else {
//        [self callbackCodeInfo:NO withCode:2 andCbid:discoverServiceCbid doDelete:YES];
    }
    
    return nil;
}
//根据指定的外围设备 UUID 及其服务 UUID 获取该外围设备的所有特征（Characteristic）
- (void)discoverCharacteristics:(NSArray *)paramsDict_ {
//    discoverCharacteristicsCbid = [paramsDict_ integerValueForKey:@"cbId" defaultValue:-1];
    NSString *peripheralUUID = paramsDict_[0];
    if (peripheralUUID.length == 0) {
        [self callbackCodeInfo:NO withCode:1 andCbid:discoverCharacteristicsCbid doDelete:YES];
        return;
    }
    NSString *serviceUUID =paramsDict_[1];
    if (serviceUUID.length == 0) {
        [self callbackCodeInfo:NO withCode:2 andCbid:discoverCharacteristicsCbid doDelete:YES];
        return;
    }
    CBPeripheral *peripheral = [_allPeripheral objectForKey:peripheralUUID];
    if (peripheral && [peripheral isKindOfClass:[CBPeripheral class]]) {
        CBService *myService = [self getServiceWithPeripheral:peripheral andUUID:serviceUUID];
        if (myService) {
            [peripheral discoverCharacteristics:nil forService:myService];
        } else {
//            [self callbackCodeInfo:NO withCode:3 andCbid:discoverCharacteristicsCbid doDelete:YES];
        }
    } else {
//        [self callbackCodeInfo:NO withCode:4 andCbid:discoverCharacteristicsCbid doDelete:YES];
    }
}
//根据指定的外围设备 UUID 及其服务 UUID 和特征 UUID 获取该外围设备的所有描述符
- (void)discoverDescriptorsForCharacteristic:(NSArray *)paramsDict_ {
//    discoverDescriptorsForCharacteristicCbid = paramsDict_[0];
    NSString *peripheralUUID = paramsDict_[0];
    if (peripheralUUID.length == 0) {
//        [self callbackCodeInfo:NO withCode:1 andCbid:discoverDescriptorsForCharacteristicCbid doDelete:YES];
        return;
    }
    NSString *serviceUUID = paramsDict_[1];
    if (serviceUUID.length == 0) {
//        [self callbackCodeInfo:NO withCode:2 andCbid:discoverDescriptorsForCharacteristicCbid doDelete:YES];
        return;
    }
    NSString *characteristicUUID = paramsDict_[2];
    if (characteristicUUID.length == 0) {
//        [self callbackCodeInfo:NO withCode:3 andCbid:discoverDescriptorsForCharacteristicCbid doDelete:YES];
        return;
    }
    CBPeripheral *peripheral = [_allPeripheral objectForKey:peripheralUUID];
    if (peripheral && [peripheral isKindOfClass:[CBPeripheral class]]) {
        CBService *myService = [self getServiceWithPeripheral:peripheral andUUID:serviceUUID];
        if (myService) {
            CBCharacteristic *characteristic = [self getCharacteristicInService:myService withUUID:characteristicUUID];
            if(characteristic){
                [peripheral discoverDescriptorsForCharacteristic:characteristic];
            } else {
//                [self callbackCodeInfo:NO withCode:4 andCbid:discoverDescriptorsForCharacteristicCbid doDelete:YES];
            }
        } else {
//            [self callbackCodeInfo:NO withCode:5 andCbid:discoverDescriptorsForCharacteristicCbid doDelete:YES];
        }
    } else {
//        [self callbackCodeInfo:NO withCode:6 andCbid:discoverDescriptorsForCharacteristicCbid doDelete:YES];
    }
}
//BLsetNotify根据指定的外围设备 UUID 及其服务 UUID 和特征 UUID 监听数据回发
- (void)setNotify:(NSArray *)paramsDict_ {
//    setNotifyCbid = [paramsDict_ integerValueForKey:@"cbId" defaultValue:-1];
    NSString *peripheralUUID = paramsDict_[0];
    if (peripheralUUID.length == 0) {
//        [self callbackCodeInfo:NO withCode:1 andCbid:setNotifyCbid doDelete:YES];
        return;
    }
    NSString *serviceUUID = paramsDict_[1];
    if (serviceUUID.length == 0) {
//        [self callbackCodeInfo:NO withCode:2 andCbid:setNotifyCbid doDelete:YES];
        return;
    }
    NSString *characteristicUUID =paramsDict_[2];
    if (characteristicUUID.length == 0) {
//        [self callbackCodeInfo:NO withCode:3 andCbid:setNotifyCbid doDelete:YES];
        return;
    }
    CBPeripheral *peripheral = [_allPeripheral objectForKey:peripheralUUID];
    if (peripheral && [peripheral isKindOfClass:[CBPeripheral class]]) {
        CBService *myService = [self getServiceWithPeripheral:peripheral andUUID:serviceUUID];
        if (myService) {
            CBCharacteristic *characteristic = [self getCharacteristicInService:myService withUUID:characteristicUUID];
            if(characteristic){
                [peripheral setNotifyValue:YES forCharacteristic:characteristic];
            } else {
                [self callbackCodeInfo:NO withCode:4 andCbid:setNotifyCbid doDelete:YES];
            }
        } else {
            [self callbackCodeInfo:NO withCode:5 andCbid:setNotifyCbid doDelete:YES];
        }
    } else {
        [self callbackCodeInfo:NO withCode:6 andCbid:setNotifyCbid doDelete:YES];
    }
}
//根据指定的外围设备 UUID 及其服务 UUID 和特征 UUID 读取数据
- (void)readValueForCharacteristic:(NSArray *)paramsDict_ {
//    readValueForCharacteristicCbid = [paramsDict_ integerValueForKey:@"cbId" defaultValue:-1];
    NSString *peripheralUUID = paramsDict_[0];
    if (peripheralUUID.length == 0) {
        [self callbackCodeInfo:NO withCode:1 andCbid:readValueForCharacteristicCbid doDelete:YES];
        return;
    }
    NSString *serviceUUID = paramsDict_[1];
    if (serviceUUID.length == 0) {
        [self callbackCodeInfo:NO withCode:2 andCbid:readValueForCharacteristicCbid doDelete:YES];
        return;
    }
    NSString *characteristicUUID = paramsDict_[2];
    if (characteristicUUID.length == 0) {
        [self callbackCodeInfo:NO withCode:3 andCbid:readValueForCharacteristicCbid doDelete:YES];
        return;
    }
    CBPeripheral *peripheral = [_allPeripheral objectForKey:peripheralUUID];
    if (peripheral && [peripheral isKindOfClass:[CBPeripheral class]]) {
        CBService *myService = [self getServiceWithPeripheral:peripheral andUUID:serviceUUID];
        if (myService) {
            CBCharacteristic *characteristic = [self getCharacteristicInService:myService withUUID:characteristicUUID];
            if(characteristic){
                [peripheral readValueForCharacteristic:characteristic];
            } else {
                [self callbackCodeInfo:NO withCode:4 andCbid:readValueForCharacteristicCbid doDelete:YES];
            }
        } else {
            [self callbackCodeInfo:NO withCode:5 andCbid:readValueForCharacteristicCbid doDelete:YES];
        }
    } else {
        [self callbackCodeInfo:NO withCode:6 andCbid:readValueForCharacteristicCbid doDelete:YES];
    }
}
//根据指定的外围设备 UUID 及其服务 UUID 和特征 UUID 及其描述符获取数据
- (void)readValueForDescriptor:(NSArray *)paramsDict_ {
//    readValueForDescriptorCbid = [paramsDict_ integerValueForKey:@"cbId" defaultValue:-1];
    NSString *peripheralUUID = paramsDict_[0];
    if (peripheralUUID.length == 0) {
        [self callbackCodeInfo:NO withCode:1 andCbid:readValueForDescriptorCbid doDelete:YES];
        return;
    }
    NSString *serviceUUID = paramsDict_[1];
    if (serviceUUID.length == 0) {
        [self callbackCodeInfo:NO withCode:2 andCbid:readValueForDescriptorCbid doDelete:YES];
        return;
    }
    NSString *characteristicUUID =paramsDict_[2];
    if (characteristicUUID.length == 0) {
        [self callbackCodeInfo:NO withCode:3 andCbid:readValueForDescriptorCbid doDelete:YES];
        return;
    }
    NSString *descriptorUUID = paramsDict_[3];
    if (descriptorUUID.length == 0) {
        [self callbackCodeInfo:NO withCode:4 andCbid:readValueForDescriptorCbid doDelete:YES];
        return;
    }
    CBPeripheral *peripheral = [_allPeripheral objectForKey:peripheralUUID];
    if (peripheral && [peripheral isKindOfClass:[CBPeripheral class]]) {
        CBService *myService = [self getServiceWithPeripheral:peripheral andUUID:serviceUUID];
        if (myService) {
            CBCharacteristic *characteristic = [self getCharacteristicInService:myService withUUID:characteristicUUID];
            if(characteristic){
                CBDescriptor *descriptor = [self getDescriptorInCharacteristic:characteristic withUUID:descriptorUUID];
                if (descriptor) {
                    [peripheral readValueForDescriptor:descriptor];
                } else {
                    [self callbackCodeInfo:NO withCode:5 andCbid:readValueForDescriptorCbid doDelete:YES];
                }
            } else {
                [self callbackCodeInfo:NO withCode:6 andCbid:readValueForDescriptorCbid doDelete:YES];
            }
        } else {
            [self callbackCodeInfo:NO withCode:7 andCbid:readValueForDescriptorCbid doDelete:YES];
        }
    } else {
        [self callbackCodeInfo:NO withCode:8 andCbid:readValueForDescriptorCbid doDelete:YES];
    }
}
//根据指定的外围设备 UUID 及其服务 UUID 和特征 UUID 写数据
- (void)writeValueForCharacteristic:(NSArray *)paramsDict_ {
//    writeValueCbid = [paramsDict_ integerValueForKey:@"cbId" defaultValue:-1];
    NSString *peripheralUUID = paramsDict_[0];
    if (peripheralUUID.length == 0) {
        [self callbackCodeInfo:NO withCode:1 andCbid:writeValueCbid doDelete:YES];
        return;
    }
    NSString *serviceUUID = paramsDict_[1];
    if (serviceUUID.length == 0) {
        [self callbackCodeInfo:NO withCode:2 andCbid:writeValueCbid doDelete:YES];
        return;
    }
    NSString *characteristicUUID =paramsDict_[2];
    if (characteristicUUID.length == 0) {
        [self callbackCodeInfo:NO withCode:3 andCbid:writeValueCbid doDelete:YES];
        return;
    }
    NSString *value =paramsDict_[3];
    if (value.length == 0) {
        [self callbackCodeInfo:NO withCode:4 andCbid:writeValueCbid doDelete:YES];
        return;
    }
    CBPeripheral *peripheral = [_allPeripheral objectForKey:peripheralUUID];
    if (peripheral && [peripheral isKindOfClass:[CBPeripheral class]]) {
        CBService *myService = [self getServiceWithPeripheral:peripheral andUUID:serviceUUID];
        if (myService) {
            CBCharacteristic *characteristic = [self getCharacteristicInService:myService withUUID:characteristicUUID];
            if(characteristic){
                NSData *valueData = [self dataFormHexString:value];
                if (valueData) {
                    CBCharacteristicWriteType type = CBCharacteristicWriteWithResponse;
                    if((characteristic.properties == CBCharacteristicPropertyWriteWithoutResponse)) {
                        type = CBCharacteristicWriteWithoutResponse;
                    } else if((characteristic.properties == CBCharacteristicPropertyWrite)) {
                        type = CBCharacteristicWriteWithResponse;
                    }
                    [peripheral writeValue:valueData forCharacteristic:characteristic type:type];
                }
            } else {
                [self callbackCodeInfo:NO withCode:5 andCbid:writeValueCbid doDelete:YES];
            }
        } else {
            [self callbackCodeInfo:NO withCode:6 andCbid:writeValueCbid doDelete:YES];
        }
    } else {
        [self callbackCodeInfo:NO withCode:7 andCbid:writeValueCbid doDelete:YES];
    }
}
//根据指定的外围设备 UUID 及其服务 UUID 和特征 UUID 及其描述符发送数据
- (void)writeValueForDescriptor:(NSArray *)paramsDict_ {
//    writeValueCbid = [paramsDict_ integerValueForKey:@"cbId" defaultValue:-1];
    NSString *peripheralUUID = paramsDict_[0];
    if (peripheralUUID.length == 0) {
        [self callbackCodeInfo:NO withCode:1 andCbid:writeValueCbid doDelete:YES];
        return;
    }
    NSString *serviceUUID =paramsDict_[1];
    if (serviceUUID.length == 0) {
        [self callbackCodeInfo:NO withCode:2 andCbid:writeValueCbid doDelete:YES];
        return;
    }
    NSString *characteristicUUID = paramsDict_[2];
    if (characteristicUUID.length == 0) {
        [self callbackCodeInfo:NO withCode:3 andCbid:writeValueCbid doDelete:YES];
        return;
    }
    NSString *descriptorUUID =paramsDict_[3];
    if (descriptorUUID.length == 0) {
        [self callbackCodeInfo:NO withCode:4 andCbid:writeValueCbid doDelete:YES];
        return;
    }
    NSString *value = paramsDict_[4];
    if (value.length == 0) {
        [self callbackCodeInfo:NO withCode:5 andCbid:writeValueCbid doDelete:YES];
        return;
    }
    CBPeripheral *peripheral = [_allPeripheral objectForKey:peripheralUUID];
    if (peripheral && [peripheral isKindOfClass:[CBPeripheral class]]) {
        CBService *myService = [self getServiceWithPeripheral:peripheral andUUID:serviceUUID];
        if (myService) {
            CBCharacteristic *characteristic = [self getCharacteristicInService:myService withUUID:characteristicUUID];
            if(characteristic){
                CBDescriptor *descriptor = [self getDescriptorInCharacteristic:characteristic withUUID:descriptorUUID];
                if (descriptor) {
                    NSData *valueData = [[NSData alloc] initWithBase64EncodedString:value options:0];
                    if (valueData) {
                        [peripheral writeValue:valueData forDescriptor:descriptor];
                    }
                } else {
                    [self callbackCodeInfo:NO withCode:6 andCbid:writeValueCbid doDelete:YES];
                }
            } else {
                [self callbackCodeInfo:NO withCode:7 andCbid:writeValueCbid doDelete:YES];
            }
        } else {
            [self callbackCodeInfo:NO withCode:8 andCbid:writeValueCbid doDelete:YES];
        }
    } else {
        [self callbackCodeInfo:NO withCode:9 andCbid:writeValueCbid doDelete:YES];
    }
}

#pragma mark - CBPeripheralDelegate -

//按特征&描述符发送数据的回调
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    NSMutableDictionary *writeCharacteristic = [NSMutableDictionary dictionary];
    if(error){
        [self callbackCodeInfo:NO withCode:-1 andCbid:writeValueCbid doDelete:YES];
        return;
    }
    NSMutableDictionary *characterDict = [self getCharacteristicsDict:characteristic];
    [writeCharacteristic setValue:characterDict forKey:@"characteristic"];
    [writeCharacteristic setValue:[NSNumber numberWithBool:YES] forKey:@"status"];
    NSString *str=[self DataTOjsonString:writeCharacteristic
                   ];
    self.writeString(str);
//    [self sendResultEventWithCallbackId:writeValueCbid dataDict:writeCharacteristic errDict:nil doDelete:YES];
}

//根据描述符读取数据
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForDescriptor:(CBDescriptor *)descriptor error:(NSError *)error{
    NSMutableDictionary *descriptorDict = [NSMutableDictionary dictionary];
    NSString *descriptorUUID = descriptor.UUID.UUIDString;
    if (!descriptorUUID) {
        [self callbackCodeInfo:NO withCode:-1 andCbid:readValueForDescriptorCbid doDelete:YES];
        return;
    }
    //[descriptorDict setValue:descriptorUUID forKey:@"descriptorUUID"];
    if(error) {
        [self callbackCodeInfo:NO withCode:-1 andCbid:readValueForDescriptorCbid doDelete:YES];
        return;
    } else {
        NSMutableDictionary *descriptorsDict = [self getDescriptorInfo:descriptor];
        [descriptorDict setValue:descriptorsDict forKey:@"descriptor"];
        [descriptorDict setValue:[NSNumber numberWithBool:YES] forKey:@"status"];
        NSString *str = [self DataTOjsonString:descriptorDict];
        self.readDescriptorString(str);
//        [self sendResultEventWithCallbackId:readValueForDescriptorCbid dataDict:descriptorDict errDict:nil doDelete:YES];
    }
}

//按特征读取数据，监听后会不断的有心跳数据包回调
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    NSMutableDictionary *characteristicDict = [NSMutableDictionary dictionary];
    NSString *characterUUID = characteristic.UUID.UUIDString;
    if (!characterUUID) {
        [self callbackCodeInfo:NO withCode:-1 andCbid:readValueForCharacteristicCbid doDelete:YES];
        return;
    }
    //[characteristicDict setValue:characterUUID forKey:@"uuid"];
    if(error) {
        [self callbackCodeInfo:NO withCode:-1 andCbid:readValueForCharacteristicCbid doDelete:YES];
    } else {
        NSMutableDictionary *characteristics = [self getCharacteristicsDict:characteristic];
        [characteristicDict setValue:characteristics forKey:@"characteristic"];
        [characteristicDict setValue:[NSNumber numberWithBool:YES] forKey:@"status"];
        NSString *jianting = [self DataTOjsonString:characteristics];
        self.NotifyString(jianting);
        if (readValueForCharacteristicCbid >= 0) {
//            [self sendResultEventWithCallbackId:readValueForCharacteristicCbid dataDict:characteristicDict errDict:nil doDelete:YES];
        }
        if (setNotifyCbid >= 0) {
//            [self sendResultEventWithCallbackId:setNotifyCbid dataDict:characteristicDict errDict:nil doDelete:NO];
        }
    }
}

//监听外围设备成功的回调
- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error {
    //NSMutableDictionary *characteristicDict = [NSMutableDictionary dictionary];
    NSString *characterUUID = characteristic.UUID.UUIDString;
    if (!characterUUID) {
        [self callbackCodeInfo:NO withCode:-1 andCbid:setNotifyCbid doDelete:NO];
        return;
    }
    //[characteristicDict setValue:characterUUID forKey:@"uuid"];
    if(error) {
        [self callbackCodeInfo:NO withCode:-1 andCbid:setNotifyCbid doDelete:NO];
    } else {
        //NSMutableDictionary *characteristics = [self getCharacteristicsDict:characteristic];
        //[characteristicDict setValue:characteristics forKey:@"characteristic"];
        //[characteristicDict setValue:[NSNumber numberWithBool:YES] forKey:@"status"];
        //[self sendResultEventWithCallbackId:setNotifyCbid dataDict:characteristicDict errDict:nil doDelete:NO];
    }
}

//根据特征查找描述符
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    NSMutableDictionary *descriptorDict = [NSMutableDictionary dictionary];
    NSString *serviceUUID = characteristic.service.UUID.UUIDString;
    if (!serviceUUID) {
        [self callbackCodeInfo:NO withCode:-1 andCbid:discoverDescriptorsForCharacteristicCbid doDelete:YES];
        return;
    }
    NSString *characteristicUUID = characteristic.UUID.UUIDString;
    if (!characteristicUUID) {
        [self callbackCodeInfo:NO withCode:-1 andCbid:discoverDescriptorsForCharacteristicCbid doDelete:YES];
        return;
    }
    //[descriptorDict setValue:characteristicUUID forKey:@"characteristaicUUID"];
    //[descriptorDict setValue:serviceUUID forKey:@"serviceUUID"];
    if(error) {
        [self callbackCodeInfo:NO withCode:-1 andCbid:discoverDescriptorsForCharacteristicCbid doDelete:YES];
    } else {
        NSMutableArray *descriptors = [NSMutableArray array];
        for(CBDescriptor *descriptor in characteristic.descriptors) {
            [descriptors addObject:[self getDescriptorInfo:descriptor]];
        }
        [descriptorDict setValue:descriptors forKey:@"descriptors"];
        [descriptorDict setValue:[NSNumber numberWithBool:YES] forKey:@"status"];

        
//        [self sendResultEventWithCallbackId:discoverDescriptorsForCharacteristicCbid dataDict:descriptorDict errDict:nil doDelete:YES];
        NSString *str = [self DataTOjsonString:descriptorDict];
        self.DescriptorString(str);
    }
}

//查询指定服务的所有特征
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
    NSMutableDictionary *characteristicDict = [NSMutableDictionary dictionary];
    NSString *serviceUUID = service.UUID.UUIDString;
    if (!serviceUUID) {
        [self callbackCodeInfo:NO withCode:-1 andCbid:discoverCharacteristicsCbid doDelete:YES];
        return;
    }
    //[serviceDict setValue:serviceUUID forKey:@"uuid"];
    if(error) {
        [self callbackCodeInfo:NO withCode:-1 andCbid:discoverCharacteristicsCbid doDelete:YES];
    } else {
        NSMutableArray *characteristics = [self getAllCharacteristicsInfoAry:service.characteristics];
        [characteristicDict setValue:characteristics forKey:@"characteristics"];
        [characteristicDict setValue:[NSNumber numberWithBool:YES] forKey:@"status"];
//        [self sendResultEventWithCallbackId:discoverCharacteristicsCbid dataDict:characteristicDict errDict:nil doDelete:YES];
        NSString *str = [self DataTOjsonString:characteristics];
        self.CharacteristicString(str);
    }
}

//查询指定设备的所有服务
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    if(!peripheral.identifier) {
        return;
    }
    if (!error) {
        NSMutableArray *services = [self getAllServiceInfoAry:peripheral.services];
        NSMutableDictionary *sendDict = [NSMutableDictionary dictionary];
        [sendDict setObject:services forKey:@"services"];
        [sendDict setObject:[NSNumber numberWithBool:YES] forKey:@"status"];
//        [self sendResultEventWithCallbackId:discoverServiceCbid dataDict:sendDict errDict:nil doDelete:YES];
        NSString *sendServices = [self DataTOjsonString:sendDict];
        self.complateString(sendServices);
    } else {
        [self callbackCodeInfo:NO withCode:-1 andCbid:discoverServiceCbid doDelete:YES];
    }
}

#pragma mark - CBCentralManagerDelegate -

//初始化中心设备管理器时返回其状态
- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    [self initManagerCallback:central.state];
}

//app状态的保存或者恢复，这是第一个被调用的方法当APP进入后台去完成一些蓝牙有关的工作设置，使用这个方法同步app状态通过蓝牙系统
- (void)centralManager:(CBCentralManager *)central willRestoreState:(NSDictionary*)dict {
    
}

//扫描设备的回调，大概每秒十次的频率在重复回调
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary*)advertisementData RSSI:(NSNumber *)RSSI {
    if (!peripheral.identifier) {
        return;
    }
    NSString *periphoeralUUID = peripheral.identifier.UUIDString;
    if (![periphoeralUUID isKindOfClass:[NSString class]] || periphoeralUUID.length<=0) {
        return;
    }
    if([[_allPeripheral allValues] containsObject:peripheral]) {//更新旧设备的信号强度值
        NSMutableDictionary *targetPerInfo = [_allPeripheralInfo objectForKey:periphoeralUUID];
        if (targetPerInfo) {
            [targetPerInfo setObject:RSSI forKey:@"rssi"];
        }
    } else {//发现新设备
        [_allPeripheral setObject:peripheral forKey:periphoeralUUID];
        NSMutableDictionary *peripheralInfo = [self getAllPeriphoerDict:peripheral];
        [_allPeripheralInfo setObject:peripheralInfo forKey:periphoeralUUID];
    }
}

//连接外围设备成功后的回调
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    [self callbackCodeInfo:YES withCode:0 andCbid:connectCbid doDelete:NO];
}

//连接外围设备失败后的回调
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error {
    [self callbackCodeInfo:NO withCode:-1 andCbid:connectCbid doDelete:NO];
}

//断开通过uuid指定的外围设备的连接
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error {
    if (disconnectClick) {
        disconnectClick = NO;
        if (error) {
            [self callbackToJs:NO withID:disconnectCbid];
        } else {
            [self callbackToJs:YES withID:disconnectCbid];
        }
    } else {
        [self callbackCodeInfo:NO withCode:-1 andCbid:connectCbid doDelete:NO];
    }
}

#pragma mark - Utilities -
//初始化蓝牙管理器回调
- (void)initManagerCallback:(CBCentralManagerState)managerState {
    NSString *state = nil;
    switch (managerState) {
        case CBCentralManagerStatePoweredOff://设备关闭状态
            state = @"poweredOff";
            break;
            
        case CBCentralManagerStatePoweredOn:// 设备开启状态 -- 可用状态
            state = @"poweredOn";
            break;
            
        case CBCentralManagerStateResetting://正在重置状态
            state = @"resetting";
            break;
            
        case CBCentralManagerStateUnauthorized:// 设备未授权状态
            state = @"unauthorized";
            break;
            
        case CBCentralManagerStateUnknown:// 初始的时候是未知的（刚刚创建的时候）
            state = @"unknown";
            break;
            
        case CBCentralManagerStateUnsupported://设备不支持的状态
            state = @"unsupported";
            break;
            
        default:
            state = @"unknown";
            break;
    }
    
    if (initCbid >= 0) {
//        [self sendResultEventWithCallbackId:initCbid dataDict:[NSDictionary dictionaryWithObject:state forKey:@"state"] errDict:nil doDelete:NO];
    }
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:state,@"state", nil];
    state = [self DataTOjsonString:dic];
    self.StateString(state);
}
//获取所有设备所有信息
- (NSMutableArray *)getAllPeriphoeralInfoAry:(NSArray *)peripherals {
    NSMutableArray *allRetrivedPeripheral = [NSMutableArray array];
    for (CBPeripheral *targetPer in peripherals) {
        NSMutableDictionary *peripheralInfo = [self getAllPeriphoerDict:targetPer];
        if (peripheralInfo && peripheralInfo.count>0) {
            [allRetrivedPeripheral addObject:peripheralInfo];
        }
    }
    return allRetrivedPeripheral;
}
//获取指定设备所有信息
- (NSMutableDictionary *)getAllPeriphoerDict:(CBPeripheral *)singlePeripheral {
    NSMutableDictionary *peripheralInfo = [NSMutableDictionary dictionary];
    NSString *periphoeralUUID = singlePeripheral.identifier.UUIDString;
    if (!periphoeralUUID) {
        return peripheralInfo;
    }
    [peripheralInfo setValue:periphoeralUUID forKey:@"uuid"];
    NSString *periphoeralName = singlePeripheral.name;
    if ([periphoeralName isKindOfClass:[NSString class]] && periphoeralName.length>0) {
        [peripheralInfo setValue:periphoeralName forKey:@"name"];
    }
    NSNumber *RSSI = singlePeripheral.RSSI;
    if (RSSI) {
        [peripheralInfo setValue:RSSI forKey:@"rssi"];
    }
    NSMutableArray *allServiceUid = [self getAllServiceInfoAry:singlePeripheral.services];
    if (allServiceUid.count > 0) {
        [peripheralInfo setObject:allServiceUid forKey:@"services"];
    }
    return peripheralInfo;
}
//收集指定设备的所有服务（service）
- (NSMutableArray *)getAllServiceInfoAry:(NSArray *)serviceAry {
    NSMutableArray *allServiceUid = [NSMutableArray array];
    for (CBService *targetService in serviceAry) {
        NSString *serviceUUID = targetService.UUID.UUIDString;
        if ([serviceUUID isKindOfClass:[NSString class]] && serviceUUID.length>0) {
            [allServiceUid addObject:serviceUUID];
        }
    }
    return allServiceUid;
}
//收集指定服务的所有特征（Characteristics）
- (NSMutableArray *)getAllCharacteristicsInfoAry:(NSArray *)characteristicsAry {
    NSMutableArray *allCharacteristics = [NSMutableArray array];
    for (CBCharacteristic *characteristic in characteristicsAry) {
        NSMutableDictionary *characterInfo = [self getCharacteristicsDict:characteristic];
        [allCharacteristics addObject:characterInfo];
    }
    return allCharacteristics;
}
//收集指定特征的所有数据
- (NSMutableDictionary *)getCharacteristicsDict:(CBCharacteristic *)characteristic {
    NSMutableDictionary *characteristicDict = [NSMutableDictionary dictionary];
    NSString *characterUUID = characteristic.UUID.UUIDString;
    if (!characterUUID) {
        return characteristicDict;
    }
    NSString *charactProperti = @"broadcast";
    switch (characteristic.properties) {
        case CBCharacteristicPropertyBroadcast:
            charactProperti = @"broadcast";
            break;
            
        case CBCharacteristicPropertyRead:
            charactProperti = @"read";
            break;
            
        case CBCharacteristicPropertyWriteWithoutResponse:
            charactProperti = @"writeWithoutResponse";
            break;
            
        case CBCharacteristicPropertyWrite:
            charactProperti = @"write";
            break;
            
        case CBCharacteristicPropertyNotify:
            charactProperti = @"notify";
            break;
            
        case CBCharacteristicPropertyIndicate:
            charactProperti = @"indicate";
            break;
            
        case CBCharacteristicPropertyAuthenticatedSignedWrites:
            charactProperti = @"authenticatedSignedWrites";
            break;
            
        case CBCharacteristicPropertyExtendedProperties:
            charactProperti = @"extendedProperties";
            break;
            
        case CBCharacteristicPropertyNotifyEncryptionRequired:
            charactProperti = @"notifyEncryptionRequired";
            break;
            
        case CBCharacteristicPropertyIndicateEncryptionRequired:
            charactProperti = @"indicateEncryptionRequired";
            break;
            
        default:
            charactProperti = @"broadcast";
            break;
    }
    [characteristicDict setValue:charactProperti forKey:@"properties"];
    if([characteristic isKindOfClass:[CBMutableCharacteristic class]]) {
        CBMutableCharacteristic *mutableCharacteristic = (CBMutableCharacteristic *)characteristic;
        NSString *permission = @"readable";
        switch (mutableCharacteristic.permissions) {
            case CBAttributePermissionsReadable:
                permission = @"readable";
                break;
                
            case CBAttributePermissionsWriteable:
                permission = @"writeable";
                break;
                
            case CBAttributePermissionsReadEncryptionRequired:
                permission = @"readEncryptionRequired";
                break;
                
            case CBAttributePermissionsWriteEncryptionRequired:
                permission = @"writeEncryptionRequired";
                break;
                
            default:
                permission = @"readable";
                break;
        }
        [characteristicDict setValue:permission forKey:@"permissions"];
    }
    NSString *serviceuuid = characteristic.service.UUID.UUIDString;
    if ([serviceuuid isKindOfClass:[NSString class]] && serviceuuid.length>0) {
        [characteristicDict setValue:serviceuuid forKey:@"serviceUUID"];
    }
    [characteristicDict setValue:characterUUID forKey:@"uuid"];
    NSData *characterData = characteristic.value;
    if (characterData) {
        NSString *value = [self hexStringFromData:characterData];
        [characteristicDict setValue:value forKey:@"value"];
    }
    NSMutableArray *descriptorAry = [self getAllDescriptorInfo:characteristic.descriptors];
    if (descriptorAry.count > 0) {
        [characteristicDict setValue:descriptorAry forKey:@"descriptors"];
    }
    
    return characteristicDict;
}
//获取指定特征的所有描述信息
- (NSMutableArray *)getAllDescriptorInfo:(NSArray *)descripterAry {
    NSMutableArray *descriptorInfoAry = [NSMutableArray array];
    for(CBDescriptor *descriptor in descripterAry){
        [descriptorInfoAry addObject:[self getDescriptorInfo:descriptor]];
    }
    return descriptorInfoAry;
}
//获取指定描述的所有信息
- (NSMutableDictionary *)getDescriptorInfo:(CBDescriptor *)descriptor {
    NSMutableDictionary *descriptorDict = [NSMutableDictionary dictionary];
    NSString *descriptorUUID = descriptor.UUID.UUIDString;
    if (!descriptorUUID) {
        return descriptorDict;
    }
    [descriptorDict setValue:descriptorUUID forKey:@"uuid"];
    NSString *characterUUID = descriptor.characteristic.UUID.UUIDString;
    [descriptorDict setValue:characterUUID forKey:@"characteristicUUID"];
    NSString *serviceUUID = descriptor.characteristic.service.UUID.UUIDString;
    [descriptorDict setValue:serviceUUID forKey:@"serviceUUID"];
    
    NSString *valueStr;
    id value = descriptor.value;
    if([value isKindOfClass:[NSNumber class]]){
        valueStr = [value stringValue];
        [descriptorDict setValue:[NSNumber numberWithBool:NO] forKey:@"decode"];
    }
    if([value isKindOfClass:[NSString class]]){
        valueStr = (NSString *)value;
        [descriptorDict setValue:[NSNumber numberWithBool:NO] forKey:@"decode"];
    }
    if([value isKindOfClass:[NSData class]]){
        NSData *descripterData = (NSData *)value;
        valueStr = [descripterData base64EncodedStringWithOptions:0];;
        [descriptorDict setValue:[NSNumber numberWithBool:YES] forKey:@"decode"];
    }
    [descriptorDict setValue:valueStr forKey:@"value"];
    return descriptorDict;
}
//根据uuid查找服务（service）
- (CBService *)getServiceWithPeripheral:(CBPeripheral *)peripheral andUUID:(NSString *)uuid {
    if(!peripheral || peripheral.state!=CBPeripheralStateConnected) {
        return nil;
    }
    for (CBService *service in peripheral.services){
        NSString *serviceUUID = service.UUID.UUIDString;
        if (!serviceUUID) {
            return nil;
        }
        if([serviceUUID isEqual:uuid]){
            return service;
        }
    }
    return nil;
}
//根据服务查找特征
- (CBCharacteristic *)getCharacteristicInService:(CBService *)service withUUID:(NSString *)uuid {
    for(CBCharacteristic *characteristic in service.characteristics) {
        NSString *characterUUID = characteristic.UUID.UUIDString;
        if (!characterUUID) {
            return nil;
        }
        if([characterUUID isEqual:uuid]){
            return characteristic;
        }
    }
    return nil;
}
//根据特征查找描述符
- (CBDescriptor *)getDescriptorInCharacteristic:(CBCharacteristic *)characteristic withUUID:(NSString *)uuid {
    for(CBDescriptor *descriptor in characteristic.descriptors){
        NSString *descriptorUUID = characteristic.UUID.UUIDString;
        if (!descriptorUUID) {
            return nil;
        }
        if([descriptorUUID isEqual:uuid]){
            return descriptor;
        }
    }
    return nil;
}
//获取或生成设备的NSUUID数组
- (NSMutableArray *)creatPeripheralNSUUIDAry:(NSArray *)peripheralUUIDS {
    NSMutableArray *allPeriphralId = [NSMutableArray array];
    for(int i=0; i<[peripheralUUIDS count]; i++) {
        NSString *peripheralUUID = [peripheralUUIDS objectAtIndex:i];
        if ([peripheralUUID isKindOfClass:[NSString class]] && peripheralUUID.length>0) {
            NSUUID *perIdentifier;
            CBPeripheral *peripheralStored = [_allPeripheral objectForKey:peripheralUUID];
            if (peripheralStored) {
                perIdentifier = peripheralStored.identifier;
            } else {
                perIdentifier = [[NSUUID alloc]initWithUUIDString:peripheralUUID];
            }
            if (perIdentifier) {
                [allPeriphralId addObject:perIdentifier];
            }
        }
    }
    return allPeriphralId;
}
//生成设备的服务的CBUUID数组
- (NSMutableArray *)creatCBUUIDAry:(NSArray *)serviceUUIDs {

    if (serviceUUIDs.count == 0) {
        return nil;
    }
    NSMutableArray *allCBUUID = [NSMutableArray array];
    for(int i=0; i<[serviceUUIDs count]; i++) {
        NSString *serviceID = [serviceUUIDs objectAtIndex:i];
//        serviceUUIDs = 
        if ([serviceID isKindOfClass:[NSString class]] && serviceID.length>0) {
            [allCBUUID addObject:[CBUUID UUIDWithString:serviceID]];
        }
    }
    return allCBUUID;
}
//带code的回调
- (void)callbackCodeInfo:(BOOL)status withCode:(int)code andCbid:(NSInteger)backID doDelete:(BOOL)delete {
//    [self sendResultEventWithCallbackId:backID dataDict:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:status] forKey:@"status"] errDict:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:code] forKey:@"code"] doDelete:delete];
}
//回调状态
- (void)callbackToJs:(BOOL)status withID:(NSInteger)backID {
//    [self sendResultEventWithCallbackId:backID dataDict:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:status] forKey:@"status"] errDict:nil doDelete:YES];
}
//情况本地记录的所有设备信息
- (void)cleanStoredPeripheral {
    if (_allPeripheralInfo.count > 0) {
        [_allPeripheralInfo removeAllObjects];
        self.allPeripheralInfo = nil;
    }
    if (_allPeripheral.count > 0) {
        for (CBPeripheral *targetPer in [_allPeripheral allValues]) {
            targetPer.delegate = nil;
        }
        [_allPeripheral removeAllObjects];
        self.allPeripheral = nil;
    }
}

- (NSData *)replaceNoUtf8:(NSData *)data {
    char aa[] = {'A','A','A','A','A','A'};                      //utf8最多6个字符，当前方法未使用
    NSMutableData *md = [NSMutableData dataWithData:data];
    int loc = 0;
    while(loc < [md length])
    {
        char buffer;
        [md getBytes:&buffer range:NSMakeRange(loc, 1)];
        if((buffer & 0x80) == 0)
        {
            loc++;
            continue;
        }
        else if((buffer & 0xE0) == 0xC0)
        {
            loc++;
            [md getBytes:&buffer range:NSMakeRange(loc, 1)];
            if((buffer & 0xC0) == 0x80)
            {
                loc++;
                continue;
            }
            loc--;
            //非法字符，将这个字符（一个byte）替换为A
            [md replaceBytesInRange:NSMakeRange(loc, 1) withBytes:aa length:1];
            loc++;
            continue;
        }
        else if((buffer & 0xF0) == 0xE0)
        {
            loc++;
            [md getBytes:&buffer range:NSMakeRange(loc, 1)];
            if((buffer & 0xC0) == 0x80)
            {
                loc++;
                [md getBytes:&buffer range:NSMakeRange(loc, 1)];
                if((buffer & 0xC0) == 0x80)
                {
                    loc++;
                    continue;
                }
                loc--;
            }
            loc--;
            //非法字符，将这个字符（一个byte）替换为A
            [md replaceBytesInRange:NSMakeRange(loc, 1) withBytes:aa length:1];
            loc++;
            continue;
        }
        else
        {
            //非法字符，将这个字符（一个byte）替换为A
            [md replaceBytesInRange:NSMakeRange(loc, 1) withBytes:aa length:1];
            loc++;
            continue;
        }
    }
    
    return md;
}
- (NSString *)hexStringFromData:(NSData *)data {
    return [[[[NSString stringWithFormat:@"%@",data]
              stringByReplacingOccurrencesOfString: @"<" withString: @""]
             stringByReplacingOccurrencesOfString: @">" withString: @""]
            stringByReplacingOccurrencesOfString: @" " withString: @""];
}

- (NSData*)dataFormHexString:(NSString *)hexString {
    hexString=[[hexString uppercaseString] stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (!(hexString && [hexString length] > 0 && [hexString length]%2 == 0)) {
        return nil;
    }
    Byte tempbyt[1]={0};
    NSMutableData* bytes=[NSMutableData data];
    for(int i=0;i<[hexString length];i++)
    {
        unichar hex_char1 = [hexString characterAtIndex:i]; ////两位16进制数中的第一位(高位*16)
        int int_ch1;
        if(hex_char1 >= '0' && hex_char1 <='9')
            int_ch1 = (hex_char1-48)*16;   //// 0 的Ascll - 48
        else if(hex_char1 >= 'A' && hex_char1 <='F')
            int_ch1 = (hex_char1-55)*16; //// A 的Ascll - 65
        else
            return nil;
        i++;
        
        unichar hex_char2 = [hexString characterAtIndex:i]; ///两位16进制数中的第二位(低位)
        int int_ch2;
        if(hex_char2 >= '0' && hex_char2 <='9')
            int_ch2 = (hex_char2-48); //// 0 的Ascll - 48
        else if(hex_char2 >= 'A' && hex_char2 <='F')
            int_ch2 = hex_char2-55; //// A 的Ascll - 65
        else
            return nil;
        
        tempbyt[0] = int_ch1+int_ch2;  ///将转化后的数放入Byte数组里
        [bytes appendBytes:tempbyt length:1];
    }
    return bytes;
}
-(NSString *)JSONString:(NSString *)aString {
    NSMutableString *s = [NSMutableString stringWithString:aString];
    [s replaceOccurrencesOfString:@"\"" withString:@"\\\"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    [s replaceOccurrencesOfString:@"/" withString:@"\\/" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    [s replaceOccurrencesOfString:@"\n" withString:@"\\n" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    [s replaceOccurrencesOfString:@"\b" withString:@"\\b" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    [s replaceOccurrencesOfString:@"\f" withString:@"\\f" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    [s replaceOccurrencesOfString:@"\r" withString:@"\\r" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    [s replaceOccurrencesOfString:@"\t" withString:@"\\t" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    return [[NSString stringWithString:s] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];;
}
@end

