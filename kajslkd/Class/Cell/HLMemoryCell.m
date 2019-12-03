//
//  HLMemoryCell.m
//  iSystant Lite
//
//  Created by HanLiu on 2019/11/6.
//  Copyright © 2019 iSystant. All rights reserved.
//

#import "HLMemoryCell.h"
#import "HLProgressView.h"

@interface HLMemoryCell ()

@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UILabel *ramInfo;
@property (nonatomic, strong) HLProgressView *progressView;
@property (nonatomic, strong) dispatch_source_t timer;

@end
@implementation HLMemoryCell

- (void)configSubViews {
    [super configSubViews];
    NSLog(@"HLMemoryCell configSubViews");
    [self.contentView addSubview:self.icon];
    [self.contentView addSubview:self.titleLbl];
    [self.contentView addSubview:self.ramInfo];
    [self.contentView addSubview:self.progressView];
    
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

    [self.ramInfo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLbl.mas_bottom).offset(16);
        make.left.equalTo(self.titleLbl.mas_left);
        make.right.mas_equalTo(-24);
        make.height.mas_equalTo(22);
    }];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-24);
        make.left.equalTo(self.ramInfo.mas_left);
        make.height.mas_equalTo(8);
        make.right.mas_equalTo(-24);
    }];
}

- (void)configData {
    if (_timer == nil) {
        __weak typeof(self)wself = self;
        self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
        dispatch_source_set_timer(self.timer, DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
        dispatch_source_set_event_handler(self.timer, ^{
            __strong typeof(wself)strongSelf = wself;
            [strongSelf configMemoryData];
        });
        dispatch_resume(self.timer);
    }
}

- (void)configMemoryData {
    self.titleLbl.text  = HLLocalized(@"Memory");
    NSString *usedRAM   = [HLMemoryMonitor monitor].totalUsedMemory;
    NSString *freeRAM   = [HLMemoryMonitor monitor].totalAvaliableMemory;
    NSString *totalRAM  = [[HLDeviceInformation sharedInstance].deviceDict objectForKey:@"RAM"];
    NSString *totalRAM2 = [HLMemoryMonitor monitor].totalMemory;
    
//    NSLog(@"\n RAM: %@  -- %@ --- %@",usedRAM,totalRAM,totalRAM2 );
    self.ramInfo.text = [NSString stringWithFormat:@"Free:%@   Used:%@   Total:%@",freeRAM,usedRAM,totalRAM2];
    self.progressView.progress = [HLMemoryMonitor monitor].memoryUsagePercentage;
}

#pragma mark - Getter
- (UIImageView *)icon {
    if (_icon == nil) {
        _icon = [[UIImageView alloc] init];
        _icon.dk_imagePicker = DKImagePickerWithImages([UIImage imageNamed:@"icon_memory_normal"], [UIImage imageNamed:@"memory_night"]);
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

- (UILabel *)ramInfo {
    if (_ramInfo == nil) {
        _ramInfo = [UILabel new];
        _ramInfo.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
        _ramInfo.dk_textColorPicker = DKColorPickerWithRGB(0x4A4A4A,0x9B9B9B);
    }
    return _ramInfo;
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
