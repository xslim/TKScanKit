//
//  TKScanKitView.h
//  Pods
//
//  Created by Taras Kalapun on 25/11/13.
//
//

#import "TKScanKit.h"

@interface TKScaningProviderViewController : UIViewController

@property (nonatomic, weak) IBOutlet id <TKScanningProviderDelegate> delegate;
@property (nonatomic, strong) TKScanningProvider *provider;

@end
