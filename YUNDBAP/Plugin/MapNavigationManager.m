//
//  MapNavigationManager.m
//  MapNavigation
//
//  Created by apple on 16/2/14.
//  Copyright © 2016年 王琨. All rights reserved.
//

#import "MapNavigationManager.h"
#import <CoreLocation/CoreLocation.h>


typedef enum : NSUInteger {
    Apple = 0,
    Baidu,
    Google,
    Gaode,
    Tencent
} MapSelect;


static MapNavigationManager * MBManager = nil;

@interface MapNavigationManager ()<UIActionSheetDelegate,CLLocationManagerDelegate>
{
    NSMutableDictionary *naviInfo;
}
@property (strong, nonatomic) NSString * urlScheme;
@property (strong, nonatomic) NSString * appName;

@property (strong, nonatomic) NSString * start;
@property (strong, nonatomic) NSString * end;
@property (strong, nonatomic) NSString * city;

@property (assign, nonatomic) MapNavStyle style;

@property (assign, nonatomic) CLLocationCoordinate2D Coordinate2D;
@property (retain, nonatomic) CLLocationManager *locationManager;
@property (assign, nonatomic) CLLocationCoordinate2D zuobiao;
@end

@implementation MapNavigationManager


+ (MapNavigationManager *)shardMBManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        MBManager = [[MapNavigationManager alloc] init];
    });
    return MBManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        //!!! 需要自己改，方便弹回来
        
        self.urlScheme = @"NewcloudApp://";
        self.appName = @"NewCloudApp";
        self.locationManager = [[CLLocationManager alloc] init];
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0)
        {
            [self.locationManager requestAlwaysAuthorization];
        }
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManager.distanceFilter = kCLDistanceFilterNone;
    }
    return self;
}
+(MapNavigationManager *)sharedObject{
    static MapNavigationManager *shared = nil;
    static dispatch_once_t tonkent;
    dispatch_once(&tonkent, ^{
        shared = [[MapNavigationManager alloc]init];
    });
    
    return shared;
}
// 地理位置发生改变时触发
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    self.zuobiao = CLLocationCoordinate2DMake(newLocation.coordinate.latitude, newLocation.coordinate.longitude);
    NSLog(@"%f, %f", self.zuobiao.latitude, self.zuobiao.longitude);
    // 停止位置更新
    [manager stopUpdatingLocation];
}

// 定位失误时触发
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"定位失败:%@",error);
}

