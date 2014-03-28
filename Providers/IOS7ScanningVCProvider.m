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

@synthesize scannerController=_scannerController;

+ (NSString *)providerName
{
    return @"CDZQRScanningViewController";
}

- (UIViewController *)scannerController {
    if (!_scannerController) {
        CDZQRScanningViewController *scanningVC = [CDZQRScanningViewController new];
        __weak typeof(self) weakSelf = self;
        // configure the scanning view controller:
        scanningVC.resultBlock = ^(NSString *result) {
            [weakSelf finishedScanningWithText:result info:nil];
        };
        scanningVC.cancelBlock = ^() {
            [weakSelf cancelledScanning];
        };
        scanningVC.errorBlock = ^(NSError *error) {
            [weakSelf failedScanningWithError:error];
        };
        _scannerController = scanningVC;
    }
    return _scannerController;
}

- (void)presentScannerFromViewController:(UIViewController *)viewController
{
    self.dismissOnFinish = YES;
    [viewController presentViewController:self.scannerController animated:YES completion:nil];
}

#endif
@end
