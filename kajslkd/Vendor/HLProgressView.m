//
//  HLProgressView.m
//  iSystant Lite
//
//  Created by HanLiu on 2019/11/9.
//  Copyright © 2019 iSystant. All rights reserved.
//

#import "HLProgressView.h"

@implementation HLProgressView

- (void)setProgress:(float)progress {
    super.progress = progress;
    if (progress < 1.0 && progress > 0.75) {
        //红色
        self.progressTintColor = [UIColor colorWithHex:@"FF4757"];
       
    }else if (progress <= 0.75 && progress > 0.5) {
        //橙色
        self.progressTintColor = [UIColor colorWithHex:@"0xFFA502"];
        
    }else if (progress <= 0.5 && progress > 0.25) {
        //淡绿
        self.progressTintColor = [UIColor colorWithHex:@"9fdfcd"];
    }else {
        //绿色
        self.progressTintColor = [UIColor colorWithHex:@"0x2ED573"];
    }
}

@end
