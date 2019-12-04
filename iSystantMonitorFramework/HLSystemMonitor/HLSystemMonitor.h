//
//  HLSystemMonitor.h
//  HLSystemMonitor
//
//  Created by HanLiu on 2019/11/25.
//  Copyright © 2019 iSystant. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HLCPUMonitor.h"
#import "HLMemoryMonitor.h"
#import "HLNetworkMonitor.h"
#import "HLDeviceInformation.h"
#import "HLBatteryMonitor.h"

@interface HLSystemMonitor : NSObject
@property (nonatomic, assign) NSTimeInterval cpuRefreshInterval;

@property (nonatomic, assign) NSTimeInterval memoryRefreshInterval;

@property (nonatomic, assign) NSTimeInterval netowrkRefreshInterval;

+ (instancetype)sharedMonitor;

- (void)parseDeviceFile;
#pragma mark - 网络信息
/// 开始监测网络流量
+ (void)startMonitorNetworkFlowWith:(NSTimeInterval)interval;

#pragma mark - 内存信息
+ (void)startMemoryMonitor:(NSTimeInterval)interval;

+ (void)stopMonitor;
@end