-(NSString *)returnNavigationInfo
{
/*
    NSString * appleMap  = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"http://maps.apple.com/"]] ? @"苹果地图" : nil;
    
    NSString * baiduMap  = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]] ? @"百度地图" : nil;
    NSString * gaodeMap  = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]] ? @"高德地图":nil;
    //不能用，需翻墙
    NSString * googleMap = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]] ? @"谷歌地图" :nil;
*/
    naviInfo = [[NSMutableDictionary alloc]init];
    BOOL isbaidu =[[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]] ;
    BOOL isgaode =[[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]];
    BOOL isgoole =[[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]];
    [self setNaviIsTure:isbaidu andMapInfo:@"bMap"];
    [self setNaviIsTure:isgaode andMapInfo:@"aMap"];
    [self setNaviIsTure:isgoole andMapInfo:@"gMap"];
//    NSString *baidu = [NSString stringWithFormat:@"%d",isbaidu];
//    NSString *gaode = [NSString stringWithFormat:@"%d",isgaode];
//    NSString *google = [NSString stringWithFormat:@"%d",isgoole];
//    NSString *res = [NSString stringWithFormat:@"百度地图:%d高德地图:%d谷歌地图:%d",isbaidu,isgaode,isgoole];
//    NSLog(@"----%@",res);
//    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:baidu,@"百度地图",gaode,@"高德地图",google,@"谷歌地图", nil];
//    NSDictionary *dict = @{@"百度地图":@"1"};
//    NSLog(@"--%@",dict);
//    NSString *res = [self DataTOjsonString:dict];
    NSString *res = [self DataTOjsonString:naviInfo];
    
    NSLog(@"---%@",res);
    return res;
}
-(void)setNaviIsTure:(BOOL)isTure andMapInfo:(NSString *)mapInfo
{
    if (isTure) {
        [naviInfo setValue:@"true" forKey:mapInfo];
    }else{
        [naviInfo setValue:@"false" forKey:mapInfo];
    }
}
-(NSString*)DataTOjsonString:(id)object
{
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}
-(void)openBaiduMap
{
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]]) {
        NSString *baiduAddressUrl = [[NSString stringWithFormat:@"baidumap://map"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        NSLog(@"%@",baiduAddressUrl);
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:baiduAddressUrl]];

    }else{
        
    }
    
}
-(void)openGaodeMap
{
    if ([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {
        NSString *gaodeAddressUrl = [[NSString stringWithFormat:@"iosamap://rootmap?sourceApplication=%@",self.appName] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:gaodeAddressUrl]];

    }else{
        
        
    }
}
-(void)openGoogleMap
{
    
    if ([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]]) {
        NSString *googleAddressUrl = [[NSString stringWithFormat:@"comgooglemaps://"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:googleAddressUrl]];
    }else
    {
        
    }


}
-(void)baiduMap:(NSArray *)path
{

    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]]) {
        NSString *baiduAddressUrl = [[NSString stringWithFormat:@"baidumap://map/direction?origin=%f,%f&destination=%f,%f&mode=driving&src=%@",[path[0] floatValue], [path[1] floatValue],[path[2] floatValue], [path[3] floatValue],self.appName] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        if ([path[2] floatValue] == 0 || [path[3] floatValue] == 0) {
            baiduAddressUrl =[[NSString stringWithFormat:@"baidumap://map/marker?location=%f,%f&title=%@&content=%@&src=%@",[path[0] floatValue], [path[1] floatValue],path[2], path[3],self.appName] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        }
        NSLog(@"%@",baiduAddressUrl);
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:baiduAddressUrl]];
        
    }else{
        UIAlertController *alercontroller = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"即将为您下载百度地图" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cacel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alercontroller addAction:cacel];
        UIAlertAction *submit = [UIAlertAction actionWithTitle:@"立即下载" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/%E7%99%BE%E5%BA%A6%E5%9C%B0%E5%9B%BE-%E6%99%BA%E8%83%BD%E7%9A%84%E6%89%8B%E6%9C%BA%E5%AF%BC%E8%88%AA-%E5%85%AC%E4%BA%A4%E5%9C%B0%E9%93%81%E5%87%BA%E8%A1%8C%E5%BF%85%E5%A4%87/id452186370?mt=8"]];
        }];
        [alercontroller addAction:submit];
        UIViewController *cuttentVc = [self getCurrentVC];
        [cuttentVc presentViewController:alercontroller animated:YES completion:^{
            
        }];
    }
}
-(void)iosMap:(NSArray *)path
{
//    CLLocationCoordinate2D _startCoordinate = CLLocationCoordinate2DMake([path[0] floatValue], [path[1] floatValue]);
//    CLLocationCoordinate2D _endCoor = CLLocationCoordinate2DMake([path[3] floatValue], [path[4] floatValue]);
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"http://maps.apple.com/"]]) {
        NSString *appleAddressUrl = [[NSString stringWithFormat:@"http://maps.apple.com/?saddr=%f,%f&daddr=%f,%f&dirflg=w",[path[0] floatValue], [path[1] floatValue],[path[2] floatValue], [path[3] floatValue]] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appleAddressUrl]];

    }else
    {
        
    }
}
-(void)gaodeDaohang:(NSArray *)path
{

    if ([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {
        //    CLLocationCoordinate2D _startCoordinate = CLLocationCoordinate2DMake([path[0] floatValue], [path[1] floatValue]);
        //    CLLocationCoordinate2D _endCoor = CLLocationCoordinate2DMake([path[3] floatValue], [path[4] floatValue]);
        NSString *urlString = [NSString stringWithFormat:@"iosamap://path?sourceApplication=%@&sid=BGVIS1&slat=%f&slon=%f&sname=%@&did=BGVIS2&dlat=%f&dlon=%f&dname=%@&dev=0&m=0&t=0",
                               self.appName,[path[0] floatValue],[path[1] floatValue],path[2],[path[3] floatValue],[path[4] floatValue],[path lastObject]];
        NSLog(@"网络请求 = %@", urlString);
        urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [NSURL URLWithString:urlString];
        [[UIApplication sharedApplication] openURL:url];

    }else{
        UIAlertController *alercontroller = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"即将为您下载高德地图" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cacel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alercontroller addAction:cacel];
        UIAlertAction *submit = [UIAlertAction actionWithTitle:@"立即下载" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/%E9%AB%98%E5%BE%B7%E5%9C%B0%E5%9B%BE-%E7%B2%BE%E5%87%86%E4%B8%93%E4%B8%9A%E7%9A%84%E6%89%8B%E6%9C%BA%E5%9C%B0%E5%9B%BE-%E8%87%AA%E9%A9%BE-%E5%85%AC%E4%BA%A4-%E9%AA%91%E8%A1%8C%E5%AF%BC%E8%88%AA/id461703208?mt=8"]];
        }];
        [alercontroller addAction:submit];
        UIViewController *cuttentVc = [self getCurrentVC];
        [cuttentVc presentViewController:alercontroller animated:YES completion:^{
            
        }];
    }
    /*iosamap://path?sourceApplication=applicationName&sid=BGVIS1&slat=39.92848272&slon=116.39560823&sname=A&did=BGVIS2&dlat=39.98848272&dlon=116.47560823&dname=B&dev=0&m=0&t=0
     参数说明：
     参数	说明	是否必填
     Path	服务类型	是
     sourceApplication	第三方调用应用名称。如applicationName	是
     sid	源ID	是
     slat	起点纬度，经纬度参数同时存在或同时为空，视为有效参数	否
     slon	起点经度，经纬度参数同时存在或同时为空，视为有效参数	否
     sname	起点名称（可为空）	否
     did	目的ID	是
     dlat	终点纬度，经纬度参数同时存在或同时为空，视为有效参数	否
     dlon	终点经度，经纬度参数同时存在或同时为空，视为有效参数	否
     dname	终点名称（可为空）	否
     dev	起终点是否偏移。0:lat和lon是已经加密后的,不需要国测加密;1:需要国测加密，可为空，但起点或终点不为空时，不能为空	否
     m	驾车：0：速度最快，1：费用最少，2：距离最短，3：不走高速，4：躲避拥堵，5：不走高速且避免收费，6：不走高速且躲避拥堵，7：躲避收费和拥堵，8：不走高速躲避收费和拥堵 公交：0：最快捷，2：最少换乘，3：最少步行，5：不乘地铁 ，7：只坐地铁 ，8：时间短	是
     t	t = 0：驾车 =1：公交 =2：步行	是
     备注： 1. 起点经纬度参数不为空，则路线以此坐标发起路线规划 。 2. 起点经纬度参数为空，且起点名称不为空，则以此名称发起路线规划。 3. 起点经纬度参数为空，且起点名称为空，则以“我的位置”发起路线规划。 4. 终点经纬度参数不为空，则路线以此坐标发起路线规划 。 5. 终点经纬度参数为空，且终点名称不为空，则以此名称发起路线规划。 6. 终点经纬度参数为空，且终点点名称为空，则以“我的位置”发起路线规划。
     
     */

}
- (void)showSheet
{
    NSString * appleMap  = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"http://maps.apple.com/"]] ? @"苹果地图" : nil;
    
    NSString * baiduMap  = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]] ? @"百度地图" : nil;
    NSString * gaodeMap  = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]] ? @"高德地图":nil;
    //不能用，需翻墙
    NSString * googleMap = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]] ? @"谷歌地图" :nil;
    //暂时不支持
    NSString * tencentMap  = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"qqmap://map/"]] ? nil : nil;
    
    
    UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:@"请选择您已经安装的导航工具" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:gaodeMap otherButtonTitles:appleMap,baiduMap,googleMap,tencentMap,nil];
    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString * str = [actionSheet buttonTitleAtIndex:buttonIndex];
    //和枚举对应
    NSArray * mapArray = @[@"苹果地图",@"百度地图",@"谷歌地图",@"高德地图",@"腾讯地图"];
    NSUInteger i = 0 ;
    for (; i < mapArray.count; i ++) {
        if ([str isEqualToString:mapArray[i]]) {
            break;
        }
    }
    
    [self startNavigation:i];
}

