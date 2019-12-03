//
//  HLFeedback.h
//  SystemMonitor
//
//  Created by HanLiu on 2018/11/11.
//  Copyright © 2018 HanLiu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HLFeedback : NSObject

+ (instancetype)sharedInstance;

- (void)sendFeedback;
- (void)sendRate;
- (void)rateInAppStore;
- (void)alertWithMessage:(NSString *)msg;
@end
