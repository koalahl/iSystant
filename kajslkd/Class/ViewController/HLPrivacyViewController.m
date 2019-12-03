//
//  HLPrivacyViewController.m
//  SystemMonitor
//
//  Created by HanLiu on 2018/11/11.
//  Copyright © 2018 HanLiu. All rights reserved.
//

#import "HLPrivacyViewController.h"
#import <WebKit/WebKit.h>

@interface HLPrivacyViewController ()
@property (nonatomic, strong) UIActivityIndicatorView *activityView;

@property (nonatomic, weak) IBOutlet UITextView *textview;

@end

@implementation HLPrivacyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = HLLocalized(@"Privacy");
    self.view.dk_backgroundColorPicker = DKColorPickerWithRGB(0xF8F8F8,0x111111);
    self.textview.dk_backgroundColorPicker = DKColorPickerWithRGB(0xF8F8F8,0x111111);

    if (@available(iOS 11.0, *)) {
        self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeNever;
        // Do any additional setup after loading the view.
    } else {
        // Fallback on earlier versions
    }
    
    self.textview.text = HLLocalized(@"PrivacyContent");

}
//
//- (void)setupProgressView {
//
//    self.activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//    self.activityView.size = CGSizeMake(50, 50);
//    self.activityView.center = self.view.center;
//    [self.view addSubview:self.activityView];
//}

- (IBAction)close:(id)sender {
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
//    if ([keyPath isEqualToString:@"estimatedProgress"]) {
//        CGFloat progerss = [[change valueForKey:NSKeyValueChangeNewKey] floatValue];
//        [self.activityView startAnimating];
//        if (progerss >= 0.5) {
//            [self.activityView stopAnimating];
//            self.activityView.hidden = YES;
//        }
//    }
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
