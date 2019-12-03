//
//  HLBatteryMonitor.h
//  SystemMonitor
//
//  Created by HanLiu on 2018/10/24.
//  Copyright © 2018 HanLiu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HLBatteryMonitor : NSObject

#pragma mark - 电池信息
/// 获取电池电量
+ (NSString *)getBatteryLevel;
/// 获取电池当前的状态，共有4种状态
+ (NSString *)getBatteryState;

@end

NS_ASSUME_NONNULL_END
