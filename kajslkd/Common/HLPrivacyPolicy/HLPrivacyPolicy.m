//
//  HLPrivacyPolicy.m
//  SystemMonitor
//
//  Created by HanLiu on 2018/11/11.
//  Copyright © 2018 HanLiu. All rights reserved.
//

#import "HLPrivacyPolicy.h"

@implementation HLPrivacyPolicy

+ (BOOL)hasShowPrivacyAlert {
    BOOL shown = [[NSUserDefaults standardUserDefaults] boolForKey:@"HLHasShowPrivacyAlert"] ;
    return shown;
}
+ (void)showPrivacyAlert {
    BOOL hasShown = [[self class] hasShowPrivacyAlert];
    if (hasShown) {
        return;
    }
    NSString *content = HLLocalized(@"PrivacyContent");
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:HLLocalized(@"Privacy") message:content preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:HLLocalized(@"Agree") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HLHasShowPrivacyAlert"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:HLLocalized(@"Disagree") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        exit(0);
    }]];

    [[UIViewController topViewController] presentViewController:alert animated:YES completion:nil];

}





@end
