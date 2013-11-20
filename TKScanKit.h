//
//  TKScanKit
//
//  Copyright (c) 2013 Taras Kalapun. All rights reserved.
//

#import "TKScanningProvider.h"

@interface TKScanKit : NSObject

+ (NSDictionary *)availableProviders;
+ (TKScanningProvider *)newProviderWithName:(NSString *)providerName;
+ (TKScanningProvider *)presentScanner:(NSString *)providerName fromViewController:(UIViewController <TKScanningProviderDelegate>*)viewController;

@end
