//
//  HLCellViewModel.h
//  iSystant Lite
//
//  Created by HanLiu on 2019/11/7.
//  Copyright © 2019 iSystant. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HLStorageCell.h"
#import "HLMemoryCell.h"
#import "HLCPUCell.h"
#import "HLBatteryCell.h"
#import "HLNetworkCell.h"
#import "HLDeviceCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface HLCellViewModel : NSObject

@property (nonatomic, copy)   NSString *title;
@property (nonatomic, assign) CGFloat rowHeight;
@property (nonatomic, copy) NSString *cellIndentifer;

- (instancetype)initWith:(NSString *)cellIndentifer
               rowHeight:(CGFloat)rowHeight
                   title:(NSString *)title;



@end

NS_ASSUME_NONNULL_END
