//
//  HLStorageCell.m
//  iSystant Lite
//
//  Created by HanLiu on 2019/11/6.
//  Copyright © 2019 iSystant. All rights reserved.
//

#import "HLStorageCell.h"
#import "HLProgressView.h"

@interface HLStorageCell ()

@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UILabel *diskInfo;
@property (nonatomic, strong) HLProgressView *progressView;

@end

@implementation HLStorageCell

- (void)configSubViews {
    [super configSubViews];
    NSLog(@"HLStorageCell configSubViews");
    [self.contentView addSubview:self.icon];
    [self.contentView addSubview:self.titleLbl];
    [self.contentView addSubview:self.diskInfo];
    [self.contentView addSubview:self.progressView];

}

- (void)configLayout {
    [super configLayout];
    NSLog(@"HLStorageCell configLayout");
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
        make.right.mas_equalTo(-24);
        make.height.mas_equalTo(22);
    }];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-30);
        make.left.equalTo(self.diskInfo.mas_left);
        make.height.mas_equalTo(8);
        make.right.mas_equalTo(-24);
    }];

}

- (void)configData {
    [self configStorageData];

//    [self.progressView.layer applySketchShadow:[UIColor blackColor] alpha:0.5 x:0 y:3 blur:10 spread:0];

}

- (void)configStorageData {
    NSDictionary *dic = [HLDeviceInformation getDeviceSize];
    NSString *totalDisk = dic[@"totalSpace"];
    NSString *usedDisk  = dic[@"usedSpace"];
    NSString *freeDisk  = dic[@"freeSpace"];
    
    NSLog(@"\ntotalDisk:%@\nusedDisk:%@\nfreeDisk:%@",totalDisk,usedDisk,freeDisk);
    self.titleLbl.text = HLLocalized(@"Storage");
    self.diskInfo.text = [NSString stringWithFormat:@"Free:%@   Used:%@   Total:%@",freeDisk,usedDisk,totalDisk];
    self.progressView.progress = [dic[@"usedPercentage"] floatValue];;
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

- (HLProgressView *)progressView {
    if (_progressView == nil) {
        _progressView = [[HLProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
        _progressView.dk_trackTintColorPicker     = DKColorPickerWithRGB(0xF0F0F1,0x34343D);
        _progressView.progressTintColor  = [UIColor colorWithHex:@"0x2ED573"];
        _progressView.layer.cornerRadius = 4;
        _progressView.layer.masksToBounds = YES;
    }
    return _progressView;
}

@end
