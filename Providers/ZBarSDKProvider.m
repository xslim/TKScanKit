//
//  TKScanKit
//
//  Copyright (c) 2013 Taras Kalapun. All rights reserved.
//

#import "ZBarSDKProvider.h"
#import <ZBarSDK/ZBarReaderViewController.h>
#import <ZBarSDK/ZBarReaderView.h>

@interface ZBarSDKProvider () <ZBarReaderDelegate>

@end

@implementation ZBarSDKProvider
#ifdef TKSK_ZBARSDK_EXISTS

@synthesize scannerController=_scannerController;

- (UIViewController *)scannerController
{
    if (!_scannerController) {
        ZBarReaderViewController *vc = [[ZBarReaderViewController alloc] init];
        vc.readerDelegate = self;

        ZBarImageScanner *scanner = vc.scanner;
        // Disable rarely used I2/5 to improve performance
        [scanner setSymbology:ZBAR_I25
                       config:ZBAR_CFG_ENABLE
                           to:0];

        [scanner setSymbology: ZBAR_UPCA
                            config: ZBAR_CFG_ENABLE
                            to: 1];

        if (self.isIntegrated) {
            self.dismissOnFinish = NO;
            vc.showsZBarControls = NO;
            vc.showsCameraControls = NO;
        }

        _scannerController = vc;
    }
    return _scannerController;
}

- (void)start {};
- (void)stop {};

- (void)setSize:(CGSize)size
{

}

- (void)configureDefaultsForScanner:(ZBarImageScanner *)scanner
{

}

- (void)presentScannerFromViewController:(UIViewController *)viewController
{
    self.dismissOnFinish = YES;
    [viewController presentViewController:self.scannerController animated:NO completion:nil];
}

- (UIView *)scanningView
{
    ZBarReaderView *v = [[ZBarReaderView alloc] init];
    v.readerDelegate = self;

    return v;
}

#pragma mark - Delegates

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    id<NSFastEnumeration> results = [info objectForKey:ZBarReaderControllerResults];
    NSString *barcode = nil;

    for (ZBarSymbol *symbol in results) {
        // Just grab the first barcode
        barcode = symbol.data;
        break;
    }

    [self finishedScanningWithText:barcode info:info];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self cancelledScanning];
}

// called when no barcode is found in an image selected by the user.
// if retry is NO, the delegate *must* dismiss the controller
- (void)readerControllerDidFailToRead:(ZBarReaderController *)reader withRetry:(BOOL)retry
{
    [self failedScanningWithError:nil];
}

- (void) readerView: (ZBarReaderView*) readerView
     didReadSymbols: (ZBarSymbolSet*) symbols
          fromImage: (UIImage*) image
{
    NSString *barcode = nil;

    for (ZBarSymbol *symbol in symbols) {
        // Just grab the first barcode
        barcode = symbol.data;
        break;
    }

    [self finishedScanningWithText:barcode info:nil];
}


//- (void) readerViewDidStart: (ZBarReaderView*) readerView;
- (void)readerView: (ZBarReaderView*) readerView
   didStopWithError: (NSError*) error
{
    [self failedScanningWithError:error];
}

#endif
@end
