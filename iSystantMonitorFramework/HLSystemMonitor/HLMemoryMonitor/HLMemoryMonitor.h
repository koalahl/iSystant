//
//  HLMemoryMonitor.h
//  SystemMonitor
//
//  Created by HanLiu on 2018/10/23.
//  Copyright © 2018 HanLiu. All rights reserved.
//

#import <UIKit/UIkit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HLMemoryMonitor : NSObject

@property (nonatomic, assign) uint8_t refreshInterval;//刷新频率

/**
 系统总内存
 */
@property (nonatomic, strong) NSString *totalMemory;

/**
 系统已用内存
 */
@property (nonatomic, strong) NSString *totalUsedMemory;

/**
 系统可用内存
 */
@property (nonatomic, strong) NSString *totalAvaliableMemory;

/**
 联动内存
 */
@property (nonatomic, strong,getter=wiredMemory) NSString *wiredMemory;
/**
 活跃内存
 */
@property (nonatomic, strong,getter=activeMemory) NSString *activeMemory;
/**
 空闲内存
 */
@property (nonatomic, strong,getter=freeMemory) NSString *freeMemory;
/**
 不活跃内存
 */
@property (nonatomic, strong,getter=inactiveMemory) NSString *inactiveMemory;

/**
 App使用内存
 */
@property (nonatomic, strong) NSString *appMemoryUsage;


/**
 其他内存
 */
@property (nonatomic, assign) CGFloat otherMemory;

/**
 内存使用率
 */
@property (nonatomic, assign) Float64 memoryUsagePercentage;

+ (instancetype)monitor;

- (void)start:(NSTimeInterval)interval;

- (void)stop;

- (CGFloat )rawMemoryValue:(NSString *)value;

@end

NS_ASSUME_NONNULL_END
