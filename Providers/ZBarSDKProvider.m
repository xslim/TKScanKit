//
//  TKScanKit
//
//  Copyright (c) 2013 Taras Kalapun. All rights reserved.
//

#import "ZBarSDKProvider.h"
#import <ZBarSDK/ZBarReaderViewController.h>

@interface ZBarSDKProvider () <ZBarReaderDelegate>

@end

@implementation ZBarSDKProvider
#ifdef TKSK_ZBARSDK_EXISTS

- (void)presentScannerFromViewController:(UIViewController *)viewController
{
    ZBarReaderViewController *vc = [[ZBarReaderViewController alloc] init];
    vc.readerDelegate = self;
    
    ZBarImageScanner *scanner = vc.scanner;
    
    // Disable rarely used I2/5 to improve performance
    [scanner setSymbology:ZBAR_I25
                   config:ZBAR_CFG_ENABLE
                       to:0];
    
    
    self.scannerController = vc;
    [viewController presentViewController:vc animated:YES completion:nil];
}

#pragma mark - Delegates

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    id<NSFastEnumeration> results = [info objectForKey:ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    NSString *barcode = nil;
    
    for (symbol in results) {
        // Just grab the first barcode
        barcode = symbol.data;
        break;
    }
    
    [self finishedScanningWithText:barcode];
    [self finishedScanningWithInfo:info];
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

#endif
@end