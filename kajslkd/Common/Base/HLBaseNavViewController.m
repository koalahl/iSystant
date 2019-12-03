//
//  HLBaseNavViewController.m
//  SystemMonitor
//
//  Created by HanLiu on 2018/11/9.
//  Copyright © 2018 HanLiu. All rights reserved.
//

#import "HLBaseNavViewController.h"
#import "UINavigationBar+Awesome.h"

@interface HLBaseNavViewController ()

@end

@implementation HLBaseNavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationBar.tintColor = [UIColor darkGrayColor];
    //设置导航栏透明
    [self.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationBar setShadowImage:[UIImage new]];
    [self themeChanged];
    //先调用一下
//    [self.navigationBar lt_setBackgroundColor:[UIColor whiteColor]];
    //监听主题变化通知， 修改导航栏title color
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeChanged) name:DKNightVersionThemeChangingNotification object:nil];
}

- (void)themeChanged {
    DKNightVersionManager *manager = [DKNightVersionManager sharedManager];
    if ([manager.themeVersion isEqualToString:DKThemeVersionNormal]) {
        [self.navigationBar setTitleTextAttributes:@{ NSForegroundColorAttributeName:[UIColor blackColor]}];
        
    }else if ([manager.themeVersion isEqualToString:DKThemeVersionNight]){
        [self.navigationBar setTitleTextAttributes:@{ NSForegroundColorAttributeName:[UIColor whiteColor]}];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.childViewControllers.count==1) {
        viewController.hidesBottomBarWhenPushed = YES; //viewController是将要被push的控制器
    }
    [super pushViewController:viewController animated:animated];
}
@end
