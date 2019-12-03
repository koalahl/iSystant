//
//  HLBaseTableViewCell.m
//  iSystant Lite
//
//  Created by HanLiu on 2019/11/6.
//  Copyright © 2019 iSystant. All rights reserved.
//

#import "HLBaseTableViewCell.h"
@interface HLBaseTableViewCell ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *line;

@end
@implementation HLBaseTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self configSubViews];
        [self configLayout];
        [self configData];
        self.dk_backgroundColorPicker = DKColorPickerWithRGB(0xFFFFFF,0x111111);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self configSubViews];
    [self configLayout];
    [self configData];
    self.dk_backgroundColorPicker = DKColorPickerWithRGB(0xFFFFFF,0x111111);
    self.selectionStyle = UITableViewCellSelectionStyleNone;

}

- (void)configSubViews {
//    [self.contentView addSubview:self.bgView];
//    [self.contentView addSubview:self.line];
}

- (void)configLayout {
//    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(12);
//        make.right.mas_equalTo(-12);
//        make.top.mas_equalTo(10);
//        make.bottom.mas_equalTo(-10);
//    }];
//    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(1);
//        make.left.mas_equalTo(64);
//        make.right.mas_equalTo(-12);
//        make.bottom.mas_equalTo(-1);
//    }];
}

- (void)configData {
//    [self setNeedsLayout];
//    [self layoutIfNeeded];
//    [self.bgView.layer applySketchShadow:[UIColor blackColor] alpha:0.5 x:0 y:3 blur:10 spread:0];
}

+ (NSString *)reuseIdentifier {
    return NSStringFromClass([self class]);
}

- (UIView *)bgView {
    if (_bgView == nil) {
        _bgView = [UIView new];
        _bgView.dk_backgroundColorPicker = DKColorPickerWithRGB(0xFFFFFF,0x111111);
        _bgView.layer.cornerRadius = 10;
        _bgView.layer.masksToBounds = YES;
    }
    return _bgView;
}

- (UIView *)line {
    if (_line == nil) {
        _line = [UIView new];
        _line.backgroundColor = [UIColor colorWithHex:@"F8F8F8"];
    }
    return _line;
}
@end
