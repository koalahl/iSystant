//
//  HLDeviceCell.m
//  iSystant Lite
//
//  Created by HanLiu on 2019/11/7.
//  Copyright © 2019 iSystant. All rights reserved.
//

#import "HLDeviceCell.h"

@interface HLDeviceCell()

@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UILabel *diskInfo;
@property (nonatomic, strong) UILabel *buildLabel;
@property (nonatomic, strong) UILabel *pubIPLabel;

@end

@implementation HLDeviceCell

- (void)configSubViews {
    [super configSubViews];
    [self.contentView addSubview:self.icon];
    [self.contentView addSubview:self.titleLbl];
    [self.contentView addSubview:self.diskInfo];
    [self.contentView addSubview:self.buildLabel];
    [self.contentView addSubview:self.pubIPLabel];

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
    [self.diskInfo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLbl.mas_bottom).offset(16);
        make.left.equalTo(self.titleLbl.mas_left);
        make.width.mas_greaterThanOrEqualTo(24);
        make.height.mas_equalTo(22);
    }];
    [self.buildLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLbl.mas_bottom).offset(16);
        make.right.mas_equalTo(-24);
        make.height.mas_equalTo(22);
    }];
    [self.pubIPLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLbl.mas_bottom).offset(16);
        make.left.equalTo(self.diskInfo.mas_right).offset(10);
        make.right.mas_equalTo(-24);
        make.height.mas_equalTo(22);
    }];
}

- (void)configData {
    [self configDeviceData];
}

- (void)configDeviceData {
    
    NSString *iphoneName    = [NSString stringWithFormat:@"%@ %@",HLLocalized(@"Welcome"), [HLDeviceInformation getiPhoneName]];
    NSString *deviceModel   = [HLDeviceInformation getDeviceName];
    NSString *sysVerion     = [HLDeviceInformation getSystemVersion];
    NSString *sysBuild      = [HLDeviceInformation getSystemBuildVersion];
    NSString *origBatteryVol= [HLDeviceInformation sharedInstance].deviceDict[@"Battery"];
    
    NSLog(@"\n设备信息：\n%@\n%@\n%@\n%@\n%@\n",iphoneName,deviceModel,sysVerion,sysBuild,origBatteryVol);
    self.titleLbl.text = iphoneName;
    self.diskInfo.text = [NSString stringWithFormat:@"%@:%@",HLLocalized(@"OS Version"),sysVerion];
    self.buildLabel.text = [NSString stringWithFormat:@"%@:%@",HLLocalized(@"Build") ,sysBuild];
//    self.pubIPLabel.text = [NSString stringWithFormat:@"%@:%@",HLLocalized(@"Public Ip") ,[HLNetworkMonitor network].publicIp];
}

#pragma mark - Getter
- (UIImageView *)icon {
    if (_icon == nil) {
        _icon = [[UIImageView alloc] init];
        _icon.image = [UIImage imageNamed:@"storage_night"];
        _icon.dk_imagePicker = DKImagePickerWithImages([UIImage imageNamed:@"icon_storage_normal"], [UIImage imageNamed:@"storage_night"]);
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

- (UILabel *)diskInfo {
    if (_diskInfo == nil) {
        _diskInfo = [UILabel new];
        _diskInfo.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
        _diskInfo.dk_textColorPicker = DKColorPickerWithRGB(0x4A4A4A,0x9B9B9B);
    }
    return _diskInfo;
}

- (UILabel *)buildLabel {
    if (_buildLabel == nil) {
        _buildLabel = [UILabel new];
        _buildLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
        _buildLabel.dk_textColorPicker = DKColorPickerWithRGB(0x4A4A4A,0x9B9B9B);
    }
    return _buildLabel;
}

- (UILabel *)pubIPLabel {
    if (_pubIPLabel == nil) {
        _pubIPLabel = [UILabel new];
        _pubIPLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
        _pubIPLabel.dk_textColorPicker = DKColorPickerWithRGB(0x4A4A4A,0x9B9B9B);
    }
    return _pubIPLabel;
}

@end
