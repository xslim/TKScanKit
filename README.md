# TKScanKit
<!--
[![Version](http://cocoapod-badges.herokuapp.com/v/TKScanKit/badge.png)](http://cocoadocs.org/docsets/TKScanKit)
[![Platform](http://cocoapod-badges.herokuapp.com/p/TKScanKit/badge.png)](http://cocoadocs.org/docsets/TKScanKit)
-->

TKScanKit is a Cocoapods only library, inspired by ARAnalytics, which provides a clean API for different scanning SDKs. It does this by using subspecs from CocoaPods to let you decide which libraries you'd like to use.

## Usage

To get list of loaded providers:
``` obj-c
NSArray *items = [TKScanKit availableProviders];
```

To start scanning:
``` obj-c
TKScanningProvider *provider = [TKScanKit newProviderWithName:@"ZBarSDK"];
provider.delegate = self;
[provider presentScannerFromViewController:viewController];
self.scanningProvider = provider;
```

Or
``` obj-c
self.currentProvider = [TKScanKit presentScanner:@"ZBarSDK" fromViewController:self];
```

And became a delegate of `TKScanningProviderDelegate`:
``` obj-c
- (void)scanningProvider:(TKScanningProvider *)provider didFinishScanningWithText:(NSString *)text info:(NSDictionary *)info
{
    NSString *title = [NSString stringWithFormat:@"Scanned: %@", text];
    [self showMessageWithTitle:title text:[info description]];
}

- (void)scanningProviderDidCancel:(TKScanningProvider *)provider { }

- (void)scanningProvider:(TKScanningProvider *)provider didFailedScanningWithError:(NSError *)error
{
    [self showMessageWithTitle:@"Error" text:[error localizedDescription]];
}
```

To run the example project: 

- clone the repo
- run `pod install` from the `TKScanKitApp` directory
- Try it

## Supported scanning providers
- [ZBarSDK](http://zbar.sourceforge.net/iphone/sdkdoc/)
- [CDZQRScanningViewController](https://github.com/cdzombak/CDZQRScanningViewController)
- [ScanditSDK](http://www.scandit.com/barcode-scanner-sdk/)
- MDCBarcodePicker, 3-d party iOS 7 scanning thing

Feel free to add more!
  
## Installation

TKScanKit is available through [CocoaPods](http://cocoapods.org), to install
it simply add the following line to your Podfile:

    pod "TKScanKit"

## Author

Taras Kalapun, t.kalapun@gmail.com

## License

TKScanKit is available under the MIT license. See the LICENSE file for more info.

