//
//  HLBatteryCell.m
//  iSystant Lite
//
//  Created by HanLiu on 2019/11/6.
//  Copyright © 2019 iSystant. All rights reserved.
//

#import "HLBatteryCell.h"

@interface HLBatteryCell ()

@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UILabel *batteryLevelLbl;
@property (nonatomic, strong) UILabel *batteryStateLbl;
@property (nonatomic, strong) UILabel *batteryRescLabel;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) dispatch_source_t timer;

@end
@implementation HLBatteryCell

- (void)configSubViews {
    [super configSubViews];
    NSLog(@"HLMemoryCell configSubViews");
    [self.contentView addSubview:self.icon];
    [self.contentView addSubview:self.titleLbl];
    [self.contentView addSubview:self.batteryLevelLbl];
    [self.contentView addSubview:self.progressView];
    [self.contentView addSubview:self.batteryStateLbl];
    [self.contentView addSubview:self.batteryRescLabel];
}

- (void)configLayout {
    NSLog(@"HLMemoryCell configLayout");
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
    
    [self.batteryLevelLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLbl.mas_bottom).offset(16);
        make.left.equalTo(self.titleLbl.mas_left);
        make.right.mas_equalTo(-24);
        make.height.mas_equalTo(22);
    }];
    [self.batteryStateLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.right.mas_equalTo(-24);
        make.width.mas_greaterThanOrEqualTo(40);
        make.height.mas_equalTo(22);
    }];
    [self.batteryRescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-24);
        make.top.equalTo(self.titleLbl.mas_bottom).offset(16);
        make.height.mas_equalTo(22);
    }];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-24);
        make.left.equalTo(self.batteryLevelLbl.mas_left);
        make.height.mas_equalTo(8);
        make.right.mas_equalTo(-24);
    }];
}

- (void)configData {
    self.titleLbl.text  = HLLocalized(@"Battery");
    
    if (_timer == nil) {
        __weak typeof(self)wself = self;
        self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
        dispatch_source_set_timer(self.timer, DISPATCH_TIME_NOW, 30 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
        dispatch_source_set_event_handler(self.timer, ^{
            __strong typeof(wself)strongSelf = wself;
            [strongSelf configBatteryData];
        });
        dispatch_resume(self.timer);
    }
}

- (void)configBatteryData {
    //进度条表示当前电量百分比
    float level = [UIDevice currentDevice].batteryLevel;
    self.progressView.progress = level;;
    
    NSString *batteryLevel = [HLBatteryMonitor getBatteryLevel];
    NSString *batteryState = [HLBatteryMonitor getBatteryState];
    //出场电量
    NSString *oriBattery = [[HLDeviceInformation sharedInstance].deviceDict[@"Battery"] componentsSeparatedByString:@"mAh"][0];
    //手动设置的电池健康度
    NSString *batteryHeathy = [[UserDefaultSuite objectForKey:@"batteryHeath"] componentsSeparatedByString:@"%"][0];
    //电池真实电量=出场电量*电池健康度*当前电池level
    float actualBattery = oriBattery.floatValue * (batteryHeathy.floatValue/100) * level;

    NSLog(@"\nBattery：%@  ,%@ , %@",oriBattery,batteryLevel,batteryState);
    self.batteryLevelLbl.text = [NSString stringWithFormat:@"%@mAh  %@",oriBattery,batteryLevel];
    self.batteryStateLbl.text = batteryState;
    self.batteryRescLabel.text = [NSString stringWithFormat:@"%@:%.0fmAh",HLLocalized(@"Real Remain"),actualBattery];

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

- (UILabel *)batteryLevelLbl {
    if (_batteryLevelLbl == nil) {
        _batteryLevelLbl = [UILabel new];
        _batteryLevelLbl.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
        _batteryLevelLbl.dk_textColorPicker = DKColorPickerWithRGB(0x4A4A4A,0x9B9B9B);
    }
    return _batteryLevelLbl;
}

- (UILabel *)batteryStateLbl {
    if (_batteryStateLbl == nil) {
        _batteryStateLbl = [UILabel new];
        _batteryStateLbl.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
        _batteryStateLbl.dk_textColorPicker = DKColorPickerWithRGB(0x4A4A4A,0x9B9B9B);
    }
    return _batteryStateLbl;
}

- (UILabel *)batteryRescLabel {
    if (_batteryRescLabel == nil) {
        _batteryRescLabel = [UILabel new];
        _batteryRescLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
        _batteryRescLabel.dk_textColorPicker = DKColorPickerWithRGB(0x4A4A4A,0x9B9B9B);
    }
    return _batteryRescLabel;
}
- (UIProgressView *)progressView {
    if (_progressView == nil) {
        _progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
        _progressView.dk_trackTintColorPicker     = DKColorPickerWithRGB(0xF0F0F1,0x34343D);
        _progressView.progressTintColor  = [UIColor colorWithHex:@"0x2ED573"];
        _progressView.layer.cornerRadius = 4;
        _progressView.layer.masksToBounds = YES;
    }
    return _progressView;
}

@end
