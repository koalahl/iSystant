//
//  HLRAMDetailViewController.m
//  iSystant Lite
//
//  Created by HanLiu on 2019/11/13.
//  Copyright © 2019 iSystant. All rights reserved.
//

#import "HLRAMDetailViewController.h"

@interface HLRAMDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *datasource;
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) NSString *memType;
@property (nonatomic, strong) NSString *memIOSpeed;
@property (nonatomic, strong) NSString *totalMem;

@end

@implementation HLRAMDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = HLLocalized(@"Memory");

    self.tableView.dk_backgroundColorPicker  = DKColorPickerWithRGB(0xF8F8F8,0x111111);
    self.view.dk_backgroundColorPicker       = DKColorPickerWithRGB(0xF8F8F8,0x111111);
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(K_NAVBAR_HEIGHT);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    [self.tableView registerClass:[HLDetailTableViewCell class] forCellReuseIdentifier:[HLDetailTableViewCell reuseIdentifier]];
    
    self.memType       = [[HLDeviceInformation sharedInstance].deviceDict objectForKey:@"MemType"];
    self.memIOSpeed    = [[HLDeviceInformation sharedInstance].deviceDict objectForKey:@"RAM Speed"];
    self.totalMem      = [[HLDeviceInformation sharedInstance].deviceDict objectForKey:@"RAM"];

    [self configData];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(configData) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
    [_timer fire];
}

- (void)configData {
    NSString *appMemUsed    = [HLMemoryMonitor monitor].appMemoryUsage;
    NSString *idleMemUsed   = [HLMemoryMonitor monitor].freeMemory;
    NSString *inactiveMem   = [HLMemoryMonitor monitor].inactiveMemory;
    NSString *wiredMemo     = [HLMemoryMonitor monitor].wiredMemory;
    NSString *activeMemLabel= [HLMemoryMonitor monitor].activeMemory;
    NSString *otherMemory   = [NSString stringWithFormat:@"%0.2fMB",[HLMemoryMonitor monitor].otherMemory];
    
    self.datasource = @[@[@{@"name":HLLocalized(@"Memory Type"),@"value":self.memType},//内存型号
                          @{@"name":HLLocalized(@"Read/Write Freq"),@"value":self.memIOSpeed},//读写频率
                          @{@"name":HLLocalized(@"Total Memory"),@"value":self.totalMem},
                          ],
                        @[
                          @{@"name":HLLocalized(@"Idle"),@"value":idleMemUsed},
                          @{@"name":HLLocalized(@"Inactive"),@"value":inactiveMem}
                          ],
                        @[
                          @{@"name":HLLocalized(@"App Used"),@"value":appMemUsed},
                          @{@"name":HLLocalized(@"Wired"),@"value":wiredMemo},
                          @{@"name":HLLocalized(@"Active"),@"value":activeMemLabel},
                          @{@"name":HLLocalized(@"Other Memory"),@"value":otherMemory}
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
            text = HLLocalized(@"Memory Info");
            break;
        case 1:
            text = HLLocalized(@"Aval. Memory");
            break;
        case 2:
            text = HLLocalized(@"Used. Memory");
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
