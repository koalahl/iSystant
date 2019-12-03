//
//  HLLabel.m
//  SystemMonitor
//
//  Created by HanLiu on 2018/12/6.
//  Copyright © 2018 HanLiu. All rights reserved.
//

#import "HLLabel.h"

@implementation HLLabel

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setUp];
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    [self setUp];
}

- (void)setUp {
    /* 你可以在这里添加一些代码，比如字体、居中、夜间模式等 */
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress)]];
}

- (void)longPress {
    
    // 设置label为第一响应者
    [self becomeFirstResponder];
    
    // 自定义 UIMenuController
    UIMenuController * menu = [UIMenuController sharedMenuController];
    UIMenuItem * item1 = [[UIMenuItem alloc]initWithTitle:@"复制" action:@selector(copyText:)];
    menu.menuItems = @[item1];
    [menu setTargetRect:self.bounds inView:self];
    [menu setMenuVisible:YES animated:YES];
}

- (void)copyText:(UIMenuController *)menu {
    // 没有文字时结束方法
    if (!self.text) return;
    // 复制文字到剪切板
    UIPasteboard * paste = [UIPasteboard generalPasteboard];
    paste.string = self.text;
    
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if(action == @selector(copyText:)) return YES;
    return NO;
}
- (BOOL)canBecomeFirstResponder {
    return YES;
}

@end
