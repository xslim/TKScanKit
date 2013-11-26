//
//  TKScanKit
//
//  Copyright (c) 2013 Taras Kalapun. All rights reserved.
//

#import "MDCBarcodePickerProvider.h"
#ifdef COCOAPODS_POD_AVAILABLE_MDCBarcodePicker
#import "MDCBarcodePicker.h"

@interface MDCBarcodePickerProvider () <MDCBarcodePickerDelegate>

@end

#endif

@implementation MDCBarcodePickerProvider
#if TKSK_MDCBARCODEPICKER_EXISTS && defined(COCOAPODS_POD_AVAILABLE_MDCBarcodePicker)

@synthesize scannerController=_scannerController;

- (UIViewController *)scannerController
{
    if (!_scannerController) {
        MDCBarcodePicker *vc = [[MDCBarcodePicker alloc] initWithDelegate:self];
        
        if (self.isIntegrated) {
            self.dismissOnFinish = NO;
        }
        
        _scannerController = vc;
    }
    return _scannerController;
}

- (void)presentScannerFromViewController:(UIViewController *)viewController
{
    self.dismissOnFinish = YES;
    [viewController presentViewController:self.scannerController animated:YES completion:nil];
}

- (void)mdcBarcodePicker:(MDCBarcodePicker *)picker didScanBarcode:(NSString *)barcode
{
    [self finishedScanningWithText:barcode info:nil];
}

#endif
@end