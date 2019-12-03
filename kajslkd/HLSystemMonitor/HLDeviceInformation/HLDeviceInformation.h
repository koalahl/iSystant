//
//  HLDeviceInformation.h
//  SystemMonitor
//
//  Created by HanLiu on 2018/10/21.
//  Copyright © 2018 HanLiu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HLNetworkMonitor.h"

NS_ASSUME_NONNULL_BEGIN

@interface HLDeviceInformation : NSObject

@property (nonatomic, strong) NSDictionary *deviceDict;

@property (nonatomic, strong) NSString *bootTime;//设备启动日期
@property (nonatomic, strong) NSString *upTime;//启动持续天数

+ (instancetype)sharedInstance;
#pragma mark - 设备信息
/// 屏幕宽度
+ (NSString *)getDeviceScreenWidth;
/// 屏幕高度
+ (NSString *)getDeviceScreenHeight;
/// 屏幕像素
+ (NSString *)getDevicePixels;
/// 获取设备型号：iphone8 的model是 iphone10,1
+ (NSString *)getDeviceModel;
/// 获取设备系列名称  如iPhone8, iPhone XS
+ (NSString *)getDeviceName;
/// 获取iPhone名称,用户自己设置的手机名称
+ (NSString *)getiPhoneName;
/// 获取app版本号
+ (NSString *)getAPPVerion;
/// 当前系统名称
+ (NSString *)getSystemName;
/// 当前系统版本号
+ (NSString *)getSystemVersion;
/// 当前系统build号
+ (NSString *)getSystemBuildVersion;
/// 通用唯一识别码UUID
+ (NSString *)getUUID;
/// 获取当前语言
+ (NSString *)getDeviceLanguage;
/// 获取系统运行时间
- (void)getSystemUpTime;
#pragma mark - 磁盘存储信息

+ (NSDictionary *)getDeviceSize;//

+ (NSString *)getTimezone;
@end

NS_ASSUME_NONNULL_END
