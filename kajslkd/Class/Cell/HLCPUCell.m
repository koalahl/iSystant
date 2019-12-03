//
//  HLCPUCell.m
//  iSystant Lite
//
//  Created by HanLiu on 2019/11/6.
//  Copyright © 2019 iSystant. All rights reserved.
//

#import "HLCPUCell.h"
#import "AAChartKit.h"
#import "AAChartModel.h"

@interface HLCPUCell ()

@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UILabel *usedCPULbl;
@property (nonatomic, strong) UILabel *cpuFreqLbl;
@property (nonatomic, strong) UILabel *usedAppCPULbl;

@property (nonatomic, strong) AAChartModel *chartModel;
@property (nonatomic, strong) AAChartView  *chartView;
@property (nonatomic, strong) NSMutableArray *cpuUsageDataArr;
@property (nonatomic, strong) NSMutableArray *appCpuUsageDataArr;

@property (nonatomic, strong) dispatch_source_t timer;

@end

@implementation HLCPUCell

- (void)configSubViews {
    _cpuUsageDataArr    = [NSMutableArray array];
    _appCpuUsageDataArr = [NSMutableArray array];

    [super configSubViews];
    [self.contentView addSubview:self.icon];
    [self.contentView addSubview:self.titleLbl];
    [self.contentView addSubview:self.usedCPULbl];
    [self.contentView addSubview:self.cpuFreqLbl];
    [self.contentView addSubview:self.usedAppCPULbl];
//    [self setUpChartView];
//    [self setUpChartModel];
}

