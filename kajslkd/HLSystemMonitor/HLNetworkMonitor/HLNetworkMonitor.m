//
//  HLNetworkMonitor.m
//  SystemMonitor
//
//  Created by HanLiu on 2018/10/23.
//  Copyright © 2018 HanLiu. All rights reserved.
//

#import "HLNetworkMonitor.h"
#include <arpa/inet.h>
#include <ifaddrs.h>
#include <net/if.h>
#include <net/if_dl.h>
#import <sys/sysctl.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>

/// DNS
#import <resolv.h>

NSString* const GSDownloadNetworkSpeedNotificationKey = @"GSDownloadNetworkSpeedNotificationKey";
NSString* const GSUploadNetworkSpeedNotificationKey = @"GSUploadNetworkSpeedNotificationKey";

#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
//#define IOS_VPN       @"utun0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"

@interface HLNetworkMonitor ()<CLLocationManagerDelegate>

@property (nonatomic, strong) NSTimer* timer;
@property (nonatomic, strong) CTTelephonyNetworkInfo *info;
@property (nonatomic, strong) CLLocationManager *locationMagager;

@end
@implementation HLNetworkMonitor
{
    //总网速
    uint64_t _iBytes;
    uint64_t _oBytes;
    uint64_t _allFlow;
    //wifi网速
    uint64_t _wifiIBytes;
    uint64_t _wifiOBytes;
    uint64_t _wifiBytes;
    //3G网速
    uint64_t _wwanIBytes;
    uint64_t _wwanOBytes;
    uint64_t _wwanFlow;
    
    struct IF_DATA_TIMEVAL _lastDeviceBootTime_;
    NSTimeInterval _interval;
}

static HLNetworkMonitor* instance = nil;

+ (instancetype)network{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
        instance.info = [[CTTelephonyNetworkInfo alloc] init];
    });
    return instance;
}

- (instancetype)init{
    if (self = [super init]) {
        _iBytes = _oBytes = _allFlow = _wifiIBytes = _wifiOBytes = _wifiBytes = _wwanIBytes = _wwanOBytes = _wwanFlow = 0;
    }
    return self;
}

#pragma mark - 开始监听网速
- (void)start:(NSTimeInterval)interval{
    [self getNetworkBasicInfo];
    _interval = interval;
    if (_timer == nil) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:_interval target:self selector:@selector(checkNetworkSpeed) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
        [_timer fire];
    }
}
//停止监听网速
- (void)stop{
    if ([_timer isValid]) {
        [_timer invalidate];
        _timer = nil;
    }
}

#pragma mark - 网速相关
- (NSString *)getWIFIFlow {
    return [self stringWithbytes:_wifiBytes];
}
- (NSString *)getWIFIOutFlow {
    return [self stringWithbytes:_wifiOBytes];
}
- (NSString *)getWIFIInFlow {
    return [self stringWithbytes:_wifiIBytes];
}

- (NSString *)getDataFlow {
    return [self stringWithbytes:_wwanFlow];
}

- (NSString *)getDataOutFlow {
    return [self stringWithbytes:_wwanOBytes];
}
- (NSString *)getDataInFlow {
    return [self stringWithbytes:_wwanIBytes];
}

- (NSString *)uploadNetworkSpeed {
    return _uploadNetworkSpeed ?: @"";
}

- (NSString *)downloadNetworkSpeed {
    return _downloadNetworkSpeed ?: @"";
}

