//
//  AppDelegate.m
//  kajslkd
//
//  Created by HanLiu on 2019/11/24.
//  Copyright © 2019 iSystant. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //1.启动统计SDK
    [MSAppCenter start:@"b7437d8d-b9c3-4453-82b7-7781c73215d1" withServices:@[[MSAnalytics class],[MSCrashes class]]];
    
    //2.设置主题
    [[DKColorTable sharedColorTable] setFile:@"theme.txt"];
    BOOL isNight = [[NSUserDefaults standardUserDefaults] boolForKey:@"AppInNight"];

    DKNightVersionManager * manager = [DKNightVersionManager sharedManager];
    manager.themeVersion = isNight ? DKThemeVersionNight:DKThemeVersionNormal;
    //4.初始化电池健康度
    NSString *batteryHeathy = [UserDefaultSuite objectForKey:@"batteryHeath"];
    if (batteryHeathy == 0) {
        [UserDefaultSuite setObject:@"100%" forKey:@"batteryHeath"];
    }
    //5.读取设置json信息文件。
    [[HLSystemMonitor sharedMonitor] parseDeviceFile];

    
    NSArray *languages = [[NSUserDefaults standardUserDefaults] valueForKey:@"AppleLanguages"];
    NSLog(@"AppleLanguages 语言有 %@", languages);
    NSString *currentLanguage = languages.firstObject;
    NSLog(@"模拟器当前语言：%@",currentLanguage);

    return YES;
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
