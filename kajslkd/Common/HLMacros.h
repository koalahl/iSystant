//
//  HLMacros.h
//  SystemMonitor
//
//  Created by HanLiu on 2018/11/11.
//  Copyright © 2018 HanLiu. All rights reserved.
//

#ifndef HLMacros_h
#define HLMacros_h

#define kHLDeviceWidth [UIScreen mainScreen].bounds.size.width
#define kHLDeviceHeight [UIScreen mainScreen].bounds.size.height

#define KAPPID @"1455066494"


// 屏宽高
#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define kStatesNavHeight ([[UIApplication sharedApplication] statusBarFrame].size.height + 44)
#define UIColorFromHex(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#pragma mark -

//#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#define IOS13_OR_LATER       ( [[[UIDevice currentDevice] systemVersion] floatValue] >= 13.0 )
#define IOS12_OR_LATER       ( [[[UIDevice currentDevice] systemVersion] floatValue] >= 12.0 )
#define IOS11_OR_LATER       ( [[[UIDevice currentDevice] systemVersion] floatValue] >= 11.0 )
#define IOS10_OR_LATER       ( [[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0 )
#define IOS9_OR_LATER        ( [[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0 )
#define IOS8_OR_LATER        ( [[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 )
#define IOS7_OR_LATER        ( [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 )
#define IOS6_OR_LATER        ( [[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0 )

#define IOS12_OR_EARLIER       ( !IOS13_OR_LATER )
#define IOS11_OR_EARLIER       ( !IOS12_OR_LATER )
#define IOS10_OR_EARLIER       ( !IOS11_OR_LATER )
#define IOS9_OR_EARLIER        ( !IOS10_OR_LATER )
#define IOS8_OR_EARLIER        ( !IOS9_OR_LATER )
#define IOS7_OR_EARLIER        ( !IOS8_OR_LATER )
#define IOS6_OR_EARLIER        ( !IOS7_OR_LATER )
#define IOS5_OR_EARLIER        ( !IOS6_OR_LATER )
#define IOS4_OR_EARLIER        ( !IOS5_OR_LATER )
#define IOS3_OR_EARLIER        ( !IOS4_OR_LATER )

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPOD ([[[UIDevice currentDevice] model] isEqualToString:@"iPod touch"])
#define IS_IPHONE (    !IS_IPAD )

#define IS_IPHONE4 (IS_SCREEN_35_INCH)
#define IS_IPHONE5 (IS_SCREEN_4_INCH)
#define IS_IPHONE6 (IS_SCREEN_47_INCH)
#define IS_IPHONE6_PLUS (IS_SCREEN_55_INCH)
#define IS_IPHONEX (IS_SCREEN_58_INCH)
#define IS_IPHONEXR (IS_SCREEN_61_INCH)
#define IS_IPHONEXS (IS_SCREEN_58_INCH &&)
#define IS_IPHONEXSMAX (IS_SCREEN_65_INCH)

#define IS_IPHONEX_SERIAL (IS_IPHONEX || IS_IPHONEXR || IS_IPHONEXSMAX)

#define K_STATUSBAR_HEIGHT (IS_IPHONEX_SERIAL? 44.0f:20.0F)
#define K_NAVBAR_HEIGHT (IS_IPHONEX_SERIAL? 88.0f:64.0f)
#define K_BOTTOMBAR_HEIGHT (IS_IPHONEX_SERIAL? 83.0f:49.0f)
#define K_BOTTOM_MARGIN_HEIGHT (IS_IPHONEX_SERIAL? 34.0f:0.0f)

#define IS_SCREEN_65_INCH       ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) : NO)

#define IS_SCREEN_61_INCH       ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) : NO)

#define IS_SCREEN_58_INCH       ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
#define IS_SCREEN_55_INCH       ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(1125, 2001), [[UIScreen mainScreen] currentMode].size) || CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size)) : NO)
#define IS_SCREEN_47_INCH       ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define IS_SCREEN_4_INCH        ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define IS_SCREEN_35_INCH       ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define IS_SCREEN_IPAD_35_INCH  ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(320, 480), [[UIScreen mainScreen] bounds].size) : NO)

#define HLLocalized(key) [NSBundle.mainBundle localizedStringForKey:(key) value:(key) table:nil]

#define UserDefaultSuite [[NSUserDefaults alloc] initWithSuiteName:@"levi.isystant.iSystant-Lite"]

//#endif    // #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)


#ifndef weakify
    #if DEBUG
        #if __has_feature(objc_arc)
        #define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
        #else
        #define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
        #endif
    #else
        #if __has_feature(objc_arc)
        #define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
        #else
        #define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
        #endif
    #endif
#endif

#ifndef strongify
    #if DEBUG
        #if __has_feature(objc_arc)
        #define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
        #else
        #define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
        #endif
    #else
        #if __has_feature(objc_arc)
        #define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
        #else
        #define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
        #endif
    #endif
#endif

#endif /* HLMacros_h */