- (void)startNavigation:(MapSelect)index
{
    NSString * urlString = [self getUrlStr:index];
    if (urlString != nil) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    }
    else if(_style == Coordinates)
    {
        MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
        MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:self.Coordinate2D addressDictionary:nil]];
        [MKMapItem openMapsWithItems:@[currentLocation, toLocation]
                       launchOptions:@{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,MKLaunchOptionsShowsTrafficKey: [NSNumber numberWithBool:YES]}];
    }
    
    
}

- (NSString *)getUrlStr:(MapSelect)index
{
    NSString * urlStr = nil;
    if (index == Apple && _style == Coordinates) {
        return urlStr;
    }
    switch (_style) {
        case Coordinates:
            urlStr = [self getUrlStrWithCoordinates:index];
            break;
        case Address:
            urlStr = [self getUrlStrWithAddress:index];
            break;
        default:
            break;
    }
    return urlStr;
}

- (NSString *)getUrlStrWithCoordinates:(MapSelect)index
{
    NSString * urlString = nil;
    MapNavigationManager * mb = [MapNavigationManager shardMBManager];

    NSString * baiduUrlStr = [[NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=latlng:%f,%f|name=目的地&mode=driving&coord_type=gcj02",mb.Coordinate2D.latitude, mb.Coordinate2D.longitude] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSString * goooleUrlStr = [[NSString stringWithFormat:@"comgooglemaps://?x-source=%@&x-success=%@&saddr=&daddr=%f,%f&directionsmode=driving",_appName,_urlScheme,mb.Coordinate2D.latitude, mb.Coordinate2D.longitude] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSString * gaodeUrlStr= [[NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=%@&lat=%f&lon=%f&dev=0&style=2",_appName,_urlScheme,mb.Coordinate2D.latitude, mb.Coordinate2D.longitude] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    switch (index) {

        case Baidu:
            urlString = baiduUrlStr;
            break;
        case Google:
            urlString = goooleUrlStr;
            break;
        case Gaode:
            urlString = gaodeUrlStr;
            break;

        default:
            break;
    }
    return urlString;
}

- (NSString *)getUrlStrWithAddress:(MapSelect)index
{
    NSString * urlString = nil;
    MapNavigationManager * mb = [MapNavigationManager shardMBManager];
    //地址系列
    //腾讯
    NSString * tencentAddressUrl = [[NSString stringWithFormat:@"qqmap://map/routeplan?type=walk&from=%@&to=%@&policy=1&referer=%@",mb.start, mb.end,_appName] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    //苹果
    NSString *appleAddressUrl = [[NSString stringWithFormat:@"http://maps.apple.com/?saddr=%@&daddr=%@&dirflg=w",_start, mb.end] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    //百度
    NSString *baiduAddressUrl = [[NSString stringWithFormat:@"baidumap://map/direction?origin=%@&destination=%@&mode=walking&region=%@&src=%@",mb.start, mb.end,_city,_appName] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    //高德
    NSString *gaodeAddressUrl = [[NSString stringWithFormat:@"iosamap://path?sourceApplication=%@&sid=BGVIS1&sname=%@&did=BGVIS2&dname=%@&dev=0&m=2&t=2",_appName,mb.start,mb.end] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    //谷歌
    NSString *googleAddressUrl = [[NSString stringWithFormat:@"comgooglemaps://?x-source=%@&x-success=%@&saddr=%@&daddr=%@&directionsmode=bicycling",_appName,_urlScheme,mb.start, mb.end] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    switch (index) {
        case Apple:
            urlString = appleAddressUrl;
            break;
        case Baidu:
            urlString = baiduAddressUrl;
            break;
        case Google:
            urlString = googleAddressUrl;
            break;
        case Gaode:
            urlString = gaodeAddressUrl;
            break;
        case Tencent:
            urlString = tencentAddressUrl;
            break;
        default:
            break;
    }
    
    return urlString;
}


+ (void)showSheetWithCity:(NSString *)city start:(NSString *)start end:(NSString *)end
{
    MapNavigationManager * mb = [self shardMBManager];
    mb.city = city;
    mb.start = start;
    mb.end = end;
    mb.style = Address;
    [mb showSheet];
    
}

+ (void)showSheetWithCoordinate2D:(CLLocationCoordinate2D)Coordinate2D
{
    MapNavigationManager * mb = [self shardMBManager];
    mb.style = Coordinates;
    mb.Coordinate2D = Coordinate2D;
    [mb showSheet];
    
}
-(UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    //app默认windowLevel是UIWindowLevelNormal，如果不是，找到UIWindowLevelNormal的
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    id  nextResponder = nil;
    UIViewController *appRootVC=window.rootViewController;
    //    如果是present上来的appRootVC.presentedViewController 不为nil
    if (appRootVC.presentedViewController) {
        nextResponder = appRootVC.presentedViewController;
    }else{
        
        NSLog(@"===%@",[window subviews]);
        UIView *frontView = [[window subviews] objectAtIndex:0];
        nextResponder = [frontView nextResponder];
    }
    
    if ([nextResponder isKindOfClass:[UITabBarController class]]){
        UITabBarController * tabbar = (UITabBarController *)nextResponder;
        UINavigationController * nav = (UINavigationController *)tabbar.viewControllers[tabbar.selectedIndex];
        //        UINavigationController * nav = tabbar.selectedViewController ; 上下两种写法都行
        result=nav.childViewControllers.lastObject;
        
    }else if ([nextResponder isKindOfClass:[UINavigationController class]]){
        UIViewController * nav = (UIViewController *)nextResponder;
        result = nav.childViewControllers.lastObject;
    }else{
        result = nextResponder;
    }
    return result;
}
@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com
