//
//  HLNetworkDetailViewController.m
//  iSystant Lite
//
//  Created by HanLiu on 2019/11/13.
//  Copyright © 2019 iSystant. All rights reserved.
//

#import "HLNetworkDetailViewController.h"

@interface HLNetworkDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *datasource;
@property (nonatomic, strong) HLNetworkMonitor *network;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSTimer *timerForSpeed;
@end

@implementation HLNetworkDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = HLLocalized(@"Network");
    self.datasource = [NSMutableArray arrayWithArray:@[@[],@[],@[]]];
    self.network    = [HLNetworkMonitor network];

    self.tableView.dk_backgroundColorPicker  = DKColorPickerWithRGB(0xF8F8F8,0x111111);
    self.view.dk_backgroundColorPicker       = DKColorPickerWithRGB(0xF8F8F8,0x111111);
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(K_NAVBAR_HEIGHT);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    [self.tableView registerClass:[HLDetailTableViewCell class] forCellReuseIdentifier:[HLDetailTableViewCell reuseIdentifier]];
    
    [self refresh];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [[HLNetworkMonitor network] getNetworkBasicInfo];
    [self config];

}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    if (_timerForSpeed) {
        [_timerForSpeed invalidate];
        _timerForSpeed = nil;
    }
}

- (void)refresh {
    //刷新网络流量
//    _timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(refreshNetworkFlow) userInfo:nil repeats:YES];
//    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
//    [_timer fire];
    //刷新网络速率
    _timerForSpeed = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(refreshNetworkSpeed) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timerForSpeed forMode:NSDefaultRunLoopMode];
    [_timerForSpeed fire];
}

- (void)config {
    //section0
    NSString *carrierName  = _network.carrierName;
    NSString *networkType  = _network.networkType;
    NSString *pubIP        = _network.publicIp;
    NSString *internalIP   = _network.internalIp;
    NSString *wifiName     = _network.wifiName;
    NSString *dns          = _network.dns;
    NSString *wifiMacAddress = _network.wifiMacAddress;

    [self.datasource replaceObjectsInRange:NSMakeRange(0, 1) withObjectsFromArray:@[@[@{@"name":HLLocalized(@"Carrier Name"),@"value":carrierName},
                                           @{@"name":HLLocalized(@"Network Type"),@"value":networkType},
                                           @{@"name":HLLocalized(@"Public IP"),@"value":pubIP},
                                           @{@"name":HLLocalized(@"Internal IP"),@"value":internalIP},
                                           @{@"name":HLLocalized(@"WIFI Name"),@"value":wifiName},
                                           @{@"name":HLLocalized(@"WIFI MAC Address"),@"value":wifiMacAddress},
                                           @{@"name":HLLocalized(@"DNS"),@"value":dns},
                                           ]]];
//    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
   
}

- (void)refreshNetworkFlow {
    //section1
    NSString *uplinkData   = _network.dataOutFlow;
    NSString *downlinkData = _network.dataInFlow;
    NSString *uplinkWIFI   = _network.wifiOutFlow;
    NSString *downlinkWIFI = _network.wifiInFlow;
    [self.datasource replaceObjectsInRange:NSMakeRange(2, 1) withObjectsFromArray:@[@[@{@"name":HLLocalized(@"Uplink Cell Data"),@"value":uplinkData},
                                           @{@"name":HLLocalized(@"Downlink Cell Data"),@"value":downlinkData},
                                           @{@"name":HLLocalized(@"Uplink WIFI"),@"value":uplinkWIFI},
                                           @{@"name":HLLocalized(@"Downlink WIFI"),@"value":downlinkWIFI},
                                           ]]];
//    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];

}

- (void)refreshNetworkSpeed {
    [self refreshNetworkFlow];
    
    //section2
    NSString *uploadSpeed   = _network.uploadNetworkSpeed;
    NSString *downloadSpeed = _network.downloadNetworkSpeed;
    [self.datasource replaceObjectsInRange:NSMakeRange(1, 1) withObjectsFromArray:@[@[@{@"name":HLLocalized(@"Uplink Speed"),@"value":uploadSpeed},
                                                                                    @{@"name":HLLocalized(@"Downlink Speed"),@"value":downloadSpeed},
                                                                                    ]]];
    [self.tableView reloadData];
//    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
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
            text = HLLocalized(@"Network Basic Info");
            break;
        case 1:
            text = HLLocalized(@"RealTime Net Speed");
            break;
        case 2:
            text = HLLocalized(@"Network Flow");
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
