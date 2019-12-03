//
//  HLCPUMonitor.h
//  SystemMonitor
//
//  Created by HanLiu on 2018/10/23.
//  Copyright © 2018 HanLiu. All rights reserved.
//

#import <Foundation/Foundation.h>

extern int freqTest(int cycles);

NS_ASSUME_NONNULL_BEGIN

@interface HLCPUMonitor : NSObject

@property (nonatomic, assign) NSTimeInterval refreshInterval;//刷新频率

/// CPU实时频率
@property (nonatomic, strong) NSString *realtimeCpuFreq;

/// 当前App的cpu使用率
@property (nonatomic, strong) NSString *appCPUUsage;
/// 系统CPU使用率
@property (nonatomic, copy) NSString *systemCPUUsage;
/// 用户态CPU使用率
@property (nonatomic, copy) NSString *userCPUUsage;
/// 空闲态CPU使用率
@property (nonatomic, copy) NSString *idleCPUUsage;
@property (nonatomic, copy) NSString *cpuMaxFrequency;
@property (nonatomic, copy) NSString *cpuMinFrequency;

/// CPU架构：iphone8->ARM64 V8
@property (nonatomic, copy) NSString *cpuSubtypeString;
/// CPU核数 ： 6核
@property (nonatomic, assign) NSUInteger cpuNumber;

+ (instancetype)monitor;

//- (void)start:(NSTimeInterval)interval;
//- (void)stop;
- (NSDecimalNumber *)rawCPUValue:(NSString *)value;
@end

NS_ASSUME_NONNULL_END
