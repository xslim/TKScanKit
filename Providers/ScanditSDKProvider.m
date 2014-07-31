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

@synthesize scannerController=_scannerController;

- (UIViewController *)scannerController
{
    if (!_scannerController) {
        if (!self.appKey) {
            self.appKey = @"5Uh0rsIDEeKQasEwzWTVCJOWVY0h8m5L8/7tFVhhJmk";
            //self.appKey = @"yIEPYlHWEeOXIVmiVOy7cX4H1tURXXfLg8TJoRK4TbA";
        }
        ScanditSDKBarcodePicker *vc = [[ScanditSDKBarcodePicker alloc] initWithAppKey:self.appKey];
        
        ScanditSDKOverlayController *ovc = vc.overlayController;
        ovc.delegate = self;
        [ovc setTorchEnabled:NO];
        [ovc showToolBar:NO];
        [ovc showSearchBar:NO];
        
        if (self.isIntegrated) {
            self.dismissOnFinish = NO;
            self.shouldRestart = NO;
            //[ovc drawViewfinder:NO];

            //[ovc setViewfinderHeight:50 width:50 landscapeHeight:50 landscapeWidth:50];
            //[ovc setViewfinderColor:0.949 green:0.008 blue:0.008];
        }
        
        _scannerController = vc;
    }
    return _scannerController;
}

- (void)start
{
    [(ScanditSDKBarcodePicker *)self.scannerController startScanning];
}

- (void)stop
{
    [(ScanditSDKBarcodePicker *)self.scannerController stopScanning];
}

- (void)setSize:(CGSize)size
{
    [(ScanditSDKBarcodePicker *)self.scannerController setSize:size];
}

- (void)presentScannerFromViewController:(UIViewController *)viewController options:(NSDictionary *)o
{
    ScanditSDKBarcodePicker *vc = (id)self.scannerController;
    
    BOOL bTorch = o[@"torch"] ? [o[@"torch"] boolValue] : YES;
    BOOL bSearch = o[@"searchBar"] ? [o[@"searchBar"] boolValue] : YES;
    CameraSwitchVisibility camVis = (o[@"cameraSwitch"] && ![o[@"cameraSwitch"] boolValue]) ? CAMERA_SWITCH_NEVER : CAMERA_SWITCH_ALWAYS;
    
    ScanditSDKOverlayController *ovc = vc.overlayController;
    [ovc setTorchEnabled:bTorch];
    [ovc setCameraSwitchVisibility:camVis];
    [ovc showToolBar:YES];
    
    [ovc showSearchBar:bSearch];
    [ovc setSearchBarKeyboardType:UIKeyboardTypeDefault];
    [ovc setMinSearchBarBarcodeLength:3];
    
    [ovc setToolBarButtonCaption:NSLocalizedString(@"Cancel", nil)];
    [ovc setSearchBarPlaceholderText:NSLocalizedString(@"Scan barcode or enter it here", nil)];
    
    [vc disableStandbyState];
    
    self.dismissOnFinish = YES;
    
    
    [viewController presentViewController:self.scannerController animated:YES completion:nil];
    [self start];
}

- (UIView *)scanningView
{
    return self.scannerController.view;
}

- (void)scanditSDKOverlayController:(ScanditSDKOverlayController *)overlayController
                     didScanBarcode:(NSDictionary *)barcodeResult
{
    UIViewController *pvc = self.scannerController.presentingViewController;
    if ([pvc isBeingPresented] || [pvc isBeingDismissed]) {
        return;
    }
    
    [self stop];
    
    @synchronized(self) {
        if (!self.isProcessingResults) {
            self.isProcessingResults = YES;
            
            // Wait just a little while before handling the barcode
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                if (barcodeResult) {
                    NSString *symbology = [barcodeResult objectForKey:@"symbology"];
                    NSString *barcode = [barcodeResult objectForKey:@"barcode"];
                    if ([symbology isEqualToString:@"UPC12"] && [barcode length] == 12) {
                        // Force UPC12 barcodes to be handled as EAN13 barcodes
                        symbology = @"EAN13";
                        barcode = [@"0" stringByAppendingString:barcode];
                    }
                    
                    //NSLog(@"Scanned barcode (%@): %@", symbology, barcode);
                    self.isProcessingResults = NO;
                    
                    if (self.isIntegrated) {
                        ScanditSDKOverlayController *ovc = [(ScanditSDKBarcodePicker *)self.scannerController overlayController];
                        [ovc resetUI];
                        [self finishedScanningWithText:barcode info:barcodeResult];
                        if (self.shouldRestart) {
                            [self start];
                        }
                        
                    } else {
                        
                        [self finishedScanningWithText:barcode info:barcodeResult];
                    }
                }
            });
        } else {
            NSLog(@"WARNING: ScanditSDK delegate called twice");
        }
    }
}

- (void)scanditSDKOverlayController:(ScanditSDKOverlayController *)overlayController
                didCancelWithStatus:(NSDictionary *)status
{
    
    [self stop];
    [self cancelledScanning];
}

- (void)scanditSDKOverlayController:(ScanditSDKOverlayController *)overlayController
                    didManualSearch:(NSString *)text
{
    [[(ScanditSDKBarcodePicker *)self.scannerController overlayController] resetUI];
    
	[self stop];
    
    [self finishedScanningWithText:text info:nil];
    
}

//- (void)finishedScanningWithText:(NSString *)text info:(NSDictionary *)info {
//    [super finishedScanningWithText:text info:info];
//    [(ScanditSDKBarcodePicker *)self.scannerController forceRelease];
//}

//

#endif
@end