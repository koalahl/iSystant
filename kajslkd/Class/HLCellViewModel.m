//
//  HLCellViewModel.m
//  iSystant Lite
//
//  Created by HanLiu on 2019/11/7.
//  Copyright © 2019 iSystant. All rights reserved.
//

#import "HLCellViewModel.h"



@implementation HLCellViewModel

- (instancetype)initWith:(NSString *)cellIndentifer
               rowHeight:(CGFloat)rowHeight
                   title:(NSString *)title {
    if (self == [super init]) {
        _title = title;
        _rowHeight = rowHeight;
        _cellIndentifer = cellIndentifer;
    }
    return self;
}

@end
