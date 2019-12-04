//
//  HLNetworkMonitor.h
//  SystemMonitor
//
//  Created by HanLiu on 2018/10/23.
//  Copyright © 2018 HanLiu. All rights reserved.
//

#import <UIKit/UIKit.h>
// 88kB/s
extern NSString *const GSDownloadNetworkSpeedNotificationKey;
// 2MB/s
extern NSString *const GSUploadNetworkSpeedNotificationKey;



NS_ASSUME_NONNULL_BEGIN

@interface HLNetworkMonitor : NSObject


/// WIFI/4G/3G
@property (nonatomic, copy) NSString *networkType;
@property (nonatomic, copy) NSString *publicIp;
@property (nonatomic, copy) NSString *internalIp;
@property (nonatomic, copy) NSString *wifiName;
@property (nonatomic, copy) NSString *wifiMacAddress;
@property (nonatomic, copy) NSString *dns;

@property (nonatomic, copy) NSString *publicIpSourceAddress;/*广东省深圳市*/
/**
 网络下行速率
 */
@property (nonatomic, copy,getter=downloadNetworkSpeed) NSString *downloadNetworkSpeed;
/**
 网络上行速率
 */
@property (nonatomic, copy,getter=uploadNetworkSpeed) NSString *uploadNetworkSpeed;
/**
 WIFI总流量
 */
@property (nonatomic, copy,getter=getWIFIFlow) NSString *wifiFlow;
/**
 WIFI上行流量
 */
@property (nonatomic, copy,getter=getWIFIOutFlow) NSString *wifiOutFlow;

/**
 WIFI下行流量
 */
@property (nonatomic, copy,getter=getWIFIInFlow) NSString *wifiInFlow;

/**
 数据总流量
 */
@property (nonatomic, copy,getter=getDataFlow) NSString *dataFlow;

/**
 数据上行流量
 */
@property (nonatomic, copy,getter=getDataOutFlow) NSString *dataOutFlow;

/**
 数据下行流量
 */
@property (nonatomic, copy,getter=getDataInFlow) NSString *dataInFlow;

@property (nonatomic, copy) NSString *carrierName;

@property (nonatomic, copy) NSString *lastDeviceBootTime;

+ (instancetype)network;


/**
 开始网络监听

 @param interval 监听间隔
 */
- (void)start:(NSTimeInterval)interval;

/**
 停止网络监听
 */
- (void)stop;

- (void)getNetworkBasicInfo;

@end

NS_ASSUME_NONNULL_END
