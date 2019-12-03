//
//  UIViewController+Extension.m
//  OMTCoreKit
//
//  Created by YZF on 2018/8/9.
//

#import "UIViewController+Extension.h"

@implementation UIViewController (Extension)

+ (UIViewController *)topViewController {
    UIViewController *topVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    
    if ([topVC isKindOfClass:[UITabBarController class]]) {
        topVC = [(UITabBarController *)topVC selectedViewController];
    }
    if ([topVC isKindOfClass:[UINavigationController class]]){
        topVC = [(UINavigationController *)topVC visibleViewController];
    }
    
    return topVC;
}

@end
