//
//  TKScanKit
//
//  Copyright (c) 2013 Taras Kalapun. All rights reserved.
//

#import "TKScanKit.h"
#import "TKScanKitProviders.h"
#import <objc/runtime.h>

@interface TKScanKit ()
+ (NSArray *)classGetSubclasses:(Class)parentClass;
@end

@implementation TKScanKit


+ (TKScanningProvider *)newProviderWithName:(NSString *)providerName
{
    NSString *providerClassString = [NSString stringWithFormat:@"%@Provider", providerName];
    Class providerClass = NSClassFromString(providerClassString);
    
    if (providerClass) {
        return [[providerClass alloc] init];
    }
    
    NSDictionary *availableProviders = [[self class] availableProviders];
    
    NSString *uppercasedProviderName = [providerName uppercaseString];
    __block NSString *clsName = nil;
    [availableProviders enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        
        if ([[key uppercaseString] isEqualToString:uppercasedProviderName]) {
            *stop = YES;
            clsName = obj;
        }
    }];
    
    providerClass = NSClassFromString(clsName);
    if (providerClass) {
        return [[providerClass alloc] init];
    }
    
    return nil;
}

+ (TKScanningProvider *)presentScanner:(NSString *)providerName fromViewController:(UIViewController <TKScanningProviderDelegate>*)viewController
{
    TKScanningProvider *provider = [self newProviderWithName:providerName];
    provider.delegate = viewController;
    [provider presentScannerFromViewController:viewController];
    return provider;
}

+ (NSDictionary *)availableProviders
{
    NSMutableDictionary *validProviders = [NSMutableDictionary dictionary];
    
    NSArray *providerClasses = [self classGetSubclasses:[TKScanningProvider class]];
    for (id cls in providerClasses){
        //NSString *name = [NSStringFromClass(cls) stringByReplacingOccurrencesOfString:@"Provider" withString:@""];
        NSString *name = [cls respondsToSelector:@selector(providerName)]? [cls providerName] : nil;
        if (name && ![name isEqualToString:@"TKScanning"]) {
            [validProviders setObject:NSStringFromClass(cls) forKey:name];
            //[validProviders addObject:name];
        }
    }
    return validProviders;
}

+ (NSArray *)classGetSubclasses:(Class)parentClass
{
    int numClasses = objc_getClassList(NULL, 0);
    __unsafe_unretained Class *classes = NULL;
    
    classes = (Class *)malloc(sizeof(Class) * numClasses);
    numClasses = objc_getClassList(classes, numClasses);
    
    NSMutableArray *result = [NSMutableArray array];
    for (NSInteger i = 0; i < numClasses; i++)
    {
        Class superClass = classes[i];
        do
        {
            superClass = class_getSuperclass(superClass);
        } while(superClass && superClass != parentClass);
        
        if (superClass == nil)
        {
            continue;
        }
        
        [result addObject:classes[i]];
    }
    
    free(classes);
    
    return result;
}

@end
