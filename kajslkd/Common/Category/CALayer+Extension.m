//
//  CALayer+Extension.m
//  iSystant Lite
//
//  Created by HanLiu on 2019/11/6.
//  Copyright © 2019 iSystant. All rights reserved.
//

#import "CALayer+Extension.h"
#import <UIKit/UIKit.h>

@implementation CALayer (Extension)

- (void)applySketchShadow:(UIColor *)color
                    alpha:(CGFloat)alpha
                        x:(CGFloat)x
                        y:(CGFloat)y
                     blur:(CGFloat)blur
                   spread:(CGFloat)spread {
    self.shadowColor   = color?color.CGColor:[UIColor blackColor].CGColor;
    self.shadowOpacity = alpha;
    self.shadowOffset  = CGSizeMake(x, y);
    self.shadowRadius  = blur / 2.0;
    if (spread == 0) {
        self.shadowPath = nil;
    }else {
        CGFloat dx = -spread;
        CGRect rect = CGRectMake(self.bounds.origin.x+dx, self.bounds.origin.y+dx, self.bounds.size.width+dx*2, self.bounds.size.height+dx*2);
        self.shadowPath = [UIBezierPath bezierPathWithRect:rect].CGPath;
    }
    
}
@end
