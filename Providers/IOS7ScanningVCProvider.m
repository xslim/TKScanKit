//
//  TKScanKit
//
//  Copyright (c) 2013 Taras Kalapun. All rights reserved.
//

#import "IOS7ScanningVCProvider.h"
#import "CDZQRScanningViewController.h"

@interface IOS7ScanningVCProvider ()

@end

@implementation IOS7ScanningVCProvider
#ifdef TKSK_IOS7SCANNINGVC_EXISTS

+ (NSString *)providerName
{
    return @"CDZQRScanningViewController";
}

- (void)presentScannerFromViewController:(UIViewController *)viewController
{
    // create the scanning view controller and a navigation controller in which to present it:
    CDZQRScanningViewController *scanningVC = [CDZQRScanningViewController new];
    UINavigationController *scanningNavVC = [[UINavigationController alloc] initWithRootViewController:scanningVC];

    __weak __typeof(&*self)weakSelf = self;
    
    // configure the scanning view controller:
    scanningVC.resultBlock = ^(NSString *result) {
        //NSDictionary *info = @{@"result": result};
        [weakSelf finishedScanningWithText:result];
        //[weakSelf finishedScanningWithInfo:info];
    };
    scanningVC.cancelBlock = ^() {
        [weakSelf cancelledScanning];
    };
    scanningVC.errorBlock = ^(NSError *error) {
        [weakSelf failedScanningWithError:error];
    };
    
    self.scannerController = scanningVC;
    
    // present the view controller full-screen on iPhone; in a form sheet on iPad:
    scanningNavVC.modalPresentationStyle = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? UIModalPresentationFullScreen : UIModalPresentationFormSheet;
    [viewController presentViewController:scanningNavVC animated:YES completion:nil];
    
}

#endif
@end