- (void)checkNetworkSpeed{
    struct ifaddrs *ifa_list = 0, *ifa;
    
    if (getifaddrs(&ifa_list) == -1) {return;}
    
    uint64_t iBytes = 0;
    uint64_t oBytes = 0;
    uint64_t allFlow = 0;
    uint64_t wifiIBytes = 0;
    uint64_t wifiOBytes = 0;
    uint64_t wifiFlow = 0;
    uint64_t wwanIBytes = 0;
    uint64_t wwanOBytes = 0;
    uint64_t wwanFlow = 0;
    
    for (ifa = ifa_list; ifa; ifa = ifa->ifa_next) {
        if (AF_LINK != ifa->ifa_addr->sa_family)
            continue;
        if (!(ifa->ifa_flags & IFF_UP) && !(ifa->ifa_flags & IFF_RUNNING))
            continue;
        if (ifa->ifa_data == 0)
            continue;
        // network
        if (strncmp(ifa->ifa_name, "lo", 2)) {
            struct if_data* if_data = (struct if_data*)ifa->ifa_data;
            
            iBytes += if_data->ifi_ibytes;
            
            oBytes += if_data->ifi_obytes;
            
            allFlow = iBytes + oBytes;
            
            _lastDeviceBootTime_ = if_data->ifi_lastchange;
        }
        
        //wifi
        if (!strcmp(ifa->ifa_name, "en0")) {
            struct if_data* if_data = (struct if_data*)ifa->ifa_data;
            
            _wifiIBytes = wifiIBytes += if_data->ifi_ibytes;
            
            _wifiOBytes = wifiOBytes += if_data->ifi_obytes;
            
            _wifiBytes = wifiFlow = wifiIBytes + wifiOBytes;
            
            //_lastDeviceBootTime_ = if_data->ifi_lastchange;

            //NSLog(@"WIFI流量-%0.2uMB,%0.2uMB,%0.2uMB",_wifiIBytes/1024/1024,_wifiOBytes/1024/1024,_wifiBytes/1024/1024);
        }
        
        //3G or gprs
        if (!strcmp(ifa->ifa_name, "pdp_ip0")) {
            struct if_data* if_data = (struct if_data*)ifa->ifa_data;
            
            _wwanIBytes =( wwanIBytes += if_data->ifi_ibytes);
            
            _wwanOBytes =( wwanOBytes += if_data->ifi_obytes);
            
            _wwanFlow =( wwanFlow = wwanIBytes + wwanOBytes);
            
            //_lastDeviceBootTime_ = if_data->ifi_lastchange;
            //NSLog(@"数据流量-%0.2uMB,%0.2uMB,%0.2uMB",wwanIBytes/1024/1024,wwanOBytes/1024/1024,wwanFlow/1024/1024);
        }
    }
    
    freeifaddrs(ifa_list);
    
    if (_iBytes != 0) {
        _downloadNetworkSpeed = [[self stringWithbytes:iBytes - _iBytes] stringByAppendingString:@"/s"];
    }
    
    _iBytes = iBytes;
    
    if (_oBytes != 0) {
        _uploadNetworkSpeed = [[self stringWithbytes:oBytes - _oBytes] stringByAppendingString:@"/s"];
    }
    
    _oBytes = oBytes;
    //NSLog(@"下行使用流量%0.2u MB,上行使用流量%0.2u MB",_iBytes/1024/1024,_oBytes/1024/1024);
}

- (NSString *)lastDeviceBootTime {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_lastDeviceBootTime_.tv_sec];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    return [dateFormatter stringFromDate:date];

}
#pragma mark - 获取网络基本信息
- (void)getNetworkBasicInfo{
    [self getWifiName];
    [self getWifiMACAddress];
    [self getPublicIPAddress];
    [self getIPAddress:YES];
    [self outPutDNSServers];
    
    if (![self.networkType isEqualToString:@"WIFI"]) {
        [self getNetWorkStates];
    }
}
//获取本机运营商名称

- (NSString *)carrierName {
    
    CTCarrier *carrier = [_info subscriberCellularProvider];
    
    //当前手机所属运营商名称
    
    NSString *mobile;
    
    //先判断有没有SIM卡，如果没有则不获取本机运营商
    
    if (!carrier.isoCountryCode) {
        
        NSLog(@"没有SIM卡");
        
        mobile = NSLocalizedString(@"No Carrier", nil);
        
    }else{
        
        mobile = [carrier carrierName];
        
        if ([mobile isEqualToString:@"中国联通"]) {
            mobile = NSLocalizedString(@"China Unicom", nil);
        }else if ([mobile isEqualToString:@"中国移动"]) {
            mobile = NSLocalizedString(@"China Mobile", nil);
        }else if ([mobile isEqualToString:@"中国电信"]) {
            mobile = NSLocalizedString(@"China Telecom", nil);
        }
        
    }
    return mobile;
}


