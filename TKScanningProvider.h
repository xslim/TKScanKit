//
//  TKScanKit
//
//  Copyright (c) 2013 Taras Kalapun. All rights reserved.
//

@class TKScanningProvider;


@protocol TKScanningProviderDelegate <NSObject>
@optional

- (void)scanningProvider:(TKScanningProvider *)provider didFinishScanningWithText:(NSString *)text info:(NSDictionary *)info;


- (void)scanningProviderDidCancel:(TKScanningProvider *)provider;


- (void)scanningProvider:(TKScanningProvider *)provider didFailedScanningWithError:(NSError *)error;

@end

@interface TKScanningProvider : NSObject

@property (nonatomic, assign) id <TKScanningProviderDelegate> delegate;

@property (nonatomic, strong) UIViewController *scannerController;
@property (nonatomic, strong, readonly) UIView *scanningView;


@property (nonatomic, assign) BOOL dismissOnFinish;
@property (nonatomic, assign) BOOL isIntegrated;
@property (nonatomic, assign) BOOL shouldRestart;

@property (nonatomic, assign) BOOL isProcessingResults;



+ (NSString *)providerName;

- (void)presentScannerFromViewController:(UIViewController *)viewController;
- (void)presentScannerFromViewController:(UIViewController *)viewController options:(NSDictionary *)options;

- (void)start;
- (void)stop;

- (void)setSize:(CGSize)size;

// Private methods, used in subclassing
- (void)finishedScanningWithText:(NSString *)text info:(NSDictionary *)info;
- (void)cancelledScanning;
- (void)failedScanningWithError:(NSError *)error;

@end