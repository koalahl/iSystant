//
//  TodayViewController.m
//  sysmonitorTodayExt
//
//  Created by HanLiu on 2019/12/4.
//  Copyright © 2019 iSystant. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import <iSystantMonitorFramework/iSystantMonitorFramework.h>

@interface TodayViewController () <NCWidgetProviding>

@property (weak, nonatomic) IBOutlet UILabel *freeRAMLabel;
@property (weak, nonatomic) IBOutlet UILabel *usedRAMLabel;
@property (weak, nonatomic) IBOutlet UILabel *upNetSpeedLabel;
@property (weak, nonatomic) IBOutlet UILabel *downNetSpeedLabel;
@property (weak, nonatomic) IBOutlet UILabel *freeDiskLabel;
@property (weak, nonatomic) IBOutlet UILabel *UsedDiskLabel;

@property (nonatomic, strong) NSTimer *timerForMemory;
@property (nonatomic, strong) NSTimer *timerForSpeed;
@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIDevice currentDevice] setBatteryMonitoringEnabled:YES];
    [[HLSystemMonitor sharedMonitor] parseDeviceFile];
    [HLSystemMonitor startMonitorNetworkFlowWith:[HLSystemMonitor sharedMonitor].netowrkRefreshInterval];
    [HLSystemMonitor startMemoryMonitor:[HLSystemMonitor sharedMonitor].memoryRefreshInterval];

//    NSUserDefaults *group = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.hl1987.app.isystant-lite"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _timerForSpeed = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(refreshNetworkSpeed) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timerForSpeed forMode:NSRunLoopCommonModes];
    [_timerForSpeed fire];
    
    _timerForMemory = [NSTimer scheduledTimerWithTimeInterval:1.67 target:self selector:@selector(refresh) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timerForMemory forMode:NSRunLoopCommonModes];
    [_timerForMemory fire];
    
    [self configDiskInfo];
}

- (void)viewDidDisappear:(BOOL)animated {
    [_timerForSpeed invalidate];
    _timerForSpeed = nil;
    [_timerForMemory invalidate];
    _timerForMemory = nil;
    [HLSystemMonitor stopMonitor];
}

- (void)refresh {
    [self configMemory];
}

- (void)refreshNetworkSpeed {

    NSString *downloadSpeed = [HLNetworkMonitor network].downloadNetworkSpeed;
    NSString *uploadSpeed = [HLNetworkMonitor network].uploadNetworkSpeed;
    //通知主线程刷新
    dispatch_async(dispatch_get_main_queue(), ^{
            self.upNetSpeedLabel.text = uploadSpeed;
            self.downNetSpeedLabel.text = downloadSpeed;
    });

}

- (void)configMemory {
    NSString *usedmemory = [HLMemoryMonitor monitor].totalUsedMemory ;
    NSString *freememory = [HLMemoryMonitor monitor].freeMemory ;

    dispatch_async(dispatch_get_main_queue(), ^{
        self.freeRAMLabel.text = freememory;
        self.usedRAMLabel.text = usedmemory;
    });
}

/// 磁盘存储信息
- (void)configDiskInfo {
    NSDictionary *dic = [HLDeviceInformation getDeviceSize];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.freeDiskLabel.text = dic[@"freeSpace"];
        self.UsedDiskLabel.text = dic[@"usedSpace"];
    });

}


- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    completionHandler(NCUpdateResultNewData);
}

@end
