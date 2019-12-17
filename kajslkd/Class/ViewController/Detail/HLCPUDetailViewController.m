//
//  HLCPUDetailViewController.m
//  iSystant Lite
//
//  Created by HanLiu on 2019/11/13.
//  Copyright © 2019 iSystant. All rights reserved.
//

#import "HLCPUDetailViewController.h"

@interface HLCPUDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *datasource;
@end

@implementation HLCPUDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = HLLocalized(@"CPU");

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

- (void)configData {
    NSString *cpufreq = [HLCPUMonitor monitor].realtimeCpuFreq;
//    NSLog(@"cpufreq = %@",cpufreq);
    NSString *cpuModel      = [HLDeviceInformation sharedInstance].deviceDict[@"CPU"];
    NSString *cpuArch       = [HLDeviceInformation sharedInstance].deviceDict[@"CPU Arch"];;
    NSString *cpuCores      = [NSString stringWithFormat:@"%@ %@", @([HLCPUMonitor monitor].cpuNumber),NSLocalizedString(@"core", nil)];
    NSString *cpuMaxFreq    = [HLDeviceInformation sharedInstance].deviceDict[@"CPU Clock"];
    NSString *L1Cache       = [HLDeviceInformation sharedInstance].deviceDict[@"L1 Cache"];
    NSString *L2Cache       = [HLDeviceInformation sharedInstance].deviceDict[@"L2 Cache"];
    NSString *L3Cache       = [HLDeviceInformation sharedInstance].deviceDict[@"L3 Cache"];
    NSString *soc           = [HLDeviceInformation sharedInstance].deviceDict[@"SoC"];
    
    NSString *gpuModel = [HLDeviceInformation sharedInstance].deviceDict[@"GPU"];
    NSString *gpuCores = [HLDeviceInformation sharedInstance].deviceDict[@"GPU Cores"];
    
    NSString *beenchmark_cpu_single = [HLDeviceInformation sharedInstance].deviceDict[@"Geekbench Single Core"];
    NSString *beenchmark_cpu_multi = [HLDeviceInformation sharedInstance].deviceDict[@"Geekbench Multi Core"];
    NSString *beenchmark_gpu_metal = [HLDeviceInformation sharedInstance].deviceDict[@"Metal"];
    
    NSString *motionProc = [HLDeviceInformation sharedInstance].deviceDict[@"Motion Coprocessor"];
    
    self.datasource = @[@[@{@"name":HLLocalized(@"Model"),@"value":cpuModel},//内存型号
                          @{@"name":HLLocalized(@"Arch"),@"value":cpuArch},//读写频率
                          @{@"name":HLLocalized(@"Cores"),@"value":cpuCores},
                          @{@"name":HLLocalized(@"Clock Frequency"),@"value":cpuMaxFreq},
//                          @{@"name":HLLocalized(@"Current Frequency"),@"value":cpufreq},
                          @{@"name":HLLocalized(@"L1Cache"),@"value":L1Cache},
                          @{@"name":HLLocalized(@"L2Cache"),@"value":L2Cache},
                          @{@"name":HLLocalized(@"L3Cache"),@"value":L3Cache},
                          @{@"name":HLLocalized(@"SoC"),@"value":soc},
                        ],
                        @[
                            @{@"name":HLLocalized(@"GPU Model"),@"value":gpuModel},
                            @{@"name":HLLocalized(@"GPU Cores"),@"value":gpuCores},
                            ],
                        @[
                            @{@"name":HLLocalized(@"CPU Single Core"),@"value":beenchmark_cpu_single},
                            @{@"name":HLLocalized(@"CPU Multi Core"),@"value":beenchmark_cpu_multi},
                            @{@"name":HLLocalized(@"GPU Metal"),@"value":beenchmark_gpu_metal},
                            ],
                        @[
                            @{@"name":HLLocalized(@"Motion Processor"),@"value":motionProc},
                            ]
                        ];
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
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
            text = HLLocalized(@"CPU Basic Info");
            break;
        case 1:
            text = HLLocalized(@"GPU");
            break;
        case 2:
            text = HLLocalized(@"BEENCHMARK");
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
