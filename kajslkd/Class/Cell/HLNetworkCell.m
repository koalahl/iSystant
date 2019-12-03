//
//  HLNetworkCell.m
//  iSystant Lite
//
//  Created by HanLiu on 2019/11/6.
//  Copyright © 2019 iSystant. All rights reserved.
//

#import "HLNetworkCell.h"
#import "HLNetworkMonitor.h"

@interface HLNetworkCell ()

@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UIImageView *uploadSpeedImg;
@property (nonatomic, strong) UIImageView *downloadSpeedImg;
@property (nonatomic, strong) UILabel *uploadSpeedLabel;
@property (nonatomic, strong) UILabel *downloadSpeedLabel;
@property (nonatomic, strong) dispatch_source_t timer;
@end
@implementation HLNetworkCell

- (void)configSubViews {
    [super configSubViews];
    NSLog(@"HLNetworkCell configSubViews");
    
    [self.contentView addSubview:self.icon];
    [self.contentView addSubview:self.titleLbl];
    [self.contentView addSubview:self.uploadSpeedLabel];
    [self.contentView addSubview:self.downloadSpeedLabel];
    [self.contentView addSubview:self.uploadSpeedImg];
    [self.contentView addSubview:self.downloadSpeedImg];

}

- (void)configLayout {
    [super configLayout];
    NSLog(@"HLNetworkCell configLayout");

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
    
    [self.uploadSpeedImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLbl.mas_left);
        make.top.equalTo(self.titleLbl.mas_bottom).offset(10);
        make.height.mas_equalTo(22);
        make.width.mas_equalTo(22);
    }];

    [self.uploadSpeedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.uploadSpeedImg.mas_right).offset(4);
        make.top.equalTo(self.titleLbl.mas_bottom).offset(10);
        make.height.mas_equalTo(22);
        make.width.mas_greaterThanOrEqualTo(36);
    }];

    [self.downloadSpeedImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView).offset(60);
        make.top.equalTo(self.titleLbl.mas_bottom).offset(10);
        make.height.mas_equalTo(22);
        make.width.mas_equalTo(22);
    }];
    
    [self.downloadSpeedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.downloadSpeedImg.mas_right).offset(4);
        make.top.equalTo(self.titleLbl.mas_bottom).offset(10);
        make.height.mas_equalTo(22);
        make.width.mas_greaterThanOrEqualTo(36);
    }];
}

- (void)configData {
    self.titleLbl.text = HLLocalized(@"Network");

    if (_timer == nil) {
        __weak typeof(self)wself = self;
        self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
        dispatch_source_set_timer(self.timer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
        dispatch_source_set_event_handler(self.timer, ^{
            __strong typeof(wself)strongSelf = wself;
            [strongSelf refreshNetworkSpeed];
        });
        dispatch_resume(self.timer);
    }

}

- (void)refreshNetworkSpeed {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *downloadSpeed = [HLNetworkMonitor network].downloadNetworkSpeed;
        NSString *uploadSpeed   = [HLNetworkMonitor network].uploadNetworkSpeed;
        self.uploadSpeedLabel.text   = uploadSpeed;
        self.downloadSpeedLabel.text = downloadSpeed;

    });
}

#pragma mark - Getter
- (UIImageView *)icon {
    if (_icon == nil) {
        _icon = [[UIImageView alloc] init];
        _icon.dk_imagePicker = DKImagePickerWithImages([UIImage imageNamed:@"icon_network_normal"], [UIImage imageNamed:@"network_night"]);
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

- (UILabel *)uploadSpeedLabel {
    if (_uploadSpeedLabel == nil) {
        _uploadSpeedLabel = [UILabel new];
        _uploadSpeedLabel.text = @"0.0B/s";
        _uploadSpeedLabel.textAlignment = NSTextAlignmentLeft;
        _uploadSpeedLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
        _uploadSpeedLabel.dk_textColorPicker = DKColorPickerWithRGB(0x4A4A4A,0x9B9B9B);
    }
    return _uploadSpeedLabel;
}

- (UILabel *)downloadSpeedLabel {
    if (_downloadSpeedLabel == nil) {
        _downloadSpeedLabel = [UILabel new];
        _downloadSpeedLabel.text = @"0.0B/s";
        _downloadSpeedLabel.textAlignment = NSTextAlignmentLeft;
        _downloadSpeedLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
        _downloadSpeedLabel.dk_textColorPicker = DKColorPickerWithRGB(0x4A4A4A,0x9B9B9B);
    }
    return _downloadSpeedLabel;
}

- (UIImageView *)uploadSpeedImg {
    if (_uploadSpeedImg == nil) {
        _uploadSpeedImg = [UIImageView new];
        _uploadSpeedImg.image = [UIImage imageNamed:@"upload"];
    }
    return _uploadSpeedImg;
}

- (UIImageView *)downloadSpeedImg {
    if (_downloadSpeedImg == nil) {
        _downloadSpeedImg = [UIImageView new];
        _downloadSpeedImg.image = [UIImage imageNamed:@"download"];
    }
    return _downloadSpeedImg;
}
@end
