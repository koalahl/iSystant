//
//  HLBatteryMonitor.m
//  SystemMonitor
//
//  Created by HanLiu on 2018/10/24.
//  Copyright © 2018 HanLiu. All rights reserved.
//

#import "HLBatteryMonitor.h"
#import <objc/runtime.h>

@implementation HLBatteryMonitor

#pragma mark - 电池信息

/// 获取电池电量
+ (NSString *)getBatteryLevel {
    NSUserDefaults * group = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.redefine.iSystantPro"];
    [group setFloat:[UIDevice currentDevice].batteryLevel forKey:@"batteryLevel"];
    return [NSString stringWithFormat:@"%0.f %%", [UIDevice currentDevice].batteryLevel*100];
}

/// 获取电池当前的状态，共有4种状态
+ (NSString *) getBatteryState {
    UIDevice *device = [UIDevice currentDevice];
    if (device.batteryState == UIDeviceBatteryStateUnknown) {
        return NSLocalizedString(@"UnKnow", nil);
    } else if (device.batteryState == UIDeviceBatteryStateUnplugged){
        return NSLocalizedString(@"Unplugged", nil);
    } else if (device.batteryState == UIDeviceBatteryStateCharging){
        return NSLocalizedString(@"Charging", nil);
    } else if (device.batteryState == UIDeviceBatteryStateFull){
        return NSLocalizedString(@"Full", nil);
    }
    return nil;
}

/// 获取精准电池电量,通过获取statusBar上的电池视图的值...这种方式已经不能用于iPhone X等刘海屏，需要适配
//+ (float)getCurrentBatteryLevel {
//    UIApplication *app = [UIApplication sharedApplication];
//    if (app.applicationState == UIApplicationStateActive||app.applicationState==UIApplicationStateInactive) {
//        Ivar ivar=  class_getInstanceVariable([app class],"_statusBar");
//        id status  = object_getIvar(app, ivar);
//        for (id aview in [status subviews]) {
//            int batteryLevel = 0;
//            for (id bview in [aview subviews]) {
//                if ([NSStringFromClass([bview class]) caseInsensitiveCompare:@"UIStatusBarBatteryItemView"] == NSOrderedSame&&[[[UIDevice currentDevice] systemVersion] floatValue] >=6.0) {
//
//                    Ivar ivar=  class_getInstanceVariable([bview class],"_capacity");
//                    if(ivar) {
//                        batteryLevel = ((int (*)(id, Ivar))object_getIvar)(bview, ivar);
//                        if (batteryLevel > 0 && batteryLevel <= 100) {
//                            return batteryLevel;
//
//                        } else {
//                            return 0;
//                        }
//                    }
//                }
//            }
//        }
//    }
//
//    return 0;
//}

@end
