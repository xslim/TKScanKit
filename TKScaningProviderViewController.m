//
//  TKScanKitView.m
//  Pods
//
//  Created by Taras Kalapun on 25/11/13.
//
//

#import "TKScaningProviderViewController.h"

@implementation TKScaningProviderViewController

@synthesize delegate=_delegate, provider=_provider;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        [self setup];
    }
    return self;
}

- (TKScanningProvider *)provider
{
    if (!_provider) {
        _provider = [TKScanKit newProviderWithName:[TKScanKit defaultProvider]];
        _provider.isIntegrated = YES;
    }
    return _provider;
}

- (void)setDelegate:(id<TKScanningProviderDelegate>)delegate
{
    self.provider.delegate = delegate;
}

- (id<TKScanningProviderDelegate>)delegate
{
    return self.provider.delegate;
}

- (void)setup
{
//    UIViewController *controller = self.provider.scannerController;
//    [self addChildViewController:controller];
//    
//    [self.view addSubview:controller.view];
//    
//    [controller didMoveToParentViewController:self];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIViewController *controller = self.provider.scannerController;
    [self addChildViewController:controller];

    [self.view addSubview:controller.view];

    [controller didMoveToParentViewController:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIViewController *child = [self.childViewControllers lastObject];
    if (child) {
        child.view.frame = self.view.bounds;
        [self.provider setSize:self.view.bounds.size];
        [child.view layoutIfNeeded];
    }
    
    [self.provider start];
}


@end
