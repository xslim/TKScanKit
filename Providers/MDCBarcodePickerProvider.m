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

- (void)presentScannerFromViewController:(UIViewController *)viewController
{
    MDCBarcodePicker *vc = [[MDCBarcodePicker alloc] initWithDelegate:self];
    self.scannerController = vc;
    [viewController presentViewController:vc animated:YES completion:nil];
}

- (void)mdcBarcodePicker:(MDCBarcodePicker *)picker didScanBarcode:(NSString *)barcode
{
    [self finishedScanningWithText:barcode info:nil];
}

#endif
@end