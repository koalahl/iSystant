//
//  HLDetailTableViewCell.m
//  iSystant Lite
//
//  Created by HanLiu on 2019/11/13.
//  Copyright © 2019 iSystant. All rights reserved.
//

#import "HLDetailTableViewCell.h"
@interface HLDetailTableViewCell ()

@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UILabel *detailLbl;

@end
@implementation HLDetailTableViewCell

- (void)configSubViews {
    [super configSubViews];
    [self.contentView addSubview:self.titleLbl];
    [self.contentView addSubview:self.detailLbl];
}

- (void)configLayout {
    [super configLayout];
    
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.centerY.mas_equalTo(0);
        make.width.mas_greaterThanOrEqualTo(40);
        make.height.mas_equalTo(22);
    }];
    [self.detailLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
//        make.right.mas_equalTo(-12);
        make.right.mas_equalTo(-24);
        make.height.mas_equalTo(22);
    }];
}

- (void)configData:(NSDictionary *)dic {
    self.titleLbl.text  = dic[@"name"];
    self.detailLbl.text = dic[@"value"];
}

#pragma mark - Getter

- (UILabel *)titleLbl {
    if (_titleLbl == nil) {
        _titleLbl = [UILabel new];
        _titleLbl.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
        _titleLbl.dk_textColorPicker = DKColorPickerWithRGB(0x4A4A4A,0xFFFFFF);
    }
    return _titleLbl;
}

- (UILabel *)detailLbl {
    if (_detailLbl == nil) {
        _detailLbl = [UILabel new];
        _detailLbl.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
        _detailLbl.dk_textColorPicker = DKColorPickerWithRGB(0x4A4A4A,0x9B9B9B);
    }
    return _detailLbl;
}
@end
