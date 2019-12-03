//
//  HLSystemMonitor.m
//  HLSystemMonitor
//
//  Created by HanLiu on 2019/11/25.
//  Copyright © 2019 iSystant. All rights reserved.
//

#import "HLSystemMonitor.h"

@implementation HLSystemMonitor

+ (instancetype)sharedMonitor {
    static HLSystemMonitor *monitor = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        monitor = [[HLSystemMonitor alloc] init];
    });
    return monitor;
}

- (instancetype)init {
    if (self = [super init]) {
        self.cpuRefreshInterval = 3;
        self.memoryRefreshInterval = 3;
        self.netowrkRefreshInterval = 1;
        //注册通知
    }
    return self;
}

- (void)parseDeviceFile {
    NSString *deviceName = [HLDeviceInformation getDeviceName];
    //    deviceName = @"iPhone X";
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"devices" ofType:@"json"];
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"devices" ofType:@"json" inDirectory:@"/Frameworks/HLSystemMonitor.a"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSData *data = [NSData dataWithContentsOfFile:path];
        //放到framework里面，变成数组了？？？原来是字典呀
//        NSDictionary *devices = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *devices = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        if ([devices objectForKey:deviceName]) {
            [HLDeviceInformation sharedInstance].deviceDict = [devices objectForKey:deviceName];
            NSLog(@"%@",[devices objectForKey:deviceName]);
        }
        else if([deviceName containsString:@"iPad"]){
            [HLDeviceInformation sharedInstance].deviceDict = [devices objectForKey:@""];
        }
    }
    
}
#pragma mark - 网络信息
/// 开始监测网络流量
+ (void)startMonitorNetworkFlowWith:(NSTimeInterval)interval {
    [[HLNetworkMonitor network] start:interval];
}
#pragma mark - 内存信息
+ (void)startMemoryMonitor:(NSTimeInterval)interval {
    [[HLMemoryMonitor monitor] start:interval];
}

+ (void)stopMonitor {
    [[HLNetworkMonitor network] stop];
    [[HLMemoryMonitor monitor] stop];
}
@end
