//
//  HLCPUMonitor.m
//  SystemMonitor
//
//  Created by HanLiu on 2018/10/23.
//  Copyright © 2018 HanLiu. All rights reserved.
//

#import "HLCPUMonitor.h"
#import <mach/mach.h>
#import <mach-o/arch.h>
#import <sys/sysctl.h>

static double GetCPUFrequency(void)
{
    volatile NSTimeInterval times[500];

    int sum = 0;

//    for(int i = 0; i < 500; i++)
//    {
//        times[i] = [[NSProcessInfo processInfo] systemUptime];
//        sum += freqTest(10000);
//        times[i] = [[NSProcessInfo processInfo] systemUptime] - times[i];
//    }
//
    NSTimeInterval time = times[0];
//    for(int i = 1; i < 500; i++)
//    {
//        if(time > times[i])
//            time = times[i];
//    }
//
    double freq = 1300000.0 / time;
    //double freq = 16770000.0f;
    return freq;
}


@interface HLCPUMonitor ()

@property (nonatomic, assign)float rtUsage_cpu;
//@property (nonatomic, strong) NSTimer *timer;
@end
@implementation HLCPUMonitor
{
    float app_cpu;
    float user_cpu;
    float idle_cpu;
    float sys_cpu;
    //float rtUsage_cpu;
}

+ (instancetype)monitor {
    static dispatch_once_t onceToken;
    static HLCPUMonitor *monitor = nil;
    dispatch_once(&onceToken, ^{
        monitor = [[HLCPUMonitor alloc] init];
        monitor.refreshInterval = 5;// 默认5秒刷新频率
    });
    return monitor;
}

//- (void)start:(NSTimeInterval)interval{
//    _refreshInterval = interval;
//    _timer = [NSTimer scheduledTimerWithTimeInterval:_refreshInterval target:self selector:@selector(excuteAll) userInfo:nil repeats:YES];
//    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
//
//    [self excuteAll];
//}
//
//- (void)stop {
//    [_timer invalidate];
//    _timer = nil;
//}
//- (void)excuteAll {
//
//}
#pragma mark - Getter

// CPU核数
- (NSUInteger)cpuNumber {
    return [NSProcessInfo processInfo].activeProcessorCount;
}

- (NSString *)realtimeCpuFreq {
    return  [NSString stringWithFormat:@"%0.f MHZ", GetCPUFrequency()/1024/1024];
}

- (NSString *)appCPUUsage {
    return [NSString stringWithFormat:@"%0.f%%",[self cpu_usage]];
}

- (NSString *)systemCPUUsage {
    return [NSString stringWithFormat:@"%0.2f%%",MIN([self systemCpuUsage]+[self cpu_usage], 100.0f) ];
}

- (NSString *)userCPUUsage {
    return [NSString stringWithFormat:@"%0.2f%%",user_cpu];
}

- (NSString *)idleCPUUsage {
    return [NSString stringWithFormat:@"%0.2f%%",idle_cpu];
}

- (NSDecimalNumber *)rawCPUValue:(NSString *)value {
    if ([value containsString:@"%"]) {
        return [NSDecimalNumber decimalNumberWithString:[value stringByReplacingOccurrencesOfString:@"%" withString:@""]];
    }
    return [NSDecimalNumber decimalNumberWithString:value];
}

#pragma mark Private
- (void)getRealtimeCpuFreq {
    self.realtimeCpuFreq = [NSString stringWithFormat:@"%0.f MHZ", GetCPUFrequency()/1024/1024];
}

- (void)getCurrentAppCPUUsage {
    self.appCPUUsage = [NSString stringWithFormat:@"%0.f%%",[self cpu_usage]];
}

- (void)getSystemCPUUsage {
    self.systemCPUUsage = [NSString stringWithFormat:@"%0.2f%%",[self systemCpuUsage]+[self cpu_usage]];
}

- (void)getUserCPUUsage{
    self.userCPUUsage = [NSString stringWithFormat:@"%0.2f%%",user_cpu];
}

- (void)getIdleCPUUsage{

    self.idleCPUUsage = [NSString stringWithFormat:@"%0.2f%%",idle_cpu];
}

/*内核结构体
 typedef struct {
     const char *name;
     cpu_type_t cputype;
     cpu_subtype_t cpusubtype;
     enum NXByteOrder byteorder;
     const char *description;
 } NXArchInfo;
 */
- (NSString *)cpuName {

    return [NSString stringWithCString:NXGetLocalArchInfo()->name encoding:NSUTF8StringEncoding] ;
}
- (integer_t)cpuType {
    return (integer_t)NXGetLocalArchInfo()->cputype;
}

- (integer_t)cpuSubtype {
    return (integer_t)NXGetLocalArchInfo()->cpusubtype;
}

- (NSString *)p_stringFromCpuType:(NSInteger)cpuType {
    switch (cpuType) {
        case CPU_TYPE_VAX:          return @"VAX";
        case CPU_TYPE_MC680x0:      return @"MC680x0";
        case CPU_TYPE_X86:          return @"X86";
        case CPU_TYPE_X86_64:       return @"X86_64";
        case CPU_TYPE_MC98000:      return @"MC98000";
        case CPU_TYPE_HPPA:         return @"HPPA";
        case CPU_TYPE_ARM:          return @"ARM";
        case CPU_TYPE_ARM64:        return @"ARM64";
        case CPU_TYPE_MC88000:      return @"MC88000";
        case CPU_TYPE_SPARC:        return @"SPARC";
        case CPU_TYPE_I860:         return @"I860";
        case CPU_TYPE_POWERPC:      return @"POWERPC";
        case CPU_TYPE_POWERPC64:    return @"POWERPC64";
        default:                    return @"Unknown";
    }
}

