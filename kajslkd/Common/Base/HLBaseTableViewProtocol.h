//
//  HLBaseTableViewProtocol.h
//  iSystant Lite
//
//  Created by HanLiu on 2019/11/6.
//  Copyright © 2019 iSystant. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HLSystemMonitor.h"

NS_ASSUME_NONNULL_BEGIN

@protocol HLBaseTableViewProtocol <NSObject>

- (void)configSubViews;
- (void)configLayout;
- (void)configData;

+ (NSString *)reuseIdentifier;
@end

NS_ASSUME_NONNULL_END