/// 判断网络类型：2G/3G/4G/5G/WIFI
- (void)getNetWorkStates{
    
    NSString *state = @"";
    NSArray *typeStrings2G = @[CTRadioAccessTechnologyEdge,
                               CTRadioAccessTechnologyGPRS,
                               CTRadioAccessTechnologyCDMA1x];
    
    NSArray *typeStrings3G = @[CTRadioAccessTechnologyHSDPA,
                               CTRadioAccessTechnologyWCDMA,
                               CTRadioAccessTechnologyHSUPA,
                               CTRadioAccessTechnologyCDMAEVDORev0,
                               CTRadioAccessTechnologyCDMAEVDORevA,
                               CTRadioAccessTechnologyCDMAEVDORevB,
                               CTRadioAccessTechnologyeHRPD];
    
    NSArray *typeStrings4G = @[CTRadioAccessTechnologyLTE];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        CTTelephonyNetworkInfo *teleInfo= [[CTTelephonyNetworkInfo alloc] init];
        //获取当前无线接入网络类型
        NSString *accessString = teleInfo.currentRadioAccessTechnology;
        //teleInfo.serviceSubscriberCellularProviders;//可以获取MCC/MNC/是否支持VOIP
        if ([typeStrings4G containsObject:accessString]) {
            state = @"4G LTE";
        } else if ([typeStrings3G containsObject:accessString]) {
            state = @"3G";
        } else if ([typeStrings2G containsObject:accessString]) {
            state = @"2G";
        } else {
            state = @"Unknow";
        }
    }
    self.networkType = state;
}

#pragma mark - IP地址信息
- (void)getPublicIPAddress {
    NSError *error;
    NSURL *ipURL = [NSURL URLWithString:@"http://pv.sohu.com/cityjson?ie=utf-8"];
    NSMutableString *ip = [NSMutableString stringWithContentsOfURL:ipURL encoding:NSUTF8StringEncoding error:&error];
    NSDictionary *dict;
    if ([ip hasPrefix:@"var returnCitySN"]) {
        NSRange range = NSMakeRange(0, 19);
        [ip deleteCharactersInRange:range];
        NSString *nowIp = [ip substringToIndex:(ip.length - 1)];
        NSData *data = [nowIp dataUsingEncoding:NSUTF8StringEncoding];
        dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",dict);
        /*
         {
         cid = 440300;
         cip = "112.97.51.234";
         cname = "广东省深圳市";
         }
         */
    }
    self.publicIp = dict[@"cip"] ?: @"0.0.0.0";
    self.publicIpSourceAddress = dict[@"cname"] ?: NSLocalizedString(@"Unknow", nil);
    NSUserDefaults * group = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.redefine.iSystantPro"];
    if (dict[@"cip"]) {
        NSString *ip = dict[@"cip"];
        [group setValue:ip forKey:@"publicIp"];
        [group synchronize];
    }
   
}

//获取设备当前网络IP地址
- (void)getIPAddress:(BOOL)preferIPv4
{
    
    NSArray *searchArray = preferIPv4 ?
    @[ /*IOS_VPN @"/" IP_ADDR_IPv4, IOS_VPN @"/" IP_ADDR_IPv6,*/ IOS_WIFI @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6 ] :
    @[ /*IOS_VPN @"/" IP_ADDR_IPv6, IOS_VPN @"/" IP_ADDR_IPv4,*/ IOS_WIFI @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4 ] ;
    
    NSDictionary *addresses = [self getIPAddresses];
    //可以拿到当前设备的所有ip信息
    NSLog(@"addresses: %@", addresses);
    
    __block NSString *address;
    [searchArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop)
     {
         address = addresses[key];
         if(address) *stop = YES;
     } ];
    self.internalIp = address ? address : @"0.0.0.0";
}

- (NSString *)getWifiName {
    if (@available(iOS 13, *)) {
         
         if (CLLocationManager.authorizationStatus == kCLAuthorizationStatusAuthorizedWhenInUse) {//开启了权限，直接搜索
             
             return [self _getWIFIName];
             
         } else if (CLLocationManager.authorizationStatus == kCLAuthorizationStatusDenied) {//如果用户没给权限，则提示
             UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"定位权限关闭提示" message:@"你关闭了定位权限，导致无法使用WIFI功能" preferredStyle:UIAlertControllerStyleAlert];
             [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
             [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
             
         } else {//请求权限
             [self.locationMagager requestWhenInUseAuthorization];
         }
         
    }
    
    return [self _getWIFIName];

}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [self _getWIFIName];
    }
}

- (NSString *)_getWIFIName {
    NSString *wifiName = nil;
    wifiName = [[self getWifiInfo] objectForKey:(__bridge NSString *)kCNNetworkInfoKeySSID];
    if (wifiName) {
        self.networkType = @"WIFI";
    }
    self.wifiName = wifiName != nil ? wifiName : NSLocalizedString(@"noWIFI", nil) ;
    return wifiName;
}

