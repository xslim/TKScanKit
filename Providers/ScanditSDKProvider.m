//
//  TKScanKit
//
//  Copyright (c) 2013 Taras Kalapun. All rights reserved.
//

#import "ScanditSDKProvider.h"


#ifdef COCOAPODS_POD_AVAILABLE_ScanditSDK
#import "ScanditSDKBarcodePicker.h"
#import "ScanditSDKOverlayController.h"

@interface ScanditSDKProvider ()<ScanditSDKOverlayControllerDelegate>

@end

#endif

@implementation ScanditSDKProvider
#if TKSK_SCANDITSDK_EXISTS && defined(COCOAPODS_POD_AVAILABLE_ScanditSDK)

- (void)presentScannerFromViewController:(UIViewController *)viewController
{
    if (!self.appKey) {
        self.appKey = @"5Uh0rsIDEeKQasEwzWTVCJOWVY0h8m5L8/7tFVhhJmk";
    }
    ScanditSDKBarcodePicker *vc = [[ScanditSDKBarcodePicker alloc] initWithAppKey:self.appKey];
    
    ScanditSDKOverlayController *ovc = vc.overlayController;
    ovc.delegate = self;
    [ovc setTorchEnabled:YES];
    [ovc setCameraSwitchVisibility:CAMERA_SWITCH_ALWAYS];
    [ovc showToolBar:YES];
    [ovc showSearchBar:YES];
    
    self.scannerController = vc;
    [viewController presentViewController:vc animated:YES completion:nil];
    [vc startScanning];
}

- (void)scanditSDKOverlayController:(ScanditSDKOverlayController *)overlayController
                     didScanBarcode:(NSDictionary *)barcode
{
    [(ScanditSDKBarcodePicker *)self.scannerController stopScanning];
    
    NSString *symbology = [barcode objectForKey:@"symbology"];
    NSString *barcodeStr= [barcode objectForKey:@"barcode"];
    if ([symbology isEqualToString:@"UPC12"] && [barcodeStr length] == 12) {
        // Force UPC12 barcodes to be handled as EAN13 barcodes
        symbology = @"EAN13";
        barcodeStr = [@"0" stringByAppendingString:barcodeStr];
    }
    
    [self finishedScanningWithText:barcodeStr];
    
    [self finishedScanningWithInfo:barcode];

}

- (void)scanditSDKOverlayController:(ScanditSDKOverlayController *)overlayController
                didCancelWithStatus:(NSDictionary *)status
{
    [(ScanditSDKBarcodePicker *)self.scannerController stopScanning];
    
    [self cancelledScanning];
}

- (void)scanditSDKOverlayController:(ScanditSDKOverlayController *)overlayController
                    didManualSearch:(NSString *)text
{
    [[(ScanditSDKBarcodePicker *)self.scannerController overlayController] resetUI];
    
	[(ScanditSDKBarcodePicker *)self.scannerController stopScanning];
    
    
    [self finishedScanningWithText:text];
//    NSDictionary *info = @{@"result": text};
//    [self finishedScanningWithInfo:info];
    
}

#endif
@end