- (NSString *)cpuSubtypeString {
    
//    const NXArchInfo *arch = NXGetAllArchInfos();
    //NSLog(@"cpu = %@ %d %d",[self cpuName],[self cpuType],[self cpuSubtype]);

    if (!_cpuSubtypeString) {
        _cpuSubtypeString = [[NSString stringWithUTF8String:NXGetLocalArchInfo()->description] uppercaseString];
    }
    return _cpuSubtypeString;
}

static inline Boolean WDTCanGetSysCtlBySpecifier(char* specifier, size_t *size) {
    if (!specifier || strlen(specifier) == 0 ||
        sysctlbyname(specifier, NULL, size, NULL, 0) == -1 || *size == -1) {
        return false;
    }
    return true;
}

static inline uint64_t WDTGetSysCtl64BySpecifier(char* specifier) {
    
    uint64_t val = 0;
    size_t size = sizeof(val);
    
    if (!WDTCanGetSysCtlBySpecifier(specifier, &size)) {
        return -1;
    }
    
    if (sysctlbyname(specifier, &val, &size, NULL, 0) == -1)
    {
        return -1;
    }
    
    return val;
}

+ (NSString *)cpuMaxFrequency {
    return [NSString stringWithFormat:@"%lluMHz",WDTGetSysCtl64BySpecifier("hw.cpufrequency_max")/1024/1024];
}

+ (NSString *)cpuMinFrequency {
    return [NSString stringWithFormat:@"%lluMHz",WDTGetSysCtl64BySpecifier("hw.cpufrequency_min")/1024/1024];
}

#pragma mark - Internal
- (float) cpu_usage
{
    kern_return_t kr;
    task_info_data_t tinfo;
    mach_msg_type_number_t task_info_count;
    
    task_info_count = TASK_INFO_MAX;
    kr = task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t)tinfo, &task_info_count);
    if (kr != KERN_SUCCESS) {
        return -1;
    }
    
    task_basic_info_t      basic_info;
    thread_array_t         thread_list;
    mach_msg_type_number_t thread_count;
    
    thread_info_data_t     thinfo;
    mach_msg_type_number_t thread_info_count;
    
    thread_basic_info_t basic_info_th;
    uint32_t stat_thread = 0; // Mach threads
    
    basic_info = (task_basic_info_t)tinfo;
    
    // get threads in the task
    kr = task_threads(mach_task_self(), &thread_list, &thread_count);
    if (kr != KERN_SUCCESS) {
        return -1;
    }
    if (thread_count > 0)
        stat_thread += thread_count;
    
    long tot_sec = 0;
    long tot_usec = 0;
    float tot_cpu = 0;
    int j;
    
    for (j = 0; j < thread_count; j++)
    {
        thread_info_count = THREAD_INFO_MAX;
        kr = thread_info(thread_list[j], THREAD_BASIC_INFO,
                         (thread_info_t)thinfo, &thread_info_count);
        if (kr != KERN_SUCCESS) {
            return -1;
        }
        
        basic_info_th = (thread_basic_info_t)thinfo;
        
        if (!(basic_info_th->flags & TH_FLAGS_IDLE)) {
            tot_sec = tot_sec + basic_info_th->user_time.seconds + basic_info_th->system_time.seconds;
            tot_usec = tot_usec + basic_info_th->user_time.microseconds + basic_info_th->system_time.microseconds;
            tot_cpu = tot_cpu + basic_info_th->cpu_usage / (float)TH_USAGE_SCALE * 100.0;
        }
        
    } // for each thread
    
    kr = vm_deallocate(mach_task_self(), (vm_offset_t)thread_list, thread_count * sizeof(thread_t));
    assert(kr == KERN_SUCCESS);
    
    app_cpu = tot_cpu;
    return tot_cpu;
}

- (float) systemCpuUsage {
    kern_return_t kr;
    mach_msg_type_number_t count;
    static host_cpu_load_info_data_t previous_info = {0, 0, 0, 0};
    host_cpu_load_info_data_t info;
    
    count = HOST_CPU_LOAD_INFO_COUNT;
    
    kr = host_statistics(mach_host_self(), HOST_CPU_LOAD_INFO, (host_info_t)&info, &count);
    if (kr != KERN_SUCCESS) {
        return -1;
    }
    
    natural_t user   = info.cpu_ticks[CPU_STATE_USER] - previous_info.cpu_ticks[CPU_STATE_USER];
    natural_t nice   = info.cpu_ticks[CPU_STATE_NICE] - previous_info.cpu_ticks[CPU_STATE_NICE];
    natural_t system = info.cpu_ticks[CPU_STATE_SYSTEM] - previous_info.cpu_ticks[CPU_STATE_SYSTEM];
    natural_t idle   = info.cpu_ticks[CPU_STATE_IDLE] - previous_info.cpu_ticks[CPU_STATE_IDLE];
    natural_t total  = user + nice + system + idle;
    previous_info    = info;
    
    user_cpu = (user) * 100.0 / total;
    idle_cpu = idle * 100.0 / total;
    return (user + nice + system) * 100.0 / total;
}
@end
