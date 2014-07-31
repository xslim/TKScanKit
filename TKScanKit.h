//
//  TKScanKit
//
//  Copyright (c) 2013 Taras Kalapun. All rights reserved.
//

#import "TKScanningProvider.h"
#import "TKScaningProviderViewController.h"

@interface TKScanKit : NSObject

+ (NSDictionary *)availableProviders;

+ (TKScanningProvider *)newProviderWithName:(NSString *)providerName;

+ (UIView *)newScanningViewWithProvider:(NSString *)providerName delegate:(id <TKScanningProviderDelegate>*)viewController;

+ (TKScanningProvider *)presentScanner:(NSString *)providerName fromViewController:(UIViewController <TKScanningProviderDelegate>*)viewController;


/*
 Default Options:
@{
 @"torch": @(YES),
 @"searchBar": @(YES),
 @"cameraSwitch": @(YES)
}
 */

+ (TKScanningProvider *)presentScanner:(NSString *)providerName fromViewController:(UIViewController <TKScanningProviderDelegate>*)viewController options:(NSDictionary *)options;

// Set Scanner class as a value class TKDefaultScanningProvider
// [userDefaults]
+ (NSString *)defaultProvider;
+ (TKScanningProvider *)presentDefaultScannerFromViewController:(UIViewController <TKScanningProviderDelegate>*)viewController;
+ (TKScanningProvider *)presentDefaultScannerFromViewController:(UIViewController <TKScanningProviderDelegate>*)viewController options:(NSDictionary *)options;

@end
