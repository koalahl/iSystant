//
//  HLMemoryMonitor.m
//  SystemMonitor
//
//  Created by HanLiu on 2018/10/23.
//  Copyright © 2018 HanLiu. All rights reserved.
//

#import "HLMemoryMonitor.h"
#import <mach/mach.h>

@implementation HLMemoryMonitor
{
    long long _totalMemory_;
    long long _availableMemory_;
    long long _usedMemory_;
    long long _freeMemory_;
    long long _wiredMemory_;
    long long _activeMemory_;
    long long _inactiveMemory_;
    long long _appMemoryUsage_;
    NSTimer  *_timer;
    NSTimeInterval _interval;

}
+ (instancetype)monitor {
    static dispatch_once_t onceToken;
    static HLMemoryMonitor *monitor = nil;
    dispatch_once(&onceToken, ^{
        monitor = [[HLMemoryMonitor alloc] init];
        monitor.refreshInterval = 5;// 默认5秒刷新频率
    });
    return monitor;
}

- (void)start:(NSTimeInterval)interval{
    [self getTotalMemorySize];
    
    [self needToRefresh];
    _interval = interval;
    if (_timer == nil) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:_interval target:self selector:@selector(needToRefresh) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
        [_timer fire];
    }
}
- (void)stop{
    if ([_timer isValid]) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)needToRefresh {
    [self getAvailableMemorySize];
    [self getUsedMemorySize];
    [self currentAppMemoryUsageSize];
    [self getMemoryUsagePercentage];
}

- (CGFloat )rawMemoryValue:(NSString *)value {
    if ([value containsString:@"GB"]) {
        return [[value stringByReplacingOccurrencesOfString:@"GB" withString:@""] floatValue]*1024;
    }
    return [[value stringByReplacingOccurrencesOfString:@"MB" withString:@""] floatValue];
}
#pragma mark - Public
/// 获取总内存大小
- (void)getTotalMemorySize {
    self.totalMemory = [self convertUnits:[self getTotalMemory]];
}

- (void)getAvailableMemorySize {
    self.totalAvaliableMemory = [self convertUnits:[self getAvailableMemory]];
}

- (void)getUsedMemorySize {
    self.totalUsedMemory = [self convertUnits:[self getUsedMemory]];
}

- (void)currentAppMemoryUsageSize {
    self.appMemoryUsage = [self convertUnits:[self currentAppMemoryUsage]];
}

- (void)getMemoryUsagePercentage {
    float a = [NSNumber numberWithLongLong:_usedMemory_].floatValue;
    uint64_t b = _totalMemory_;
    NSString *percentage = [NSString stringWithFormat:@"%0.3f",a/b];
    self.memoryUsagePercentage =  percentage.floatValue ;
}

- (NSString *)freeMemory {
    return [self convertUnits:_freeMemory_];
}
- (NSString *)inactiveMemory {
    return [self convertUnits:_inactiveMemory_];
}
- (NSString *)wiredMemory {
    return [self convertUnits:_wiredMemory_];
}
- (NSString *)activeMemory {
    return [self convertUnits:_activeMemory_];
}

- (CGFloat)otherMemory {
    return (_totalMemory_ - _freeMemory_ - _inactiveMemory_ - _wiredMemory_ - _activeMemory_ - _appMemoryUsage_)/1024/1024;
}
#pragma mark - Private
- (long long)getTotalMemory {
    _totalMemory_ = [NSProcessInfo processInfo].physicalMemory;
    return _totalMemory_;
}

/// 获取当前可用内存: free_count空闲内存+inactive_count非活跃内存
- (long long)getAvailableMemory {
    vm_statistics_data_t vmStats;
    mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
    kern_return_t kernReturn = host_statistics(mach_host_self(), HOST_VM_INFO, (host_info_t)&vmStats, &infoCount);
    if (kernReturn != KERN_SUCCESS)
    {
        return NSNotFound;
    }
    _freeMemory_ = vm_page_size * vmStats.free_count;
    _inactiveMemory_ = vm_page_size * vmStats.inactive_count;
    _availableMemory_ = _freeMemory_ + _inactiveMemory_;//MB
    return _availableMemory_/1024*1024;
}

/// 获取当前已用内存: wire_count绑定内存+active_count活跃内存
- (long long)getUsedMemory {
    vm_statistics_data_t vmStats;
    mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
    kern_return_t kernReturn = host_statistics(mach_host_self(), HOST_VM_INFO, (host_info_t)&vmStats, &infoCount);
    if (kernReturn != KERN_SUCCESS)
    {
        return NSNotFound;
    }
    _wiredMemory_ = vm_page_size * vmStats.wire_count;
    _activeMemory_ = vm_page_size * vmStats.active_count;
    _usedMemory_ = _wiredMemory_ + _activeMemory_;
    return _usedMemory_;
}

/// 计算当前应用占用的内存大小
- (int64_t)currentAppMemoryUsage {
//    struct mach_task_basic_info info;//有些用的是这个，后面可以测试一下结果
    int64_t memoryUsageInByte = 0;
    task_vm_info_data_t vmInfo;
    mach_msg_type_number_t count = TASK_VM_INFO_COUNT;
    kern_return_t kernelReturn = task_info(mach_task_self(), TASK_VM_INFO, (task_info_t) &vmInfo, &count);
    if(kernelReturn == KERN_SUCCESS) {
        memoryUsageInByte = (int64_t) vmInfo.phys_footprint;
        //NSLog(@"Memory in use (in bytes): %lld", memoryUsageInByte);
    } else {
        NSLog(@"Error with task_info(): %s", mach_error_string(kernelReturn));
    }
    _appMemoryUsage_ = memoryUsageInByte;
    return memoryUsageInByte;
}

- (NSString *)convertUnits:(long long)size
{
    double doublesize = [NSNumber numberWithLongLong:size].doubleValue;
    if (doublesize>1024*1024*1024){
        return [NSString stringWithFormat:@"%.2fGB",doublesize/1024/1024/1024];//大于1G，则转化成G单位的字符串
    }
    else if(doublesize<1024*1024*1024&&doublesize>=1024*1024)//大于1M，则转化成M单位的字符串
    {
        return [NSString stringWithFormat:@"%.2fMB",doublesize/1024/1024];
    }
    else if(doublesize>=1024&&doublesize<1024*1024) //不到1M,但是超过了1KB，则转化成KB单位
    {
        return [NSString stringWithFormat:@"%.2fKB",doublesize/1024];
    }
    else//剩下的都是小于1K的，则转化成B单位
    {
        return [NSString stringWithFormat:@"%.2fB",doublesize];
    }
}

@end
