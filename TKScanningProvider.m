//
//  TKScanKit
//
//  Copyright (c) 2013 Taras Kalapun. All rights reserved.
//

#import "TKScanningProvider.h"

@interface TKScanningProvider ()
@property (nonatomic, assign) BOOL dismissInProcess;
@end

@implementation TKScanningProvider

- (id)init
{
    self = [super init];
    if (self) {
        [self presetDefaults];
    }
    return self;
}

#pragma mark - Public

+ (NSString *)providerName {
    return [NSStringFromClass(self) stringByReplacingOccurrencesOfString:@"Provider" withString:@""];;
}

- (void)presentScannerFromViewController:(UIViewController *)viewController { }

#pragma mark - Private

- (void)presetDefaults
{
    self.dismissOnFinish = YES;
}


- (void)dismissIfNeeded
{
    if (!self.dismissOnFinish || self.dismissInProcess) {
        return;
    }
    
    if (!self.scannerController) {
        return;
    }
    
    UIViewController *pvc = self.scannerController.presentingViewController;
    if (!pvc) {
        return;
    }
    
    self.dismissInProcess = YES;
    
    __weak __typeof(&*self)weakSelf = self;
    [pvc dismissViewControllerAnimated:YES completion:^{
        weakSelf.dismissInProcess = NO;
    }];
    
}

#pragma mark - Delegate proxies

- (void)finishedScanningWithText:(NSString *)text
{
    NSLog(@"TKScanKit finishedScanningWithText: %@", text);
    [self dismissIfNeeded];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(scanningProvider:didFinishScanningWithText:)]) {
        [self.delegate scanningProvider:self didFinishScanningWithText:text];
    }
    
    // TODO: Blocks
}

- (void)finishedScanningWithInfo:(NSDictionary *)info
{
    NSLog(@"TKScanKit finishedScanningWithInfo: %@", info);
    [self dismissIfNeeded];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(scanningProvider:didFinishScanningWithInfo:)]) {
        [self.delegate scanningProvider:self didFinishScanningWithInfo:info];
    }
    
    // TODO: Blocks
}

- (void)cancelledScanning
{
    NSLog(@"TKScanKit cancelledScanning");
    [self dismissIfNeeded];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(scanningProviderDidCancel:)]) {
        [self.delegate scanningProviderDidCancel:self];
    }
    
    // TODO: Blocks
}

- (void)failedScanningWithError:(NSError *)error
{
    NSLog(@"TKScanKit failedScanningWithError: %@", [error debugDescription]);
    [self dismissIfNeeded];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(scanningProvider:didFailedScanningWithError:)]) {
        [self.delegate scanningProvider:self didFailedScanningWithError:error];
    }
    
    // TODO: Blocks
}

@end