//
//  UIColor+Extension.h
//  SystemMonitor
//
//  Created by HanLiu on 2018/11/18.
//  Copyright © 2018 HanLiu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (Extension)

+ (UIColor *)colorWithHex:(NSString *)color;
+ (UIColor *)colorWithRGBA:(NSString *)rgba;

@end

NS_ASSUME_NONNULL_END
