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

@property (weak, nonatomic) IBOutlet UILabel *deviceModelLabel;

@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIDevice currentDevice] setBatteryMonitoringEnabled:YES];
    [[HLSystemMonitor sharedMonitor] parseDeviceFile];
    
    NSString *deviceModel   = [HLDeviceInformation getDeviceName];
    self.deviceModelLabel.text = deviceModel;
    
    
    NSUserDefaults *group = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.hl1987.app.isystant-lite"];
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    completionHandler(NCUpdateResultNewData);
}

@end