- (void)configLayout {
    [super configLayout];
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(18);
        make.top.mas_equalTo(18);
        make.width.height.mas_equalTo(44);
    }];
    
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.left.equalTo(self.icon.mas_right).offset(10);
        make.width.mas_greaterThanOrEqualTo(40);
        make.height.mas_equalTo(22);
    }];
    
    [self.usedCPULbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLbl.mas_bottom).offset(8);
        make.left.equalTo(self.titleLbl.mas_left);
        make.right.mas_equalTo(-24);
        make.height.mas_equalTo(22);
    }];
    [self.usedAppCPULbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLbl.mas_bottom).offset(8);
        make.right.mas_equalTo(-24);
        make.height.mas_equalTo(22);
    }];
    [self.cpuFreqLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.right.mas_equalTo(-24);
        make.width.mas_greaterThanOrEqualTo(40);
        make.height.mas_equalTo(22);
    }];

}
- (void)configData {
    
    self.titleLbl.text = HLLocalized(@"CPU");
    [self configCPUData];
    
    if (_timer == nil) {
        __weak typeof(self)wself = self;
        self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
        dispatch_source_set_timer(self.timer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
        dispatch_source_set_event_handler(self.timer, ^{
            __strong typeof(wself)strongSelf = wself;
            [strongSelf configCPUData];
        });
        dispatch_resume(self.timer);
    }
}

- (void)configCPUData {
//    NSString *cpuSubType    = [HLCPUMonitor monitor].cpuSubtypeString;
//    NSString *cpuCoreNumer  = [NSString stringWithFormat:@"%@ %@", @([HLCPUMonitor monitor].cpuNumber),NSLocalizedString(@"core", nil)];
    NSString *cpuUsage      = [HLCPUMonitor monitor].systemCPUUsage;
    NSString *appCpuUsage   = [HLCPUMonitor monitor].appCPUUsage;
//    NSString *realTimeCPUFreq = [HLCPUMonitor monitor].realtimeCpuFreq;
//    NSLog(@"\nCPU信息：%@, %@, %@, %@, %@",cpuSubType,cpuCoreNumer,cpuUsage,appCpuUsage,realTimeCPUFreq);
    
    self.usedCPULbl.text = [NSString stringWithFormat:@"%@:%@",HLLocalized(@"Load"),cpuUsage];
    self.cpuFreqLbl.text = [HLDeviceInformation sharedInstance].deviceDict[@"CPU Clock"];
    self.usedAppCPULbl.text = [NSString stringWithFormat:@"%@:%@",HLLocalized(@"App Load"),appCpuUsage];
//    [self onlyRefreshTheChartData];
}

- (void)setUpChartView {
    self.chartView = [[AAChartView alloc] initWithFrame:CGRectMake(72, 60, self.width,80)];
    self.chartView.isClearBackgroundColor = YES;
//    self.chartView.delegate = self;
//    self.chartView.scrollEnabled = YES;//AAChartView 滚动效果
    [self.contentView addSubview:self.chartView];
}

- (void)setUpChartModel {
    self.chartModel = AAChartModel.new
    .chartTypeSet(AAChartTypeSpline)//曲线图
    .xAxisVisibleSet(false)
    .yAxisVisibleSet(false)
    .legendEnabledSet(false)
    .titleSet(@"")
    .subtitleSet(@"")
    .yAxisTitleSet(@"摄氏度")
    .colorsThemeSet(@[@"#1e90ff",@"#dc143c"]);
    ;

    NSDecimalNumber *c1 = [[HLCPUMonitor monitor] rawCPUValue:[HLCPUMonitor monitor].systemCPUUsage];
    NSDecimalNumber *c2 = [[HLCPUMonitor monitor] rawCPUValue:[HLCPUMonitor monitor].appCPUUsage];
    [_cpuUsageDataArr addObject:c1];
    [_appCpuUsageDataArr addObject:c2];

    self.chartModel.seriesSet(@[
                                AASeriesElement.new
                                .nameSet(@"")
                                .dataSet(_cpuUsageDataArr)
                                .colorSet((id)[AAGradientColor ultramarineColor])
                                ,
                                AASeriesElement.new
                                .nameSet(@"")
                                .dataSet(_appCpuUsageDataArr)
                                .colorSet((id)[AAGradientColor sanguineColor])
                                ,
                                ]
                              );
    [self.chartView aa_drawChartWithChartModel:self.chartModel];
    
}

- (void)onlyRefreshTheChartData {
    NSDecimalNumber *c1 = [[HLCPUMonitor monitor] rawCPUValue:[HLCPUMonitor monitor].systemCPUUsage];
    NSDecimalNumber *c2 = [[HLCPUMonitor monitor] rawCPUValue:[HLCPUMonitor monitor].appCPUUsage];
    [_cpuUsageDataArr addObject:c1];
    [_appCpuUsageDataArr addObject:c2];
    //如果已存在的数据大于50条，则把前面
    if (_cpuUsageDataArr.count > 50) {
        [_cpuUsageDataArr removeObjectsInRange:NSMakeRange(0, 5)];
    }
    if (_appCpuUsageDataArr.count >50) {
        [_appCpuUsageDataArr removeObjectsInRange:NSMakeRange(0, 5)];
    }
    NSArray *series = @[
                        @{@"name":@"",
                          @"type":@"bar",
                          @"data":_cpuUsageDataArr},
                        @{@"name":@"",
                          @"type":@"bar",
                          @"data":_appCpuUsageDataArr},
                        ];
    [self.chartView aa_addPointToChartSeriesElementWithElementIndex:20 options:nil redraw:YES shift:YES animation:YES];
//    [self.chartView aa_onlyRefreshTheChartDataWithChartModelSeries:series];
    NSLog(@"Updated the chart data content!!! ☺️☺️☺️");
}


#pragma mark - Getter
- (UIImageView *)icon {
    if (_icon == nil) {
        _icon = [[UIImageView alloc] init];
        _icon.dk_imagePicker = DKImagePickerWithImages([UIImage imageNamed:@"icon_battery_normal"], [UIImage imageNamed:@"battery_night"]);
    }
    return _icon;
}

- (UILabel *)titleLbl {
    if (_titleLbl == nil) {
        _titleLbl = [UILabel new];
        _titleLbl.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
        _titleLbl.dk_textColorPicker = DKColorPickerWithRGB(0x4A4A4A,0xFFFFFF);
    }
    return _titleLbl;
}

- (UILabel *)usedCPULbl {
    if (_usedCPULbl == nil) {
        _usedCPULbl = [UILabel new];
        _usedCPULbl.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
        _usedCPULbl.dk_textColorPicker = DKColorPickerWithRGB(0x4A4A4A,0x9B9B9B);
    }
    return _usedCPULbl;
}

- (UILabel *)cpuFreqLbl {
    if (_cpuFreqLbl == nil) {
        _cpuFreqLbl = [UILabel new];
        _cpuFreqLbl.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
        _cpuFreqLbl.dk_textColorPicker = DKColorPickerWithRGB(0x4A4A4A,0x9B9B9B);
    }
    return _cpuFreqLbl;
}

- (UILabel *)usedAppCPULbl {
    if (_usedAppCPULbl == nil) {
        _usedAppCPULbl = [UILabel new];
        _usedAppCPULbl.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
        _usedAppCPULbl.dk_textColorPicker = DKColorPickerWithRGB(0x4A4A4A,0x9B9B9B);

    }
    return _usedAppCPULbl;
}
@end
