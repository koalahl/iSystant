//
//  ViewController.m
//  iSystant Lite
//
//  Created by HanLiu on 2019/11/3.
//  Copyright © 2019 iSystant. All rights reserved.
//

#import "HLDeviceViewController.h"
#import "HLSystemMonitor.h"
#import <CoreLocation/CoreLocation.h>

#import "HLCellViewModel.h"
#import "HLSettingViewController.h"
#import "HLPhoneDetailViewController.h"
#import "HLCPUDetailViewController.h"
#import "HLRAMDetailViewController.h"
#import "HLNetworkDetailViewController.h"


@interface HLDeviceViewController ()<UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *phoneName;
@property (nonatomic, strong) UIButton *settingBtn;

// ios13 获取wifi信息，需要先获取定位权限
@property (nonatomic, strong) CLLocationManager *locationMagager;
@property (nonatomic, strong) HLCellViewModel *cellViewModel;
@property (nonatomic, strong) NSArray *cellViewModels;

@end

@implementation HLDeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //打开电池监听
    [[UIDevice currentDevice] setBatteryMonitoringEnabled:YES];
    [HLSystemMonitor startMemoryMonitor:[HLSystemMonitor sharedMonitor].memoryRefreshInterval];
    
    [self startNetworkMonitor];
    [self requestLocationPrivacy];
    [self buildCellsDatas];
    [self configSubViews];
}

- (void)buildCellsDatas {
    HLCellViewModel *deviceCVM = [[HLCellViewModel alloc] initWith:[HLDeviceCell reuseIdentifier] rowHeight:100 title:@"device"];
    HLCellViewModel *cpuCVM = [[HLCellViewModel alloc] initWith:[HLCPUCell reuseIdentifier] rowHeight:100 title:@"cpu"];
    HLCellViewModel *storageCVM = [[HLCellViewModel alloc] initWith:[HLStorageCell reuseIdentifier] rowHeight:132 title:@"storage"];
    HLCellViewModel *memoryCVM = [[HLCellViewModel alloc] initWith:[HLMemoryCell reuseIdentifier] rowHeight:126 title:@"memory"];
    HLCellViewModel *networkCVM = [[HLCellViewModel alloc] initWith:[HLNetworkCell reuseIdentifier] rowHeight:100 title:@"network"];
    HLCellViewModel *batteryCVM = [[HLCellViewModel alloc] initWith:[HLBatteryCell reuseIdentifier] rowHeight:126 title:@"battery"];
    
    self.cellViewModels = @[deviceCVM,cpuCVM,networkCVM,memoryCVM,storageCVM,batteryCVM];

}

- (void)configSubViews {
    self.phoneName = [UILabel new];
    self.phoneName.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    self.phoneName.backgroundColor = [UIColor clearColor];
    self.phoneName.dk_textColorPicker        = DKColorPickerWithRGB(0x111111,0xFFFFFF);
    self.tableView.dk_backgroundColorPicker  = DKColorPickerWithRGB(0xF8F8F8,0x111111);
    self.view.dk_backgroundColorPicker       = DKColorPickerWithRGB(0xF8F8F8,0x111111);

    [self.view addSubview:self.phoneName];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.settingBtn];
    
    [self.phoneName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(K_STATUSBAR_HEIGHT+20);
        make.centerX.equalTo(self.view).offset(10);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneName.mas_bottom).offset(20);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    [self.settingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(44);
        make.right.mas_equalTo(-15);
        make.centerY.equalTo(self.phoneName);
    }];
    [self.tableView registerClass:[HLCPUCell class] forCellReuseIdentifier:[HLCPUCell reuseIdentifier]];
    [self.tableView registerClass:[HLStorageCell class] forCellReuseIdentifier:[HLStorageCell reuseIdentifier]];
    [self.tableView registerClass:[HLMemoryCell class] forCellReuseIdentifier:[HLMemoryCell reuseIdentifier]];
    [self.tableView registerClass:[HLNetworkCell class] forCellReuseIdentifier:[HLNetworkCell reuseIdentifier]];
    [self.tableView registerClass:[HLDeviceCell class] forCellReuseIdentifier:[HLDeviceCell reuseIdentifier]];
    [self.tableView registerClass:[HLBatteryCell class] forCellReuseIdentifier:[HLBatteryCell reuseIdentifier]];

    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.phoneName.text = [NSString stringWithFormat:@"%@",[HLDeviceInformation getiPhoneName]];
}

#pragma mark - Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cellViewModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HLCellViewModel *cvm = self.cellViewModels[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cvm.cellIndentifer forIndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    HLCellViewModel *cvm = self.cellViewModels[indexPath.row];
    return cvm.rowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HLCellViewModel *cvm = self.cellViewModels[indexPath.row];
    //触发震动
    UIImpactFeedbackGenerator *impact = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleLight];
    //prepare可用可不用，Apple推荐使用，减少latency
    [impact prepare];
    [impact impactOccurred];
    
    if ([cvm.title isEqualToString:@"device"]) {
        HLPhoneDetailViewController *phoneVC = [HLPhoneDetailViewController new];
        [self.navigationController pushViewController:phoneVC animated:YES];
    }else if ([cvm.title isEqualToString:@"cpu"]) {
        HLCPUDetailViewController *cpuVC = [HLCPUDetailViewController new];
        [self.navigationController pushViewController:cpuVC animated:YES];

    }else if ([cvm.title isEqualToString:@"memory"]) {
        HLRAMDetailViewController *ramVC = [HLRAMDetailViewController new];
        [self.navigationController pushViewController:ramVC animated:YES];
    }else if ([cvm.title isEqualToString:@"network"]) {
        HLNetworkDetailViewController *netVC = [HLNetworkDetailViewController new];
        [self.navigationController pushViewController:netVC animated:YES];
    }
}

#pragma mark - Action
- (void)goToSettingVC {
    
    HLBaseNavViewController *nav = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"settingNav"];
    
    [self presentViewController:nav animated:YES completion:nil];

}

#pragma mark - Getter

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    return _tableView;
}

- (UIButton *)settingBtn {
    if (_settingBtn == nil) {
        _settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_settingBtn dk_setImage:DKImagePickerWithNames(@"icon_setting_normal",@"icon_setting_night") forState:UIControlStateNormal];
        [_settingBtn addTarget:self action:@selector(goToSettingVC) forControlEvents:UIControlEventTouchUpInside];
    }
    return _settingBtn;
}

- (void)startNetworkMonitor {
    [[HLNetworkMonitor network] start:1];
}

#pragma mark - Private
- (void)requestLocationPrivacy {
    if (@available(iOS 13, *)) {
         
         if (CLLocationManager.authorizationStatus == kCLAuthorizationStatusAuthorizedWhenInUse) {//开启了权限，直接搜索
             
             
         } else if (CLLocationManager.authorizationStatus == kCLAuthorizationStatusDenied) {//如果用户没给权限，则提示
             UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"定位权限关闭提示" message:@"你关闭了定位权限，导致无法使用WIFI功能" preferredStyle:UIAlertControllerStyleAlert];
             [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
             [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
             
         } else {//请求权限
             [self.locationMagager requestWhenInUseAuthorization];
         }
    }
   
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [self startNetworkMonitor];
    }
}

- (CLLocationManager *)locationMagager {
    if (!_locationMagager) {
        _locationMagager = [[CLLocationManager alloc] init];
        _locationMagager.delegate = self;
    }
    return _locationMagager;
}
@end
