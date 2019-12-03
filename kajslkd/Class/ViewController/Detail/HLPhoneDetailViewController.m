//
//  HLPhoneDetailViewController.m
//  iSystant Lite
//
//  Created by HanLiu on 2019/11/13.
//  Copyright © 2019 iSystant. All rights reserved.
//

#import "HLPhoneDetailViewController.h"

@interface HLPhoneDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *datasource;
@end

@implementation HLPhoneDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = HLLocalized(@"Device");
    self.tableView.dk_backgroundColorPicker  = DKColorPickerWithRGB(0xF8F8F8,0x111111);
    self.view.dk_backgroundColorPicker       = DKColorPickerWithRGB(0xF8F8F8,0x111111);

    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(K_NAVBAR_HEIGHT);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    [self.tableView registerClass:[HLDetailTableViewCell class] forCellReuseIdentifier:[HLDetailTableViewCell reuseIdentifier]];
    
    [self configData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)configData {
    NSString *iphoneName    = [NSString stringWithFormat:@"%@", [HLDeviceInformation getiPhoneName]];
    NSString *deviceName    = [HLDeviceInformation getDeviceName];
    NSString *deviceModel   = [HLDeviceInformation getDeviceModel];
    NSString *systemVersion = [HLDeviceInformation getSystemVersion];
    NSString *systemBuild   = [HLDeviceInformation getSystemBuildVersion];
    
    NSString *screenWidth   = [HLDeviceInformation getDeviceScreenWidth];
    NSString *screenHeight  = [HLDeviceInformation getDeviceScreenHeight];
    NSString *pixels = [HLDeviceInformation getDevicePixels];
    NSString *ppi = [NSString stringWithFormat:@"%@PPI", [[HLDeviceInformation sharedInstance].deviceDict objectForKey:@"PPI"]];
    NSString *systemLanguage = [HLDeviceInformation getDeviceLanguage];
    NSString *systemUpTime   = [HLDeviceInformation sharedInstance].upTime;
    NSString *rebootDate     = [HLDeviceInformation sharedInstance].bootTime;
    NSString *timeZone       = [HLDeviceInformation getTimezone];
    
    self.datasource = @[@[@{@"name":HLLocalized(@"Device Name"),@"value":iphoneName},//手机名称
                          @{@"name":HLLocalized(@"Device Type"),@"value":deviceName},//设备名称设备型号
                          @{@"name":HLLocalized(@"Device Model"),@"value":deviceModel},//设备型号
                          @{@"name":HLLocalized(@"OS Version"),@"value":systemVersion},
                          @{@"name":HLLocalized(@"Build Version"),@"value":systemBuild}
                        ],
                        @[@{@"name":HLLocalized(@"Width"),@"value":screenWidth},
                          @{@"name":HLLocalized(@"Height"),@"value":screenHeight},
                          @{@"name":HLLocalized(@"Pixels"),@"value":pixels},
                          @{@"name":HLLocalized(@"PPI"),@"value":ppi}
                        ],
                        @[@{@"name":HLLocalized(@"System Language"),@"value":systemLanguage},
                          @{@"name":HLLocalized(@"TimeZone"),@"value":timeZone},
                          @{@"name":HLLocalized(@"Reboot Date"),@"value":rebootDate},
                          @{@"name":HLLocalized(@"SystemUpTime"),@"value":systemUpTime}
                        ]
                       ];
    [self.tableView reloadData];
}

#pragma mark - Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.datasource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.datasource[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HLDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[HLDetailTableViewCell reuseIdentifier]];

    NSDictionary *dic = self.datasource[indexPath.section][indexPath.row];
    [cell configData:dic];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *text = @"";
    switch (section) {
        case 0:
            text = HLLocalized(@"System");
            break;
        case 1:
            text = HLLocalized(@"Screen");
            break;
        case 2:
            text = HLLocalized(@"Others");
            break;
        default:
            break;
    }
    return text;
}
#pragma mark - Getter

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    return _tableView;
}
@end
