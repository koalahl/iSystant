//
//  HLSettingViewController.m
//  iSystant Lite
//
//  Created by HanLiu on 2019/11/9.
//  Copyright © 2019 iSystant. All rights reserved.
//

#import "HLSettingViewController.h"
#import <SafariServices/SFSafariViewController.h>
#import "HLFeedback.h"

static NSString *weibo = @"https://weibo.cn/u/1619592223";//@"sinaweibo://userinfo?uid=1619592223";
static NSString *twitter = @"https://twitter.com/hanangellove";

@interface HLSettingViewController ()
@property (weak, nonatomic) IBOutlet UILabel *appVersionLabel;
@property (weak, nonatomic) UILabel *widgetUIDescLabel;
@property (weak, nonatomic) IBOutlet UILabel *batteryHeathLabel;
@property (weak, nonatomic) IBOutlet UISwitch *nightModeSwither;
@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UIView *topView;

@end

@implementation HLSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.appVersionLabel.text = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
    if (@available(iOS 11.0, *)) {
        self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeNever;
        // Do any additional setup after loading the view.
    } else {
        // Fallback on earlier versions
    }
    
    UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc] initWithCustomView:self.backBtn];
    self.navigationItem.rightBarButtonItem = rightBarBtn;
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    [self configNightMode];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self configWidgetDesc];
    [self configBatteryHeathy];
    
}

- (void)configWidgetDesc {
    NSUserDefaults *group =  [[NSUserDefaults alloc] initWithSuiteName:@"group.com.redefine.iSystantPro"];
    NSUInteger type = [group integerForKey:@"widgetUIType"];
    if (type == 1) {
        self.widgetUIDescLabel.text = HLLocalized(@"Default") ;
    }else if (type == 2) {
        self.widgetUIDescLabel.text = HLLocalized(@"Type 2") ;
    }
}

- (void)configBatteryHeathy {
    NSString *batteryHeath = [UserDefaultSuite objectForKey:@"batteryHeath"];
    self.batteryHeathLabel.text =  batteryHeath? batteryHeath:@"100%";
}

//设置夜间模式
- (void)configNightMode {
    self.tableView.dk_backgroundColorPicker  = DKColorPickerWithRGB(0xFFFFFF,0x111111);
    
    DKNightVersionManager *manager = [DKNightVersionManager sharedManager];
    if ([manager.themeVersion isEqualToString:DKThemeVersionNormal]) {
        self.nightModeSwither.on = NO;
    }else if ([manager.themeVersion isEqualToString:DKThemeVersionNight]){
        self.nightModeSwither.on = YES;
    }
    [self.nightModeSwither addTarget:self action:@selector(switchTheme:) forControlEvents:UIControlEventValueChanged];
}

- (void)switchTheme:(UISwitch *)sender {
    
    DKNightVersionManager *manager = [DKNightVersionManager sharedManager];
    if (sender.on) {
        [manager nightFalling];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"AppInNight"];
    }else {
        [manager dawnComing];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"AppInNight"];
    }
}
#pragma mark - Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:break;
                case 1:{
                    __weak typeof(self)wself = self;
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:HLLocalized(@"Set Battery Heath")  message:HLLocalized(@"Set Battery Heath Context")  preferredStyle:UIAlertControllerStyleAlert];
                    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                    }];
                    [alert addAction:[UIAlertAction actionWithTitle:HLLocalized(@"Cancel") style:UIAlertActionStyleCancel handler:nil]];
                    [alert addAction:[UIAlertAction actionWithTitle:HLLocalized(@"Confirm") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        NSString *tex = alert.textFields[0].text;
                        NSLog(@"yyy%@",tex);
                        if ([tex isEqualToString:@""] || tex.length >3) {
                            return ;
                        }
                        wself.batteryHeathLabel.text = [NSString stringWithFormat:@"%@%%",alert.textFields[0].text ];
                        [UserDefaultSuite setObject:wself.batteryHeathLabel.text forKey:@"batteryHeath"];
                    }]];
                    
                    [self presentViewController:alert animated:YES completion:nil];
                }
                    break;
                default:
                    break;
            };
            break;
        case 1://{开发者}
            switch (indexPath.row) {
                case 0://意见反馈
                    [[HLFeedback sharedInstance] sendFeedback];
                    break;
                case 1://微博
                {
                    [self openWeibo:weibo];
                }
                    break;
                case 2://twitter
                    [self openTwitter];
                    break;
                default:
                    break;
            }
            break;
        case 2://{关于}
            switch (indexPath.row) {
                case 1://去评分
                    [[HLFeedback sharedInstance] rateInAppStore];
                    break;
                case 2://分享
                    [self share];
                    break;
                default:
                    break;
            }
            break;
        case 3://
            [self openMyApp:@"1455066494"];
            break;
        default:
            break;
    }
}
- (void)openMyApp:(NSString *)appID{
    //应用内打开App store 页面，可以撰写评论。
    NSURL *appReviewUrl = [NSURL URLWithString:[NSString stringWithFormat: @"itms-apps://itunes.apple.com/app/id%@",appID]];//换成你应用的 APPID
    /// 大于等于10.0系统使用此openURL方法
    if (@available (iOS 10.3,*)) {
        [[UIApplication sharedApplication] openURL:appReviewUrl options:@{} completionHandler:nil];
    }else {
        [[UIApplication sharedApplication] openURL:appReviewUrl];
    }
}

- (void)openWeibo:(NSString *)urlScheme {
    NSURL *url = [NSURL URLWithString:urlScheme];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url options:@{UIApplicationOpenURLOptionUniversalLinksOnly:@"xxx"} completionHandler:^(BOOL success) {
            NSLog(@"打开微博");
        }];
    }
    
}

- (void)openTwitter {
    SFSafariViewController *safariVC = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:twitter]];
    [self presentViewController:safariVC animated:YES completion:nil];
}

- (void)share {
    NSMutableArray *items = [NSMutableArray array];
    [items addObject:HLLocalized(@"AppName")];
    [items addObject:[UIImage imageNamed:@"Icon-60"]];
    [items addObject:[NSURL URLWithString:@"https://itunes.apple.com/us/app/isystant-pro/id1441902045?mt=8"]];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:items applicationActivities:nil];
    [self presentViewController:activityViewController animated:YES completion:nil];
}

- (void)back {
    if (self.navigationController) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


#pragma mark - Getter

- (UIButton *)backBtn {
    if (_backBtn == nil) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setTitle:HLLocalized(@"Cancel") forState:UIControlStateNormal];
        [_backBtn dk_setTitleColorPicker:DKColorPickerWithRGB(0x4A4A4A,0xFFFFFF) forState:UIControlStateNormal];
        //        [_backBtn dk_setImage:DKImagePickerWithNames(@"icon_setting_normal",@"icon_setting_night") forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

- (UIView *)topView {
    if (_topView == nil) {
        _topView = [UIView new];
        _topView.dk_backgroundColorPicker = DKColorPickerWithRGB(0xFFFFFF,0x111111);
    }
    return _topView;
}
@end

