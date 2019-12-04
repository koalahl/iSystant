//
//  HLDeviceInformation.m
//  SystemMonitor
//
//  Created by HanLiu on 2018/10/21.
//  Copyright © 2018 HanLiu. All rights reserved.
//

#import "HLDeviceInformation.h"
#import "sys/utsname.h"
#import <ifaddrs.h>
#import <arpa/inet.h>
#import <mach/mach.h>
#import <sys/sysctl.h>
#include <sys/param.h>
#include <sys/mount.h>
#include <net/if.h>

#import "HLCPUMonitor.h"
#import "HLMemoryMonitor.h"
#import "HLNetworkMonitor.h"

#define MIB_SIZE 2

@implementation HLDeviceInformation
    
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static HLDeviceInformation *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[HLDeviceInformation alloc] init];
    });
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        [self getSystemUpTime];
    }
    return self;
}
#pragma mark - 硬件信息
/// 获取iPhone名称：Levi's iphone
+ (NSString *)getiPhoneName {
    return [UIDevice currentDevice].name;
}

/// 当前系统名称： iOS
+ (NSString *)getSystemName {
    return [UIDevice currentDevice].systemName;
}

/// 当前系统版本号： 12.1
+ (NSString *)getSystemVersion {
    [self getSystemBuildVersion];
    return [UIDevice currentDevice].systemVersion;//12.1
}
+ (NSString *)getSystemBuildVersion {
    NSString *versionStr = [[NSProcessInfo processInfo] operatingSystemVersionString];//Version 12.1 (Build 16B5084a)
    NSArray *tempArr = [versionStr componentsSeparatedByString:@" "];
    if (tempArr.count >2) {
        NSString *tempStr = [tempArr objectAtIndex:3];
        NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"()"];
        NSString *build = [tempStr stringByTrimmingCharactersInSet:set];
        return build;
    }
    
    return @"";
}
/// 通用唯一识别码UUID
+ (NSString *)getUUID {
    return [[UIDevice currentDevice] identifierForVendor].UUIDString;
}
/// 屏幕宽度：375
+ (NSString *)getDeviceScreenWidth {
    return [NSString stringWithFormat:@"%.f pt",[UIScreen mainScreen].bounds.size.width] ;
}

/// 屏幕高度：667
+ (NSString *)getDeviceScreenHeight {
    return [NSString stringWithFormat:@"%.f pt",[UIScreen mainScreen].bounds.size.height] ;
}
/// 屏幕像素
+ (NSString *)getDevicePixels {
    CGFloat scale = [UIScreen mainScreen].scale;
    if ([[HLDeviceInformation getDeviceName] containsString:@"Plus"]) {
        return @"1080x1920";
    }
    return [NSString stringWithFormat:@"%.fx%.f",[UIScreen mainScreen].bounds.size.width *scale,[UIScreen mainScreen].bounds.size.height * scale];
}

