//
//  CALayer+Extension.h
//  iSystant Lite
//
//  Created by HanLiu on 2019/11/6.
//  Copyright © 2019 iSystant. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface CALayer (Extension)

- (void)applySketchShadow:(UIColor *)color
                    alpha:(CGFloat)alpha
                        x:(CGFloat)x
                        y:(CGFloat)y
                     blur:(CGFloat)blur
                   spread:(CGFloat)spread;
@end

NS_ASSUME_NONNULL_END