- (NSString *)getWifiMACAddress {
    NSString *wifiMacName = @"0.0.0.0.0.0";
    wifiMacName = [[self getWifiInfo] objectForKey:(__bridge NSString *)kCNNetworkInfoKeyBSSID];
    self.wifiMacAddress = wifiMacName ? wifiMacName : @"0.0.0.0.0.0";
    return wifiMacName;
}

#pragma mark Private
//获取所有相关IP信息
- (NSDictionary *)getIPAddresses{
    NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];
    
    // retrieve the current interfaces - returns 0 on success
    struct ifaddrs *interfaces;
    if(!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        struct ifaddrs *interface;
        for(interface=interfaces; interface; interface=interface->ifa_next) {
            if(!(interface->ifa_flags & IFF_UP) /* || (interface->ifa_flags & IFF_LOOPBACK) */ ) {
                continue; // deeply nested code harder to read
            }
            const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
            char addrBuf[ MAX(INET_ADDRSTRLEN, INET6_ADDRSTRLEN) ];
            if(addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6)) {
                NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
                NSString *type;
                if(addr->sin_family == AF_INET) {
                    if(inet_ntop(AF_INET, &addr->sin_addr, addrBuf, INET_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv4;
                    }
                } else {
                    const struct sockaddr_in6 *addr6 = (const struct sockaddr_in6*)interface->ifa_addr;
                    if(inet_ntop(AF_INET6, &addr6->sin6_addr, addrBuf, INET6_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv6;
                    }
                }
                if(type) {
                    NSString *key = [NSString stringWithFormat:@"%@/%@", name, type];
                    addresses[key] = [NSString stringWithUTF8String:addrBuf];
                }
            }
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    return [addresses count] ? addresses : nil;
}

/// 获取本机DNS服务器
- (void)outPutDNSServers
{
    res_state res = malloc(sizeof(struct __res_state));
    
    int result = res_ninit(res);
    
    NSMutableArray *dnsArray = @[].mutableCopy;
    
    if ( result == 0 )
    {
        for ( int i = 0; i < res->nscount; i++ )
        {
            NSString *s = [NSString stringWithUTF8String :  inet_ntoa(res->nsaddr_list[i].sin_addr)];
            
            [dnsArray addObject:s];
        }
    }
    else{
        NSLog(@"%@",@" res_init result != 0");
    }
    
    res_nclose(res);
    NSString *dnsStr = @"0.0.0.0";
    for (NSString *str in dnsArray) {
        if (![str isEqualToString:@"0.0.0.0"]) {
            dnsStr = str;
        }
    }
    self.dns = dnsStr;
}

- (NSDictionary *)getWifiInfo{
    CFArrayRef wifiInterfaces = CNCopySupportedInterfaces();
    if (!wifiInterfaces) {
        return nil;
    }

    NSDictionary *networkInfo = (__bridge NSDictionary *)CNCopyCurrentNetworkInfo(CFArrayGetValueAtIndex(wifiInterfaces, 0));
    
    if (networkInfo) {
        NSLog(@"WIFI信息%@",networkInfo);
        CFRelease(wifiInterfaces);
        return networkInfo;
    }
    CFRelease(wifiInterfaces);
    return nil;
}

- (CLLocationManager *)locationMagager {
    if (!_locationMagager) {
        _locationMagager = [[CLLocationManager alloc] init];
        _locationMagager.delegate = self;
    }
    return _locationMagager;
}
#pragma mark - helper

- (NSString*)stringWithbytes:(long long)bytes{
    if (bytes < 1024) // B
    {
        return [NSString stringWithFormat:@"%lldB", bytes];
    }
    else if (bytes >= 1024 && bytes < 1024 * 1024) // KB
    {
        return [NSString stringWithFormat:@"%.2fKB", (double)bytes / 1024];
    }
    else if (bytes >= 1024 * 1024 && bytes < 1024 * 1024 * 1024) // MB
    {
        return [NSString stringWithFormat:@"%.2fMB", (double)bytes / (1024 * 1024)];
    }
    else // GB
    {
        return [NSString stringWithFormat:@"%.2fGB", (double)bytes / (1024 * 1024 * 1024)];
    }
}

@end