/// 获取app版本号
+ (NSString *)getAPPVerion {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

+ (NSString *)getDeviceModel {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    return deviceString;
}

/// 获取设备类型：iPhone X
+ (NSString *)getDeviceName {
    
    // 需要#import "sys/utsname.h"
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,3"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPhone5,3"])    return @"iPhone 5c (GSM)";
    if ([deviceString isEqualToString:@"iPhone5,4"])    return @"iPhone 5c (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPhone6,1"])    return @"iPhone 5s (GSM)";
    if ([deviceString isEqualToString:@"iPhone6,2"])    return @"iPhone 5s (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([deviceString isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceString isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([deviceString isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    if ([deviceString isEqualToString:@"iPhone8,4"])    return @"iPhone SE";
    if ([deviceString isEqualToString:@"iPhone9,1"] ||[deviceString isEqualToString:@"iPhone9,3"])    return @"iPhone 7";
    if ([deviceString isEqualToString:@"iPhone9,4"] ||[deviceString isEqualToString:@"iPhone9,2"])    return @"iPhone 7 Plus";

    if ([deviceString isEqualToString:@"iPhone10,1"] || [deviceString isEqualToString:@"iPhone10,4"])    return @"iPhone 8";
    if ([deviceString isEqualToString:@"iPhone10,2"] || [deviceString isEqualToString:@"iPhone10,5"])    return @"iPhone 8 Plus";
    if ([deviceString isEqualToString:@"iPhone10,3"] || [deviceString isEqualToString:@"iPhone10,6"])    return @"iPhone X";
    
    if ([deviceString isEqualToString:@"iPhone11,8"])    return @"iPhone Xʀ";
    if ([deviceString isEqualToString:@"iPhone11,2"])    return @"iPhone Xs";
    if ([deviceString isEqualToString:@"iPhone11,6"] ||[deviceString isEqualToString:@"iPhone11,4"])    return @"iPhone Xs Max";
    if ([deviceString isEqualToString:@"iPhone12,1"])    return @"iPhone 11";
    if ([deviceString isEqualToString:@"iPhone12,3"])    return @"iPhone 11 Pro";
    if ([deviceString isEqualToString:@"iPhone12,5"])    return @"iPhone 11 Pro Max";

    if ([deviceString isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([deviceString isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([deviceString isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([deviceString isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([deviceString isEqualToString:@"iPod5,1"])      return @"iPod Touch (5 Gen)";
    
    if ([deviceString isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceString isEqualToString:@"iPad1,2"])      return @"iPad 3G";
    if ([deviceString isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,2"])      return @"iPad 2";
    if ([deviceString isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([deviceString isEqualToString:@"iPad2,4"])      return @"iPad 2";
    if ([deviceString isEqualToString:@"iPad2,5"])      return @"iPad Mini (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,6"])      return @"iPad Mini";
    if ([deviceString isEqualToString:@"iPad2,7"])      return @"iPad Mini (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
    if ([deviceString isEqualToString:@"iPad3,2"])      return @"iPad 3 (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPad3,3"])      return @"iPad 3";
    if ([deviceString isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([deviceString isEqualToString:@"iPad3,5"])      return @"iPad 4";
    if ([deviceString isEqualToString:@"iPad3,6"])      return @"iPad 4 (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPad4,1"])      return @"iPad Air (WiFi)";
    if ([deviceString isEqualToString:@"iPad4,2"])      return @"iPad Air (Cellular)";
    if ([deviceString isEqualToString:@"iPad4,4"])      return @"iPad Mini 2 (WiFi)";
    if ([deviceString isEqualToString:@"iPad4,5"])      return @"iPad Mini 2 (Cellular)";
    if ([deviceString isEqualToString:@"iPad4,6"])      return @"iPad Mini 2";
    if ([deviceString isEqualToString:@"iPad4,7"])      return @"iPad Mini 3";
    if ([deviceString isEqualToString:@"iPad4,8"])      return @"iPad Mini 3";
    if ([deviceString isEqualToString:@"iPad4,9"])      return @"iPad Mini 3";
    if ([deviceString isEqualToString:@"iPad5,1"])      return @"iPad Mini 4 (WiFi)";
    if ([deviceString isEqualToString:@"iPad5,2"])      return @"iPad Mini 4 (LTE)";
    if ([deviceString isEqualToString:@"iPad5,3"] ||[deviceString isEqualToString:@"iPad5,4"])      return @"iPad Air 2";
    if ([deviceString isEqualToString:@"iPad6,3"] || [deviceString isEqualToString:@"iPad6,4"])      return @"iPad Pro";
    if ([deviceString isEqualToString:@"iPad6,7"] || [deviceString isEqualToString:@"iPad6,8"])      return @"iPad Pro 12.9";
    if ([deviceString isEqualToString:@"iPad6,11"] || [deviceString isEqualToString:@"iPad6,12"])      return @"iPad 2017";
    
    if ([deviceString isEqualToString:@"iPad7,1"] || [deviceString isEqualToString:@"iPad7,2"])      return @"iPad Pro 2nd";
    if ([deviceString isEqualToString:@"iPad7,3"] || [deviceString isEqualToString:@"iPad7,4"])      return @"iPad Pro 10.5";
    if ([deviceString isEqualToString:@"iPad7,5"] || [deviceString isEqualToString:@"iPad7,6"])      return @"iPad 6th";

    if ([deviceString isEqualToString:@"iPad8,1"] || [deviceString isEqualToString:@"iPad8,2"] ||[deviceString isEqualToString:@"iPad8,3"] ||[deviceString isEqualToString:@"iPad8,4"])      return @"iPad Pro 3rd 11";
    if ([deviceString isEqualToString:@"iPad8,5"] || [deviceString isEqualToString:@"iPad8,6"] ||[deviceString isEqualToString:@"iPad8,7"]||[deviceString isEqualToString:@"iPad8,8"])      return @"iPad Pro 3rd 12.9";
    if ([deviceString isEqualToString:@"iPad11,1"] || [deviceString isEqualToString:@"iPad11,2"]) return @"iPad Mini 2019";
    if ([deviceString isEqualToString:@"iPad11,3"] || [deviceString isEqualToString:@"iPad11,4"]) return @"iPad Air 2019";

    if ([deviceString isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceString isEqualToString:@"x86_64"])       return [UIDevice currentDevice].name;// @"Simulator";
    
    return deviceString;
}

/// 获取系统运行时间
- (void)getSystemUpTime {
    int mib[MIB_SIZE];
    size_t size;
    struct timeval  boottime;
    
    mib[0] = CTL_KERN;
    mib[1] = KERN_BOOTTIME;
    size = sizeof(boottime);
    if (sysctl(mib, MIB_SIZE, &boottime, &size, NULL, 0) != -1)
    {
        // successful call
        NSDate* bootDate = [NSDate dateWithTimeIntervalSince1970:boottime.tv_sec];
        NSLog(@"bootDate = %@",bootDate);

        NSString * upTimeStr = @"";
        double uptime = ceil([[NSDate date] timeIntervalSinceDate:bootDate]);
        double hour = floor(uptime/ 3600) ;
        double min = ceil(uptime / 60 - hour * 60);
        NSUInteger day = 0;
        if (hour >= 24) {
            day = hour / 24;
            hour = hour - day * 24;
            upTimeStr = [NSString stringWithFormat:@"%ld %@ %0.f %@ %0.f %@",day,NSLocalizedString(@"day", nil), hour,NSLocalizedString(@"hour", nil), min,NSLocalizedString(@"min", nil)];
        }else {
            upTimeStr = [NSString stringWithFormat:@" %0.f %@ %0.f %@", hour,NSLocalizedString(@"hour", nil), min,NSLocalizedString(@"min", nil)];
        }
        self.upTime = upTimeStr;
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        self.bootTime = [dateFormatter stringFromDate:bootDate];
    }
    
}

+ (NSString *)getTimezone {
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    return zone.name;
}


#
#pragma mark - 磁盘信息

+ (NSDictionary *)getDeviceSize{
    long long maxspace = 1;
    long long freespace = 1;
    long long usedspace = 1;

    //NSString *freeSpace = @"";
    //总大小
    struct statfs buf1;
    if (statfs("/", &buf1) >= 0) {
        maxspace = (long long)buf1.f_bsize * buf1.f_blocks;
    }
    //可用大小
    if (@available(iOS 11.0,*)) {
        NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:NSTemporaryDirectory()];
        /*
        NSDictionary *total = [fileURL resourceValuesForKeys:@[NSURLVolumeTotalCapacityKey] error:nil];
        NSLog(@"总空间:%@",total[NSURLVolumeTotalCapacityKey]);
         */
        NSDictionary *results = [fileURL resourceValuesForKeys:@[NSURLVolumeAvailableCapacityForImportantUsageKey] error:nil];
        NSLog(@"剩余可用空间:%@",results[NSURLVolumeAvailableCapacityForImportantUsageKey]);
        freespace = [results[NSURLVolumeAvailableCapacityForImportantUsageKey] longLongValue];
        
        //freeSpace = [NSString stringWithFormat:@"%0.2fGB",(double)freespace/1000/1000/1000];
    }else {
        //ios 10 获取总存储空间代码
        NSArray *paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        struct statfs tStats;
        statfs([[paths lastObject] cStringUsingEncoding:NSUTF8StringEncoding], &tStats);
        
        long long totalSpace = (float)(tStats.f_blocks * tStats.f_bsize);
        NSLog(@"总空间%0.2lld",totalSpace);
        maxspace = totalSpace;
        
        //iOS10 获取剩余空间
        struct statfs buf;
        if(statfs("/var", &buf) >= 0){
            freespace = (long long)(buf.f_bsize * buf.f_bfree);
        }
        //freeSpace = [NSString stringWithFormat:@"%0.2fGB",(double)freespace/1024/1024/1024];
    }
    //已用空间
    usedspace = maxspace - freespace;
    float usedPercentage = (float)usedspace / maxspace;
    NSDictionary *sizeDic = @{@"totalSpace":[NSString stringWithFormat:@"%0.2fGB",(double)maxspace/1000/1000/1000],
                              @"usedSpace":[NSString stringWithFormat:@"%0.2fGB",(double)usedspace/1000/1000/1000],
                              @"freeSpace":[NSString stringWithFormat:@"%0.2fGB",(double)freespace/1000/1000/1000],
                              @"usedPercentage":[NSNumber numberWithFloat:usedPercentage]
                              };
    NSLog(@"%@",sizeDic);

    return sizeDic;
}

#pragma mark - 系统本地化
/// 获取当前语言
+ (NSString *)getDeviceLanguage {
    NSArray *languageArray = [NSLocale preferredLanguages];
    return [languageArray objectAtIndex:0];
}

#pragma mark -- Private
+ (NSString *)convertUnits:(long long)size
{
    double doublesize = [NSNumber numberWithLongLong:size].doubleValue;
    if (doublesize>1024*1024*1024){
        return [NSString stringWithFormat:@"%.1fGB",doublesize/1024/1024/1024];//大于1G，则转化成G单位的字符串
    }
    else if(doublesize<1024*1024*1024&&doublesize>=1024*1024)//大于1M，则转化成M单位的字符串
    {
        return [NSString stringWithFormat:@"%.1fMB",doublesize/1024/1024];
    }
    else if(doublesize>=1024&&doublesize<1024*1024) //不到1M,但是超过了1KB，则转化成KB单位
    {
        return [NSString stringWithFormat:@"%.1fKB",doublesize/1024];
    }
    else//剩下的都是小于1K的，则转化成B单位
    {
        return [NSString stringWithFormat:@"%.1fB",doublesize];
    }
}

@end
