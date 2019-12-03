//
//  HLFeedback.m
//  SystemMonitor
//
//  Created by HanLiu on 2018/11/11.
//  Copyright © 2018 HanLiu. All rights reserved.
//

#import "HLFeedback.h"
#import <MessageUI/MFMailComposeViewController.h>
#import <StoreKit/StoreKit.h>



@interface HLFeedback()<MFMailComposeViewControllerDelegate,SKStoreProductViewControllerDelegate>

@end
@implementation HLFeedback
+ (instancetype)sharedInstance {
    static HLFeedback *feedback = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        feedback = [[HLFeedback alloc] init];
    });
    return feedback;
}

- (void)sendFeedback
{
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    if (!mailClass) {
        [self alertWithMessage:@"当前系统版本不支持应用内发送邮件功能，您可以使用mailto方法代替"];
        return;
    }
    if (![mailClass canSendMail]) {
        [self alertWithMessage:@"用户没有设置邮件账户"];
        return;
    }
    [self displayMailPicker];
}

- (void)sendRate {

    UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"喜欢这个App吗?给个五星好评吧!" message:nil preferredStyle:UIAlertControllerStyleAlert];
    //跳转APPStore 中应用的撰写评价页面
    UIAlertAction *review = [UIAlertAction actionWithTitle:@"我要吐槽" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self rateInAppStore];
    }];
    //不做任何操作
    UIAlertAction *noReview = [UIAlertAction actionWithTitle:@"用用再说" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [alertVC removeFromParentViewController];
    }];
    
    [alertVC addAction:review];
    [alertVC addAction:noReview];
    
    
    if (@available(iOS 10.3, *)) {//判断系统,是否添加五星好评的入口
        if([SKStoreReviewController respondsToSelector:@selector(requestReview)]){
            UIAlertAction *fiveStar = [UIAlertAction actionWithTitle:@"五星好评" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [[UIApplication sharedApplication].keyWindow endEditing:YES];
                [SKStoreReviewController requestReview];
            }];
            [alertVC addAction:fiveStar];
        }
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIViewController topViewController] presentViewController:alertVC animated:YES completion:nil];
    });

}

- (void)rateInAppStore {
    //应用内打开App store 页面，可以撰写评论。
    NSURL *appReviewUrl = [NSURL URLWithString:[NSString stringWithFormat: @"itms-apps://itunes.apple.com/app/id%@?action=write-review",KAPPID]];//换成你应用的 APPID
    //CGFloat version = [[[UIDevice currentDevice]systemVersion]floatValue];
    /// 大于等于10.0系统使用此openURL方法
    if (@available (iOS 10.3,*)) {
        [[UIApplication sharedApplication] openURL:appReviewUrl options:@{} completionHandler:nil];
    }else {
        [[UIApplication sharedApplication] openURL:appReviewUrl];
    }

}
//代理方法
#pragma mark - SKStoreProductViewControllerDelegate
- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController {
    [[UIViewController topViewController] dismissViewControllerAnimated:YES completion:^{
        //[self alertWithMessage:@"Thanks for your comment!"];
    }];
}
- (void)alertWithMessage:(NSString *)msg {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"" message:msg preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [[UIViewController topViewController]  presentViewController:alertVC animated:YES completion:nil];
}


#pragma mark - 发邮件
//调出邮件发送窗口
- (void)displayMailPicker
{
    MFMailComposeViewController *mailPicker = [[MFMailComposeViewController alloc] init];
    mailPicker.mailComposeDelegate = self;
    
    //设置主题
    [mailPicker setSubject: [NSString stringWithFormat:@"[iSystant Lite]%@",HLLocalized(@"feedback")]];
    //添加收件人
    NSArray *toRecipients = [NSArray arrayWithObject: @"weakstrongself@gmail.com"];
    [mailPicker setToRecipients: toRecipients];
    //添加抄送
    NSArray *ccRecipients = [NSArray arrayWithObjects:@"", nil];
    [mailPicker setCcRecipients:ccRecipients];
    //添加密送
    NSArray *bccRecipients = [NSArray arrayWithObjects:@"", nil];
    [mailPicker setBccRecipients:bccRecipients];
    
    // 添加一张图片
    //    UIImage *addPic = [UIImage imageNamed: @"Icon@2x.png"];
    //    NSData *imageData = UIImagePNGRepresentation(addPic);            // png
    //    //关于mimeType：http://www.iana.org/assignments/media-types/index.html
    //    [mailPicker addAttachmentData: imageData mimeType: @"" fileName: @"Icon.png"];
    
    //添加一个pdf附件
    //    NSString *file = [self fullBundlePathFromRelativePath:@"高质量C++编程指南.pdf"];
    //    NSData *pdf = [NSData dataWithContentsOfFile:file];
    //    [mailPicker addAttachmentData: pdf mimeType: @"" fileName: @"高质量C++编程指南.pdf"];
    
   
    NSString *emailBodyWithdeviceInfo = [NSString stringWithFormat:@"%@ <br><br><br><br>%@:%@ <br>%@:%@<br>",HLLocalized(@"feedbackBodyTitle"),HLLocalized(@"OS Version"),[UIDevice currentDevice].systemVersion,HLLocalized(@"AppVersion"),[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    
    [mailPicker setMessageBody:emailBodyWithdeviceInfo isHTML:YES];
    [[UIViewController topViewController] presentViewController:mailPicker animated:YES completion:nil];
}
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(nullable NSError *)error{
    //关闭邮件发送窗口
    [[UIViewController topViewController] dismissViewControllerAnimated:YES completion:nil];
    //    NSString *msg;
    //    switch (result) {
    //            case MFMailComposeResultCancelled:
    //                msg = @"用户取消编辑邮件";
    //                break;
    //            case MFMailComposeResultSaved:
    //                msg = @"用户成功保存邮件";
    //                    break;
    //            case MFMailComposeResultSent:
    //                    msg = @"用户点击发送，将邮件放到队列中，还没发送";
    //                    break;
    //            case MFMailComposeResultFailed:
    //                    msg = @"用户试图保存或者发送邮件失败";
    //                    break;
    //            default:
    //                    msg = @"";
    //                    break;
    //        }
    //   [self alertWithMessage:msg];
}

@end
